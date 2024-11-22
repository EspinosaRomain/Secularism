clear all
set more off

//Set WD
cd "~/Dropbox/Recherche/DonneesEglise/DataAnalysis/"

//Import data
use "Laws 3rd Republic/RawData/VoteLoi1905.dta"
ren Département departement

//Merge departements into SupraDepartements
replace departement="Cher et Indre" if departement=="Cher" | departement=="Indre"
replace departement="Marne et Ardennes" if departement=="Marne" | departement=="Ardennes"
replace departement="Rhône et Loire" if departement=="Rhône" | departement=="Loire" 
replace departement="Vienne et Deux-Sèvres" if departement=="Vienne" | departement=="Deux-Sèvres"
replace departement="Haute-Vienne et Creuse" if departement=="Haute-Vienne" | departement=="Creuse" 
replace departement="Haute-Saône et Doubs" if departement=="Haute-Saône" | departement=="Doubs"

//Other orthographic changes
replace departement="Seine-Inférieure" if departement=="Seinte-Inférieure"
replace departement="Côtes-d'Armor" if departement=="Côtes-du-Nord"
replace departement="Seine-Maritime" if departement=="Seine-Inférieure"
replace departement="Loire-Atlantique" if departement=="Loire-Inférieure"
replace departement="Yvelines" if departement=="Seine-et-Oise"
replace departement="Charente-Maritime" if departement=="Charente-Inférieure"
replace departement="Alpes-de-Haute-Provence" if departement=="Basses-Alpes"
replace departement="Pyrénées-Atlantiques" if departement=="Basses-Pyrénées"
replace departement="Bas-Rhin et Haut-Rhin" if departement=="Haut-Rhin"

//Assumption with Seine=Paris
replace departement="Paris" if departement=="Seine"
ren departement SupraDepartement

//We merge with non-sworn priests data
merge m:1 SupraDepartement using "NonSwornPriests/Data/DataAssermentesTreated.dta"
tab Supra if _merge==2
tab Supra if _merge==1
drop if _merge!=3

//Recode the variable "Pour" (in favor)
gen votePour=cond(vote=="Pour",1,cond(vote=="Contre",0,.))

//Correlation
pwcorr votePour nonSwornPriest, sig

//Regression
probit votePour nonSwornPriest, cluster(SupraDepartement)
mfx

//Regression without Paris
probit votePour nonSwornPriest if SupraDepartement!="Paris", cluster(SupraDepartement)
mfx