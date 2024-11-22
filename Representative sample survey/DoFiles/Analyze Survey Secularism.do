clear all
set more off

//Set WD
cd "~/Dropbox/Recherche/DonneesEglise/DataAnalysis/Representative sample survey/"

//Import data
import excel "RawData/OpinionWay-BDD Enquête laïcité.xlsx", sheet("BJ21699-BDD") firstrow

//ID
gen id=_n

//Treatment
gen quest_islam=cond(echECHANTILLON=="ech A",0,1)
tab quest_islam

//Recode religious variables
ren rs30Pouvezvousmedirequelle religion
tab religion, miss
gen catho=cond(religion=="Catholique",1,0)
replace catho=. if religion==""
gen atheist=cond(religion=="Sans religion",1,0)
replace atheist=. if religion==""

//Interaction: Treatment and religious variables 
gen quest_islam_catho=cond(religion=="Catholique",quest_islam,0,.)
replace quest_islam_catho=. if religion==""
gen quest_islam_sansRel=cond(religion=="Sans religion",quest_islam,0,.)
replace quest_islam_sansRel=. if religion==""


//Recode variables that were separate across treatments
forvalues k=1(1)7{
	gen q2_`k'=q2_i`k' if quest_islam==0
	replace q2_`k'=q5_i`k' if quest_islam==1
}
drop q2_i* q5_i*

forvalues k=1(1)8{
	gen q3_`k'=q3_i`k' if quest_islam==0
	replace q3_`k'=q6_i`k' if quest_islam==1
}
//replace q3_3=-q3_3+10
//replace q3_5=-q3_5+10
drop q3_i* q6_i*

forvalues k=1(1)6{
	gen q4_`k'=q4_i`k' if quest_islam==0
	replace q4_`k'=q7_i`k' if quest_islam==1
}
drop q4_i* q7_i*

ren q4_1 position_LFI
ren q4_2 position_EELV
ren q4_3 position_PS
ren q4_4 position_LREM
ren q4_5 position_LR
ren q4_6 position_RN

//Keep Catholics and Atheists
keep if religion=="Catholique" | religion=="Sans religion"

//Opinions about religion and state
tab catho if religion=="Catholique" | religion=="Sans religion"
mat Results=J(6,5,.)
forvalues k=1(1)6{
	qui su q2_`k' if religion=="Sans religion" [iw=poids]
	mat Results[`k',1]=round(`r(mean)',0.01)
	qui su q2_`k' if religion=="Catholique"  [iw=poids]
	mat Results[`k',2]=round(`r(mean)',0.01)
	reg q2_`k' catho  if religion=="Catholique" | religion=="Sans religion" [iw=poids]
	mat b=e(b)
	mat V=e(V)
	mat Results[`k',3]=round(2 * normprob(-abs(b[1,1]/sqrt(V[1,1]))),0.001)
	//SE
	qui ci means q2_`k' [aw=poids] if  religion=="Sans religion"
	mat Results[`k',4]=round(`r(se)',0.001)
	qui ci means q2_`k' [aw=poids] if religion=="Catholique" 
	mat Results[`k',5]=round(`r(se)',0.001)

}
mat list Results

//DIFF BETWEEN CATHOLICISM AND ISLAM

//Summary statistics about opinions for catholics
mat ResultsCatho=J(8,5,.)
forvalues k=1(1)8{
	su q3_`k' if quest_islam==0 & catho==1 [iw=poids] 
	mat ResultsCatho[`k',1]=round(`r(mean)',0.01)
	su q3_`k' if quest_islam==1 & catho==1  [iw=poids]
	mat ResultsCatho[`k',2]=round(`r(mean)',0.01)
	reg q3_`k' quest_islam  if catho==1 [iw=poids]
	mat b=e(b)
	mat V=e(V)
	mat ResultsCatho[`k',3]=round(2 * normprob(-abs(b[1,1]/sqrt(V[1,1]))),0.001)	
	//SE
	ci means q3_`k' [aw=poids] if quest_islam==0 & catho==1
	mat ResultsCatho[`k',4]=round(`r(se)',0.001)
	ci means q3_`k' [aw=poids] if quest_islam==1 & catho==1
	mat ResultsCatho[`k',5]=round(`r(se)',0.001)
}
mat list ResultsCatho

