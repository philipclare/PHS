//****************************************************************************//
//
// PROGRAM: Diabetes analysis - Aim 3
// PURPOSE: Analysis for Aim 3 of Diabetes trend analysis
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

/* Aim 3. Trends in diabetes management strategies */

capture program drop trendcalc3
program define trendcalc3, eclass
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

mi estimate, saving(temp, replace) esampvaryok: svy: logit `outcome' `time1' i.agecat sex i.educ i.i_aria i.i_seifa i.i_lang i.i_cob if diab==1

mi predict prtemp using temp
mi predict setemp using temp, stdp
gen lotemp=prtemp-invnormal(0.975)*setemp
gen uptemp=prtemp+invnormal(0.975)*setemp
replace prtemp=invlogit(prtemp)
replace lotemp=invlogit(lotemp)
replace uptemp=invlogit(uptemp)

mean prtemp lotemp uptemp, over(`time2')

end

// Categorical time categories
trendcalc3 i_mgmt1 cat
	matrix mgmt1_res_cat=J(3,4,.)
	matrix temp=e(b)
	matrix mgmt1_res_cat[1,1]=temp[1,1..4]
	matrix mgmt1_res_cat[2,1]=temp[1,5..8]
	matrix mgmt1_res_cat[3,1]=temp[1,9..12]
	matrix rownames mgmt1_res_cat = "Prevalence" "Lower CI" "Upper CI"
	matrix colnames mgmt1_res_cat = "2004-2007" "2008-2011" "2012-2015" "2016-2019"
trendcalc3 i_mgmt2 cat
	matrix mgmt2_res_cat=J(3,4,.)
	matrix temp=e(b)
	matrix mgmt2_res_cat[1,1]=temp[1,1..4]
	matrix mgmt2_res_cat[2,1]=temp[1,5..8]
	matrix mgmt2_res_cat[3,1]=temp[1,9..12]
	matrix rownames mgmt2_res_cat = "Prevalence" "Lower CI" "Upper CI"
	matrix colnames mgmt2_res_cat = "2004-2007" "2008-2011" "2012-2015" "2016-2019"
trendcalc3 i_mgmt3 cat
	matrix mgmt3_res_cat=J(3,4,.)
	matrix temp=e(b)
	matrix mgmt3_res_cat[1,1]=temp[1,1..4]
	matrix mgmt3_res_cat[2,1]=temp[1,5..8]
	matrix mgmt3_res_cat[3,1]=temp[1,9..12]
	matrix rownames mgmt3_res_cat = "Prevalence" "Lower CI" "Upper CI"
	matrix colnames mgmt3_res_cat = "2004-2007" "2008-2011" "2012-2015" "2016-2019"

matrix table3=mgmt1_res_cat \ mgmt2_res_cat \ mgmt3_res_cat

// Continuous time
trendcalc3 i_mgmt1 cont
	matrix mgmt1_res_cont=J(3,16,.)
	matrix temp=e(b)
	matrix mgmt1_res_cont[1,1]=temp[1,1..16]
	matrix mgmt1_res_cont[2,1]=temp[1,17..32]
	matrix mgmt1_res_cont[3,1]=temp[1,33..48]
	matrix rownames mgmt1_res_cont = "Prevalence" "Lower CI" "Upper CI"
	matrix colnames mgmt1_res_cont = "2004" "2005" "2006" "2007" "2008" "2009" "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019"
trendcalc3 i_mgmt2 cont
	matrix mgmt2_res_cont=J(3,16,.)
	matrix temp=e(b)
	matrix mgmt2_res_cont[1,1]=temp[1,1..16]
	matrix mgmt2_res_cont[2,1]=temp[1,17..32]
	matrix mgmt2_res_cont[3,1]=temp[1,33..48]
	matrix rownames mgmt2_res_cont = "Prevalence" "Lower CI" "Upper CI"
	matrix colnames mgmt2_res_cont = "2004" "2005" "2006" "2007" "2008" "2009" "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019"
trendcalc3 i_mgmt3 cont
	matrix mgmt3_res_cont=J(3,16,.)
	matrix temp=e(b)
	matrix mgmt3_res_cont[1,1]=temp[1,1..16]
	matrix mgmt3_res_cont[2,1]=temp[1,17..32]
	matrix mgmt3_res_cont[3,1]=temp[1,33..48]
	matrix rownames mgmt3_res_cont = "Prevalence" "Lower CI" "Upper CI"
	matrix colnames mgmt3_res_cont = "2004" "2005" "2006" "2007" "2008" "2009" "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019"

matrix tableS5=mgmt1_res_cont \ mgmt2_res_cont \ mgmt3_res_cont

matrix list table3
matrix list tableS5
