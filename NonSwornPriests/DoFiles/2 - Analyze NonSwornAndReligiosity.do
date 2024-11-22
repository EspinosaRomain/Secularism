clear all
set more off

//Set WD
cd "~/Dropbox/Recherche/DonneesEglise/DataAnalysis/NonSwornPriests/"

//Import data
use "Data/religiosityAndNonSwornPriests.dta", clear

//Look at data
pwcorr religiosity_2013 nonSwornPriest, sig

//Regressions
local k=1
local j=1
foreach var in religiosity_2013 pourcent_enfants_baptises_2013 propPrive_2013 confirm_pour_dixmille pretre_pour_dixmille diacres_pour_dixmille prop_mariage_eglise{   
	reg `var' nonSwornPriest
	if(`k'==1){
		outreg2  using "Tables/resultsCorrelationIndices.xls",  stats(coef se)  replace excel
		}
	if(`k'>1){
		outreg2  using "Tables/resultsCorrelationIndices.xls",  stats(coef se)  append excel
		}
	local k=`k'+1
	reg `var' nonSwornPriest tx_chom_2013 ratioDecile_2013 lnMedianeNiveauVie_2013 lnPop15etPlus
	if(`j'==1){
		outreg2  using "Tables/resultsCorrelationIndices_Controls.xls",  stats(coef se)  replace excel
		}
	if(`j'>1){
		outreg2  using "Tables/resultsCorrelationIndices_Controls.xls",  stats(coef se)  append excel
		}
	local j=`j'+1
}

