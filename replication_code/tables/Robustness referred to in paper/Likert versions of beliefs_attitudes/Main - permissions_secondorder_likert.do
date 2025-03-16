/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 		MAIN - 		Ability to leave the house, Ability to make 
							purchases, Attitudes towards women working 
							(female and male social networks). Main result 
							specifications




Table footnotes: Variations in sample size are due to drop-off from telephone survey; order of survey modules was randomized. The outcomes in Columns 1 and 2 are constructed as follows:
respondents were asked to rate their level of agreement (using a 5 point Likert scale from `completely disagree' to `completely agree') with the statements "If I wanted to meet with a
friend outside of my home, I could do so without seeking approval / permission from anyone in my household first" and "I can make a purchase of 1000 SAR without needing to take
permission from any member of my family" (1000 SAR is roughly equivalent to 265 USD, in 2021 dollars), respectively. The outcome variables are indicators for above-median response
on the Likert scale for each statement response. The social network attitudes indices in Columns 3 and 4 were constructed as follows: respondents were asked to think about each group
(male family members, male members of social network, or female members of social network) and report what share of that group they think would `somewhat' or `completely' agree
with the statements reported in Columns 2-4 in Table A10. The outcomes shown here are weighted indices of the standardized responses to each statement using the swindex command
developed by Schwab et al. (2020). Column 4 combines statements about male family members and male members of social network into a single index. All estimates include individual
and household controls: age (above median dummy), education level (less than a highschool degree), marital status (indicators for married, never-married, and widowed), household size
(number of members), number of cars owned (indicators for one car and for more than one car), an indicator for baseline labor force participation, and randomization cohort fixed effects.
SEs are clustered at household level. We impute for missing control values and include missing dummies for each. * p < 0.1 ** p < 0.05 *** p < 0.01

					   				
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
	global 	permission_attitudes G1_2_likert G1_3_likert ///
			ga2nd_fcom_likert_sw ga2nd_allmen_likert_sw
			

* Run models	
		* Cohort FEs, PAP controls, baseline employment
		foreach var in $permission_attitudes {		

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


	esttab $permission_attitudes using ///
	"$output_rct/robustness/Permissions_attitudes women working_swindex_likert_cohortPAP_v2_`c(current_date)'.tex", ///
	label se nonotes keep(*treatment) ///
	scalars("cmean Control mean" "b_cmean $\beta$/control mean" "pval P-value $\beta = 0$") ///
	b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) ///	
	mtitles("\shortstack{Allowed to leave\\the house without\\permission}" ///
		"\shortstack{Allowed to make\\purchase without\\permission}" ///
		"\shortstack{Female Social\\Network}" "\shortstack{Male Social\\Network}") ///
	mgroups("Agreement with the following statements" ///
	"\shortstack{Indices: Second order attitudes\\towards women working}", pattern(1 0 1 0) ///
	prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	varwidth(75) modelwidth(15) fragment nobaselevels nogaps replace 
	
