clear all
set more off

//Set working directory
cd "~/Dropbox/Recherche/DonneesEglise/DataAnalysis/"


//Import data on non-sworn priests
use "NonSwornPriests/RawData/DataAssermentes.dta"

//Generate proportion of non-sworn priests
gen percentPrintemps1791=jureursprintemps1791/totalclerge
gen percentEte1791=jureursete1791/totalclerge
gen pourc_assermentes_1791=(jureursprintemps1791+jureursete1791)/(2*totalclerge)
replace pourc_assermentes_1791=jureursprintemps1791/totalclerge if jureursete1791==.
replace pourc_assermentes_1791=jureursete1791/totalclerge if jureursprintemps1791==.
replace pourc_assermentes_1791=pourc_diocese_assermentes/100 if pourc_assermentes_1791==.
gen nonSwornPriest=1-pourc_assermentes_1791

//Merge with data on religiosity
keep departement nonSwornPriest
ren departement SupraDepartement
merge 1:1 SupraDepartement using "Religiosity/Data/religiosity2013.dta"
drop _merge

//Save data
save "NonSwornPriests/Data/DataAssermentesTreated.dta", replace

//Import data on working conditions
clear 
import excel "NonSwornPriests/RawData/dataPopulationCommunes2013.xlsx", sheet("Feuil1") firstrow

//I keep the data of interest and I compute the sum by departement
keep DEP P13_POP1564 P13_ACT1564 P13_ACTOCC1564 P13_CHOM1564	P13_POP15P
collapse (sum) P13_POP1564 P13_ACT1564 P13_ACTOCC1564 P13_CHOM1564	P13_POP15P, by(DEP)

//I code departements in the same way as before
gen Departement=""
replace Departement="Ain" if DEP=="01"
replace Departement="Aisne" if DEP=="02"
replace Departement="Allier" if DEP=="03"
replace Departement="Alpes-de-Haute-Provence" if DEP=="04"
replace Departement="Hautes-Alpes" if DEP=="05"
replace Departement="Alpes-Maritimes" if DEP=="06"
replace Departement="Ardèche" if DEP=="07"
replace Departement="Ardennes" if DEP=="08"
replace Departement="Ariège" if DEP=="09"
replace Departement="Aube" if DEP=="10"
replace Departement="Aude" if DEP=="11"
replace Departement="Aveyron" if DEP=="12"
replace Departement="Bouches-du-Rhône" if DEP=="13"
replace Departement="Calvados" if DEP=="14"
replace Departement="Cantal" if DEP=="15"
replace Departement="Charente" if DEP=="16"
replace Departement="Charente-Maritime" if DEP=="17"
replace Departement="Cher" if DEP=="18"
replace Departement="Corrèze" if DEP=="19"
replace Departement="Corse-du-Sud" if DEP=="2A"
replace Departement="Haute-Corse" if DEP=="2B"
replace Departement="Côte-d'Or" if DEP=="21"
replace Departement="Côtes-d'Armor" if DEP=="22"
replace Departement="Creuse" if DEP=="23"
replace Departement="Dordogne" if DEP=="24"
replace Departement="Doubs" if DEP=="25"
replace Departement="Drôme" if DEP=="26"
replace Departement="Eure" if DEP=="27"
replace Departement="Eure-et-Loir" if DEP=="28"
replace Departement="Finistère" if DEP=="29"
replace Departement="Gard" if DEP=="30"
replace Departement="Haute-Garonne" if DEP=="31"
replace Departement="Gers" if DEP=="32"
replace Departement="Gironde" if DEP=="33"
replace Departement="Hérault" if DEP=="34"
replace Departement="Ille-et-Vilaine" if DEP=="35"
replace Departement="Indre" if DEP=="36"
replace Departement="Indre-et-Loire" if DEP=="37"
replace Departement="Isère" if DEP=="38"
replace Departement="Jura" if DEP=="39"
replace Departement="Landes" if DEP=="40"
replace Departement="Loir-et-Cher" if DEP=="41"
replace Departement="Loire" if DEP=="42"
replace Departement="Haute-Loire" if DEP=="43"
replace Departement="Loire-Atlantique" if DEP=="44"
replace Departement="Loiret" if DEP=="45"
replace Departement="Lot" if DEP=="46"
replace Departement="Lot-et-Garonne" if DEP=="47"
replace Departement="Lozère" if DEP=="48"
replace Departement="Maine-et-Loire" if DEP=="49"
replace Departement="Manche" if DEP=="50"
replace Departement="Marne" if DEP=="51"
replace Departement="Haute-Marne" if DEP=="52"
replace Departement="Mayenne" if DEP=="53"
replace Departement="Meurthe-et-Moselle" if DEP=="54"
replace Departement="Meuse" if DEP=="55"
replace Departement="Morbihan" if DEP=="56"
replace Departement="Moselle" if DEP=="57"
replace Departement="Nièvre" if DEP=="58"
replace Departement="Nord" if DEP=="59"
replace Departement="Oise" if DEP=="60"
replace Departement="Orne" if DEP=="61"
replace Departement="Pas-de-Calais" if DEP=="62"
replace Departement="Puy-de-Dôme" if DEP=="63"
replace Departement="Pyrénées-Atlantiques" if DEP=="64"
replace Departement="Hautes-Pyrénées" if DEP=="65"
replace Departement="Pyrénées-Orientales" if DEP=="66"
replace Departement="Bas-Rhin" if DEP=="67"
replace Departement="Haut-Rhin" if DEP=="68"
replace Departement="Rhône" if DEP=="69"
replace Departement="Haute-Saône" if DEP=="70"
replace Departement="Saône-et-Loire" if DEP=="71"
replace Departement="Sarthe" if DEP=="72"
replace Departement="Savoie" if DEP=="73"
replace Departement="Haute-Savoie" if DEP=="74"
replace Departement="Paris" if DEP=="75"
replace Departement="Seine-Maritime" if DEP=="76"
replace Departement="Seine-et-Marne" if DEP=="77"
replace Departement="Yvelines" if DEP=="78"
replace Departement="Deux-Sèvres" if DEP=="79"
replace Departement="Somme" if DEP=="80"
replace Departement="Tarn" if DEP=="81"
replace Departement="Tarn-et-Garonne" if DEP=="82"
replace Departement="Var" if DEP=="83"
replace Departement="Vaucluse" if DEP=="84"
replace Departement="Vendée" if DEP=="85"
replace Departement="Vienne" if DEP=="86"
replace Departement="Haute-Vienne" if DEP=="87"
replace Departement="Vosges" if DEP=="88"
replace Departement="Yonne" if DEP=="89"
replace Departement="Territoire de Belfort" if DEP=="90"
replace Departement="Essonne" if DEP=="91"
replace Departement="Hauts-de-Seine" if DEP=="92"
replace Departement="Seine-Saint-Denis" if DEP=="93"
replace Departement="Val-de-Marne" if DEP=="94"
replace Departement="Val-d'Oise" if DEP=="95"
drop if Departement==""

