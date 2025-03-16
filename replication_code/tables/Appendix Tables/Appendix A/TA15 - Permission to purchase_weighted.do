/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 		APPENDIX TABLE - Stacked: labor market outcomes and ability to 
								 spend without permission, weighted by BL 
								 age-edu and by BL employment status
			
Table footnotes: The outcome in column (4) indicates whether the respondent is employed and applied for at least one job in the previous
month (a more general measure of search beyond job applications was not collected for employed respondents). Results for
unemployment are similar if we redefine unemployed to include only those who applied for at least one job in the previous month.
In Panels B and C we re-estimate our results using survey weights to map to population estimates of education according to age
group (Panel B), and labor force participation (Panel C). We generate these weights using administrative data from GASTAT (2017)
and GASTAT (2018b), the latter is reported in Table A2. We use LFP, age, and education measured in our sample at baseline.
Variations in sample size are due to drop-off from telephone survey; order of survey modules was randomized. All estimates include
individual and household controls: age (above median dummy), education level (less than a highschool degree), marital status
(indicators for married, never-married, and widowed), household size (number of members), number of cars owned (indicators for
one car and for more than one car), an indicator for baseline labor force participation, and randomization cohort fixed effects. SEs
are clustered at household level. We impute for missing control values and include missing dummies for each. * p < 0.1 ** p <
0.05 *** p < 0.01.

********************************************************************************
********************************************************************************
*******************************************************************************/
eststo clear

* RUN THESE DO FILES FIRST:

	do "$rep_code/1 - Pull in data.do"
	do "$rep_code/2 - Setting regression controls.do"
	do "$rep_code/3 - Imputation for controls.do"
	
	
	
* Set global for table outcomes
	global 	spend  G1_3_abovemed

			
* Run models

	* (1) WEIGHTED
	local i = 1 	// store estimates according to weight order
	foreach weight in age_edu_weight emp_weight {
		
	
	global 	spend_wt`i'  G1_3_abovemed_wt`i'
		
		* Cohort FEs, PAP controls, baseline employment - weighted
		foreach var in  $spend {	

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
	foreach var in $spend {	

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
		
		* Write to latex			 
		esttab G1_3_abovemed G1_3_abovemed_wt1 G1_3_abovemed_wt2 using ///
		"$output_rct/Spend_cohortPAP_weighted_`c(current_date)'.tex", ///
		label se nonotes scalars("cmean Control mean" "b_cmean $\beta$/control mean"  "pval P-value $\beta = 0$") ///
		nobaselevels keep(treatment) nogaps  b(%9.3f) se(%9.3f) ///
		star(* 0.1 ** 0.05 *** 0.01) ///	
		mtitles( "\shortstack{Unweighted}" ///
		"\shortstack{Weight by education\\and age}" ///
		"\shortstack{Weighted by baseline\\labor force participation}") ///
		fragment varwidth(25) modelwidth(15) replace
