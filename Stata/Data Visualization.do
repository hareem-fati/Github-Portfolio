/*****************************************************************
******************************************************************
******************************************************************
Written By:				Hareem Fatima
Date Written:			DD/MM/YYYY
Last Modified By:		
Date Modified:			DD/MM/YYYY			
Purpose: 				Generating Graphs for GEA Blog


******************************************************************
******************************************************************
*****************************************************************/

* Set globals for variable lists 
	
	do 					"${dofilesgit}/cleaning/analysis_prep/setglobals.do"
	
********************************************************************************
*					(0) Settings and globals
********************************************************************************

global shades5 "bar(1, color(green) fintensity(inten200) lcolor(white)) bar(2, color(green) fintensity(inten100) lcolor(white)) bar(3, color(green) fintensity(inten70) lcolor(white)) bar(4, color(green) fintensity(inten50) lcolor(white)) bar(5, color(green) fintensity(inten30) lcolor(white)) bar(6, color(green) fintensity(inten20) lcolor(white)) bar(7, color(green) fintensity(inten10) lcolor(white))" 

global shades6 "bar(1, color(cranberry) fintensity(inten200) lcolor(white)) bar(2, color(cranberry) fintensity(inten100) lcolor(white)) bar(3, color(cranberry) fintensity(inten70) lcolor(white)) bar(4, color(cranberry) fintensity(inten50) lcolor(white)) bar(5, color(cranberry) fintensity(inten30) lcolor(white)) bar(6, color(cranberry) fintensity(inten20) lcolor(white)) bar(7, color(cranberry) fintensity(inten10) lcolor(white))" 

global shades7 "bar(1, color(navy) fintensity(inten200) lcolor(white)) bar(2, color(navy) fintensity(inten100) lcolor(white)) bar(3, color(navy) fintensity(inten70) lcolor(white)) bar(4, color(navy) fintensity(inten50) lcolor(white)) bar(5, color(navy) fintensity(inten30) lcolor(white)) bar(6, color(navy) fintensity(inten20) lcolor(white)) bar(7, color(navy) fintensity(inten10) lcolor(white))" 	
	
global shades8 "bar(1, color(navy) fintensity(inten300) lcolor(white)) bar(2, color(navy) fintensity(inten200) lcolor(white)) bar(3, color(navy) fintensity(inten100) lcolor(white)) bar(4, color(navy) fintensity(inten50) lcolor(white)) bar(5, color(navy) fintensity(inten30) lcolor(white))" 	

******************************************************************************
				*//PART 1: BASELINE & ADLISTING GRAPHS//*
******************************************************************************

/******************************************************************
					Part I: Defining Sample
******************************************************************/
				
clear all
		
use "$idrem_firm\firms_prep" , clear			///Using firm-level data. 
					
keep if inlist(signup_service, 1)
			
merge 1:m firm_id using "$idrem_job\adlisting_prep", gen(ad_firm)	///merging firm-level data with job-level data. 
		
sort firm_id submissiondate_clean, stable 
	
