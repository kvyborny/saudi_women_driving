/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 		MAIN TABLE - Stacked: driving, mobility, labor market outcomes,
							 and independent decision making
				
Table footnotes: 

Table 1: Column (5) and (6) outcomes are set to zero for 24 observations in which the respondent reported making no trips
outside the home in the previous 7 days. Variations in sample size are due to drop-off from telephone survey; order of survey
modules was randomized. All estimates include individual and household controls: age (above median dummy), education level
(less than a highschool degree), marital status (indicators for married, never-married, and widowed), household size (number
of members), number of cars owned (indicators for one car and for more than one car), an indicator for baseline labor force
participation, and randomization cohort fixed effects. SEs are clustered at household level. We impute for missing control
values and include missing dummies for each. * p < 0.1 ** p < 0.05 *** p < 0.01.

Table 2: The outcome in column (4) indicates whether the respondent is employed and applied for at least one job in the previous
month (a more general measure of search beyond job applications was not collected for employed respondents). Results for
unemployment are similar if we redefine unemployed to include only those who applied for at least one job in the previous month.
The outcomes in Columns 5 and 6 were constructed as follows: respondents were asked to rate their own level of agreement (using
a 5 point Likert scale from `completely disagree' to `completely agree') for each of the statements in Panel A, Columns 2-5 and 7 of
Table A10. Responses to each statement were then transformed into binary indicators for above median responses. Respondents
were also asked what the ideal age is for a woman to have her first child (Panel A, Column 6 of Table A10). Respondents were
also asked about the number of people they spoke to on the phone and met with in the previous 7 days (Panel B, Columns
2-3 of Table A10). Weighted indices of the standardized responses to each set of questions, respectively, were generated using
the swindex command developed by Schwab et al. (2020). Variations in sample size are due to drop-off from telephone survey;
order of survey modules was randomized. All estimates include individual and household controls: age (above median dummy),
education level (less than a highschool degree), marital status (indicators for married, never-married, and widowed), household size
(number of members), number of cars owned (indicators for one car and for more than one car), an indicator for baseline labor
force participation, and strata fixed effects. SEs are clustered at household level. We replace missing control values with 0 and
include missing dummies for each. * p < 0.1 ** p < 0.05 *** p < 0.01
********************************************************************************
********************************************************************************
*******************************************************************************/
eststo clear

* RUN THESE DO FILES FIRST:

	do "$rep_code/1 - Pull in data.do"
	do "$rep_code/2 - Setting regression controls.do"
	do "$rep_code/3 - Imputation for controls.do"
	
	
* shorten var name for storage
	rename share_trips_unaccomp_w3 share_unaccomp
	
	
* Set global for table outcomes
	global 	drive_mob s_train_bi_w3 license_w3 drive_any_mo_bi_w3 ///
			M4_1_TEXT share_unaccomp no_trips_unaccomp_w3 
			
	global 	lab employed_w3  unemployed_w3 not_in_LF_w3 ///
			empl_jobsearch_w3 ga_1st_order_binary_sw social_contact_sw
			

* Run models

	*  Cohort FEs, PAP controls, baseline employment
		foreach var in $drive_mob $lab {	

			reghdfe `var' treatment  $controls if endline_start_w3==1, ///
			absorb(randomization_cohort2   )  vce(cluster file_nbr)
			est sto `var'

			
			* grab control mean
			sum `var' if e(sample) & treatment==0
			estadd scalar cmean = r(mean)	
			
			* grab beta/control mean
			local beta: display %4.3f _b[treatment]
			local cmean: display %4.3f r(mean)
			estadd scalar b_cmean = `beta'/`cmean'
			
			* P-value 
			test treatment = 0 
			estadd scalar pval = `r(p)' 
	
		}	
		
		


* Write to latex

	* Drive training, license and mobility
		esttab $drive_mob ///
		using "$output_rct/Drive training & license_cohortPAP_`c(current_date)'.tex", ///
		 label se scalars("cmean Control mean" "b_cmean $\beta$/control mean" "pval P-value $\beta = 0$") ///
		 nogaps nobaselevels ///
		 keep(treatment) b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) ///	
		 mtitles("\shortstack{Started\\driver's\\training}" ///
		 "\shortstack{Received\\license}" "\shortstack{Any driving in\\past month}" ///
		"\shortstack{Number of\\times left\\house in\\last 7 days}" ///
		"\shortstack{Share of trips\\made without\\male chaperone}" ///
		"\shortstack{Always travels\\with male\\chaperone}") ///
		 replace  varwidth(25) modelwidth(12) fragment nonotes
		 	
			 
		* Economic and financial agency
		esttab $lab using ///
		"$output_rct/LFP_ind dec_cohortPAP_binary_`c(current_date)'.tex", ///
		label se nonotes scalars("cmean Control mean" "b_cmean $\beta$/control mean"  "pval P-value $\beta = 0$") ///
		nobaselevels keep(treatment) nogaps  b(%9.3f) se(%9.3f) ///
		star(* 0.1 ** 0.05 *** 0.01) ///	
		mtitles( "\shortstack{Employed}" ///
		"\shortstack{Unemployed}" ///
		"\shortstack{Out of\\labor force}" ///
		"\shortstack{On the job\\search}" ///
		"\shortstack{Index: Own\\attitudes\\towards women\\working}" ///
		"\shortstack{Index:\\Social\\contact}") ///
		fragment varwidth(25) modelwidth(15) replace
		
	
		
