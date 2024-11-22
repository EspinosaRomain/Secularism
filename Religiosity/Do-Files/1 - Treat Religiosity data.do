clear all
set more off
 
//Set working directory
cd "~/Dropbox/Recherche/DonneesEglise/DataAnalysis/Religiosity" 
 
//Import Data at the diocese level
import excel "RawData/dataReligiosityDiocese.xlsx", sheet("Feuil1") firstrow

//There are sometimes two dioceses overlapping in two departements
//I create supradepartements which include both departements and both dioceses
replace Departement="Marne et Ardennes" if Diocese=="Châlons" | Diocese=="Reims"
replace Departement="Rhône et Loire" if Diocese=="Lyon" | Diocese=="Saint-Étienne"

//There is sometimes one diocese for two departement, so I create a supradepartement here as well
replace Departement="Cher et Indre" if Diocese=="Bourges"
replace Departement="Bas-Rhin et Haut-Rhin" if Diocese=="Strasbourg"
replace Departement="Haute-Vienne et Creuse" if Diocese=="Limoges"
replace Departement="Corse" if Diocese=="Ajaccio"
replace Departement="Vienne et Deux-Sèvres" if Diocese=="Poitiers"
replace Departement="Haute-Saône et Doubs" if Diocese=="Besançon"

//For the departements or supradepartements that contain the two diocese, I compute the total of the outcome variables.
local obsBefore=_N
set obs `=_N+5'
gen id=_n
replace Departement="Bouches-du-Rhône" if id==`obsBefore'+1
replace Departement="Pas-de-Calais"  if id==`obsBefore'+2
replace Departement="Seine-Maritime" if id==`obsBefore'+3
replace Departement="Marne et Ardennes" if id==`obsBefore'+4
replace Departement="Rhône et Loire" if id==`obsBefore'+5

foreach dep in Bouches-du-Rhône Pas-de-Calais Seine-Maritime "Marne et Ardennes" "Rhône et Loire"{
	foreach var in total_baptises_2013 enfants_baptistes_2013 mariages_2013 confirmations_2013 population_diocese_2013 nb_pretres_2013 nb_diacres_2013 nbseminaristes_2013 projec_pretres_2024 paroisses{
		qui su `var' if Departement=="`dep'", d 
		qui replace `var'= `r(sum)' if  Departement=="`dep'" & `var'==.
	}
}

//I compute the weighted mean for the percentages
gen enfantsTotal=enfants_baptistes_2013/pourcent_enfants_baptises_2013
foreach dep in Bouches-du-Rhône Pas-de-Calais Seine-Maritime "Marne et Ardennes" "Rhône et Loire"{
	su enfantsTotal if Departement=="`dep'", d 
	replace enfantsTotal= `r(sum)' if  Departement=="`dep'" & enfantsTotal==.
	su pourcent_enfants_baptises_2013 if Departement=="`dep'" [iw=enfantsTotal] 
	replace pourcent_enfants_baptises_2013= `r(mean)' if  Departement=="`dep'" & pourcent_enfants_baptises_2013==.
}

//I drop the units that have been aggregated
drop if Departement=="Bouches-du-Rhône" & id<`obsBefore'
drop if Departement=="Pas-de-Calais" & id<`obsBefore'
drop if Departement=="Seine-Maritime" & id<`obsBefore'
drop if Departement=="Marne et Ardennes" & id<`obsBefore'
drop if Departement=="Rhône et Loire" & id<`obsBefore'

//I drop useless variables
drop Diocese id enfantsTotal
ren population_diocese_2013 pop_total_diocese_2013

//I rename Departement as SupraDepartement, as some units are larger than Departements
ren Departement SupraDepartement

//I save the data
save "Data/treatedDataReligiosity2013.dta", replace

//Import Data about weddings
clear all
set more off
import excel "RawData/dataMariagesDepartement.xlsx", sheet("Feuil1") firstrow

ren Département Departement
ren mariages_2013 mariagesINSEE_2013

//I compute the sum for the supradepartements
replace Departement="Marne et Ardennes" if Departement=="Marne" | Departement=="Ardennes"
replace Departement="Rhône et Loire"  if Departement=="Rhône" | Departement=="Loire"
replace Departement="Cher et Indre"  if Departement=="Cher" | Departement=="Indre"
replace Departement="Bas-Rhin et Haut-Rhin" if Departement=="Bas-Rhin" | Departement=="Haut-Rhin"
replace Departement="Haute-Vienne et Creuse" if Departement=="Haute-Vienne" | Departement=="Creuse"
replace Departement="Corse" if Departement=="Corse-du-Sud" | Departement=="Haute-Corse"
replace Departement="Vienne et Deux-Sèvres" if Departement=="Vienne" | Departement=="Deux-Sèvres"
replace Departement="Haute-Saône et Doubs" if Departement=="Doubs" | Departement=="Haute-Saône"
collapse (sum) mariagesINSEE_2013, by(Departement) 

ren Departement SupraDepartement

//Merge two datasets
merge 1:1 SupraDepartement using "Data/treatedDataReligiosity2013.dta"
drop _merge

//I save the data
save "Data/treatedDataReligiosity2013.dta", replace

//Import data about schools
clear
use "RawData/DataSchools2000s.dta", clear
keep departement public_2013 prive_2013
ren departement Departement

//I compute the sum for the supradepartements
replace Departement="Marne et Ardennes" if Departement=="Marne" | Departement=="Ardennes"
replace Departement="Rhône et Loire"  if Departement=="Rhône" | Departement=="Loire"
replace Departement="Cher et Indre"  if Departement=="Cher" | Departement=="Indre"
replace Departement="Bas-Rhin et Haut-Rhin" if Departement=="Bas-Rhin" | Departement=="Haut-Rhin"
replace Departement="Haute-Vienne et Creuse" if Departement=="Haute-Vienne" | Departement=="Creuse"
replace Departement="Corse" if Departement=="Corse-du-Sud" | Departement=="Haute-Corse"
replace Departement="Vienne et Deux-Sèvres" if Departement=="Vienne" | Departement=="Deux-Sèvres"
replace Departement="Haute-Saône et Doubs" if Departement=="Doubs" | Departement=="Haute-Saône"
collapse (sum) public_2013 prive_2013, by(Departement) 

//I compute the share of students in private schools
gen propPrive_2013=prive_2013/(prive_2013+public_2013)

keep Departement propPrive_2013
ren Departement SupraDepartement

//Merge two datasets
merge 1:1 SupraDepartement using "Data/treatedDataReligiosity2013.dta"
drop _merge 

//I save the data
save "Data/treatedDataReligiosity2013.dta", replace