ds firm_id, not
collapse (lastnm) `r(varlist)' , by(firm_id)

drop if EB_type_fs == 0
drop if EB_type_fs == .


	
isid firm_id

do		"${dofilesgit}\cleaning\analysis_prep\firmsbl_subfiles\firmsbl_labels_updated.do", nostop	//Assigning firm-level labels.


run "$Do_FS\\$FS_adl_labels" , nostop		//Assigning job-level variables. 
	
			
/******************************************************************
					Part II: Generating Relevant Variables
******************************************************************/		
	//Harmonizing Industry Classification Variable//

		recode industry_classification_fs (1 = 23)
		recode industry_classification_fs (4 = 23)
		recode industry_classification_fs (5 = 23)
		recode industry_classification_fs (6 = 23)
		recode industry_classification_fs (15 = 23)
		recode industry_classification_fs (21 = 23)
		recode industry_classification_fs (18 = 23)
		recode industry_classification_fs (14 = 19)
		
	//Generating Select Multiple Stubs Of Method Advertisement//	
	
	 gen method_advertisment1 = 1 if rec_cons_ad1_ad == 1 
	 replace method_advertisment1 = 0 if rec_cons_ad1_ad == 0
	 
	 gen method_advertisment2 = 1 if rec_cons_ad2_ad == 1 
	 replace method_advertisment2 = 0 if rec_cons_ad2_ad == 0
	 
	 gen method_advertisment3 = 1 if rec_cons_ad3_ad == 1 
	 replace method_advertisment3 = 0 if rec_cons_ad3_ad == 0
	 
	 gen method_advertisment4 = 1 if rec_cons_ad4_ad == 1 
	 replace method_advertisment4 = 0 if rec_cons_ad4_ad == 0
	 
	 gen method_advertisment5 = 1 if rec_cons_ad5_ad == 1 
	 replace method_advertisment5 = 0 if rec_cons_ad5_ad == 0
	 
	 gen method_advertisment6 = 1 if rec_cons_ad6_ad == 1 
	 replace method_advertisment6 = 0 if rec_cons_ad6_ad == 0
	 
	 gen method_advertisment7 = 1 if rec_cons_ad7_ad == 1 
	 replace method_advertisment7 = 0 if rec_cons_ad7_ad == 0
	 
				//Capturing Baseline Information// 

	replace method_advertisment1 = 1 if fsbl_rv_harm_news_cons == 1  
	replace method_advertisment2 = 1 if fsbl_rv_harm_web_cons == 1  
	replace method_advertisment3 = 1 if fsbl_rv_harm_outsrc_cons == 1 
	replace method_advertisment6 = 1 if fsbl_rv_harm_colg_cons == 1  
	replace method_advertisment7 = 1 if fsbl_rv_harm_cv_drop_cons == 1
	
	gen method_advertisment8 = 1 if fsbl_rv_harm_referrals_cons == 1
	replace method_advertisment8 = 0 if fsbl_rv_harm_referrals_cons == 0
	
	replace method_advertisment7  = method_advertisment3 if method_advertisment7  != . & method_advertisment3 == 1                   //3rd-party outsourcing
	replace method_advertisment7 = 1 if method_advertisment3 == 1 
	
	replace method_advertisment7 = method_advertisment6  if method_advertisment7  != . & method_advertisment6 == 1                       //college recruitement
	replace method_advertisment7 = 1 if method_advertisment6 == 1 

	replace method_advertisment7 = method_advertisment4  if method_advertisment7  != . & method_advertisment4 == 1						//company website
	replace method_advertisment7 = 1 if method_advertisment4 == 1 
	
	replace method_advertisment2 = method_advertisment5 if method_advertisment2  != . & method_advertisment5 == 1					//clubbing social media with web-platform
 
	
	label variable method_advertisment1 "Newspaper"
	label variable method_advertisment2 "Web-platform"
	label variable method_advertisment3 "Third-party outsourcing"
	label variable method_advertisment4 "Company Website"
	label variable method_advertisment5 "Social Media"
	label variable method_advertisment6 "College recruitement"
	label variable method_advertisment7 "Other Mediums"
	label variable method_advertisment8 "Referrals"
	
	
	lab var rec_cons_ad1 "Ad posted in Newspaper"
	lab var rec_cons_ad2 "Ad posted on Web Platform eg. rozee"	
	lab var rec_cons_ad3 "Ad posted at a Recruitment Firm/headhunter"
	lab var rec_cons_ad4 "Ad posted on company website"
	lab var rec_cons_ad5 "Ad posted on social media (Facebook, WhatsApp, Linkedin)"
	lab var rec_cons_ad6 "Ad posted at College/University Recruitment Drives"
	lab var rec_cons_ad7 "Ad posted on Other mediums"
	
	foreach var of varlist method_advertisment1 method_advertisment2 method_advertisment3 method_advertisment4 method_advertisment5 method_advertisment6 method_advertisment7 method_advertisment8 {
		label define `var'  1 "Yes" 0 "No"
		label values `var' `var'
	}

	
			***Binary Variable For Multiple Methods Of Advertisement***

	egen advertisement_method = rowtotal(method_advertisment1 method_advertisment2 method_advertisment7 method_advertisment8)
	
	replace advertisement_method = . if [missing(method_advertisment1) & missing(method_advertisment7) & missing(method_advertisment8)]
	
	gen multiple_adv_meth = 1 if advertisement_method > 1 & !missing(advertisement_method)
	replace multiple_adv_meth = 0 if advertisement_method <= 1 & !missing(advertisement_method)
	
	*label drop multiple_adv_meth
	capture label variable multiple_adv_meth "Multiple Methods Of Advertisment Used"
	label define multiple_adv_meth 1 "Multiple Advertisment Methods" ///
	0 "Single Method Advertisement"
	label values multiple_adv_meth multiple_adv_meth
	
		

			***Redefining Labels For Industry Classification**
	
	*label drop industry_classification_fs
	capture label variable industry_classification_fs "Which industry does this firm belong to?"
	label define industry_classification_fs 1 "Agriculture" 2 "Mining" 			///
	3 "Manufacturing" 4 "Electricity & Gas Supply" 5 "Sanitation Servcies" 		///
	6 "Construction" 7 "Wholesale & retail" 8 "Storage & Transportation" 		///
	9 "Accommodation & food service" 10 "ICT" 11 "Financial activities" 		///
	12 "Real estate" 13 "Professional & scientific activities" 					///
	14 "Admin & customer support" 15 "Public administration & defence" 			///
	16 "Education" 17 "Health activities" 18 "Arts & recreation" 				///	
	19 "Other service activities" 20 "Activities of household employees" 		/// 
	21 "Extraterritorial organization activities" 22 "Can't decide" 23 "Others" ///
	.f  "Filtered because the question isn't relevant" 							///
	.a "The question wasn't deployed"
	capture capture label values industry_classification_fs industry_classification_fs
	
	capture {
		foreach rgvar of varlist job_gender_ad {
			label variable `rgvar' "Do you have any gender requirements for this job?"
			note `rgvar': "Do you have any gender requirements for this job?"
			label define `rgvar' 1 "Male" 2 "Preferably Male" 3 "Female"		///
			4 "Preferably Female" 5 "No gender specification" 6 "Not Mentioned" ///
			.h "Refer to headquarters" .r "Don't want to say" .d "Don't know" 	///
			.l "Left the survey" .u "The respondent does not understand" 		/// 
			.f "Filtered because the question isn't relevant" 					///
			.r "Refused to answer/Don't want to say" 							///
			.a "Question wasn't deployed" .s "Firm didn't sign-up" 				///
			.i "Incorrectly missing" .c "Can't Determine", modify
			label values `rgvar' `rgvar'
		}
	}
	
