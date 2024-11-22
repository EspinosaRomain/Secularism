clear all
set more off

//Set WD
cd "~/Dropbox/Recherche/DonneesEglise/DataAnalysis/Education/"

//Import data
import delimited "RawData/edPublique.csv", delimiter(";", collapse) varnames(1) encoding(ISO-8859-1)

//Recode data with comma
foreach var in tp1850 tp1863 tp1867 tp1876 tp1881 tp1886 tp1891 tp1896 tp1996 tp2001 tp2006 tp2011 tp2016 tp2018{
	replace `var'="" if `var'=="NA"
	destring `var', dpcomma replace
} 

