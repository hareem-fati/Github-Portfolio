/*******************************************************************************
 Improrting Table 12.2 From Excel To Stata

 Author: 				Hareem Fatima
 Date Created: 			01/04/2024 (DD-MM-YYY)
 
 Purpose: This do-file does the following:
				1. Imports data from Excel to Stata
				2. Cleaning year-wise datasets
				3. Merging year-wise datasets to form a Master data.
				4. Transformming into panel data

*******************************************************************************/
********************************************************************************
cd "D:\NGOs\Stata"

clear all

*******Part 1: Importing & Generating Excel sheets into Stata**********

import excel using "D:\NGOs\Data\Excel\Table 12.2.xlsx", describe
forvalues sheet=1/`=r(N_worksheet)' {
  local sheetname=r(worksheet_`sheet')
  import excel using "D:\NGOs\Data\Excel\Table 12.2.xlsx", sheet("`sheetname'") firstrow clear
  save "file_`sheetname'", replace
}

*******Part 2: Importing & Generating Excel sheets into Stata**********

*******Part 2a: Cleaning, harmonizing & saving 2020 dataset**********
use "D:\NGOs\Stata\data\file_2020.dta", clear

rename DivisionDistrict Division_district

foreach var of varlist March April May June July August {
	rename `var' `var'_2020
	}
	
drop if Division_district == ""
drop GrandTotal
	
encode Division_district, gen(district)
order district
gen id = _n

save "D:\NGOs\Stata\data\file_2020.dta", replace

*******Part 2b: Cleaning, harmonizing & saving 2021 dataset**********
use "D:\NGOs\Stata\data\file_2021.dta", clear

rename DivisionDistrict Division_district
encode Division_district, gen(district)
order district

drop Total
drop if Division_district == ""
gen id = _n

save "D:\NGOs\Stata\data\file_2021.dta", replace

*******Part 2c: Cleaning, harmonizing & saving 2022 dataset**********

use "D:\NGOs\Stata\data\file_2022.dta", clear
rename DivisionDistrict Division_district

encode Division_district, gen(district)
order district

drop Total
drop if Division_district == ""

foreach var of varlist April_2022 May_2022 June_2022 {
replace `var' = "" if `var' == "-"	
}
 
destring April_2022 May_2022 June_2022, replace
gen id = _n

save "D:\NGOs\Stata\data\file_2022.dta", replace

*******Part 3: Merging to form master data**********

use "D:\NGOs\Stata\data\file_2021.dta", clear

merge 1:1 id using "D:\NGOs\Stata\data\file_2020.dta", gen(merge1)
order district Division_district March_2020 April_2020 May_2020 June_2020 July_2020 August_2020
merge 1:1 id using "D:\NGOs\Stata\data\file_2022.dta", gen(merge)

drop merge* id

save "D:\NGOs\Stata\data\covid19_district_wise_cases.dta", replace


*******Part 4: Transformming into Panel Data**********

use "D:\NGOs\Stata\data\covid19_district_wise_cases.dta", clear

	reshape long @_2020 @_2021 @_2022, i( district ) j(month) string
	reshape long _, i(district month) j(year)
	
	rename _ covid_cases
	lab var covid_cases "Covid-19 cases"
	
	replace covid_cases = 0 if covid_cases==.
	
	egen month_year = concat(month year)	
	numdate mo mdate2 = month_year, pattern(M20Y)
	
	drop month_year
	
	egen month_year = group(mdate2 year)
	
	*drop mdate2
	
	//check if a panel
	xtset district month_year 
	
save "D:\NGOs\Stata\data\\covid19_district_wise_cases_panel.dta", replace


