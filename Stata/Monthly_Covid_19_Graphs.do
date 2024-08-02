clear all
set more off

use "D:\NGOs\Stata\data\\covid19_district_wise_cases_panel.dta"
	
drop if strpos(Division_district ,"Divn.") 
drop if inlist(district, 34,16)
drop if inlist(month, "January", "February") & covid_cases == 0


label define month_year 3 "Mar 20" 4 "Apr 20" 5 "May 20" 6 "Jun 20" 	///
7 "Jul 20" 8 "Aug 20" 9 "Sep 20" 10 "Oct 20" 11 "Nov 20" 12 "Dec 20" 13 "Jan 21" 14 "Feb 21"																						///
15 "Mar 21" 16 "Apr 21" 17 "May 21" 18 "Jun 21" 19 "Jul 21" 20 "Aug 21" 21 "Sep 21" 22 "Oct 21"																						///
23 "Nov 21" 24 "Dec 21" 25 "Jan 22" 26 "Feb 22" 27 "Mar 22" 28 "Apr 22" 29 "May 22" 30 "Jun 22"																						///
31 "Jul 22" 32 "Aug 22" 33 "Sep 22" 34 "Oct 22" 35 "Nov 22" 36 "Dec 22", replace

label values month_year month_year
lab var month_year "Month"

set scheme cleanplots

sort district month_year

							*********District-wise Bar Graph*********

graph bar covid_cases if district != 47, over(month_year, label(labsize(tiny) angle(vertical) )) title("Monthly COVID-19 Cases") subtitle("March 2020-June 2022", size(*0.8)) ytitle("Number of Cases") 
graph export "D:\NGOs\Stata\Graphs\District_wise_monthly_cases_bar.png", as(png) name("Graph")
							*********Punjab Time-series*********
xtline covid_cases if district == 47, recast(line) ytitle(Number of Cases) tlabel(3(1)36, labels labsize(vsmall) angle(vertical) valuelabel) byopts(title(Monthly COVID-19 Cases) subtitle(March 2020-June 2022))

							*********District-wise Line Graphs*********
xtline covid_cases if district != 47, recast(line) ytitle(Number of Cases) tlabel(3(1)36, labels labsize(vsmall) angle(vertical) valuelabel) byopts(title(Monthly COVID-19 Cases) subtitle(March 2020-June 2022))



