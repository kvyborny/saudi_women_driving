/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 		APPEN TABLE - 	HTE (MARITAL STATUS) FOR OUTCOMES: EMPLOYED,
								UNEMPLOYED, AND EMPLOYED SEARCH
								  
								  
TABLE FOOTNOTES:							 


********************************************************************************
********************************************************************************
*******************************************************************************/
eststo clear

* RUN THESE DO FILES FIRST:

	do "$rep_code/1 - Pull in data.do"
	do "$rep_code/2 - Setting regression controls.do"
	do "$rep_code/3 - Imputation for controls.do"
	
* Restrict data to main follow up
	keep if endline_start_w3==1

	
* Set global for table outcomes
	global 	hte_outcome employed_w3 unemployed_w3 empl_jobsearch_w3			
			
* Relabel vars for table output
	lab var rel_status_BL "Marital status at BL"


* Run models

		* Run and store p-vals for FDR
		foreach outcome of global hte_outcome {
		
			reghdfe `outcome' treatment##i.rel_status_BL  $controls_HTEhusb, ///
				absorb(randomization_cohort2)  vce(cluster file_nbr)
			
			* Store P-values for MHT
			
				* Beta 1
				test 1.treatment = 0 
				local p_`outcome'_b1 = r(p)
					
				* Beta 1 + Beta 5 (interaction with 'married')
				test 1.treatment + 1.treatment#2.rel_status_BL = 0 
				local p_`outcome'_b15 = r(p)
				
				* Beta 1 + Beta 6 (interaction with 'never-married')
				test 1.treatment + 1.treatment#3.rel_status_BL = 0 
				local p_`outcome'_b16 = r(p)
				
				* Beta 1 + Beta 7 (interaction with 'widowed')
				test 1.treatment + 1.treatment#4.rel_status_BL = 0 
				local p_`outcome'_b17 = r(p)

		}
		
		foreach i in 1 15 16 17 {
			mat pval_b`i' = (`p_employed_w3_b`i'' \ `p_unemployed_w3_b`i'' \ `p_empl_jobsearch_w3_b`i'')
		}
		
		* To check these:
		di "pvals for beta 1:"
		mat list pval_b1
		di "pvals for  beta 1 + beta 5:"
		mat list pval_b15
		di "pvals for  beta 1 + beta 6:"
		mat list pval_b16
		di "pvals for  beta 1 + beta 7:"
		mat list pval_b17
		
		* Generate q-vals
		preserve
			foreach i in 1 15 16 17 {
					
				mat pval = pval_b`i'
				clear
				do "$rep_code/tables/Appendix Tables/Appendix B/Anderson_2008_fdr_sharpened_qvalues.do"
				mat qval_b`i' = qval
			}
			
			* To check these:
			di "qvals for beta 1:"
			mat list qval_b1
			di "qvals for  beta 1 + beta 5:"
			mat list qval_b15
			di "qvals for  beta 1 + beta 6:"
			mat list qval_b16
			di "qvals for  beta 1 + beta 7:"
			mat list qval_b17

		restore
		
		* RE-RUN MODELS FOR MARITAL STATUS 
		local q = 1 		// row of q-val corresponding to outcome
		foreach outcome of global hte_outcome {
		
			reghdfe `outcome' treatment##i.rel_status_BL  $controls_HTEhusb, ///
				absorb(randomization_cohort2)  vce(cluster file_nbr)
			eststo `outcome'_mar
			
			* treatment 
			test _b[1.treatment] =0
			estadd scalar b1 = r(p)
				 
			* treatment + treatment x married
			test _b[1.treatment] + _b[1.treatment#2.rel_status_BL]=0
			estadd scalar b1_b5 = r(p)
			
			* treatment + treatment x never-married
			test _b[1.treatment] + _b[1.treatment#3.rel_status_BL]=0
			estadd scalar b1_b6 = r(p)
				
			* treatment + treatment x widowed or no co-parent
			test _b[1.treatment] + _b[1.treatment#4.rel_status_BL]=0
			estadd scalar b1_b7 = r(p)
				
			* grab control means across BL marital status 
			sum `outcome' if e(sample) & treatment==0 & rel_status_BL==1
			estadd scalar cmean_div = r(mean)
			
			sum `outcome' if e(sample) & treatment==0 & rel_status_BL==2
			estadd scalar cmean_mar = r(mean)
			
			sum `outcome' if e(sample) & treatment==0 & rel_status_BL==3
			estadd scalar cmean_sing = r(mean)
	
			sum `outcome' if e(sample) & treatment==0 & rel_status_BL==4
			estadd scalar cmean_wid = r(mean)	
			
			* Q-values
			estadd scalar qval_b1 = qval_b1[`q',1]			// beta 1
			estadd scalar qval_b15 = qval_b15[`q',1]		// beta 1 + beta 5
			estadd scalar qval_b16 = qval_b16[`q',1]		// beta 1 + beta 6
			estadd scalar qval_b17 = qval_b17[`q',1]		// beta 1 + beta 7
			local q = `q' + 1

		}
		
		
		
	  			
 

		
* Write to latex
	* TABLE A
	
		* PANEL C - MARITAL STATUS
		esttab employed_w3_mar unemployed_w3_mar empl_jobsearch_w3_mar using ///
		"$output_rct/MHT_labor_multHTE_multHTE_TabAPanelC_`c(current_date)'.tex", ///
		label se nonotes nomtitles  ///
		nogaps nobaselevels nonotes keep(*treatment *rel_status_BL) ///
		drop(2.rel_status_BL 3.rel_status_BL 4.rel_status_BL) ///
		b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) ///	
		varlabels(1.treatment "$\beta\textsubscript{1}$: Treatment" ///
				  1.treatment#2.rel_status_BL "$\beta\textsubscript{5}$: Treatment x Married" ///
				  1.treatment#3.rel_status_BL "$\beta\textsubscript{6}$: Treatment x Never-married" ///
				  1.treatment#4.rel_status_BL "$\beta\textsubscript{7}$: Treatment x Widowed" ) ///
		fragment  replace noobs
		
		
		* Add N, control mean, and p-val for test that total effect is different from zero 
		esttab employed_w3_mar unemployed_w3_mar empl_jobsearch_w3_mar using ///
		"$output_rct/MHT_labor_multHTE_multHTE_TabAPanelC_`c(current_date)'.tex", ///
		append fragment nomtitles nonumbers noconstant noobs  nonotes  ///
		cells(none) stats(N cmean_div cmean_mar cmean_sing cmean_wid b1 qval_b1 ///
		b1_b5 qval_b15 b1_b6 qval_b16 b1_b7 qval_b17, ///
		labels("Observations" "Mean: Control, divorced" ///
		"Mean: Control, married" "Mean: Control, never-married" ///
		"Mean: Control, widowed" ///
		"P-value: $\beta\textsubscript{1}$ = 0" ///
		"FDR Q-value: $\beta\textsubscript{1}$ = 0" ///
		"P-value: $\beta\textsubscript{1}$ + $\beta\textsubscript{5}$ = 0" ///
		"FDR Q-value: $\beta\textsubscript{1}$ + $\beta\textsubscript{5}$ = 0" ///
		"P-value: $\beta\textsubscript{1}$ + $\beta\textsubscript{6}$ = 0" ///
		"FDR Q-value: $\beta\textsubscript{1}$ + $\beta\textsubscript{6}$ = 0" ///
		"P-value: $\beta\textsubscript{1}$ + $\beta\textsubscript{7}$ = 0" ///
		"FDR Q-value: $\beta\textsubscript{1}$ + $\beta\textsubscript{7}$ = 0") ///
		fmt(0 %9.3f %9.3f))

	