capture label variable women_incl_fs "Gender Inclusivity at Firms"	 	
label 	define women_incl_fs 1"No women employees, no interest in hiring"		///
 2 "No women employees but open to hiring" 3 "Some women employees"
label 	values women_incl_fs women_incl_fs	
	
/******************************************************************
					Part III: Generating Graphs
******************************************************************/
	
				***Graph 1: Firm & Advertisment Method****
	
count if method_advertisment1 == 1
local newspaper = `r(N)'

count if method_advertisment2 == 1
local web_platform = `r(N)'

count if method_advertisment7 == 1
local other_mediums = `r(N)'

count if method_advertisment8 == 1
local Referrals = `r(N)'
	
distinct firm_id
local nb_firms = `r(N)'


graph bar method_advertisment1 method_advertisment2 method_advertisment7 method_advertisment8, bargap(15)			///
legend(cols(2) size(small) label (1 "Newspaper") label (2 "Web-platform") 											///
label (3 "Other Mediums") label (4 "Referrals") ylab(0 "0"  .2 "20"  .4 "40" .6 "60" .8 "80" )						///
ytitle("Percent of Firms") 																							///
title("Vacancy Advertisment Methods Used By Firms", span size(medium)) l1title("") 									///				
plotregion(fcolor(white)) graphregion(fcolor(white))																///		
note("{N: `nb_firms'; Sample: Adlisting + Baseline." 				 												///							
"Other mediums include cable ads , door-to-door, third-party outsourcing, company website & college recruitment."	///
"Nb Firm Newspaper = `newspaper'; Nb Firm Web-platform = `web_platform'; Nb Firm Other Mediums = `other_mediums'; Nb Firm Referrals = `Referrals'.}", size(vsmall)) 
			
	graph export "$graph_out\GEA Blog\FS Graphs\methods_advertisements.png", replace

				
		***Graph 2: Firm Size & Method Advertisment***

distinct firm_id
local nb_firms = `r(N)'	

count if method_advertisment1 == 1
local newspaper = `r(N)'

count if method_advertisment2 == 1
local web_platform = `r(N)'

count if method_advertisment7 == 1
local other_mediums = `r(N)'

count if method_advertisment8 == 1
local Referrals = `r(N)'
	

splitvallabels employee_size_cat_fs	

graph hbar method_advertisment1 method_advertisment2  method_advertisment7 method_advertisment8, over (employee_size_cat_fs) bargap(15)						legend(cols(2) size(small) label (1 "Newspaper") label (2 "Web-platform") label (3 "Other Mediums") label (4 "Referrals"))	ylab(0 "0"  .2 "20"  .4 "40" .6 "60" .8 "80" )	ytitle("Percent of Firms", size(small))							
title("Firm Size & Advertisement Method" ,span size(medium)) 	plotregion(fcolor(white)) graphregion(fcolor(white))				
note("{N: `nb_firms'; Sample: Adlisting + Baseline." 				///							
"Other mediums include cable ads , door-to-door, third-party outsourcing, company website & college recruitment."    			///
"Nb Firm Newspaper = `newspaper'; Nb Firm Web-platform = `web_platform'; Nb Firm Other Mediums = `other_mediums'; Nb Firm Referrals = `Referrals'.}", size(vsmall)) 
																		
	graph export "$graph_out\GEA Blog\FS Graphs\method_adv_emp_size.png", as(png) replace
			
 
			**Graph 3: Eductaion Level & Method Advertisment**	  
								
