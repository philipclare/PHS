//****************************************************************************//
//
// PROGRAM: Diabetes analysis - data preparation
// PURPOSE: Clean and impute data for diabetes trend analysis
// AUTHOR: Philip J Clare
// Date: 17/02/2021
//
//****************************************************************************//

use "/Users/pjclare/Dropbox (Sydney Uni)/PHS/phs0419.dta", clear

label define noyes 0 "No" 1 "Yes"

/* DIABETES */

* Replicate i_diab1 variable contained in dataset
gen diab=0 if DBT1=="2" | DBT1=="3" | DBT2=="2" | DBT2=="3" | DBT2=="4" | DBT2x=="2" | DBT2x=="3" | DBT2x=="4"
replace diab=1 if (DBT1=="1" | DBT2=="1" | DBT2x=="1") & DBT19=="2"
replace diab=2 if (DBT1=="1" | DBT2=="1" | DBT2x=="1") & (DBT19=="1" | DBT19=="3" | DBT19=="4") | DBT4=="2"
replace diab=2 if diab==1 & DBT4=="1"
label var diab "Type 2 diabetes"
label values diab noyes

/* OVERWWEIGHT AND OBESE */

* Replicate d_bmi variable, for QA purposes
gen bmi=w3/(h3/100)^2
*corr bmi d_bmi // For checking purposes only - these variables correlate perfectly

* Generate overweight/obese indicator, based on BMI
gen i_owtobs=bmi>=25
tab i_owtobs i_bmic // These don't match - it looks like the dataset codes those with BMI>=24 as overweight?
label var i_owtobs "Overweight or obese based on BMI"

/* ADEQUATE NUTRITION */

* Vegetables
gen i_vegb2=0 if r_veg1_txt=="No serves" | r_veg1_txt=="Less than 1 serve" | r_veg1_txt=="1 serve" | r_veg1_txt=="2 serves"
replace i_vegb2=1 if r_veg1_txt=="3 serves" | r_veg1_txt=="4 serves" | r_veg1_txt=="5 serves" | r_veg1_txt=="6 serves" | r_veg1_txt=="More than 6 serves"
label values i_vegb2 noyes
label var i_vegb2 "Consumed minimum serves of vegatables daily (3+)"

* Fruit
replace i_fruitb="" if i_fruitb=="^"
destring i_fruitb, replace
recode i_fruitb 2=0
label values i_fruitb noyes

* Fast food
gen i_fastfb=0 if (NUT13a>=1 & NUT13a!=.) | (NUT13b>=4 & NUT13b!=.)
replace i_fastfb=0 if NUT13x=="1" | (NUT13xb>=1 & NUT13xb!=.) | (NUT13xc>=4 & NUT13xc!=.)
replace i_fastfb=1 if NUT13=="3" | NUT13x=="4"
replace i_fastfb=1 if NUT13a==0 | NUT13b<4 | NUT13xc<4
label var i_fastfb "Consume fast food less than weekly"
label values i_fastfb noyes

* Sweetened drinks
gen i_swtdrnkb=0 if (CNFI15a>=1 & CNFI15a!=.) | (CNFI15b>=7 & CNFI15b!=.)
replace i_swtdrnkb=0 if (CNFI15xa>=1 & CNFI15xa!=.) | (CNFI15xb>=7 & CNFI15xb!=.) | (CNFI15xc>=28 & CNFI15xc!=.)
replace i_swtdrnkb=1 if CNFI15=="3" | CNFI15x=="4"
replace i_swtdrnkb=1 if CNFI15a==0 | CNFI15b<7 | CNFI15xb<7 | CNFI15xc<30
label var i_swtdrnkb "Consume sweetened drinks less than daily"
label values i_swtdrnkb noyes

/* SUFFICIENT PHYSICAL ACTIVITY */

gen i_physactb=0 if i_physact=="2"
replace i_physactb=1 if i_physact=="1"
label values i_physactb noyes 
label var i_physactb "Adequate physical activity"

/* SMOKING STATUS */

gen i_nonsmkb=0 if i_smoke2=="1"
replace i_nonsmkb=1 if i_smoke2=="2"
label values i_nonsmkb noyes 
label var i_nonsmkb "Current non-smoker"

/* ALCOHOL */

replace r_alcoholfreq="" if r_alcoholfreq=="^"
destring r_alcoholfreq, replace
destring year, replace

