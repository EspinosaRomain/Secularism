clear all
set more off

//Set WD
cd "~/Dropbox/Recherche/DonneesEglise/DataAnalysis/"

//Import data
import delimited "Education/RawData/les-effectifs-du-premier-degr-2009-2020-74512.csv", delimiter(";", collapse) varnames(1) encoding(ISO-8859-1)

//Drop non-relevant geographic areas
keep if niveaug=="DEPARTEMENT"

//Keep only primary schools
keep if niveaudense=="ELEMENTAIRE"

//Generate dummy for public school
gen public_school=cond(contratde=="PUBLIC",1,0)

//Sum students by type of school and departement and year
collapse (sum) nombredeleves, by(libellegeographique public_school rentree)

//Generate total number of students per school/dep/year
egen totalStud=sum(nombredeleves), by(libellegeographique rentree)

//Generate share of students in public elementary schools
keep if public_school==1
//gen share_public=nombredeleves/totalStud
drop public_school
ren nombredeleves studPublic
ren rentree year
ren libelle dep

//Save data before merging
save "Education/Data/educ21thcentury.dta", replace

//Import data 
clear
import delimited "Education/RawData/SheetDepNames21cent.csv", delimiter(";", collapse) varnames(1) encoding(ISO-8859-1)
ren ÿþdep dep
replace dep=subinstr(dep, "ÿþ", "",.) 
save "Education/Data/tmpMergingDepSheet.dta", replace

//Merge departement names
use "Education/Data/educ21thcentury.dta", clear
merge n:1 dep using "Education/Data/tmpMergingDepSheet.dta"
save "Education/Data/educ21thcentury.dta", replace

//Collapse data for supra-departements
drop if departement==""
collapse (sum) studPublic totalStud, by(departement year)

//merge with priests data
merge n:1 departement using "NonSwornPriests/RawData/DataAssermentes.dta"
drop _merge

//Generate proportion of non-sworn priests
gen percentPrintemps1791=jureursprintemps1791/totalclerge
gen percentEte1791=jureursete1791/totalclerge
gen pourc_assermentes_1791=(jureursprintemps1791+jureursete1791)/(2*totalclerge)
replace pourc_assermentes_1791=jureursprintemps1791/totalclerge if jureursete1791==.
replace pourc_assermentes_1791=jureursete1791/totalclerge if jureursprintemps1791==.
replace pourc_assermentes_1791=pourc_diocese_assermentes/100 if pourc_assermentes_1791==.
gen nonSwornPriest=1-pourc_assermentes_1791

//Generate share of studs in public schools
gen share_public=studPublic/totalStud

//Keep relevant data
keep year departement share_public nonSwornPriest

//Regressions
mat Results=J(12,4,.)
forvalues k=2009(1)2020{
	qui reg share_public nonSwornPriest if year==`k'
	mat b=e(b)
	mat V=e(V)
	mat Results[`k'-2008,1]=round(b[1,1],0.001)
	mat Results[`k'-2008,2]=round(sqrt(V[1,1]),0.001)
	mat Results[`k'-2008,3]=round(e(r2),0.001)
	mat Results[`k'-2008,4]=e(N)
}
mat list Results