count if tag_highed_firms == 0
local tag_lowed = `r(N)'

count if tag_highed_firms == 1
local tag_highed = `r(N)'

count if method_advertisment1 == 1
local newspaper = `r(N)'

count if method_advertisment2 == 1
local web_platform = `r(N)'

count if method_advertisment7 == 1
local other_mediums = `r(N)'

count if method_advertisment8 == 1
local Referrals = `r(N)'	

distinct firm_id
local nb_firms = `r(N)'

splitvallabels tag_highed_firms	

graph hbar method_advertisment1 method_advertisment2 					/// 
method_advertisment7 method_advertisment8, over(tag_highed_firms) bargap(10)															///
ytitle("Percent of Firms", size(vsmall)) 						///		
title("Educational Requirement & Advertisement Method" ,span size(medium)) 			///														
ylab(0 "0"  .2 "20"  .4 "40" .6 "60" .8 "80" )				///				
legend(cols(2) size(small) label (1 "Newspaper") label (2 "Web-platform") label (3 "Other Mediums") label (4 "Referrals"))		///
plotregion(fcolor(white)) graphregion(fcolor(white)) ///														
note("{N =`nb_firms'; Sample: Adlisting + Baseline."				///
"Nb Firms High-ed:`tag_highed' & Nb Firms Low-ed:`tag_lowed'."		///										
"Other mediums include cable ads , door-to-door, third-party outsourcing, company website & college recruitment."				///
"Nb Firm Newspaper = `newspaper'; Nb Firm Web-platform = `web_platform'; Nb Firm Other Mediums = `other_mediums'; Nb Firm Referrals = `Referrals'.}", size(vsmall)) 

graph export "$graph_out\GEA Blog\FS Graphs\Education level & method of advertisement.png", as(png) name("Graph") replace

	  
	  **Graph 4 : Industry Classification & Method Of Advertisment**	
		
distinct firm_id
local nb_firms = `r(N)'

count if method_advertisment1 == 1
local newspaper = `r(N)'

count if method_advertisment2 == 1
local web_platform = `r(N)'

count if method_advertisment7 == 1
local other_mediums = `r(N)'

count if method_advertisment8 == 1
local Referrals = `r(N)'

splitvallabels industry_classification_fs

graph hbar method_advertisment1 method_advertisment2  method_advertisment7 method_advertisment8, over(industry_classification_fs) bargap(5)								ytitle("Percent of firms", size(small)) 						title("Industry & Method Advertisement", span size(medium))		legend(cols(2) size(small) label (1 "Newspaper") label (2 "Web-platform") label (3 "Other Mediums") label (4 "Referrals"))	ylab(0 "0"  .2 "20"  .4 "40" .6 "60" .8 "80" )					 plotregion(fcolor(white)) graphregion(fcolor(white))			note("{N: `nb_firms'; Sample: Adlisting + Baseline." 									///
"Other mediums includes third-party outsourcing, company website & college recruitment." 											///
"Other industries include Agriculture, Electricity, Construction, Public administration, Arts & recreation, Extraterritorial organization activities."											///
"Nb Firm Newspaper = `newspaper'; Nb Firm Web-platform = `web_platform'; Nb Firm Other Mediums = `other_mediums'; Nb Firm Referrals = `Referrals'.}", size(vsmall)) 

	graph export "$graph_out\GEA Blog\FS Graphs\industry_advertisement.png", as(png) name("Graph") replace
	
		**Graph 5: Recent Hire Gender & Method Advertisement**
		
count if method_advertisment1 == 1
local newspaper = `r(N)'

count if method_advertisment2 == 1
local web_platform = `r(N)'

count if method_advertisment7 == 1
local other_mediums = `r(N)'

count if method_advertisment8 == 1
local Referrals = `r(N)'

count if fsbl_rv_gender_hire == 1
local female = `r(N)'

count if fsbl_rv_gender_hire == 2
local male = `r(N)'

count if fsbl_rv_gender_hire == 3
local transgender = `r(N)'

distinct firm_id
local nb_firms = `r(N)'


