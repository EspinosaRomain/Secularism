clear all
set more off

//Set WD
cd "~/Dropbox/Recherche/DonneesEglise/DataAnalysis/Religiosity/"

//Import data
use "Data/treatedDataReligiosity2013.dta"

//Generate data
gen confirm_pour_dixmille=confirmations_2013/pop_total_diocese_2013*10000
gen pretre_pour_dixmille=nb_pretres_2013/pop_total_diocese_2013*10000
gen diacres_pour_dixmille=nb_diacres_2013/pop_total_diocese_2013*10000
gen prop_mariage_eglise=mariages_2013/mariagesINSEE_2013  

//Analyze data
su pourcent_enfants_baptises_2013 propPrive_2013 confirm_pour_dixmille pretre_pour_dixmille diacres_pour_dixmille prop_mariage_eglise

pwcorr pourcent_enfants_baptises_2013 propPrive_2013 confirm_pour_dixmille pretre_pour_dixmille diacres_pour_dixmille prop_mariage_eglise, sig

pca pourcent_enfants_baptises_2013 propPrive_2013 confirm_pour_dixmille pretre_pour_dixmille diacres_pour_dixmille prop_mariage_eglise
predict religiosity_2013 symbol_2013


//Save
save "Data/religiosity2013.dta", replace

