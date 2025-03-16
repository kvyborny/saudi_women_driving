/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 		APPENDIX TABLE - Stacked driving, mobility, 
								 labor market outcomes, and independent decision 
								 making; treatment interacted with husband 
								 influence indicator (version where influence is 
								 determined by kids in the HH if divorced)

Table footnotes: Notes: `Has husband/co-parent' is defined as (a) currently married or (b) divorced/separated with children under 18 in the household. 16 respondents are missing administrative data on children
in the household and are excluded from these estimates; Appendix Table A13 alternatively assumes that such respondents do not have children, and results are very similar. Three additional
observations are dropped due to missing baseline marital status, which are used as control variables and missing values are imputed using a dummy variable adjustment approach in Table 1;
together these cause a difference in sample size between tables. Outcome variables are constructed as described in the notes to Table 1. Variations in sample size are due to drop-off from
telephone survey; order of survey modules was randomized. All estimates include cohort FEs and individual and household control variables: age, education level, household size, number of cars
owned by household, and baseline employment. Marital status dummies are not included as a control in this table because they are highly collinear with "has husband/co-parent". However,
results are unchanged if we include individual indicators as controls for: married; divorced/separated with co-parent; and widowed (never married is the reference group). SEs are clustered at
household level. * p < 0.1 ** p < 0.05 *** p < 0.01.


								 
********************************************************************************
********************************************************************************
********************************************************************************/
eststo clear

* RUN THESE DO FILES FIRST:

	do "$github/paper_replication_RR/1 - Pull in data.do"
	do "$github/paper_replication_RR/tables/Robustness referred to in paper/Main estimates from original submission/2 - Setting regression controls_original.do"
	do "$github/paper_replication_RR/tables/Robustness referred to in paper/Main estimates from original submission/3 - Imputation for controls_original.do"
	
* Restrict data to main follow up
	keep if endline_start_w3==1
	
* shorten var name for storage
	rename share_trips_unaccomp_w3 share_unaccomp
	
* Set global for table outcomes
	global 	drive_mob_lab s_train_bi_w3 license_w3 drive_any_mo_bi_w3 ///
			M4_1_TEXT share_unaccomp employed_w3  unemployed_w3 not_in_LF_w3 ///
			empl_jobsearch_w3 no_trips_unaccomp_w3 G1_2_abovemed G1_3_abovemed

* Run models
			   
		* (1) Cohort FEs, PAP controls, baseline employment, HTE husband influence 	   
		foreach var of global drive_mob_lab {		

			reghdfe `var' treatment##i.husb_influence_kids_original_BL $controls_HTE_orig , ///
			absorb(randomization_cohort2 )  vce(cluster file_nbr)
			eststo `var'_1
			
			* Test total effect
			test _b[1.treatment] + _b[1.treatment#1.husb_influence_kids]=0
			estadd scalar b1_b3 = r(p)
			
			* Store total effect for outcomes in Panel B			
			lincom 1.treatment + 1.treatment#1.husb_influence_kids				
			local totaleff: di %9.3f `r(estimate)'
			if `r(p)' < 0.01 {
			local star "\sym{***}"
			}
			else if `r(p)' < 0.05 {
			local star "\sym{**}"
			}
			else if `r(p)' < 0.1 {
			local star "\sym{*}"
			}
			else {
				local star ""
			}
			estadd local total_eff_b  "`totaleff'`star'"
			local aux_se: display %5.3f `r(se)'
			estadd local total_eff_se "(`aux_se')"
		
			
			* grab control means for each subgroup
			sum `var' if e(sample) & treatment==0 & husb_influence_kids_original_BL==0
			estadd scalar cmean_nohus = r(mean)
			
			sum `var' if e(sample) & treatment==0 & husb_influence_kids_original_BL==1
			estadd scalar cmean_hus = r(mean)
		}
		
