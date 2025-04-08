/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 		APPENDIX - 	Stacked: driving, mobility, labor market outcomes,
							own, social contact; strata FEs; no controls
	
Table footnotes: Outcome variables are constructed as described in the notes for Tables 1 - 3. Variations in sample size are due to drop-off from telephone survey; order of survey modules was randomized. All estimates include randomization cohort fixed effects, SEs are clustered at household level. * p < 0.1 ** p < 0.05 *** p < 0.01.
	
********************************************************************************
********************************************************************************
********************************************************************************/
eststo clear

* RUN THESE DO FILES FIRST:

	do "$rep_code/1 - Pull in data.do"
	

	
* Set global for table outcomes
	global lab employed_w3 unemployed_w3 not_in_LF_w3   ///
		 empl_jobsearch_w3 ga_1st_order_likert_sw social_contact_sw

	
* Run models
	
		* (1) Strata FEs, PAP controls, baseline employment
		foreach var of global lab {		

			reghdfe `var' treatment if endline_start_w3==1, ///
			absorb(randomization_cohort2)  vce(cluster file_nbr)
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
		esttab employed_w3 unemployed_w3 not_in_LF_w3 empl_jobsearch_w3 ///
		ga_1st_order_likert_sw social_contact_sw using ///
		"$output_rct/robustness/LFP_ind dec_cohortPAP_nocontrols_likert_`c(current_date)'.tex", ///
		label se nonotes ///
		scalars("cmean Control mean" "b_cmean $\beta$/control mean" "pval P-value $\beta = 0$") ///
		nobaselevels nonotes keep(treatment) ///
		nogaps nobaselevels b(%9.3f) se(%9.3f) ///
		star(* 0.1 ** 0.05 *** 0.01) ///	
		mtitles( "\shortstack{Employed}" ///
		"\shortstack{Unemployed}" ///
		"\shortstack{Out of\\labor force}" ///
		"\shortstack{On the job\\search}" ///
		"\shortstack{Index: Own\\attitudes towards\\women working}" ///
		"\shortstack{Index: Social\\contact}") ///
		fragment varwidth(25) modelwidth(15) replace
		
		
		
