/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 		ROBUSTNESS -	Labor market outcomes, own attitudes, social contact.
								Unemployed redefined to include only those who
								applied for at least one job in the previous
								month
				
Table footnotes: This table is an alternate version of Table 2 in the paper, where
unemployed is redefined to include only those who applied for at least one job in the previous
month. The outcome in column (4) indicates whether the respondent is employed and applied for at least one job in the previous
month (a more general measure of search beyond job applications was not collected for employed respondents). The outcomes in Columns 5 and 6 were constructed as follows: respondents were asked to rate their own level of
agreement (using a 5 point Likert scale from `completely disagree' to `completely agree') for each of the statements in Panel A,
Columns 2-5 and 7 of Table A9 . Respondents were also asked about the number of people the spoke to on the phone and met
with in the previous 7 days (Panel B, Columns 2-3 of Table A9). Weighted indices of the standardized responses to each set
of questions, respectively, were generated using the swindex command developed by Schwab et al. (2020). Variations in sample
size are due to drop-off from telephone survey; order of survey modules was randomized. All estimates include individual and
household controls: age (above median dummy), education level (less than a highschool degree), marital status (indicators for
married, never-married, and widowed), household size (number of members), number of cars owned (indicators for one car and
for more than one car), an indicator for baseline labor force participation, and randomization cohort fixed effects. SEs are
clustered at household level. We impute for missing control values and include missing dummies for each. * p < 0.1 ** p <
0.05 *** p < 0.01.


********************************************************************************
********************************************************************************
********************************************************************************/
eststo clear

* RUN THESE DO FILES FIRST:

	do "$rep_code/1 - Pull in data.do"
	do "$rep_code/2 - Setting regression controls.do"
	do "$rep_code/3 - Imputation for controls.do"
	
	
* shorten var name for storage
	
	rename social_contact_binary_sw soc_cont_bi_sw
	
* Set global for table outcomes
			
	global 	lab employed_w3 unempl_jobsearch_w3 not_in_LF_w3 ///
			empl_jobsearch_w3 ga_1st_order_likert_sw social_contact_sw
			

* Run models

	*  Cohort FEs, PAP controls, baseline employment
		foreach var in  $lab {	

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
		 
		* Economic and financial agency
		esttab $lab using ///
		"$output_rct/robustness/LFP_ind dec_cohortPAP_likert_altunemp_`c(current_date)'.tex", ///
		label se nonotes scalars("cmean Control mean" "b_cmean $\beta$/control mean"  "pval P-value $\beta = 0$") ///
		nobaselevels keep(treatment) nogaps  b(%9.3f) se(%9.3f) ///
		star(* 0.1 ** 0.05 *** 0.01) ///	
		mtitles( "\shortstack{Employed}" ///
		"\shortstack{Unemployed\\and applied for\\at least one job}" ///
		"\shortstack{Out of\\labor force}" ///
		"\shortstack{On the job\\search}" ///
		"\shortstack{Index: Own\\attitudes towards\\women working}" ///
		"\shortstack{Index: Social\\contact}") ///
		fragment varwidth(25) modelwidth(15) replace
		