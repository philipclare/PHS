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

mi estimate, saving(temp, replace) esampvaryok: svy: logit `outcome' `time1' i.agecat sex i.educ i.i_aria i.i_seifa i.i_lang i.i_cob i_owtobs i_vegb2 i_fruitb i_swtdrnkb i_physactb i_nonsmkb i_lowriskdb i_lowdistb if diab==1

mi predict prtemp using temp
mi predict setemp using temp, stdp
gen lotemp=prtemp-invnormal(0.975)*setemp
gen uptemp=prtemp+invnormal(0.975)*setemp
replace prtemp=invlogit(prtemp)
replace lotemp=invlogit(lotemp)
replace uptemp=invlogit(uptemp)

mean prtemp lotemp uptemp if diab==1 & i_owtobs==0
mean prtemp lotemp uptemp if diab==1 & i_owtobs==1
mean prtemp lotemp uptemp if diab==1 & i_owtobs==0, over(`time2')
mean prtemp lotemp uptemp if diab==1 & i_owtobs==1, over(`time2')

end

trendcalc3 i_mgmt2 cat
