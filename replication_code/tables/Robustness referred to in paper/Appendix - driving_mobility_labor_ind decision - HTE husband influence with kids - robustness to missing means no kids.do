/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 		APPENDIX TABLE - Received license, employed, not in LF, permission
								 to make purchase; treatment interacted with husband/ 
								 co-parent indicator. 
								 This also assumes that if the value for number of kids
								 in the household <18 is missing, that the 
								 participant has no kids <18 in the household.
								
								 
								 
Table footnotes: `Has husband/co-parent' is defined as (a) currently married or (b) divorced/separated with children under 18 in the
household. Outcome variables are constructed as described in Tables 1 and 2. Four observations are dropped due to missing
baseline marital status. 12 respondents are missing administrative data on children in the household; this table assumes that such
respondents do not have children, presenting a robustness check to the main analysis in Table 5 in which such cases are excluded
from analysis.
All estimates include individual and household controls: age (above median dummy), education level (less than a highschool degree),
household size (number of members), number of cars owned (indicators for one car and for more than one car), an indicator for
baseline labor force participation, and randomization cohort fixed effects. SEs are clustered at household level. We impute for
missing control values and include missing dummies for each, except for the interaction control. Marital status dummies are not
included as a control in this table because they are highly collinear with "has husband/co-parent". However, results are robust to
including individual indicators as controls for: married; single; and widowed (divorced/separated is the reference group). * p < 0.1
** p < 0.05 *** p < 0.01.
				
********************************************************************************
********************************************************************************
********************************************************************************/
eststo clear

* RUN THESE DO FILES FIRST:

	do "$rep_code/1 - Pull in data.do"
	do "$rep_code/2 - Setting regression controls.do"
	do "$rep_code/3 - Imputation for controls.do"
	
* Restrict data to main follow up
	keep if endline_start_w3==1
	
* shorten var name for storage
	rename share_trips_unaccomp_w3 share_unaccomp
	
* Set global for table outcomes
	global hte_outcome license_w3 employed_w3 not_in_LF_w3 G1_3_abovemed

* Run models
			   
		* (1) Cohort FEs, PAP controls, baseline employment, HTE husband influence 	   
		foreach var in $hte_outcome {		

			reghdfe `var' treatment##i.husb_influence_kids_alt $controls_HTEhusb , ///
			absorb(randomization_cohort2 )  vce(cluster file_nbr)
			eststo `var'
			
			* Test total effect
			test _b[1.treatment] + _b[1.treatment#1.husb_influence_kids_alt]=0
			estadd scalar b1_b3 = r(p)
			
			* Store total effect for outcomes in Panel B			
			lincom 1.treatment + 1.treatment#1.husb_influence_kids_alt				
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
			sum `var' if e(sample) & treatment==0 & husb_influence_kids_alt==0
			estadd scalar cmean_nohus = r(mean)
			
			sum `var' if e(sample) & treatment==0 & husb_influence_kids_alt==1
			estadd scalar cmean_hus = r(mean)
		}
		
* Write to latex
	
	* (1)
	* PANEL A		 
	esttab $hte_outcome using ///
		"$output_rct/robustness/HTE results_husb_copar_altdefn_`c(current_date)'.tex", ///
		 label se nogaps nobaselevels ///
		 keep(*treatment *husb_influence_kids_alt) b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) ///	
		 mtitles("\shortstack{Received\\license}" "\shortstack{Employed}" ///
		"\shortstack{Not in LF}"  ///
		"\shortstack{Allowed to\\make purchase\\without\\permission}") ///
		varlabels(1.treatment "$\beta\textsubscript{1}$: Treatment" ///
		1.husb_influence_kids_alt "$\beta\textsubscript{2}$: Has husband/co-parent" ///
		1.treatment#1.husb_influence_kids_alt ///
		"$\beta\textsubscript{3}$: Treatment x Has husband/co-parent") ///
		 replace  varwidth(25) modelwidth(12) fragment nonotes noobs
		 
		 * Add total effects	
		esttab	$hte_outcome using ///
		"$output_rct/robustness/HTE results_husb_copar_altdefn_`c(current_date)'.tex", ///
		append fragment nomtitles nonumbers noconstant noobs nogaps nonotes ///
		cells(none) stats(total_eff_b total_eff_se, ///
		labels("$\beta\textsubscript{1}$ + $\beta\textsubscript{3}$" " "))
		 
		* Add N, control mean, and p-val for test that total effect is different from zero 
		 esttab	$hte_outcome using ///
		"$output_rct/robustness/HTE results_husb_copar_altdefn_`c(current_date)'.tex", ///
		append fragment nomtitles nonumbers noconstant noobs  nonotes  ///
		cells(none) stats(N  cmean_nohus cmean_hus, labels("Observations" ///
		"Mean: Control, no husband/co-parent" ///
		"Mean: Control, has husband/co-parent") ///
		fmt(0 %9.3f %9.3f))
		
		

	