//****************************************************************************//
//
// PROGRAM: Diabetes analysis - Aim 1
// PURPOSE: Analysis for Aim 1 of Diabetes trend analysis
// AUTHOR: Philip J Clare
// Date: 17/02/2021
//
//****************************************************************************//

if "`c(os)'"=="Windows" {
	use "C:\Users\pcla5984\Dropbox (Sydney Uni)\PHS\Diabetes\Data\phs0419 imputed.dta", clear
}
else {
	use "/Users/pjclare/Dropbox (Sydney Uni)/PHS/Diabetes/Data/phs0419 imputed.dta", clear
}

mi svyset [pweight=wgt], strata(strata)

/* Aim 1. Trends in type 2 diabetes */

capture program drop trendcalc
program define trendcalc, eclass
capture drop prtemp setemp lotemp uptemp

local outcome="`1'"
if "`2'"=="cat" {
    local time1="i.yearcat"
	local time2="yearcat"
}
else if "`2'"=="cont" {
    local time1="c.year"
	local time2="year"
}

mi estimate, saving(temp, replace): svy: logit `outcome' `time1' i.agecat sex i.educ i.i_aria i.i_seifa i.i_lang i.i_cob

preserve
mi predict prtemp using temp
mi predict setemp using temp, stdp
mi extract 0, clear
gen lotemp=prtemp-invnormal(0.975)*setemp
gen uptemp=prtemp+invnormal(0.975)*setemp
replace prtemp=invlogit(prtemp)
replace lotemp=invlogit(lotemp)
replace uptemp=invlogit(uptemp)

svy: mean prtemp lotemp uptemp, over(`time2')
restore

end

trendcalc diab cat
	matrix figure1=J(3,4,.)
	matrix temp=e(b)
	matrix figure1[1,1]=temp[1,1..4]
	matrix figure1[2,1]=temp[1,5..8]
	matrix figure1[3,1]=temp[1,9..12]
	matrix rownames figure1 = "Prevalence" "Lower CI" "Upper CI"
	matrix colnames figure1 = "2004-2007" "2008-2011" "2012-2015" "2016-2019"
trendcalc diab cont
	matrix figureS1=J(3,16,.)
	matrix temp=e(b)
	matrix figureS1[1,1]=temp[1,1..16]
	matrix figureS1[2,1]=temp[1,17..32]
	matrix figureS1[3,1]=temp[1,33..48]
	matrix rownames figureS1 = "Prevalence" "Lower CI" "Upper CI"
	matrix colnames figureS1 = "2004" "2005" "2006" "2007" "2008" "2009" "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019"

matrix list figure1
matrix list figureS1



