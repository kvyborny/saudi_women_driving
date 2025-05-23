/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 	Robustness	 - 	Alternate Table A16; second order gender attitudes;
							Likert version


Table footnotes: Alternate version of Table A16, where we use the full likert 
scale to generate the index outcome. Second order belief outcomes were constructed 
as follows: respondents were asked to think about each group (male family members, 
male members of social network, or female members of social network) and report 
what share of that group they think would `somewhat' or `completely' agree with 
the statement, which are reported in Columns 2-4 of each panel. The outcome in 
Column 1 of each panel is a weighted index of the standardized responses to each 
statement using the swindex command developed by Schwab et al. (2020). The command 
uses all available data (hence a higher N in Column 1) and assigns lower weight 
to index components with missing values. Variations in sample size among Columns 
2-4 are due to drop-off from telephone survey; order of survey modules was randomized. 
All estimates include individual and household controls: age (above median dummy), 
education level (less than a high school degree), marital status (indicators for 
married, never-married, and widowed), household size (number of members), number 
of cars owned (indicators for one car and for more than one car), an indicator for 
baseline labor force participation, and strata fixed effects. SEs are clustered 
at household level. We replace missing control values with 0 and include missing 
dummies for each. * p < 0.1 ** p < 0.05 *** p < 0.01
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
	global secondorder_full ga2nd_fcom_likert_sw G6_2_propor G8_2_propor G10_2_propor ///
							ga2nd_mfam_likert_sw G6_1_propor G8_1_propor G10_1_propor ///
							ga2nd_mcom_likert_sw G6_3_propor G8_3_propor G10_3_propor




* Run models
		
		* (1) Cohort FEs, baseline employment, PAP controls
		foreach var of global secondorder_full {		

			reghdfe `var' treatment $controls, ///
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
	* Female (Panel A)
		esttab ga2nd_fcom_likert_sw G6_2_propor G8_2_propor G10_2_propor  /// 
			using "$output_rct/robustness/Alt_Table_A16_Panel_A_Likert.tex", ///
			posthead("\midrule \multicolumn{1}{@{}l}{\textbf{Panel A: Female Social Network}} \\ \midrule") ///
			label se scalars("cmean Control mean" "b_cmean $\beta$/control mean" "pval P-value $\beta = 0$") ///
			nonotes keep(treatment) ///
			b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) ///	
			mtitles("\shortstack{Index: Second\\order attitudes\\towards women\\working}" ///
			"\shortstack{Women can be\\equally good\\business\\executives}" ///	
			"\shortstack{It's ok for\\a woman to\\have priorities\\outside the\\home}" ///
			"\shortstack{Children OK if\\mother works}") ///
			mgroups("Index" "Index Components", pattern(1 1 0 0) ///
			prefix(\multicolumn{@span}{c}{) suffix(})   ///
			span erepeat(\cmidrule(lr){@span})) varwidth(25) modelwidth(15) fragment  ///
			nogaps nobaselevels replace

		
	* Male Family (Panel B)
		esttab  ga2nd_mfam_likert_sw G6_1_propor G8_1_propor G10_1_propor /// 
			using "$output_rct/robustness/Alt_Table_A16_Panel_B_Likert.tex", ///
			posthead("\multicolumn{1}{@{}l}{\textbf{Panel B: Male Family}} \\ \midrule") ///
			label se scalars("cmean Control mean" "b_cmean $\beta$/control mean" "pval P-value $\beta = 0$") ///
			nonotes keep(treatment) ///
			b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) nogaps nobaselevels ///	
			nomtitles nonum varwidth(25) modelwidth(15) fragment nolines prefoot(\midrule) replace 

		 
	* Male community (Panel C)
		esttab ga2nd_mcom_likert_sw G6_3_propor G8_3_propor G10_3_propor /// 
			using "$output_rct/robustness/Alt_Table_A16_Panel_C_Likert.tex", ///
			posthead("\multicolumn{1}{@{}l}{\textbf{Panel C: Male Social Network}} \\ \midrule") ///
			label se scalars("cmean Control mean" "b_cmean $\beta$/control mean" "pval P-value $\beta = 0$") ///
			nonotes keep(treatment) ///
			b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) nogaps nobaselevels ///	
			nomtitles nonum varwidth(25) modelwidth(15) fragment nolines prefoot(\midrule) replace  
			

