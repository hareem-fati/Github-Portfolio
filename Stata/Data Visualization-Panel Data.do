/*******************************************************************************
	Generating Monthwise Graphs for Districts In Punjab

	Author: 				Hareem Fatima
	Date Created: 			01/04/2024 (DD-MM-YYY)
	Last Modified by: 
	Last Modified Date: 
 
	Purpose: This do-file does the following:
	1) Runs Settings
	2) Generates & Saves District-wise Monthly Graphs for COVID-19 cases in Punjab, Pakistan
				
*******************************************************************************/

/**********************************************************
					PART I: SETTINGS
**********************************************************/

clear all
set more off
set maxvar 30000
set scheme cleanplots

global NGOs "C:\HF Stuff\NGOs\Stata"

/**********************************************************
				PART II: LOAD DATA
**********************************************************/
				
use "$NGOs\Data\covid19_district_wise_cases_panel.dta"


/**********************************************************
				PART III: GENERATE GRAPHS
**********************************************************/

			******District-wise Bar Graph******

graph bar covid_cases if district != 47, over(month_year, label(labsize(tiny) angle(vertical) )) title("Monthly COVID-19 Cases in Punjab") subtitle("March 2020-June 2022", size(*0.8)) ytitle("Number of Cases") 
graph export "$NGOs\Graphs\District_wise_monthly_cases_bar.png", as(png) name("Graph") replace
			
			
			******Punjab Time-series******

xtline covid_cases if district == 47, recast(line) ytitle(Number of Cases) tlabel(3(1)36, labels labsize(vsmall) angle(vertical) valuelabel) byopts(title(Monthly COVID-19 Cases) subtitle(March 2020-June 2022))
graph export "$NGOs\Graphs\Punjab.png", as(png) name("Graph") replace