* Write to latex
	
	* (1)
	* PANEL A		 
	esttab 	s_train_bi_w3_1 license_w3_1 drive_any_mo_bi_w3_1 M4_1_TEXT_1 ///
			share_unaccomp_1 no_trips_unaccomp_w3_1 using ///
			"$output_rct/Drive training_license_cohortPAP_husbinfluence_kids_original_`c(current_date)'.tex", ///
			label se nogaps nobaselevels ///
			keep(*treatment *husb_influence_kids_original_BL) b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) ///	
			mtitles("\shortstack{Started driver's\\training}" ///
			"\shortstack{Received\\license}" "\shortstack{Any driving\\in past month}" ///
			"\shortstack{Number of\\times left\\house in\\last 7 days}" ///
			"\shortstack{Share of\\trips made\\without male\\chaperone}" ///
			"\shortstack{Always travels\\with male\\chaperone}") ///
			varlabels(1.treatment "$\beta\textsubscript{1}$: Treatment" ///
			1.husb_influence_kids_original_BL "$\beta\textsubscript{2}$: Has husband/co-parent" ///
			1.treatment#1.husb_influence_kids_original_BL ///
			"$\beta\textsubscript{3}$: Treatment x Has husband/co-parent") ///
			replace  varwidth(25) modelwidth(12) fragment nonotes noobs
		 
		 * Add total effects	
		esttab	s_train_bi_w3_1 license_w3_1 drive_any_mo_bi_w3_1 M4_1_TEXT_1 ///
				share_unaccomp_1 no_trips_unaccomp_w3_1 using ///
				"$output_rct/Drive training_license_cohortPAP_husbinfluence_kids_original_`c(current_date)'.tex", ///
				append fragment nomtitles nonumbers noconstant noobs nogaps nonotes ///
				cells(none) stats(total_eff_b total_eff_se, ///
				labels("$\beta\textsubscript{1}$ + $\beta\textsubscript{3}$" " "))
		 
		* Add N, control mean, and p-val for test that total effect is different from zero 
		esttab	s_train_bi_w3_1 license_w3_1 drive_any_mo_bi_w3_1 M4_1_TEXT_1 ///
				share_unaccomp_1 no_trips_unaccomp_w3_1 using ///
				"$output_rct/Drive training_license_cohortPAP_husbinfluence_kids_original_`c(current_date)'.tex", ///
				append fragment nomtitles nonumbers noconstant noobs  nonotes  ///
				cells(none) stats(N  cmean_nohus cmean_hus, labels("Observations" ///
				"Mean: Control, no husband/co-parent" ///
				"Mean: Control, has husband/co-parent") ///
				fmt(0 %9.3f %9.3f))
		
		
	* PANEL B	
	esttab 	employed_w3_1 unemployed_w3_1 not_in_LF_w3_1 empl_jobsearch_w3_1 ///
			G1_2_abovemed_1 G1_3_abovemed_1 using ///
			"$output_rct/LFP_ind dec_cohortPAP_husbinfluence_kids_original_`c(current_date)'.tex", ///
			label se nogaps nobaselevels ///
			keep(*treatment *husb_influence_kids_original_BL) b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) ///	
			mtitles("\shortstack{Employed}" ///
			"\shortstack{Unemployed}" ///
			"\shortstack{Out of labor\\force}" ///
			"\shortstack{On the job\\search}" ///
			"\shortstack{Allowed to\\leave the\\house without\\permission}" ///
			"\shortstack{Allowed to\\make purchase\\without\\permission}") ///
			varlabels(1.treatment "$\beta\textsubscript{1}$: Treatment" ///
			1.husb_influence_kids_original_BL "$\beta\textsubscript{2}$: Has husband/co-parent" ///
			1.treatment#1.husb_influence_kids_original_BL "$\beta\textsubscript{3}$: Treatment x Has husband/co-parent") ///
			replace  varwidth(25) modelwidth(12) fragment nonotes noobs
		 
		 * Add total effects	
		esttab	employed_w3_1 unemployed_w3_1 not_in_LF_w3_1 empl_jobsearch_w3_1 ///
				G1_2_abovemed_1 G1_3_abovemed_1 using ///
				"$output_rct/LFP_ind dec_cohortPAP_husbinfluence_kids_original_`c(current_date)'.tex", ///
				append fragment nomtitles nonumbers noconstant noobs nogaps nonotes ///
				cells(none) stats(total_eff_b total_eff_se, ///
				labels("$\beta\textsubscript{1}$ + $\beta\textsubscript{3}$" " "))
		 
		* Add N, control mean, and p-val for test that total effect is different from zero 
		esttab	employed_w3_1 unemployed_w3_1 not_in_LF_w3_1 empl_jobsearch_w3_1 ///
				G1_2_abovemed_1 G1_3_abovemed_1 using ///
				"$output_rct/LFP_ind dec_cohortPAP_husbinfluence_kids_original_`c(current_date)'.tex", ///
				append fragment nomtitles nonumbers noconstant noobs  nonotes  ///
				cells(none) stats(N  cmean_nohus cmean_hus , ///
				labels("Observations" "Mean: Control, no husband/co-parent" ///
				"Mean: Control, has husband/co-parent") ///
				fmt(0 %9.3f %9.3f))
						
						
						
/* NOTE: 
	Outcome for "On the job search" includes 2 additional observations (one is dropped
	due to missing marital status). After 
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
						
	