gen alcdays=ALC1a
replace alcdays=0 if (ALC1=="2" | ALC1=="3") & year<=2014
replace alcdays=0 if (ALC1x=="2" | ALC1x=="3" | ALC1x=="4") & year>2014
gen weeklydrink=0 if alcdays==0
replace weeklydrink=alcdays*ALC2a if alcdays>0 & alcdays!=.
gen i_lowriskdb=weeklydrink<=10 if weeklydrink!=.
label values i_lowriskdb noyes 
label var i_lowriskdb "Drink no more than 10 standard drinks per week"

/* MENTAL HEALTH */

gen i_lowdistb=0 if r_k10a=="3" | r_k10a=="4"
replace i_lowdistb=1 if r_k10a=="1" | r_k10a=="2"
label values i_lowdistb noyes 
label var i_lowdistb "Low to moderate distress (Kessler K-10)"

/* DIABETES MANAGEMENT */

* Optimal management
gen i_mgmt1=0 if diab==0 | (diab==1 & (DBT6_3=="0" | DBT6X_3=="0"))
replace i_mgmt1=1 if (diab==1 | diab==2) & (DBT6_3=="1" | DBT6X_3=="1")
label var i_mgmt1 "Managing diabetes by following a special diet" 
gen i_mgmt2=0 if diab==0 | (diab==1 & (DBT6_4=="0" | DBT6X_4=="0"))
replace i_mgmt2=1 if (diab==1 | diab==2) & (DBT6_4=="1" | DBT6X_4=="1")
label var i_mgmt2 "Managing diabetes by losing weight" 
gen i_mgmt3=0 if diab==0 | (diab==1 & (DBT6_5=="0" | DBT6X_5=="0"))
replace i_mgmt3=1 if (diab==1 | diab==2) & (DBT6_5=="1" | DBT6X_5=="1")
label var i_mgmt3 "Managing diabetes by exercising most days" 
label values i_mgmt1 i_mgmt2 i_mgmt3 noyes 

gen i_diabmngb=0 if i_mgmt1==0 & i_mgmt2==0 & i_mgmt3==0
replace i_diabmngb=1 if i_mgmt1==1 | i_mgmt2==1 | i_mgmt3==1
label var i_diabmngb "Managing diabetes through diet, losing weight and exercise"
label values i_diabmngb noyes 

* Lifestyle modification management
gen i_diablfstlb=0 if diab==1 & (D10=="3" | D10=="4" | D10=="5") & (D11=="3" | D11=="4" | D11=="5")
replace i_diablfstlb=1 if diab==1 & (D10=="1" | D10=="2" | D11=="1" | D11=="2")
label values i_diablfstlb noyes 
label var i_diablfstlb "Consulted diabetes eduator or dietician in last 2 years"

/* SOCIODEMOGRAPHICS */

* Year
replace year=year-2004
label define year 0 "2004" 1 "2005" 2 "2006" 3 "2007" 4 "2008" 5 "2009" 6 "2010" 7 "2011" 8 "2012" 9 "2013" 10 "2014" 11 "2015" 12 "2016" 13 "2017" 14 "2018" 15 "2019"
label values year year

* Sex
replace sex="" if sex=="^^^^"
destring sex, replace
recode sex 2=0
label define sex 0 "Female" 1 "Male"
label values sex sex

* Education
gen educ=0 if QALLP=="1" | QALLP=="2" | QALLP=="6" | QALLP=="7"
replace educ=1 if QALLP=="3"
replace educ=2 if QALLP=="4"
label define edu 0 "School" 1 "Technical/diploma/other" 2 "University"
label values educ edu
label var educ "Highest level of education/qualification attained"

* Area-level disadvantage (IRSD)
gen seifa=seifa_irsd_2016-1
label define seifa 0 "Least disadvantaged" 4 "Most disdvantaged"
label values seifa seifa
label var seifa "SEIFA-IRSD 2016"

gen i_seifa=seifa
recode i_seifa 1=0 2=0 3=1 4=1
label define i_seifa 0 "Least disadvantaged" 1 "Most disdvantaged"
label values i_seifa i_seifa
label var i_seifa "Binary indicator of SEIFA-IRSD 2016"

* Remoteness
destring ariaplusc, replace
label define aria 1 "Major city" 2 "Inner regional" 3 "Outer regional" 4 "Remote" 5 "Very remote"
label values ariaplusc aria

gen i_aria=ariaplusc-1
recode i_aria 2=1 3=1 4=1
label define i_aria 0 "Major city" 1 "Regional/remote"
label values i_aria i_aria
label var i_aria "Remoteness indicator"

*Country of birth
gen i_cob=1 if cob=="01"
replace i_cob=0 if cob!="01" & cob!=""
label var i_cob "Born in Australia"
label values i_cob noyes

