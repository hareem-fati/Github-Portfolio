/*******************************************************************************
		MASTER CLEANING DO-FILE FOR DISTRICT-WISE PUNJAB COVID-19 CASES

 Author: 				Hareem Fatima
 Date Created: 			01/04/2024 (DD-MM-YYY)
 
 Purpose: This do-file does the following:
				1. Imports data from Excel to Stata
				2. Cleaning year-wise datasets
				3. Merging year-wise datasets to form a Master data.
				4. Transformming into panel data
				5. Cleaning & Saving Transformed Data

*******************************************************************************/

/**********************************************************
					 SETTINGS
**********************************************************/
cd "C:\HF Stuff\NGOs\Data"

global NGOs_Excel "C:\HF Stuff\NGOs\Data\Excel"
global NGOs_Data "C:\HF Stuff\NGOs\Stata\Data"

clear all
set more off
set maxvar 30000

		*****PART I: IMPORTING & GENERATING EXCEL SHEETS INTO STATA*****

import excel using "$NGOs_Excel\Table 12.2.xlsx", describe
forvalues sheet=1/`=r(N_worksheet)' {
  local sheetname=r(worksheet_`sheet')
  import excel using "$NGOs_Excel\Table 12.2.xlsx", sheet("`sheetname'") firstrow clear
  save "file_`sheetname'", replace
}


/**********************************************************
			PART II: CLEANING & HARMONIZING YEAR-WISE DATA
**********************************************************/
			
		****PART II A: CLEANING & HARMONIZING 2020 DATA****
			
	use "$NGOs_Data\file_2020.dta", clear

	rename DivisionDistrict Division_district

	foreach var of varlist March April May June July August {
	rename `var' `var'_2020
}
	
	drop if Division_district == ""
	drop GrandTotal
	
	encode Division_district, gen(district)
	order district
	
	gen id = _n

	save "$NGOs_Data\file_2020.dta", replace

	****PART II B: CLEANING & HARMONIZING 2021 DATA****
			
	use "$NGOs_Data\file_2021.dta", clear

	rename DivisionDistrict Division_district
	encode Division_district, gen(district)
	order district

	drop Total
	drop if Division_district == ""
	
	gen id = _n

	save "$NGOs_Data\file_2021.dta", replace

	****PART II C: CLEANING & HARMONIZING 2022 DATA****

	use "$NGOs_Data\file_2022.dta", clear
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

	save "$NGOs_Data\file_2022.dta", replace
	
/**********************************************************
	PART III:  MERGING YEAR-WISE DATA TO FORM MASTER DATA
**********************************************************/

	use "$NGOs_Data\file_2021.dta", clear

	merge 1:1 id using "$NGOs_Data\file_2020.dta", gen(merge1)
	order district Division_district March_2020 April_2020 May_2020 June_2020 July_2020 August_2020

merge 1:1 id using "$NGOs_Data\file_2022.dta", gen(merge)

drop merge* id

save "$NGOs_Data\covid19_district_wise_cases.dta", replace


/**********************************************************
	PART IV:  TRANSFORMING FROM CROSS-SECTION TO PANEL DATA
**********************************************************/

use "$NGOs_Data\covid19_district_wise_cases.dta", clear

	reshape long @_2020 @_2021 @_2022, i( district ) j(month) string
	reshape long _, i(district month) j(year)
	
	rename _ covid_cases
	lab var covid_cases "Covid-19 cases"
	
	replace covid_cases = 0 if covid_cases==.
	
	egen month_year = concat(month year)	
	numdate mo mdate2 = month_year, pattern(M20Y)
	
	drop month_year
	
	egen month_year = group(mdate2 year)
	

	//check if a panel
	xtset district month_year 
	
save "$NGOs_Data\\covid19_district_wise_cases_panel.dta", replace


/**********************************************************
		PART V: CLEANING & LABELLING DATA
**********************************************************/
	
drop if strpos(Division_district ,"Divn.") 
drop if inlist(district, 34,16)
drop if inlist(month, "January", "February") & covid_cases == 0


label define month_year 3 "Mar 20" 4 "Apr 20" 5 "May 20" 6 "Jun 20"  7 "Jul 20" 8 "Aug 20" 9 "Sep 20" 10 "Oct 20" 11 "Nov 20" 12 "Dec 20" 13 "Jan 21" 14 "Feb 21" 15 "Mar 21" 16 "Apr 21" 17 "May 21" 18 "Jun 21" 19 "Jul 21" 20 "Aug 21" 21 "Sep 21" 22 "Oct 21" 23 "Nov 21" 24 "Dec 21" 25 "Jan 22" 26 "Feb 22" 27 "Mar 22" 28 "Apr 22" 29 "May 22" 30 "Jun 22" 31 "Jul 22" 32 "Aug 22" 33 "Sep 22" 34 "Oct 22" 35 "Nov 22" 36 "Dec 22", replace

label values month_year month_year
lab var month_year "Month"

sort district month_year


save "$NGOs_Data\\covid19_district_wise_cases_panel.dta", replace