//Summary statistics about opinions for Atheists
mat ResultsAtheists=J(8,5,.)
forvalues k=1(1)8{
	su q3_`k' if quest_islam==0 & atheist==1 [iw=poids] 
	mat ResultsAtheists[`k',1]=round(`r(mean)',0.01)
	su q3_`k' if quest_islam==1 & atheist==1  [iw=poids]
	mat ResultsAtheists[`k',2]=round(`r(mean)',0.01)
	reg q3_`k' quest_islam  if atheist==1 [iw=poids]
	mat b=e(b)
	mat V=e(V)
	mat ResultsAtheists[`k',3]=round(2 * normprob(-abs(b[1,1]/sqrt(V[1,1]))),0.001)	
	//SE
	ci means q3_`k' [aw=poids] if quest_islam==0 & atheist==1
	mat ResultsAtheists[`k',4]=round(`r(se)',0.001)
	ci means q3_`k' [aw=poids] if quest_islam==1 & atheist==1
	mat ResultsAtheists[`k',5]=round(`r(se)',0.001)
}
mat list ResultsAtheists


//Diff-in-diff
mat ResultsDiffInDiff=J(8,1,.)
forvalues k=1(1)8{
	reg q3_`k' catho quest_islam quest_islam_catho if religion=="Catholique" | religion=="Sans religion" [iw=poids], robust
	mat b=e(b)
	mat V=e(V)
	mat ResultsDiffInDiff[`k',1]=round(2 * normprob(-abs(b[1,3]/sqrt(V[3,3]))),0.001)	
}
mat list ResultsDiffInDiff

//Diff-in-diff written in another way
mat ResultsDiffInDiff_2=J(16,3,.)
capture gen catho_islam=cond(catho==1,quest_islam,0)
capture gen atheist_islam=cond(atheist==1,quest_islam,0)
forvalues k=1(1)8{
	reg q3_`k' catho catho_islam atheist_islam if religion=="Catholique" | religion=="Sans religion" [iw=poids], robust
	mat b=e(b)
	mat V=e(V)
	mat ResultsDiffInDiff_2[2*`k'-1,1]=round(b[1,2],0.001)
	mat ResultsDiffInDiff_2[2*`k'-1,2]=round(b[1,3],0.001)
	mat ResultsDiffInDiff_2[2*`k',1]=round(sqrt(V[2,2]),0.001)
	mat ResultsDiffInDiff_2[2*`k',2]=round(sqrt(V[3,3]),0.001)
	mat ResultsDiffInDiff_2[2*`k'-1,3]=ResultsDiffInDiff[`k',1]
}
mat list ResultsDiffInDiff_2


///PARTY POSITIONS///

//Summary statistics about opinions for catholics
mat ResultsCatho=J(6,5,.)
local k=1
foreach var in LFI EELV PS LREM LR RN{
	su position_`var' if quest_islam==0 & catho==1 [iw=poids] 
	mat ResultsCatho[`k',1]=round(`r(mean)',0.01)
	su position_`var' if quest_islam==1 & catho==1  [iw=poids]
	mat ResultsCatho[`k',2]=round(`r(mean)',0.01)
	reg position_`var' quest_islam  if catho==1 [iw=poids]
	mat b=e(b)
	mat V=e(V)
	mat ResultsCatho[`k',3]=round(2 * normprob(-abs(b[1,1]/sqrt(V[1,1]))),0.001)	
	//SE
	ci means position_`var' [aw=poids] if quest_islam==0 & catho==1
	mat ResultsCatho[`k',4]=round(`r(se)',0.001)
	ci means position_`var' [aw=poids] if quest_islam==1 & catho==1
	mat ResultsCatho[`k',5]=round(`r(se)',0.001)
	local k=`k'+1
}
mat list ResultsCatho

//Summary statistics about opinions for atheists
mat ResultsAtheists=J(6,5,.)
local k=1
foreach var in LFI EELV PS LREM LR RN{
	su position_`var' if quest_islam==0 & atheist==1 [iw=poids] 
	mat ResultsAtheists[`k',1]=round(`r(mean)',0.01)
	su position_`var' if quest_islam==1 & atheist==1 [iw=poids]
	mat ResultsAtheists[`k',2]=round(`r(mean)',0.01)
	reg position_`var' quest_islam  if atheist==1 [iw=poids]
	mat b=e(b)
	mat V=e(V)
	mat ResultsAtheists[`k',3]=round(2 * normprob(-abs(b[1,1]/sqrt(V[1,1]))),0.001)	
	//SE
	ci means position_`var' [aw=poids] if quest_islam==0 & atheist==1
	mat ResultsAtheists[`k',4]=round(`r(se)',0.001)
	ci means position_`var' [aw=poids] if quest_islam==1 & atheist==1
	mat ResultsAtheists[`k',5]=round(`r(se)',0.001)
	local k=`k'+1
}
mat list ResultsAtheists

//Diff-in-diff
mat ResultsDiffInDiff=J(6,1,.)
local k=1
foreach var in LFI EELV PS LREM LR RN{
	reg position_`var' catho quest_islam quest_islam_catho if religion=="Catholique" | religion=="Sans religion" [iw=poids], robust
	mat b=e(b)
	mat V=e(V)
	mat ResultsDiffInDiff[`k',1]=round(2 * normprob(-abs(b[1,3]/sqrt(V[3,3]))),0.001)	
	local k=`k'+1
}
mat list ResultsDiffInDiff

