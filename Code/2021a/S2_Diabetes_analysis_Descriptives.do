//****************************************************************************//
//
// PROGRAM: Diabetes analysis - descriptives
// PURPOSE: Descriptives of sample for diabetes trend analysis
// AUTHOR: Philip J Clare
// Date: 17/02/2021
//
//****************************************************************************//

if "`c(os)'"=="Windows" {
	use "C:\Users\pcla5984\Dropbox (Sydney Uni)\PHS\Diabetes\Data\phs0419 cleaned.dta", clear
}
else {
	use "/Users/pjclare/Dropbox (Sydney Uni)/PHS/Diabetes/Data/phs0419 cleaned.dta", clear
}

gen agecat=0 if age>=40 & age<50
replace agecat=1 if age>=50 & age<60
replace agecat=2 if age>=60 & age<70
replace agecat=3 if age>=70 & age<80
replace agecat=4 if age>=80
label define agec 0 "40-49" 1 "50-59" 2 "60-69" 3 "70-79" 4 "80+"
label values agecat agec
label var agecat "Age category"

gen yearcat=0 if year>=0 & year<=3
replace yearcat=1 if year>=4 & year<=7
replace yearcat=2 if year>=8 & year<=11
replace yearcat=3 if year>=12 & year<=15
label define yearc 0 "2004-2007" 1 "2008-2011" 2 "2012-2015" 3 "2016-2019"
label values yearcat yearc
label var yearcat "Age category (2yr)"

matrix table1n=J(25,4,.)
matrix table1p=J(25,4,.)

tab sex yearcat if diab==1, matcell(x)
	matrix table1n[2,1]=x
tab agecat yearcat if diab==1, matcell(x)
	matrix table1n[5,1]=x
tab educ yearcat if diab==1, matcell(x)
	matrix table1n[11,1]=x
tab i_lang yearcat if diab==1, matcell(x)
	matrix table1n[15,1]=x
tab i_cob yearcat if diab==1, matcell(x)
	matrix table1n[18,1]=x
tab i_aria yearcat if diab==1, matcell(x)
	matrix table1n[21,1]=x
tab i_seifa yearcat if diab==1, matcell(x)
	matrix table1n[24,1]=x

prop sex if diab==1, over(yearcat)
	matrix x=e(b)
	matrix table1p[2,1]=x[1,1..4] \ x[1,5..8]
prop agecat if diab==1, over(yearcat)
	matrix x=e(b)
	matrix table1p[5,1]=x[1,1..4] \ x[1,5..8] \ x[1,9..12] \ x[1,13..16] \ x[1,17..20]
prop educ if diab==1, over(yearcat)
	matrix x=e(b)
	matrix table1p[11,1]=x[1,1..4] \ x[1,5..8] \ x[1,9..12]
prop i_lang if diab==1, over(yearcat)
	matrix x=e(b)
	matrix table1p[15,1]=x[1,1..4] \ x[1,5..8]
prop i_cob if diab==1, over(yearcat)
	matrix x=e(b)
	matrix table1p[18,1]=x[1,1..4] \ x[1,5..8]
prop i_aria if diab==1, over(yearcat)
	matrix x=e(b)
	matrix table1p[21,1]=x[1,1..4] \ x[1,5..8]
prop i_seifa if diab==1, over(yearcat)
	matrix x=e(b)
	matrix table1p[24,1]=x[1,1..4] \ x[1,5..8]
	
matrix table1=table1n[1..25,1],table1p[1..25,1],table1n[1..25,2],table1p[1..25,2],table1n[1..25,3],table1p[1..25,3],table1n[1..25,4],table1p[1..25,4]
matrix rownames table1 = "Sex" "Female" "Male" "Age group" "40-49" "50-59" "60-69" "70-79" "80+" "Highest level of education" "School" "Technical/diploma/other" "University" "Speak non-English at home" "No" "Yes" "Born in Australia" "No" "Yes" "ARIA" "Major city" "Regional/remote" "SEIFA" "Least disadvantaged" "Most disadvantaged"
matrix colnames table1 = "2004-2007 n" "2004-2007 %" "2008-2011 n" "2008-2011 %" "2012-2015 n" "2012-2015 %" "2016-2019 n" "2016-2019 %"
matrix list table1

matrix tables1n=J(25,4,.)
matrix tables1p=J(25,4,.)

tab sex yearcat if diab==0, matcell(x)
	matrix tables1n[2,1]=x
tab agecat yearcat if diab==0, matcell(x)
	matrix tables1n[5,1]=x
tab educ yearcat if diab==0, matcell(x)
	matrix tables1n[11,1]=x
tab i_lang yearcat if diab==0, matcell(x)
	matrix tables1n[15,1]=x
tab i_cob yearcat if diab==0, matcell(x)
	matrix tables1n[18,1]=x
tab i_aria yearcat if diab==0, matcell(x)
	matrix tables1n[21,1]=x
tab i_seifa yearcat if diab==0, matcell(x)
	matrix tables1n[24,1]=x

prop sex if diab==0, over(yearcat)
	matrix x=e(b)
	matrix tables1p[2,1]=x[1,1..4] \ x[1,5..8]
prop agecat if diab==0, over(yearcat)
	matrix x=e(b)
	matrix tables1p[5,1]=x[1,1..4] \ x[1,5..8] \ x[1,9..12] \ x[1,13..16] \ x[1,17..20]
prop educ if diab==0, over(yearcat)
	matrix x=e(b)
	matrix tables1p[11,1]=x[1,1..4] \ x[1,5..8] \ x[1,9..12]
prop i_lang if diab==0, over(yearcat)
	matrix x=e(b)
	matrix tables1p[15,1]=x[1,1..4] \ x[1,5..8]
prop i_cob if diab==0, over(yearcat)
	matrix x=e(b)
	matrix tables1p[18,1]=x[1,1..4] \ x[1,5..8]
prop i_aria if diab==0, over(yearcat)
	matrix x=e(b)
	matrix tables1p[21,1]=x[1,1..4] \ x[1,5..8]
prop i_seifa if diab==0, over(yearcat)
	matrix x=e(b)
	matrix tables1p[24,1]=x[1,1..4] \ x[1,5..8]
	
matrix tables1=tables1n[1..25,1],tables1p[1..25,1],tables1n[1..25,2],tables1p[1..25,2],tables1n[1..25,3],tables1p[1..25,3],tables1n[1..25,4],tables1p[1..25,4]
matrix rownames tables1 = "Sex" "Female" "Male" "Age group" "40-49" "50-59" "60-69" "70-79" "80+" "Highest level of education" "School" "Technical/diploma/other" "University" "Speak non-English at home" "No" "Yes" "Born in Australia" "No" "Yes" "ARIA" "Major city" "Regional/remote" "SEIFA" "Least disadvantaged" "Most disadvantaged"
matrix colnames tables1 = "2004-2007 n" "2004-2007 %" "2008-2011 n" "2008-2011 %" "2012-2015 n" "2012-2015 %" "2016-2019 n" "2016-2019 %"
matrix list tables1
