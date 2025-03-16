/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 		MULTIPLE HYPOTHESIS TESTING: Ability to leave the house, 
				Ability to make purchases



Table footnotes: TO ADD

					   				
********************************************************************************
********************************************************************************
*******************************************************************************/
eststo clear

* RUN THESE DO FILES FIRST:

	do "$rep_code/1 - Pull in data.do"
	do "$rep_code/2 - Setting regression controls.do"
	do "$rep_code/3 - Imputation for controls.do"



* Set global for table outcomes

	* likert/cts version
	global 	mob_spen  G1_2_abovemed G1_3_abovemed 
			

* Run models	
		*  Run first for q-vals: Cohort FEs, PAP controls, baseline employment
		foreach var in $mob_spen {	

			reghdfe `var' treatment  $controls if endline_start_w3==1, ///
			absorb(randomization_cohort2   )  vce(cluster file_nbr)
					
			* Store P-value for MHT
			test treatment = 0 
			local p_`var' = `r(p)'
	
		}	
		
		preserve
		mat pval = (`p_G1_2_abovemed' \ `p_G1_3_abovemed')
		
		clear
		do "$rep_code/tables/Appendix Tables/Appendix B/Anderson_2008_fdr_sharpened_qvalues.do"
		restore
		
		*  Now re-run to store for table: Cohort FEs, PAP controls, baseline employment
		local i = 1 		// set local to pull qval from matrix
		foreach var in $mob_spen {	
			
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


	esttab $mob_spen using ///
	"$output_rct/MHT_Mobility_Spending_swindex_binary_cohortPAP_`c(current_date)'.tex", ///
	label se nonotes keep(*treatment) ///
	scalars("cmean Control mean" "b_cmean $\beta$/control mean" "pval P-value $\beta = 0$" ///
	"qval FDR Q-value $\beta = 0$") ///
	b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) ///	
	mtitles("\shortstack{Allowed to\\leave house\\w/o permission}" ///
		"\shortstack{Allowed to\\make purchase\\w/o permission}") ///
	varwidth(75) modelwidth(15) fragment nobaselevels nogaps replace 
	
	
