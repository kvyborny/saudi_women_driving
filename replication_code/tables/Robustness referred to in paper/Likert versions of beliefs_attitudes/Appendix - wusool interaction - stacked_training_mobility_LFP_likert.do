/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 		APPENDIX TABLE - Wusool/Uber interaction - stacked: LFP, own
									attitudes, social contact, permissions, 
									second order attitudes; likert version
				
				
Table footnotes: Outcome variables are constructed as described in the notes for Tables 1 - 3. Variations in sample size are due to drop-off from telephone survey; order of survey modules was randomized.
All estimates include individual and household controls: age (above median dummy), education level (less than a highschool degree), marital status (indicators for married, never-married, and
widowed), household size (number of members), number of cars owned (indicators for one car and for more than one car), an indicator for baseline labor force participation, and randomization
cohort fixed effects. SEs are clustered at household level. We impute for missing control values and include missing dummies for each. * p < 0.1 ** p < 0.05 *** p < 0.01

********************************************************************************
********************************************************************************
********************************************************************************/
eststo clear

* RUN THESE DO FILES FIRST:

	do "$rep_code/1 - Pull in data.do"
	do "$rep_code/2 - Setting regression controls.do"
	do "$rep_code/3 - Imputation for controls.do"

keep if endline_start_w3==1
	
	
* shorten var name for storage
	rename share_trips_unaccomp_w3 share_unaccomp
	
	
* Set global for table outcomes
			
	global 	lab employed_w3  unemployed_w3 not_in_LF_w3 ///
			empl_jobsearch_w3 ga_1st_order_likert_sw social_contact_sw
			
	global 	permission_attitudes G1_2_likert G1_3_likert ///
			ga2nd_fcom_likert_sw ga2nd_allmen_likert_sw

* relabel original treatment vars for clarity in tables 
lab var driving_T "Driving training"
lab var wusool_T "Wusool subsidy"
	
		
	* Run models
	foreach var in $lab $permission_attitudes {		

		reghdfe `var' driving_T##wusool_T $controls, ///
		absorb(randomization_cohort2)  vce(cluster file_nbr)
		eststo `var'

		test _b[1.driving_T] + _b[1.driving_T#1.wusool_T] = 0
		estadd scalar b1_b3_0 = r(p)
	
		test _b[1.wusool_T] + _b[1.driving_T#1.wusool_T] = 0
		estadd scalar b2_b3_0 = r(p)

		* grab control mean
		sum `var' if e(sample) & treat==0
		estadd scalar cmean = r(mean)	
		}
			
 

* Write to latex	

	esttab $lab using ///
		"$output_rct/robustness/Interact_Labor force participation_likert_`c(current_date)'.tex", ///
		label se nonotes scalars("cmean Control Group Mean" ///
		"b1_b3_0 P-val: $\beta\textsubscript{1}$ + $\beta\textsubscript{3}$ = 0" ///
		"b2_b3_0 P-val: $\beta\textsubscript{2}$ + $\beta\textsubscript{3}$ = 0" ) ///
		nogaps nobaselevels nonotes keep(*wusool_T *driving_T) ///
		b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) ///	
		mtitles("\shortstack{Employed}" ///
				"\shortstack{Unemployed}" ///
				"\shortstack{Out of\\labor force}" ///
				"\shortstack{On the job\\search}" ///
				"\shortstack{Index: Own\\attitudes towards\\women working}" ///
				"\shortstack{Index: Social\\contact}") ///
		varlabels(1.driving_T "$\beta\textsubscript{1}$: Driving training" ///
		1.wusool_T "$\beta\textsubscript{2}$: Rideshare subsidy" ///
		1.driving_T#1.wusool_T "$\beta\textsubscript{3}$: Driving training x Rideshare subsidy") ///
		fragment varwidth(25) modelwidth(15) replace
		
		esttab $permission_attitudes using ///
	"$output_rct/robustness/Interact_permissions_attitudes women working_likert_`c(current_date)'.tex", ///
	label se nonotes keep( *wusool_T *driving_T) ///
	scalars("cmean Control Group Mean" ///
		 "b1_b3_0 P-val: $\beta\textsubscript{1}$ + $\beta\textsubscript{3}$ = 0" ///
		 "b2_b3_0 P-val: $\beta\textsubscript{2}$ + $\beta\textsubscript{3}$ = 0" ) ///
	b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) ///	
	mtitles("\shortstack{Allowed to leave\\the house without\\permission}" ///
		"\shortstack{Allowed to make\\purchase without\\permission}" ///
		"\shortstack{Female Social\\Network}" "\shortstack{Male Social\\Network}") ///
	mgroups("Agreement with the following statements" ///
	"\shortstack{Indices: Second order attitudes\\towards women working}", pattern(1 0 1 0) ///
	prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	varwidth(75) modelwidth(15) fragment nobaselevels nogaps replace 
		
		