/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 		APPENDIX - 	First order beliefs and social contact; index and
							index components



Table footnotes: Column 1 in each panel is a weighted index of the standardized responses to the statements/questions reported under Index Components (Columns 2-7 in Panel A, Columns 2-3 in Panel B),
using the swindex command developed by Schwab et al. (2020). The command uses all available data (hence a higher N in Column 1) and assigns lower weight to index components with missing
values. Respondents were asked to rate their own level of agreement (using a 5 point Likert scale from completely disagree' to completely agree') for each statement in Panel A, Columns 2-5 and
7. All estimates include individual and household controls: age (above median dummy), education level (less than a highschool degree), marital status (indicators for married, never-married, and
widowed), household size (number of members), number of cars owned (indicators for one car and for more than one car), an indicator for baseline labor force participation, and randomization cohort
fixed effects. SEs are clustered at household level. We impute for missing control values and include missing dummies for each. Variations in sample size are due to drop-off from telephone survey;
order of survey modules was randomized. * p < 0.1 ** p < 0.05 *** p < 0.01

					   				
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
		
	global firstorder ga_1st_order_binary_sw G5_1_abovemed G7_1_abovemed ///
			G9_1_abovemed G1_1_abovemed G13_scale P1_3_abovemed
			
	global 	soccont social_contact_sw N1_cleaned N3_cleaned


* Run models	
		* Cohort FEs, PAP controls, baseline employment
		foreach var in $firstorder $soccont {		

			reghdfe `var' treatment  $controls , ///
			absorb(randomization_cohort2  )  vce(cluster file_nbr)
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

	* First order beliefs
	esttab $firstorder using ///
	"$output_rct/Gender Attitudes_1storder_swindex_cohortPAP_binary_`c(current_date)'.tex", ///
	label se scalars("cmean Control mean" "b_cmean $\beta$/control mean" "pval P-value $\beta = 0$") ///
	nonotes keep(*treatment) ///
	b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) ///	
	mtitles("\shortstack{Index: Own\\attitudes towards\\women working}" ///
		"\shortstack{Women can be\\equally good\\business\\executives}" ///
		"\shortstack{It's ok for\\a woman to\\have priorities\\outside the home}" ///
		"\shortstack{Children OK if\\mother works}" ///
		"\shortstack{Ok to put own\\needs above those\\of my family}" ///
		"\shortstack{Ideal age for\\a woman to have\\her first child}" ///
		"\shortstack{Government\\should allow\\a national\\women's soccer\\team}") ///
	mgroups("Index" "Index Components", pattern(1 1 0 0 0 0 0) ///
	prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	varwidth(75) modelwidth(15) fragment nobaselevels nogaps replace 
	
	* Social Contact
	esttab $soccont using ///
	"$output_rct/Social Contact Index Components_swindex_binary_cohortPAP_`c(current_date)'.tex", ///
	label se nonotes keep(*treatment) ///
	scalars("cmean Control mean" "b_cmean $\beta$/control mean" "pval P-value $\beta = 0$") ///
	b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) ///	
	mtitles("\shortstack{Social contact}" ///
		"\shortstack{Number of people\\spoken to on\\phone in past\\7 days}" ///
		"\shortstack{Number of\\different\\people met in\\person in past\\7 days}") ///
	mgroups("Index" ///
	"Index Components", pattern(1 1 0) ///
	prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	varwidth(75) modelwidth(15) fragment nobaselevels nogaps replace 
	
