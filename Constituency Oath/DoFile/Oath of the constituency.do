clear all
set more off

//Set WD
cd "~/Dropbox/Recherche/DonneesEglise/DataAnalysis/"

//Import data
import excel "Constituency Oath/RawData/Députés clergé constituante.xlsx", sheet("Feuille 1") firstrow

//Exclude those who did not take part in the decision
drop if Suppléant=="ne figure pas dans dico"
drop if Suppléant=="malade n'assiste pas aux discussions sur CCC"
drop if Suppléant=="démission le 14/09/1789"
drop if Suppléant=="démission le 30/07/1789"
drop if Suppléant=="démission le 29/10/1789"
drop if Suppléant=="mort le 8/11/1789"
drop if Suppléant=="démission 01/08/1789"
drop if Suppléant=="quitte Paris en octobre 1789"
drop if Ordre==209 //resigned on 29/10/1789
drop if Député=="D'Arberg (Élection annulée)"
drop if Député=="Salm-Salm (Élection annulée)"
drop if Suppléant=="Suppléant ayant siégé POUR LE TIERS-ETAT"

//Representatives in favor of the Oath
//Generate a binary variable YES vs. others
gen serment_binaire=cond(Sermentstatut=="oui" | Sermentstatut=="adhésion",1,0)
replace serment_binaire=. if Sermentstatut=="il émigre le 30/10/1790"
replace serment_binaire=1 if Sermentstatut=="oui et adhésion après avoir été considéré réfractaire"

//Generate a ternary variable where with YES/NO/Others
gen serment_ternaire=cond(Sermentstatut=="non",-1,serment_binaire)
replace serment_binaire=0 if Sermentstatut=="est considéré comme réfractaire"
replace serment_ternaire=-1 if Sermentstatut=="est considéré comme réfractaire"
replace serment_binaire=0 if Sermentstatut=="a priori réfractaire"
replace serment_ternaire=-1 if Sermentstatut=="a priori réfractaire"

//Generate a binary variable where we consider only YES/NO (people we know they view for sure)
gen serment_sur=cond(Sermentstatut=="oui" | Sermentstatut=="adhésion",1,.)
replace serment_sur=0 if Sermentstatut=="non"

//Prepare merging
sort Département
gen SupraDepartement=Département
replace SupraDepartement="Paris" if Ville=="Paris-ville"
replace SupraDepartement="Bas-Rhin et Haut-Rhin" if Département=="Bas-Rhin"
replace SupraDepartement="Cher et Indre" if Département=="Cher"
replace SupraDepartement="Haute-Vienne et Creuse" if Département=="Creuse"
replace SupraDepartement="Côtes-d'Armor" if Département=="Côtes-du-Nord"
replace SupraDepartement="Haute-Saône et Doubs" if Département=="Doubs"
replace SupraDepartement="Eure-et-Loir" if Département=="Eure-et-Loire"
replace SupraDepartement="Bas-Rhin et Haut-Rhin" if Département=="Haut-Rhin"
replace SupraDepartement="Rhône et Loire" if Département=="Rhône"
replace SupraDepartement="Rhône et Loire" if Département=="Loire"
replace SupraDepartement="Marne et Ardennes" if Département=="Marne"
replace SupraDepartement="Marne et Ardennes" if Département=="Ardennes"
replace SupraDepartement="Pyrénées-Atlantiques" if Département=="Basses-Pyrénées"
replace SupraDepartement="Vienne et Deux-Sèvres" if Département=="Vienne"
replace SupraDepartement="Haute-Vienne et Creuse" if Département=="Haute-Vienne"
replace SupraDepartement="Jura" if Ville=="Dole"

//Import data priests
merge m:1 SupraDepartement using "NonSwornPriests/Data/DataAssermentesTreated.dta"
drop if _merge==2

//Correlation
reg serment_sur nonSwornPriest, cluster(SupraDepartement)
logit serment_sur nonSwornPriest, cluster(SupraDepartement)
mlogit serment_ternaire nonSwornPriest, cluster(SupraDepartement)

