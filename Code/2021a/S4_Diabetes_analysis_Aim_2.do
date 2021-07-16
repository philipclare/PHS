//****************************************************************************//
//
// PROGRAM: Diabetes analysis - Aim 2
// PURPOSE: Analysis for Aim 2 of Diabetes trend analysis
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

/* Aim 2. Associations between diabetes and risk factors over time */

capture program drop trendcalc2
program define trendcalc2, eclass
capture drop prtemp setemp lotemp uptemp

local outcome="`1'"
if "`2'"=="cat" {
    local time1="i.yearcat"
	local time2="yearcat"
	local lincom="(nodiabt2: _b[1.yearcat]) (nodiabt3: _b[2.yearcat]) (nodiabt4: _b[3.yearcat]) (diabt1: _b[1.diab]) (diabt2: _b[1.yearcat] + _b[1.diab] + _b[1.diab#1.yearcat]) (diabt3: _b[2.yearcat] + _b[1.diab] + _b[1.diab#2.yearcat]) (diabt4: _b[3.yearcat] + _b[1.diab] + _b[1.diab#3.yearcat])"
}
else if "`2'"=="cont" {
    local time1="c.year"
	local time2="year"
	local lincom=""
}

mi estimate `lincom', saving(temp, replace): svy: logit `outcome' diab##`time1' i.agecat sex i.educ i.i_aria i.i_seifa i.i_lang i.i_cob

mi predict prtemp using temp
mi predict setemp using temp, stdp
gen lotemp=prtemp-invnormal(0.975)*setemp
gen uptemp=prtemp+invnormal(0.975)*setemp
replace prtemp=invlogit(prtemp)
replace lotemp=invlogit(lotemp)
replace uptemp=invlogit(uptemp)