* Language spoken at home
gen i_lang=LANPa
replace i_lang="" if i_lang=="." | i_lang=="R" | i_lang=="X" | i_lang=="^"
destring i_lang, replace
recode i_lang 2=0
label var i_lang "Speak a language other than English at home"
label values i_lang noyes

* Local health network
replace lhn="0" if lhn=="X700"
replace lhn="1" if lhn=="X710"
replace lhn="2" if lhn=="X720"
replace lhn="3" if lhn=="X730"
replace lhn="4" if lhn=="X740"
replace lhn="5" if lhn=="X750"
replace lhn="6" if lhn=="X760"
replace lhn="7" if lhn=="X770"
replace lhn="8" if lhn=="X800"
replace lhn="9" if lhn=="X810"
replace lhn="10" if lhn=="X820"
replace lhn="11" if lhn=="X830"
replace lhn="12" if lhn=="X840"
replace lhn="13" if lhn=="X850"
replace lhn="14" if lhn=="X860"
destring lhn, replace
label define lhn 0 "Sydney" 1 "South Western Sydney" 2 "South Eastern Sydney" 3 "Illawarra Shoalhaven" 4 "Western Sydney" 5 "Nepean Blue Mountains" 6 "Northern Sydney" 7 "Central Coast" 8 "Hunter New England" 9 "Nothern NSW" 10 "Mid North Coast" 11 "Southern NSW" 12 "Murrumbidgee" 13 "Western NSW" 14 "Far West"
label values lhn lhn

* Destring strata variable
encode stratavar, generate(stratavar2)
drop stratavar
rename stratavar2 stratavar
encode strata, generate(strata2)
drop strata
rename strata2 strata

keep if age>=40 & diab!=2 & strata!=. & wgt!=.

keep year age sex educ i_seifa i_aria i_lang i_cob lhn strata wgt ///
diab i_owtobs i_vegb2 i_fruitb i_fastfb i_swtdrnkb i_physactb i_nonsmkb i_lowriskdb i_lowdistb i_mgmt1 i_mgmt2 i_mgmt3

misstable summ year age sex educ i_seifa i_aria i_lang i_cob lhn strata wgt ///
diab i_owtobs i_vegb2 i_fruitb i_fastfb i_swtdrnkb i_physactb i_nonsmkb i_lowriskdb i_lowdistb i_mgmt1 i_mgmt2 i_mgmt3, all

misstable patt year age sex educ i_seifa i_aria i_lang i_cob lhn strata wgt ///
diab i_owtobs i_vegb i_fruitb i_fastfb i_swtdrnkb i_physactb i_nonsmkb i_lowriskdb i_lowdistb i_mgmt1 i_mgmt2 i_mgmt3, freq asis

save "/Users/pjclare/Dropbox (Sydney Uni)/PHS/Diabetes/Data/phs0419 cleaned.dta", replace

mi set flong
mi set M=80
mi register imputed diab i_vegb i_fruitb i_fastfb i_swtdrnkb i_physactb i_nonsmkb i_lowriskdb i_lowdistb educ i_seifa i_aria i_lang i_mgmt1 i_mgmt2 i_mgmt3

mi impute chained (logit) diab i_vegb i_fruitb i_fastfb i_swtdrnkb i_physactb i_nonsmkb i_lowriskdb i_lowdistb i_aria i_seifa i_lang ///
(logit, cond(if diab==1) omit(i.diab)) i_mgmt1 i_mgmt2 i_mgmt3 ///
(mlogit) educ ///
= year age sex lhn i_owtobs i_cob strata [pweight=wgt], replace aug rseed(213901) noisily

mi passive: gen agecat=0 if age>=40 & age<50
mi passive: replace agecat=1 if age>=50 & age<60
mi passive: replace agecat=2 if age>=60 & age<70
mi passive: replace agecat=3 if age>=70 & age<80
mi passive: replace agecat=4 if age>=80
label define agec 0 "40-49" 1 "50-59" 2 "60-69" 3 "70-79" 4 "80+"
label values agecat agec
label var agecat "Age category"

mi passive: gen yearcat=0 if year>=0 & year<=3
mi passive: replace yearcat=1 if year>=4 & year<=7
mi passive: replace yearcat=2 if year>=8 & year<=11
mi passive: replace yearcat=3 if year>=12 & year<=15
label define yearc 0 "2004-2007" 1 "2008-2011" 2 "2012-2015" 3 "2016-2019"
label values yearcat yearc
label var yearcat "Age category (2yr)"

save "/Users/pjclare/Dropbox (Sydney Uni)/PHS/Diabetes/Data/phs0419 imputed.dta", replace

