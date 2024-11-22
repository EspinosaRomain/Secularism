clear all
set more off

//Set WD
cd "~/Dropbox/Recherche/DonneesEglise/DataAnalysis/"

//Import data
use "Laws 3rd Republic/RawData/VoteLoi1882.dta"

//Harmonize names
ren Département departement
replace departement="Deux-Sèvres" if departement=="Deux-Sèvres "
replace departement="Loire" if departement=="Loire "
replace departement="Drôme" if departement=="Drôme "
replace departement="Rhône" if departement=="Rhône "
replace departement="Sarthe" if departement=="Sarthe "
replace departement="Seine-et-Oise" if departement=="Seine-et-Oise "
replace departement="Landes" if departement=="landes"
replace departement="Côte-d'Or" if departement=="Côte-d'or"
replace departement="Pyrénées-Orientales" if departement=="Pyrénées Orientales"
replace departement="Territoire de Belfort" if departement=="Territoire-de-Belfort"

//Merge departements into SupraDepartements
replace departement="Cher et Indre" if departement=="Cher" | departement=="Indre"
replace departement="Marne et Ardennes" if departement=="Marne" | departement=="Ardennes"
replace departement="Rhône et Loire" if departement=="Rhône" | departement=="Loire" 
replace departement="Vienne et Deux-Sèvres" if departement=="Vienne" | departement=="Deux-Sèvres"
replace departement="Haute-Vienne et Creuse" if departement=="Haute-Vienne" | departement=="Creuse" 
replace departement="Haute-Saône et Doubs" if departement=="Haute-Saône" | departement=="Doubs"

//Other orthographic changes because Departements changed names over time
replace departement="Alpes-de-Haute-Provence" if departement=="Basses-Alpes"
replace departement="Charente-Maritime" if departement=="Charente-Inférieure"
replace departement="Charente-Maritime" if departement=="Charente Inférieure"
replace departement="Seine-Inférieure" if departement=="Seinte-Inférieure"
replace departement="Côtes-d'Armor" if departement=="Côtes-du-Nord"
replace departement="Seine-Maritime" if departement=="Seine-Inférieure"
replace departement="Loire-Atlantique" if departement=="Loire-Inférieure"
replace departement="Yvelines" if departement=="Seine-et-Oise"
replace departement="Pyrénées-Atlantiques" if departement=="Basses-Pyrénées"

//On face a challenge with the regional unit "Seine" (department in 1901)
//It contains 45 representatives from 4 current departement (Jureurs): Paris, Seine-Saint-Denis, Val-d'Oise, Val-de-Marne
//We assume that Seine=Paris
replace departement="Paris" if departement=="Seine"

//Rename variable
ren departement SupraDepartement

//We merge with non-sworn priests data
merge m:1 SupraDepartement using "NonSwornPriests/Data/DataAssermentesTreated.dta"
tab SupraDepartement if _merge!=3
drop if _merge!=3

//Recode the variable "Pour" (in favor)
gen votePour=cond(vote=="Pour",1,cond(vote=="Contre",0,.))

//Correlation
pwcorr votePour nonSwornPriest, sig

//Regression
probit votePour nonSwornPriest, cluster(SupraDepartement)
mfx

//Regression withou Paris
probit votePour nonSwornPriest if SupraDepartement!="Paris", cluster(SupraDepartement)
mfx

