/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 		MAIN TABLE - Stacked: driving, mobility, labor market outcomes,
							 and independent decision making
				
Table footnotes: Notes: Panel A, Column (5) and (6) outcomes are set to zero for 24 observations in which the respondent reported making no trips
outside the home in the previous 7 days. The outcome in Panel B, column (2) indicates the respondent reports she is not working
but is searching for a job. The outcome in Panel B, column (4) indicates whether the respondent is employed and applied for at
least one job in the previous month (a more general measure of search beyond job applications was not collected for employed
respondents). Results for unemployment are similar if we redefine unemployed to include only those who applied for at least one
job in the previous month. The outcomes in Panel B columns 5 and 6 are constructed as follows: respondents were asked to rate
their level of agreement (using a 5 point Likert scale from `completely disagree' to `completely agree') with the statements "If I
wanted to meet with a friend outside of my home, I could do so without seeking approval / permission from anyone in my household
first" and "I can make a purchase of 1000 SAR without needing to take permission from any member of my family" (1000 SAR is
roughly equivalent to 265 USD, in 2021 dollars), respectively. The outcome variables are indicators for above-median response on
the Likert scale for each statement response. Variations in sample size are due to drop-off from telephone survey; order of survey
modules was randomized. All estimates include cohort FEs and individual and household control variables: age, education level,
indicators for marital status, household size, number of cars owned by household, baseline employment. SEs clustered at household
level; * p < 0.1 ** p < 0.05 *** p < 0.01.


********************************************************************************
********************************************************************************
********************************************************************************/
eststo clear

* RUN THESE DO FILES FIRST:

	do "$github/paper_replication_RR/1 - Pull in data.do"
	do "$github/paper_replication_RR/tables/Robustness referred to in paper/Main estimates from original submission/2 - Setting regression controls_original.do"
	do "$github/paper_replication_RR/tables/Robustness referred to in paper/Main estimates from original submission/3 - Imputation for controls_original.do"
	
* Restrict data to those who started the main follow-up survey
	keep if endline_start_w3==1
	
* shorten var name for storage
	rename share_trips_unaccomp_w3 share_unaccomp
	
* Set global for table outcomes
	global 	drive_mob_lab s_train_bi_w3 license_w3 drive_any_mo_bi_w3 ///
			M4_1_TEXT share_unaccomp employed_w3  unemployed_w3 not_in_LF_w3 ///
			empl_jobsearch_w3 no_trips_unaccomp_w3 G1_2_abovemed G1_3_abovemed
	
* Run models
	
		* (1) Cohort FEs, PAP controls, baseline employment
		foreach var of global drive_mob_lab {		

			reghdfe `var' treatment  $controls_orig, ///
			absorb(randomization_cohort2   )  vce(cluster file_nbr)
			eststo `var'_1
			
			* grab control mean
			sum `var' if e(sample) & treatment==0
			estadd scalar cmean = r(mean)	

			}
			


* Write to latex
	* (1)
	* Drive training, license and mobility
		esttab s_train_bi_w3_1 license_w3_1 drive_any_mo_bi_w3_1 M4_1_TEXT_1 ///
		share_unaccomp_1 no_trips_unaccomp_w3_1 ///
		using "$output_rct/Drive training & license_cohortPAP_original_`c(current_date)'.tex", ///
		 label se scalars("cmean Mean: Control") nogaps nobaselevels ///
		 keep(treatment) b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) ///	
		 mtitles("\shortstack{Started\\driver's\\training}" ///
		 "\shortstack{Received\\license}" "\shortstack{Any driving\\in past\\month}" ///
		"\shortstack{Number of\\times left\\house in\\last 7 days}" ///
		"\shortstack{Share of\\trips made\\without male\\chaperone}" ///
		"\shortstack{No trips\\made without\\male chaperone}") ///
		 replace  varwidth(25) modelwidth(12) fragment nonotes
			 
		* Economic and financial agency
		esttab employed_w3_1 unemployed_w3_1 not_in_LF_w3_1 empl_jobsearch_w3_1 ///
		G1_2_abovemed_1 G1_3_abovemed_1 using ///
		"$output_rct/LFP_ind dec_cohortPAP_original_`c(current_date)'.tex", ///
		label se nonotes scalars("cmean Mean: Control") ///
		nobaselevels nonotes keep(treatment) ///
		nogaps nobaselevels b(%9.3f) se(%9.3f) ///
		star(* 0.1 ** 0.05 *** 0.01) ///	
		mtitles( "\shortstack{Employed}" ///
		"\shortstack{Unemployed}" ///
		"\shortstack{Out of\\labor force}" ///
		"\shortstack{On the job\\search}" ///
		"\shortstack{Allowed to leave\\the house without\\permission}" ///
		"\shortstack{Allowed to make\\purchase without\\permission}") ///
		fragment varwidth(25) modelwidth(15) replace
		
/* NOTE: 
	Outcome for "On the job search" includes 2 additional observations. After 
	our original submission, we noticed that the outcome was excluding those who
	were not employed and missing a value for number of jobs applied to in the 
	previous month. We corrected this as shown in the excerpts of code below. The
	results are nearly identical.
	
	
	ORIGINAL CODING OF `empl_jobsearch_w3'

gen empl_jobsearch_w3 = 0 if jobs_applied_w3!=. & employed_w3!=.
	replace empl_jobsearch_w3 = 1 if jobs_applied_w3!=. & jobs_applied_w3>0 & employed_w3==1
	lab var empl_jobsearch_w3 "Employed and applied in past month (wave 3)"
	
	
	CURRENT CODING OF `empl_jobsearch_w3'

	gen empl_jobsearch_w3 = 0 if jobs_applied_w3!=. & employed_w3!=.
	replace empl_jobsearch_w3 = 0 if jobs_applied_w3==. & employed_w3==0
	replace empl_jobsearch_w3 = 1 if jobs_applied_w3!=. & jobs_applied_w3>0 & employed_w3==1
	lab var empl_jobsearch_w3 "Employed and applied in past month (wave 3)"
	
	The N for `Received license' has decreased by two observations. This was a mistake
	in the code for the original submission. `Received license' takes a value of 1
	if the respondent reported getting a license during the interim survey, and when
	restricting to those who had responded to the endline we mistakenly included
	two respondents who reported having a license in the interim but did not appear
	in the endline.
*/
		