clear all
set more off

//Set WD
cd "~/Dropbox/Recherche/DonneesEglise/DataAnalysis/"

//Import data
import excel "Education/RawData/ENSP_T33_MisEnForme.xls", first

//Clean data
drop if Nomdelunit=="FRANCE"

ren Totaldesélèvesdesécolespubl studentsPublic_secular_1850
ren ET studentsPublic_religious_1850 
ren EW studentsPublic_secular_1863
ren EX studentsPublic_religious_1863
ren FA studentsPublic_secular_1867
ren FB studentsPublic_religious_1867
ren FE studentsPublic_secular_1877
ren FX studentsPublic_religious_1877
ren Codedud CodeDepartement
ren Nomdelunit NomDepartement

keep NomDepartement studentsPublic_secular_* studentsPublic_religious_*

//Save data before merging
save "Education/Data/educ19thcentury.dta", replace

//Import data 
clear
import delimited "Education/RawData/SheetForDepNames.csv", delimiter(";", collapse) varnames(1) encoding(ISO-8859-1)
ren nomdepartement NomDepartement
save "Education/Data/tmpMergingDepSheet.dta", replace

//Merge departement names
use "Education/Data/educ19thcentury.dta", clear
merge 1:1 NomDepartement using "Education/Data/tmpMergingDepSheet.dta"
save "Education/Data/educ19thcentury.dta", replace

//Collapse data for supra-departements
drop if departement==""
drop NomDepartement _merge
collapse (sum) studentsPublic_secular_1850 studentsPublic_religious_1850 studentsPublic_secular_1863 studentsPublic_religious_1863 studentsPublic_secular_1867 studentsPublic_religious_1867 studentsPublic_secular_1877 studentsPublic_religious_1877, by(departement)
foreach k in studentsPublic_secular_1850 studentsPublic_religious_1850 studentsPublic_secular_1863 studentsPublic_religious_1863 studentsPublic_secular_1867 studentsPublic_religious_1867 studentsPublic_secular_1877 studentsPublic_religious_1877{
	replace `k'=. if `k'==0
} 

//Merge with non-sworn priests
replace departement=subinstr(departement, "Ã¨", "è",.)
replace departement=subinstr(departement, "Ã´", "ô",.)
replace departement=subinstr(departement, "Ã©", "é",.)
merge 1:1 departement using "NonSwornPriests/RawData/DataAssermentes.dta"
drop _merge

//Generate proportion of non-sworn priests
gen percentPrintemps1791=jureursprintemps1791/totalclerge
gen percentEte1791=jureursete1791/totalclerge
gen pourc_assermentes_1791=(jureursprintemps1791+jureursete1791)/(2*totalclerge)
replace pourc_assermentes_1791=jureursprintemps1791/totalclerge if jureursete1791==.
replace pourc_assermentes_1791=jureursete1791/totalclerge if jureursprintemps1791==.
replace pourc_assermentes_1791=pourc_diocese_assermentes/100 if pourc_assermentes_1791==.
gen nonSwornPriest=1-pourc_assermentes_1791

//Save data
save "Education/Data/educ19thcentury.dta", replace

//Remove useless dataset
erase "Education/Data/tmpMergingDepSheet.dta"

//Generate data on shares
foreach k in 1850 1863 1867 1877{
	gen share_secular_`k'=studentsPublic_secular_`k'/(studentsPublic_secular_`k'+studentsPublic_religious_`k')
}


//Analyze data
mat Results=J(4,2,.)
reg share_secular_1850 nonSwornPriest
mat b=e(b)
mat V=e(V)
mat Results[1,1]=round(b[1,1],0.001)
mat Results[1,2]=round(sqrt(V[1,1]),0.001)
reg share_secular_1863 nonSwornPriest
mat b=e(b)
mat V=e(V)
mat Results[2,1]=round(b[1,1],0.001)
mat Results[2,2]=round(sqrt(V[1,1]),0.001)
reg share_secular_1867 nonSwornPriest
mat b=e(b)
mat V=e(V)
mat Results[3,1]=round(b[1,1],0.001)
mat Results[3,2]=round(sqrt(V[1,1]),0.001)
reg share_secular_1877 nonSwornPriest
mat b=e(b)
mat V=e(V)
mat Results[4,1]=round(b[1,1],0.001)
mat Results[4,2]=round(sqrt(V[1,1]),0.001)

mat list Results