graph hbar method_advertisment1 method_advertisment2  method_advertisment7 method_advertisment8, over(fsbl_rv_gender_hire) bargap(5) 					legend(label (1 "Newspaper") label (2 "Referrals") label (3 "Other Mediums") label (4 "Web-platform")) ytitle("Percent of Firms", size(vsmall)) title("Gender of Recent Hire & Advertisement Method" ,span size(medium)) ylab(0 "0"  .2 "20"  .4 "40" .6 "60" .8 "80" )	plotregion(fcolor(white)) graphregion(fcolor(white))			note("{N: `nb_firms'; Sample: Baseline + Adlisting."							///
"Other mediums include third-party outsourcing, CV drop-offs & college recruitment." 											/// 
"Unit of analysis = Firms"											///
"Nb male: `male'; Nb female: `female'; Nb transgender: `transgender'"														///
"Nb Firm Newspaper = `newspaper'; Nb Firm Web-platform = `web_platform'; Nb Firm Other Mediums = `other_mediums'; Nb Firm Referrals = `Referrals'.}", size(vsmall)) 	

graph export "$graph_out\GEA Blog\FS Graphs\gender recent hire.png", as(png) name("Graph") replace
	
	
	**Graph 6: Women Inclusivity & Method Advertisment**
	
keep if !missing(women_incl_fs)	

label drop women_incl_fs	
	
capture label variable women_incl_fs "Gender Inclusivity at Firms"	 	
label 	define women_incl_fs 1"No women employees, no interest in hiring"	 2 "No women employees but open to hiring" 3 "Some women employees"
label 	values women_incl_fs women_incl_fs	
				
distinct firm_id
local nb_firms = `r(N)'

count if method_advertisment1 == 1
local newspaper = `r(N)'

count if method_advertisment2 == 1
local web_platform = `r(N)'

count if method_advertisment7 == 1
local other_mediums = `r(N)'

count if method_advertisment8 == 1
local Referrals = `r(N)'	

count if women_incl_fs == 1
local no_women_emp = `r(N)'

count if women_incl_fs == 2
local no_women_open = `r(N)'

count if women_incl_fs == 3
local some_women = `r(N)'
	
splitvallabels women_incl_fs	

graph hbar method_advertisment1 method_advertisment2  method_advertisment7 method_advertisment8, over(women_incl_fs, label(labsize(1.7))) bargap(10) 	ytitle("Percent of Firms", size(vsmall)) title("Women Inclusivity & Firm Advertisement Method" ,span size(medium)) legend(cols(2) size(small) label (1 "Newspaper") label (2 "Web-platform") label (3 "Other Mediums") label (4 "Referrals"))	ylab(0 "0"  .2 "20"  .4 "40" .6 "60" .8 "80" )				plotregion(fcolor(white)) graphregion(fcolor(white)) note("{N=`nb_firms';  Sample: Adlisting + Baseline firms that answered questions on women inclusivity."  							
"Unit of analysis: Firms"      					
 "Other mediums include cable ads , door-to-door, third-party outsourcing, company website & college recruitment."														///
"Nb firms not interested in hiring women = `no_women_emp'; Nb firms open to hiring women = `no_women_open'; Nb firms that have some female employees = `some_women'}", size(vsmall)) 

	graph export "$graph_out\GEA Blog\FS Graphs\female_employees & Advertisement.png", as(png) name("Graph") replace
	


				********///BASELINE GRAPHS///********

/******************************************************************
					Part I: Defining Sample
******************************************************************/
clear all
		
use "$idrem_firm\firms_prep" 
					
keep if inlist(signup_service, 1)

fre EB_type_fs

drop if EB_type_fs == 0
			
