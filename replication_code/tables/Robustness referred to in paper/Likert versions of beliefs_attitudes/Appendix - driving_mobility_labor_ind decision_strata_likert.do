/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 		APPENDIX TABLE - Stacked: labor market outcomes,
							 and independent decision making, strata FEs; likert
							 versions
	
Table footnotes: Outcome variables are constructed as described in the notes for Tables 1 - 3. Variations in sample size are due to drop-off from telephone survey; order of survey modules was randomized. All
estimates include individual and household controls: age (above median dummy), education level (less than a highschool degree), marital status (indicators for married, never-married, and widowed),
household size (number of members), number of cars owned (indicators for one car and for more than one car), an indicator for baseline labor force participation, and fixed effects for randomization
strata. SEs are clustered at household level. We impute for missing control values and include missing dummies for each.
	
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

	
* Set global for table outcomes

	
	global 	lab employed_w3  unemployed_w3 not_in_LF_w3 ///
			empl_jobsearch_w3 ga_1st_order_likert_sw social_contact_sw
	
* Run models
	
		* (1) Strata FEs, PAP controls, baseline employment
		foreach var in  $lab {		

			reghdfe `var' treatment  $controls, ///
			absorb(group_strata)  vce(cluster file_nbr)
			eststo `var'
			
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

			 
		* Economic and financial agency
		esttab $lab using ///
		"$output_rct/robustness/LFP_ind dec_strataPAP_likert_`c(current_date)'.tex", ///
		label se nonotes scalars("cmean Control mean" "b_cmean $\beta$/control mean" "pval P-value $\beta = 0$") ///
		nobaselevels nonotes keep(treatment) ///
		nogaps nobaselevels b(%9.3f) se(%9.3f) ///
		star(* 0.1 ** 0.05 *** 0.01) ///	
		mtitles("\shortstack{Employed}" ///
		"\shortstack{Unemployed}" ///
		"\shortstack{Out of\\labor force}" ///
		"\shortstack{On the job\\search}" ///
		"\shortstack{Index: Own\\attitudes towards\\women working}" ///
		"\shortstack{Index: Social\\contact}") ///
		fragment varwidth(25) modelwidth(15) replace
		
		
