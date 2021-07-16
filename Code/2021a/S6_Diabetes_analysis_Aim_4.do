//****************************************************************************//
//
// PROGRAM: Diabetes analysis - Aim 4
// PURPOSE: Analysis for Aim 4 of Diabetes trend analysis
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

/* Aim 4. Associations between diabetes management strategies and risk factors */
mi estimate, esampvaryok saving(mgmt1, replace) or: svy: logit i_mgmt1 i_owtobs i_vegb2 i_fruitb i_swtdrnkb i_physactb i_nonsmkb i_lowriskdb i_lowdistb i.yearcat i.agecat sex i.educ i.i_aria i.i_seifa i.i_lang i.i_cob if diab==1

mi estimate, esampvaryok saving(mgmt2, replace) or: svy: logit i_mgmt2 i_owtobs i_vegb2 i_fruitb i_swtdrnkb i_physactb i_nonsmkb i_lowriskdb i_lowdistb i.yearcat i.agecat sex i.educ i.i_aria i.i_seifa i.i_lang i.i_cob if diab==1

mi estimate, esampvaryok saving(mgmt3, replace) or: svy: logit i_mgmt3 i_owtobs i_vegb2 i_fruitb i_swtdrnkb i_physactb i_nonsmkb i_lowriskdb i_lowdistb i.yearcat i.agecat sex i.educ i.i_aria i.i_seifa i.i_lang i.i_cob if diab==1
