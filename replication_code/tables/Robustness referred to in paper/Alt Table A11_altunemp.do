/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 		ROBUSTNESS TABLE - Stacked: labor market outcomes, weighted by
									BL age-edu and by BL employment status.
									Unemployed redefined to include only those who
									applied for at least one job in the previous
									month
			
Table footnotes: This table is an alternate version of Table A11 Column 2 in the paper, where
unemployed is redefined to include only those who applied for at least one job in the previous
month.  * p < 0.1 ** p <
0.05 *** p < 0.01.

********************************************************************************
********************************************************************************
********************************************************************************/
eststo clear

* RUN THESE DO FILES FIRST:

	do "$rep_code/1 - Pull in data.do"
	do "$rep_code/2 - Setting regression controls.do"
	do "$rep_code/3 - Imputation for controls.do"
	
	
	
* Set global for table outcomes
	global 	labor  unempl_jobsearch_w3 

			
* Run models

	* (1) WEIGHTED
	local i = 1 	// store estimates according to weight order
	foreach weight in age_edu_weight emp_weight {
		
	
	global 	labor_wt`i' employed_w3_wt`i'  unempl_jobsearch_w3_wt`i' not_in_LF_w3_wt`i' ///
			empl_jobsearch_w3_wt`i' 
		
		* Cohort FEs, PAP controls, baseline employment - weighted
		foreach var in  $labor {	

			reghdfe `var' treatment  $controls if endline_start_w3==1 [pweight=`weight'], ///
			absorb(randomization_cohort2   )  vce(cluster file_nbr)
			est sto `var'_wt`i'

			
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
	

		local i = `i'+1		
	}	
	
	
	* (2) UNWEIGHTED PANEL FOR REFERENCE
	foreach var in $labor {	

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
		