/******************************************************************
					Part II: Generating Relevant Variables
******************************************************************/			
		//Harmonizing Industry Classification Variable//

		recode industry_classification_fs (1 = 23)
		recode industry_classification_fs (4 = 23)
		recode industry_classification_fs (5 = 23)
		recode industry_classification_fs (6 = 23)
		recode industry_classification_fs (15 = 23)
		recode industry_classification_fs (21 = 23)
		recode industry_classification_fs (18 = 23)
		recode industry_classification_fs (14 = 19)
			
			//Harmonizing Method Advertisement Variable//
			
		egen fsbl_rv_harm_other_mediums_cons = rowtotal( fsbl_rv_harm_colg_cons fsbl_rv_harm_outsouricng_cons)
		replace fsbl_rv_harm_other_mediums_cons = . if fsbl_rv_harm_other_mediums_cons == 0
		replace fsbl_rv_harm_other_mediums_cons = 0 if (fsbl_rv_harm_outsouricng_cons == 0 | fsbl_rv_harm_colg_cons == 0) & fsbl_rv_harm_other_mediums_cons == .
		
		
	***Binary Variable For Multiple Methods Of Advertisement***

	egen advertisement_method = rowtotal(fsbl_rv_harm_newspaper_cons  fsbl_rv_harm_referrals_cons fsbl_rv_harm_other_mediums_cons fsbl_rv_harm_web_platform_cons)
	
	replace advertisement_method = . if [missing(fsbl_rv_harm_newspaper_cons) & missing(fsbl_rv_harm_referrals_cons) & missing(fsbl_rv_harm_other_mediums_cons) & missing(fsbl_rv_harm_web_platform_cons)]
	
	gen multiple_adv_meth = 1 if advertisement_method > 1 & !missing(advertisement_method)
	replace multiple_adv_meth = 0 if advertisement_method <= 1 & !missing(advertisement_method)
	
	capture label variable multiple_adv_meth "Multiple Methods Of Advertisment Used"
	label define multiple_adv_meth 1 "Multiple Advertisment Methods" 0 "Single Advertisment Method"
	label values multiple_adv_meth multiple_adv_meth
	
		
			***Redefining Labels For Industry Classification**
	
	label drop industry_classification_fs
	capture label variable industry_classification_fs "Which industry does this firm belong to?"
	label define industry_classification_fs 1 "Agriculture" 2 "Mining" 3 "Manufacturing" 4 "Electricity & Gas Supply" 5 "Sanitation Servcies" 6 "Construction" 7 "Wholesale & retail" 8 "Storage & Transportation" 9 "Accommodation & food service" 10 "ICT" 11 "Financial activities" 12 "Real estate" 13 "Professional & scientific activities" 14 "Admin & customer support" 15 "Public administration & defence" 16 "Education" 17 "Health activities" 18 "Arts & recreation" 19 "Other service activities" 20 "Activities of household employees" 21 "Extraterritorial organization activities" 22 "Can't decide" 23 "Others" .f  "Filtered because the question isn't relevant" .a "The question wasn't deployed"
	capture capture label values industry_classification_fs industry_classification_fs
	
/******************************************************************
					Part III: Generating Graphs
******************************************************************/
	
				***Graph 1: Firm & Advertisment Method****
	
distinct firm_id if !missing(fsbl_rv_harm_referrals_cons)
local nb_firms = `r(N)'

count if fsbl_rv_harm_newspaper_cons == 1
local newspaper = `r(N)'

count if fsbl_rv_harm_web_platform_cons == 1
local web_platform = `r(N)'

count if fsbl_rv_harm_other_mediums_cons == 1
local other_mediums = `r(N)'

count if fsbl_rv_harm_referrals_cons == 1
local Referrals = `r(N)'


graph bar fsbl_rv_harm_newspaper_cons fsbl_rv_harm_referrals_cons  fsbl_rv_harm_other_mediums_cons fsbl_rv_harm_web_platform_cons, bargap(15)				legend(label (1 "Newspaper") label (2 "Referrals") label (3 "Other Mediums") label (4 "Web-platform")) ylab(0 "0"  .2 "20"  .4 "40" .6 "60" .8 "80" )		ytitle("Percent of Firms") 	title("Vacancy Advertisment Methods Used By Firms" , span size(medium)) l1title("") 											blabel(total, position(outside) format(%10.4f)) plotregion(fcolor(white)) graphregion(fcolor(white)) note("N: `nb_firms'; Sample: Baseline Representative Survey." 								/// 
"Other mediums include third-party outsourcing, CV drop-offs & college recruitment." 												///
"Firms can select multiple advertisement methods." 					///
"This question is only answered by firms who opened a vacancy in the past year.", size(small)) 
			
	graph export "$graph_out\GEA Blog\FS Graphs\Firm Graphs\firm_method_advertisements.png", replace

			***Graph 2: Firm Size & Method Advertisment***

distinct firm_id
local nb_firms = `r(N)'	

count if fsbl_rv_harm_newspaper_cons == 1
local newspaper = `r(N)'

count if fsbl_rv_harm_web_platform_cons == 1
local web_platform = `r(N)'

count if fsbl_rv_harm_other_mediums_cons == 1
local other_mediums = `r(N)'

