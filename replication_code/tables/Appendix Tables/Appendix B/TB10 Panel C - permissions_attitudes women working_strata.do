/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 		APPENDIX TABLE - Ability to leave house, make purchases, and second
								order attitudes towards women working
	
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
	* likert/cts version
	global 	attitudes_soccont_bi G1_2_abovemed G1_3_abovemed ///
			ga2nd_fcom_binary_sw ga2nd_allmen_binary_sw
			
	
* Run models
	
		* (1) Strata FEs, PAP controls, baseline employment
		foreach var of global attitudes_soccont_bi {		

			reghdfe `var' treatment $controls, ///
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
	* (1)
	* Likert/cts version
	esttab $attitudes_soccont_bi using ///
	"$output_rct/Permissions_attitudes women working_sw_binary_strataPAP_`c(current_date)'.tex", ///
	label se nonotes keep(*treatment) ///
	scalars("cmean Control mean" "b_cmean $\beta$/control mean" "pval P-value $\beta = 0$") ///
	b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) ///	
	mtitles("\shortstack{Allowed to\\leave house\\w/o permission}" ///
		"\shortstack{Allowed to\\make purchase\\w/o permission}" ///
		"\shortstack{Female Social\\Network}" "\shortstack{Male Social\\Network}") ///
	mgroups("\shortstack{Agreement with the\\following statements}" ///
	"\shortstack{Indices: Second order attitudes\\towards women working}", pattern(1 0 1 0) ///
	prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	varwidth(75) modelwidth(15) fragment nobaselevels nogaps replace 






	

