clear all
set more off

//Set working directory
cd "~/Dropbox/Recherche/DonneesEglise/DataAnalysis/Post-Electoral Studies"

//Import données Quetelet
use "Data/FES2017.dta"

//Sympathie politique
gen sympathy_FI=PR9_1 if PR9_1<11
gen sympathy_PS=PR9_2 if PR9_2<11
gen sympathy_EELV=PR9_3 if PR9_3<11
gen sympathy_LREM=PR9_4 if PR9_4<11
gen sympathy_LR=PR9_5 if PR9_5<11
gen sympathy_FN=PR9_6 if PR9_6<11

//Generate variables
ren S3 age
destring age, replace
ren S11 occupation
ren S6 education
ren S16 retraite
ren S2 genre

global controls "age ib4.occupation ib4.education ib2.retraite genre"
//Occupation: groupe de référence : Service
//Retraite : En activité
//Education : BAC

//Generate variables aboutreligion
tab SD41 [iw=w1]
gen catho=cond(SD41==0,1,0)
gen atheist=cond(SD41==5,1,0)
gen muslim=cond(SD41==3,1,0)

//Variables about sympathy
mat ResultsSympathy=J(6,6,.)
local k=1
tab atheist
tab catho
foreach var in FI PS EELV LREM LR FN{
	qui su sympathy_`var' [iw=w1] if atheist==1
	mat ResultsSympathy[`k',1]=`r(mean)'
	ci means sympathy_`var' [aw=w1] if atheist==1
	mat ResultsSympathy[`k',2]=round(1.96*`r(se)',0.001)
	qui su sympathy_`var' [iw=w1] if catho==1
	mat ResultsSympathy[`k',3]=`r(mean)'
	ci means sympathy_`var' [aw=w1] if catho==1
	mat ResultsSympathy[`k',4]=round(1.96*`r(se)',0.001)
	reg sympathy_`var' catho [iw=w1] if atheist==1 | catho==1, robust
	mat b=e(b)
	mat V=e(V)
	mat ResultsSympathy[`k',5]=round(2 * normprob(-abs(b[1,1]/sqrt(V[1,1]))),0.001)
	reg sympathy_`var' catho $controls [iw=w1] if atheist==1 | catho==1, robust
	mat b=e(b)
	mat V=e(V)
	mat ResultsSympathy[`k',6]=round(2 * normprob(-abs(b[1,1]/sqrt(V[1,1]))),0.001)
	local k=`k'+1
}
mat list ResultsSympathy


//Political opinions 
//L’homosexualité est une manière acceptable de vivre sa sexualité (Low score: agree)
capture gen gayAcceptable=-O7 if O7<4
oprobit gayAcceptable ib5.SD41 $controls [iw=w1], robust
outreg2  using "Tables/RegQuetelet_opinion_2017",  tex stats(coef se)  replace

//La femme est faite avant tout pour avoir des enfants et les élever (Low score: agree)
capture gen womenChildren=-O45 if O45<4
oprobit womenChildren ib5.SD41 $controls [iw=w1], robust
outreg2  using "Tables/RegQuetelet_opinion_2017",  tex stats(coef se)  append

//Importance de suivre les coutumes et les traditions françaises (Low score: important)
capture gen frenchCustoms=-O34 if O34<4
oprobit frenchCustoms ib5.SD41 $controls [iw=w1], robust
outreg2  using "Tables/RegQuetelet_opinion_2017",  tex stats(coef se)  append

//Importance d'avoir des origines françaises pour être vraiment Français (Low score: important)
capture gen frenchAncestry=-O32 if O32<4
oprobit frenchAncestry ib5.SD41 $controls [iw=w1], robust
outreg2  using "Tables/RegQuetelet_opinion_2017",  tex stats(coef se)  append

//En général,la culture française est menacée par les immigrés (Low score: agree)
capture gen migrantsGoodCulture=-O28 if O28<5
oprobit migrantsGoodCulture ib5.SD41 $controls [iw=w1], robust
outreg2  using "Tables/RegQuetelet_opinion_2017",  tex stats(coef se)  append

//Les minorités devraient s'adapter aux coutumes et traditions françaises (Low score: agree)
capture gen minorityShouldAdapt=-O25 if O25<5
oprobit minorityShouldAdapt ib5.SD41 $controls [iw=w1], robust
outreg2  using "Tables/RegQuetelet_opinion_2017",  tex stats(coef se)  append