count if fsbl_rv_harm_referrals_cons == 1
local Referrals = `r(N)'

splitvallabels employee_size_cat_fs	

graph hbar fsbl_rv_harm_newspaper_cons fsbl_rv_harm_referrals_cons fsbl_rv_harm_other_mediums_cons fsbl_rv_harm_web_platform_cons, over (employee_size_cat_fs) bargap(15) legend(label (1 "Newspaper") label (2 "Referrals") label (3 "Other Mediums") label (4 "Web-platform")) 	ylab(0 "0"  .2 "20"  .4 "40" .6 "60" .8 "80" ) ytitle("Percent of Firms", size(small)) title("Firm Size & Advertisement Method" ,span size(medium)) plotregion(fcolor(white)) graphregion(fcolor(white)) note("{N: `nb_firms'." 												///
"Sample: Baseline. Other mediums include third-party outsourcing, CV drop-offs & college recruitment."  								///
"Nb Firm Newspaper = `newspaper'; Nb Firm Web-platform = `web_platform'; Nb Firm Other Mediums = `other_mediums'; Nb Firm Referrals = `Referrals'.}", size(vsmall))    																				
	graph export "$graph_out\GEA Blog\FS Graphs\Firm Graphs\method_adv_emp_size.png", as(png) replace
				  
	  **Graph 6: Eductaion Level & Method Advertisment**
	  
count if tag_highed_firms == 0
local tag_lowed = `r(N)'

count if tag_highed_firms == 1
local tag_highed = `r(N)'

count if fsbl_rv_harm_newspaper_cons == 1
local newspaper = `r(N)'

count if fsbl_rv_harm_web_platform_cons == 1
local web_platform = `r(N)'

count if fsbl_rv_harm_other_mediums_cons == 1
local other_mediums = `r(N)'

count if fsbl_rv_harm_referrals_cons == 1
local Referrals = `r(N)'


distinct firm_id
local nb_firms = `r(N)'


splitvallabels tag_highed_firms	

graph hbar fsbl_rv_harm_newspaper_cons fsbl_rv_harm_referrals_cons  fsbl_rv_harm_other_mediums_cons fsbl_rv_harm_web_platform_cons, over(tag_highed_firms) bargap(15) 	legend(label (1 "Newspaper") label (2 "Referrals") label (3 "Other Mediums") label (4 "Web-platform")) 						ytitle("Percent of Firms", size(vsmall)) title("Educational Requirement & Advertisement Method" ,span size(medium)) 		ylab(0 "0"  .2 "20"  .4 "40" .6 "60" .8 "80" )	   plotregion(fcolor(white)) graphregion(fcolor(white))			note("{N: `nb_firms'; Sample: Baseline."							///
"Other mediums include third-party outsourcing, CV drop-offs & college recruitment." 												/// 
"No. of High-ed firms:`tag_highed' & No. of Low-ed firms: `tag_lowed'"															///
"Nb Firm Newspaper = `newspaper'; Nb Firm Web-platform = `web_platform'; Nb Firm Other Mediums = `other_mediums'; Nb Firm Referrals = `Referrals'.}", size(vsmall)) 

	graph export "$graph_out\GEA Blog\FS Graphs\Firm Graphs\Education level & method of advertisement.png", as(png) name("Graph") replace
	
	  
	  **Graph 5: Industry Classification & Method Of Advertisment**
distinct firm_id
local nb_firms = `r(N)'

count if fsbl_rv_harm_newspaper_cons == 1
local newspaper = `r(N)'

count if fsbl_rv_harm_web_platform_cons == 1
local web_platform = `r(N)'

count if fsbl_rv_harm_other_mediums_cons == 1
local other_mediums = `r(N)'

count if fsbl_rv_harm_referrals_cons == 1
local Referrals = `r(N)'

splitvallabels industry_classification_fs

graph hbar fsbl_rv_harm_newspaper_cons fsbl_rv_harm_referrals_cons  fsbl_rv_harm_web_platform_cons fsbl_rv_harm_other_mediums_cons, over(industry_classification_fs) bargap(10)ytitle("Percent of firms", size(small))												ylab(0 "0"  .2 "20"  .4 "40" .6 "60" .8 "80" )					title("Industry & Method Advertisement", span size(medium))		legend(label (1 "Newspaper") label (2 "Referrals") label (3 "Web-platform") label (4 "Other Mediums"))					plotregion(fcolor(white)) graphregion(fcolor(white))			note("{N: `nb_firms'; Sample: Baseline. Other mediums include third-party outsourcing, CV drop-offs & college recruitment."										///
"Other industries include Agriculture, Electricity, Construction, Public administration, Arts & recreation, Extraterritorial organization activities." 		
///
"Nb Firm Newspaper = `newspaper'; Nb Firm Web-platform = `web_platform'; Nb Firm Other Mediums = `other_mediums'; Nb Firm Referrals = `Referrals'.}", size(vsmall))

	graph export "$graph_out\GEA Blog\FS Graphs\Firm Graphs\industry_advertsiment.png", as(png) name("Graph") replace
	
	
	**Graph 6: Recent Hire Gender & Method Advertisement**
		