mean prtemp lotemp uptemp, over(diab `time2')

end

// Categorical time categories

trendcalc2 i_owtobs cat
	matrix i_owtobs_res_cat=J(6,4,.)
	matrix temp=e(b)
	matrix i_owtobs_res_cat[4,1]=temp[1,1..4]
	matrix i_owtobs_res_cat[1,1]=temp[1,5..8]
	matrix i_owtobs_res_cat[5,1]=temp[1,9..12]
	matrix i_owtobs_res_cat[2,1]=temp[1,13..16]
	matrix i_owtobs_res_cat[6,1]=temp[1,17..20]
	matrix i_owtobs_res_cat[3,1]=temp[1,21..24]
	matrix rownames i_owtobs_res_cat = "T2 Diabetes - Prevalence" "Lower CI" "Upper CI" "No T2 Diabetes - Prevalence" "Lower CI" "Upper CI"
	matrix colnames i_owtobs_res_cat = "2004-2007" "2008-2011" "2012-2015" "2016-2019"
trendcalc2 i_vegb2 cat
	matrix i_vegb2_res_cat=J(6,4,.)
	matrix temp=e(b)
	matrix i_vegb2_res_cat[4,1]=temp[1,1..4]
	matrix i_vegb2_res_cat[1,1]=temp[1,5..8]
	matrix i_vegb2_res_cat[5,1]=temp[1,9..12]
	matrix i_vegb2_res_cat[2,1]=temp[1,13..16]
	matrix i_vegb2_res_cat[6,1]=temp[1,17..20]
	matrix i_vegb2_res_cat[3,1]=temp[1,21..24]
	matrix rownames i_vegb2_res_cat = "T2 Diabetes - Prevalence" "Lower CI" "Upper CI" "No T2 Diabetes - Prevalence" "Lower CI" "Upper CI"
	matrix colnames i_vegb2_res_cat = "2004-2007" "2008-2011" "2012-2015" "2016-2019"
trendcalc2 i_fruitb cat
	matrix i_fruitb_res_cat=J(6,4,.)
	matrix temp=e(b)
	matrix i_fruitb_res_cat[4,1]=temp[1,1..4]
	matrix i_fruitb_res_cat[1,1]=temp[1,5..8]
	matrix i_fruitb_res_cat[5,1]=temp[1,9..12]
	matrix i_fruitb_res_cat[2,1]=temp[1,13..16]
	matrix i_fruitb_res_cat[6,1]=temp[1,17..20]
	matrix i_fruitb_res_cat[3,1]=temp[1,21..24]
	matrix rownames i_fruitb_res_cat = "T2 Diabetes - Prevalence" "Lower CI" "Upper CI" "No T2 Diabetes - Prevalence" "Lower CI" "Upper CI"
	matrix colnames i_fruitb_res_cat = "2004-2007" "2008-2011" "2012-2015" "2016-2019"
trendcalc2 i_swtdrnkb cat
	matrix i_swtdrnkb_res_cat=J(6,4,.)
	matrix temp=e(b)
	matrix i_swtdrnkb_res_cat[4,1]=temp[1,1..4]
	matrix i_swtdrnkb_res_cat[1,1]=temp[1,5..8]
	matrix i_swtdrnkb_res_cat[5,1]=temp[1,9..12]
	matrix i_swtdrnkb_res_cat[2,1]=temp[1,13..16]
	matrix i_swtdrnkb_res_cat[6,1]=temp[1,17..20]
	matrix i_swtdrnkb_res_cat[3,1]=temp[1,21..24]
	matrix rownames i_swtdrnkb_res_cat = "T2 Diabetes - Prevalence" "Lower CI" "Upper CI" "No T2 Diabetes - Prevalence" "Lower CI" "Upper CI"
	matrix colnames i_swtdrnkb_res_cat = "2004-2007" "2008-2011" "2012-2015" "2016-2019"
trendcalc2 i_physactb cat
	matrix i_physactb_res_cat=J(6,4,.)
	matrix temp=e(b)
	matrix i_physactb_res_cat[4,1]=temp[1,1..4]
	matrix i_physactb_res_cat[1,1]=temp[1,5..8]
	matrix i_physactb_res_cat[5,1]=temp[1,9..12]
	matrix i_physactb_res_cat[2,1]=temp[1,13..16]
	matrix i_physactb_res_cat[6,1]=temp[1,17..20]
	matrix i_physactb_res_cat[3,1]=temp[1,21..24]
	matrix rownames i_physactb_res_cat = "T2 Diabetes - Prevalence" "Lower CI" "Upper CI" "No T2 Diabetes - Prevalence" "Lower CI" "Upper CI"
	matrix colnames i_physactb_res_cat = "2004-2007" "2008-2011" "2012-2015" "2016-2019"
trendcalc2 i_nonsmkb cat
	matrix i_nonsmkb_res_cat=J(6,4,.)
	matrix temp=e(b)
	matrix i_nonsmkb_res_cat[4,1]=temp[1,1..4]
	matrix i_nonsmkb_res_cat[1,1]=temp[1,5..8]
	matrix i_nonsmkb_res_cat[5,1]=temp[1,9..12]
	matrix i_nonsmkb_res_cat[2,1]=temp[1,13..16]
	matrix i_nonsmkb_res_cat[6,1]=temp[1,17..20]
	matrix i_nonsmkb_res_cat[3,1]=temp[1,21..24]
	matrix rownames i_nonsmkb_res_cat = "T2 Diabetes - Prevalence" "Lower CI" "Upper CI" "No T2 Diabetes - Prevalence" "Lower CI" "Upper CI"
	matrix colnames i_nonsmkb_res_cat = "2004-2007" "2008-2011" "2012-2015" "2016-2019"
trendcalc2 i_lowriskdb cat
	matrix i_lowriskdb_res_cat=J(6,4,.)
	matrix temp=e(b)
	matrix i_lowriskdb_res_cat[4,1]=temp[1,1..4]
	matrix i_lowriskdb_res_cat[1,1]=temp[1,5..8]
	matrix i_lowriskdb_res_cat[5,1]=temp[1,9..12]
	matrix i_lowriskdb_res_cat[2,1]=temp[1,13..16]
	matrix i_lowriskdb_res_cat[6,1]=temp[1,17..20]
	matrix i_lowriskdb_res_cat[3,1]=temp[1,21..24]
	matrix rownames i_lowriskdb_res_cat = "T2 Diabetes - Prevalence" "Lower CI" "Upper CI" "No T2 Diabetes - Prevalence" "Lower CI" "Upper CI"
	matrix colnames i_lowriskdb_res_cat = "2004-2007" "2008-2011" "2012-2015" "2016-2019"
trendcalc2 i_lowdistb cat
	matrix i_lowdistb_res_cat=J(6,4,.)
	matrix temp=e(b)
	matrix i_lowdistb_res_cat[4,1]=temp[1,1..4]
	matrix i_lowdistb_res_cat[1,1]=temp[1,5..8]
	matrix i_lowdistb_res_cat[5,1]=temp[1,9..12]
	matrix i_lowdistb_res_cat[2,1]=temp[1,13..16]
	matrix i_lowdistb_res_cat[6,1]=temp[1,17..20]
	matrix i_lowdistb_res_cat[3,1]=temp[1,21..24]
	matrix rownames i_lowdistb_res_cat = "T2 Diabetes - Prevalence" "Lower CI" "Upper CI" "No T2 Diabetes - Prevalence" "Lower CI" "Upper CI"
	matrix colnames i_lowdistb_res_cat = "2004-2007" "2008-2011" "2012-2015" "2016-2019"

matrix table2=i_owtobs_res_cat \ i_vegb2_res_cat \ i_fruitb_res_cat \ i_swtdrnkb_res_cat \ ///
i_physactb_res_cat \ i_nonsmkb_res_cat \ i_lowriskdb_res_cat \ i_lowdistb_res_cat
	
// Continuous time
trendcalc2 i_owtobs cont
	matrix i_owtobs_res_cont=J(6,16,.)
	matrix temp=e(b)
	matrix i_owtobs_res_cont[4,1]=temp[1,1..16]
	matrix i_owtobs_res_cont[1,1]=temp[1,17..32]
	matrix i_owtobs_res_cont[5,1]=temp[1,33..48]
	matrix i_owtobs_res_cont[2,1]=temp[1,49..64]
	matrix i_owtobs_res_cont[6,1]=temp[1,65..80]
	matrix i_owtobs_res_cont[3,1]=temp[1,81..96]
	matrix rownames i_owtobs_res_cont = "T2 Diabetes - Prevalence" "Lower CI" "Upper CI" "No T2 Diabetes - Prevalence" "Lower CI" "Upper CI"
	matrix colnames i_owtobs_res_cont = "2004" "2005" "2006" "2007" "2008" "2009" "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019"
trendcalc2 i_vegb2 cont
	matrix i_vegb2_res_cont=J(6,16,.)
	matrix temp=e(b)
	matrix i_vegb2_res_cont[4,1]=temp[1,1..16]
	matrix i_vegb2_res_cont[1,1]=temp[1,17..32]
	matrix i_vegb2_res_cont[5,1]=temp[1,33..48]
	matrix i_vegb2_res_cont[2,1]=temp[1,49..64]
	matrix i_vegb2_res_cont[6,1]=temp[1,65..80]
	matrix i_vegb2_res_cont[3,1]=temp[1,81..96]
	matrix rownames i_vegb2_res_cont = "T2 Diabetes - Prevalence" "Lower CI" "Upper CI" "No T2 Diabetes - Prevalence" "Lower CI" "Upper CI"
	matrix colnames i_vegb2_res_cont = "2004" "2005" "2006" "2007" "2008" "2009" "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019"
trendcalc2 i_fruitb cont
	matrix i_fruitb_res_cont=J(6,16,.)
	matrix temp=e(b)
	matrix i_fruitb_res_cont[4,1]=temp[1,1..16]
	matrix i_fruitb_res_cont[1,1]=temp[1,17..32]
	matrix i_fruitb_res_cont[5,1]=temp[1,33..48]
	matrix i_fruitb_res_cont[2,1]=temp[1,49..64]
	matrix i_fruitb_res_cont[6,1]=temp[1,65..80]
	matrix i_fruitb_res_cont[3,1]=temp[1,81..96]
	matrix rownames i_fruitb_res_cont = "T2 Diabetes - Prevalence" "Lower CI" "Upper CI" "No T2 Diabetes - Prevalence" "Lower CI" "Upper CI"
	matrix colnames i_fruitb_res_cont = "2004" "2005" "2006" "2007" "2008" "2009" "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019"
trendcalc2 i_swtdrnkb cont
	matrix i_swtdrnkb_res_cont=J(6,16,.)
	matrix temp=e(b)
	matrix i_swtdrnkb_res_cont[4,1]=temp[1,1..16]
	matrix i_swtdrnkb_res_cont[1,1]=temp[1,17..32]
	matrix i_swtdrnkb_res_cont[5,1]=temp[1,33..48]
	matrix i_swtdrnkb_res_cont[2,1]=temp[1,49..64]
	matrix i_swtdrnkb_res_cont[6,1]=temp[1,65..80]
	matrix i_swtdrnkb_res_cont[3,1]=temp[1,81..96]
	matrix rownames i_swtdrnkb_res_cont = "T2 Diabetes - Prevalence" "Lower CI" "Upper CI" "No T2 Diabetes - Prevalence" "Lower CI" "Upper CI"
	matrix colnames i_swtdrnkb_res_cont = "2004" "2005" "2006" "2007" "2008" "2009" "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019"
trendcalc2 i_physactb cont
	matrix i_physactb_res_cont=J(6,16,.)
	matrix temp=e(b)
	matrix i_physactb_res_cont[4,1]=temp[1,1..16]
	matrix i_physactb_res_cont[1,1]=temp[1,17..32]
	matrix i_physactb_res_cont[5,1]=temp[1,33..48]
	matrix i_physactb_res_cont[2,1]=temp[1,49..64]
	matrix i_physactb_res_cont[6,1]=temp[1,65..80]
	matrix i_physactb_res_cont[3,1]=temp[1,81..96]
	matrix rownames i_physactb_res_cont = "T2 Diabetes - Prevalence" "Lower CI" "Upper CI" "No T2 Diabetes - Prevalence" "Lower CI" "Upper CI"
	matrix colnames i_physactb_res_cont = "2004" "2005" "2006" "2007" "2008" "2009" "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019"
trendcalc2 i_nonsmkb cont
	matrix i_nonsmkb_res_cont=J(6,16,.)
	matrix temp=e(b)
	matrix i_nonsmkb_res_cont[4,1]=temp[1,1..16]
	matrix i_nonsmkb_res_cont[1,1]=temp[1,17..32]
	matrix i_nonsmkb_res_cont[5,1]=temp[1,33..48]
	matrix i_nonsmkb_res_cont[2,1]=temp[1,49..64]
	matrix i_nonsmkb_res_cont[6,1]=temp[1,65..80]
	matrix i_nonsmkb_res_cont[3,1]=temp[1,81..96]
	matrix rownames i_nonsmkb_res_cont = "T2 Diabetes - Prevalence" "Lower CI" "Upper CI" "No T2 Diabetes - Prevalence" "Lower CI" "Upper CI"
	matrix colnames i_nonsmkb_res_cont = "2004" "2005" "2006" "2007" "2008" "2009" "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019"
trendcalc2 i_lowriskdb cont
	matrix i_lowriskdb_res_cont=J(6,16,.)
	matrix temp=e(b)
	matrix i_lowriskdb_res_cont[4,1]=temp[1,1..16]
	matrix i_lowriskdb_res_cont[1,1]=temp[1,17..32]
	matrix i_lowriskdb_res_cont[5,1]=temp[1,33..48]
	matrix i_lowriskdb_res_cont[2,1]=temp[1,49..64]
	matrix i_lowriskdb_res_cont[6,1]=temp[1,65..80]
	matrix i_lowriskdb_res_cont[3,1]=temp[1,81..96]
	matrix rownames i_lowriskdb_res_cont = "T2 Diabetes - Prevalence" "Lower CI" "Upper CI" "No T2 Diabetes - Prevalence" "Lower CI" "Upper CI"
	matrix colnames i_lowriskdb_res_cont = "2004" "2005" "2006" "2007" "2008" "2009" "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019"
trendcalc2 i_lowdistb cont
	matrix i_lowdistb_res_cont=J(6,16,.)
	matrix temp=e(b)
	matrix i_lowdistb_res_cont[4,1]=temp[1,1..16]
	matrix i_lowdistb_res_cont[1,1]=temp[1,17..32]
	matrix i_lowdistb_res_cont[5,1]=temp[1,33..48]
	matrix i_lowdistb_res_cont[2,1]=temp[1,49..64]
	matrix i_lowdistb_res_cont[6,1]=temp[1,65..80]
	matrix i_lowdistb_res_cont[3,1]=temp[1,81..96]
	matrix rownames i_lowdistb_res_cont = "T2 Diabetes - Prevalence" "Lower CI" "Upper CI" "No T2 Diabetes - Prevalence" "Lower CI" "Upper CI"
	matrix colnames i_lowdistb_res_cont = "2004" "2005" "2006" "2007" "2008" "2009" "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019"
	
matrix figureS2=i_owtobs_res_cont \ i_vegb2_res_cont \ i_fruitb_res_cont \ i_swtdrnkb_res_cont 
matrix figureS3=i_physactb_res_cont \ i_nonsmkb_res_cont \ i_lowriskdb_res_cont \ i_lowdistb_res_cont

matrix list table2
matrix list figureS2
matrix list figureS3