//I save the data at the departement level (to compute a weighted mean below for another dataset)
save "NonSwornPriests/Data/dataEmploi2013_DEP.dta", replace

//I now regroup departement to match the supradepartements
ren  Departement SupraDepartement
replace SupraDepartement="Marne et Ardennes" if SupraDepartement=="Marne" | SupraDepartement=="Ardennes"
replace SupraDepartement="Rhône et Loire"  if SupraDepartement=="Rhône" | SupraDepartement=="Loire"
replace SupraDepartement="Cher et Indre"  if SupraDepartement=="Cher" | SupraDepartement=="Indre"
replace SupraDepartement="Bas-Rhin et Haut-Rhin" if SupraDepartement=="Bas-Rhin" | SupraDepartement=="Haut-Rhin"
replace SupraDepartement="Haute-Vienne et Creuse" if SupraDepartement=="Haute-Vienne" | SupraDepartement=="Creuse"
replace SupraDepartement="Corse" if SupraDepartement=="Corse-du-Sud" | SupraDepartement=="Haute-Corse"
replace SupraDepartement="Vienne et Deux-Sèvres" if SupraDepartement=="Vienne" | SupraDepartement=="Deux-Sèvres"
replace SupraDepartement="Haute-Saône et Doubs" if SupraDepartement=="Doubs" | SupraDepartement=="Haute-Saône"
drop DEP
collapse (sum) P13_POP1564 P13_ACT1564 P13_ACTOCC1564 P13_CHOM1564	P13_POP15P, by(SupraDepartement)

//I generate the variables of interest
gen tx_chom_2013=P13_CHOM1564/P13_ACT1564
gen tx_act_2013=P13_ACTOCC1564/P13_ACT1564
gen pop15ansEtPlus_2013=P13_POP15P
gen lnPop15etPlus=ln(pop15ansEtPlus_2013)

//I keep the variables of interest
keep SupraDepartement tx_chom_2013 tx_act_2013 pop15ansEtPlus_2013 lnPop15etPlus

//I save the data
save "NonSwornPriests/Data/dataEmploi2013.dta", replace

//I now merge with other economic variables
clear 
import excel "NonSwornPriests/RawData/dataNiveauDeVieDep.xlsx", sheet("Feuil1") firstrow

merge 1:1 Departement using  "NonSwornPriests/Data/dataEmploi2013_DEP.dta"
drop _merge

replace Departement="Marne et Ardennes" if Departement=="Marne" | Departement=="Ardennes"
replace Departement="Rhône et Loire"  if Departement=="Rhône" | Departement=="Loire"
replace Departement="Cher et Indre"  if Departement=="Cher" | Departement=="Indre"
replace Departement="Bas-Rhin et Haut-Rhin" if Departement=="Bas-Rhin" | Departement=="Haut-Rhin"
replace Departement="Haute-Vienne et Creuse" if Departement=="Haute-Vienne" | Departement=="Creuse"
replace Departement="Corse" if Departement=="Corse-du-Sud" | Departement=="Haute-Corse"
replace Departement="Vienne et Deux-Sèvres" if Departement=="Vienne" | Departement=="Deux-Sèvres"
replace Departement="Haute-Saône et Doubs" if Departement=="Doubs" | Departement=="Haute-Saône"

//I compute the weighted mean using population data at the departement level
collapse (mean) medianeNiveauVie_2013 erDecile2013 emeDecile2013 [iw=P13_POP15P], by(Departement)

//I generate variables of interest
gen lnMedianeNiveauVie_2013=ln(medianeNiveauVie_2013)
gen ratioDecile_2013=emeDecile2013/erDecile2013

keep Departement ratioDecile_2013 lnMedianeNiveauVie_2013
ren Departement SupraDepartement

//I save the data
save "NonSwornPriests/Data/dataNiveauDeVie2013.dta", replace

//Merge datasets
clear
use "NonSwornPriests/Data/DataAssermentesTreated.dta"

merge 1:1 SupraDepartement using "NonSwornPriests/Data/dataEmploi2013.dta"
drop _merge

merge 1:1 SupraDepartement using "NonSwornPriests/Data/dataNiveauDeVie2013.dta"
drop _merge

//I save the final dataset
save "NonSwornPriests/Data/religiosityAndNonSwornPriests.dta", replace