distinct firm_id if !missing(fsbl_rv_harm_referrals_cons)
local nb_firms = `r(N)'
drop if fsbl_rv_gender_hire == 3


graph hbar fsbl_rv_harm_newspaper_cons fsbl_rv_harm_referrals_cons  fsbl_rv_harm_other_mediums_cons fsbl_rv_harm_web_platform_cons, over(fsbl_rv_gender_hire) bargap(15) 							legend(label (1 "Newspaper") label (2 "Referrals") label (3 "Other Mediums") label (4 "Web-platform")) 						ytitle("Percent of Firms", size(vsmall)) title("Gender of Recent Hire & Advertisement Method" ,span size(medium)) 				ylab(0 "0"  .2 "20"  .4 "40" .6 "60" .8 "80" 1.0 "100") 		blabel(total, position(outside) format(%10.4f) size(vsmall))	plotregion(fcolor(white)) graphregion(fcolor(white))			note("N: `nb_firms'. Sample: Representative Baseline Sample."											///
"Other mediums include third-party outsourcing, CV drop-offs & college recruitment." 										///																
"Firms can select multiple advertisement methods." 					///
"This question is only answered by firms who opened a vacancy in the past year.", size(small))	

graph export "$graph_out\GEA Blog\FS Graphs\Firm Graphs\gender_of_recent_hire.png", as(png) name("Graph") replace

	
	  **Graph 7: Women Inclusion & Method Advertisment**
	 	
	distinct firm_id if !missing(fsbl_rv_harm_referrals_cons)	
	local nb_firms = `r(N)'
	
	distinct firm_id if women_incl_fs == 3 &  !missing(fsbl_rv_harm_referrals_cons)	
	local Nb_firms = `r(N)'
	
	count if fsbl_rv_harm_cv_drop_cons == 1 & women_incl_fs == 3
	local cvdrop = `r(N)'
	local cv_drop =100*`cvdrop'/`Nb_firms'
	di %3.2f `cv_drop'
	
	count if fsbl_rv_harm_outsouricng_cons == 1 & women_incl_fs == 3
	local cvoutsc = `r(N)'
	local cv_outsc = 100*`cvoutsc'/`Nb_firms'
	di %3.2f `cv_outsc'
	
	count if fsbl_rv_harm_colg_cons == 1 & women_incl_fs == 3
	local clog_per = `r(N)'
	local colg = 100 * `clog_per'/`Nb_firms' 
	di %3.2f `colg'
	
	label   drop women_incl_fs	
	
	capture label variable women_incl_fs "Gender Inclusivity at Firms"	 	
	label 	define women_incl_fs 1 "No women employees, no interest in hiring"	 2 "No women employees, but open to hiring" 3 "Some women employees"

	label 	 values women_incl_fs women_incl_fs	
	
	splitvallabels women_incl_fs		
	
graph hbar fsbl_rv_harm_newspaper_cons fsbl_rv_harm_referrals_cons fsbl_rv_harm_other_mediums_cons fsbl_rv_harm_web_platform_cons fsbl_rv_harm_cv_drop_cons, over(women_incl_fs, label(labsize(1.7))) bargap(10) ytitle("Percent of Firms", size(vsmall)) ylab(0 "0" .2 "20" .4 "40" .6 "60" .8 "80" 1.0 "100" )		legend(label(1 "Newspaper") label(2 "Referrals") label (3 "Other Mediums") label (4 "Web-platform") label (5 "CV Drop-offs")) title("Women Inclusivity & Firm Advertisement Method" ,span size(medium))	blabel(total, position(outside) format(%10.4f) size(vsmall)) plotregion(fcolor(white)) 					 graphregion(fcolor(white))	note("N: `nb_firms'; Sample: Representative Baseline Sample."  				///							
"Unit of observation: Firms"										///
"Other mediums include third-party outsourcing & college recruitment." 												///
"Firms can select multiple advertisement methods."					///
"This question is only answered by firms who opened a vacancy in the past year.", size(vsmall)) 

	graph export "$graph_out\GEA Blog\FS Graphs\Firm Graphs\firm_gender_inclusivity.png", as(png) name("Graph") replace