/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 		MULTIPLE HYPOTHESIS TESTING - JOB SEARCH
				
Table footnotes: 

********************************************************************************
********************************************************************************
*******************************************************************************/
eststo clear

* RUN THESE DO FILES FIRST:

	do "$rep_code/1 - Pull in data.do"
	do "$rep_code/2 - Setting regression controls.do"
	do "$rep_code/3 - Imputation for controls.do"
	

			
	global 	job_search2 employed_w3  unemployed_w3 empl_jobsearch_w3 
			

* Run models

	*  Run first for q-vals: Cohort FEs, PAP controls, baseline employment
		foreach var in $job_search2 {	

			reghdfe `var' treatment  $controls if endline_start_w3==1, ///
			absorb(randomization_cohort2   )  vce(cluster file_nbr)
					
			* Store P-value for MHT
			test treatment = 0 
			local p_`var' = `r(p)'
	
		}	
		
		preserve
		mat pval = (`p_employed_w3' \ `p_unemployed_w3' \ `p_empl_jobsearch_w3')
		
		clear
		do "$rep_code/tables/Appendix Tables/Appendix B/Anderson_2008_fdr_sharpened_qvalues.do"
		restore
		
		*  Now re-run to store for table: Cohort FEs, PAP controls, baseline employment
		local i = 1 		// set local to pull qval from matrix
		foreach var in $job_search2 {	
			
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
			
			* Q-value
			estadd scalar qval = qval[`i',1]
			local i = `i' + 1
	
		}
		
		


* Write to latex


			 
		* Economic and financial agency
		esttab $job_search2 using ///
		"$output_rct/MHT_emp_unemp_empsearch_`c(current_date)'.tex", ///
		label se nonotes scalars("cmean Control mean" "b_cmean $\beta$/control mean" ///
		"pval P-value $\beta = 0$" "qval FDR Q-value $\beta = 0$") ///
		nobaselevels keep(treatment) nogaps  b(%9.3f) se(%9.3f) ///
		star(* 0.1 ** 0.05 *** 0.01) ///	
		mtitles( "\shortstack{Employed}" ///
		"\shortstack{Unemployed}" ///
		"\shortstack{On the job\\search}") ///
		fragment varwidth(25) modelwidth(15) replace
		
	
		