//Diff-in-diff written in another way
mat ResultsDiffInDiff_2=J(12,3,.)
local k=1
foreach var in LFI EELV PS LREM LR RN{
	reg position_`var' catho catho_islam atheist_islam if religion=="Catholique" | religion=="Sans religion" [iw=poids], robust
	mat b=e(b)
	mat V=e(V)
	mat ResultsDiffInDiff_2[2*`k'-1,1]=round(b[1,2],0.001)
	mat ResultsDiffInDiff_2[2*`k'-1,2]=round(b[1,3],0.001)
	mat ResultsDiffInDiff_2[2*`k',1]=round(sqrt(V[2,2]),0.001)
	mat ResultsDiffInDiff_2[2*`k',2]=round(sqrt(V[3,3]),0.001)
	mat ResultsDiffInDiff_2[2*`k'-1,3]=ResultsDiffInDiff[`k',1]
	local k=`k'+1
}
mat list ResultsDiffInDiff_2


//Vote at the presidential elections
gen vote_presidentielle=""
replace vote_presidentielle="Hamon" if v7t1Pourquelcandidatavezvo=="Benoit Hamon"
replace vote_presidentielle="Macron" if v7t1Pourquelcandidatavezvo=="Emmanuel Macron"
replace vote_presidentielle="Fillon" if v7t1Pourquelcandidatavezvo=="François Fillon"
replace vote_presidentielle="Mélenchon" if v7t1Pourquelcandidatavezvo=="Jean-Luc Mélenchon"
replace vote_presidentielle="LePen" if v7t1Pourquelcandidatavezvo=="Marine Le Pen"

tab vote_presidentielle


gen vote_melenchon=cond(vote_presidentielle=="Mélenchon",1,0,.)
replace vote_melenchon=. if vote_presidentielle==""
gen vote_hamon=cond(vote_presidentielle=="Hamon",1,0,.)
replace vote_hamon=. if vote_presidentielle==""
gen vote_macron=cond(vote_presidentielle=="Macron",1,0,.)
replace vote_macron=. if vote_presidentielle==""
gen vote_fillon=cond(vote_presidentielle=="Fillon",1,0,.)
replace vote_fillon=. if vote_presidentielle==""
gen vote_lepen=cond(vote_presidentielle=="LePen",1,0,.)
replace vote_lepen=. if vote_presidentielle==""


mat Results=J(5,5,.)
local k=1
foreach var in melenchon hamon macron fillon lepen{
	qui su vote_`var' [iw=poids] if catho==0
	mat Results[`k',1]=`r(mean)'
	mat Results[`k',2]=1.96*sqrt(`r(mean)'*(1-`r(mean)')/`r(N)')
	qui su vote_`var' [iw=poids] if catho==1
	mat Results[`k',3]=`r(mean)'
	mat Results[`k',4]=1.96*sqrt(`r(mean)'*(1-`r(mean)')/`r(N)')
	probit vote_`var' catho [iw=poids] if religion=="Catholique" | religion=="Sans religion", robust
	mat b=e(b)
	mat V=e(V)
	mat Results[`k',5]=round(2 * normprob(-abs(b[1,1]/sqrt(V[1,1]))),0.001)
	local k=`k'+1
}
mat list Results


