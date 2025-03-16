/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 		APPENDIX TABLE - PAP -  training, license, expected commute, 
										mobility. Expected likelihood of driving
										in the future is maintained as likert


Table footnotes: The outcome in Panel A, Column 6 was constructed as follows: respondents who reported not driving in the previous month were asked ``will you drive in the future? How likely are you to drive?" with a Likert response scale. This was also coded as `likely' if the respondent reported driving in the previous month. All outcomes reported in this table were collected during the interim follow-up.  Variations in sample size are due to drop-off from telephone survey. All estimates include individual and household controls: age (above median dummy), education level (less than a highschool degree), marital status (indicators for married, never-married, and widowed), household size (number of members), number of cars owned (indicators for one car and for more than one car), an indicator for baseline labor force participation, and 
 randomization cohort fixed effects. SEs are clustered at household level. We impute for missing control values and include missing dummies for each. * p $<$ 0.1 ** p $<$ 0.05 *** p $<$ 0.01
				
********************************************************************************
********************************************************************************
********************************************************************************/
eststo clear

* RUN THESE DO FILES FIRST:

	do "$rep_code/1 - Pull in data.do"
	do "$rep_code/2 - Setting regression controls.do"
	do "$rep_code/3 - Imputation for controls.do"

	
	
* shorten var name to fit storage requirements
	rename expectcomm_ehai_amount_tr_w2 expect_comm

* outcomes global
global pap_mob saudidrive_w2 license_w2 expect_comm drive_lastm_w2 drive_month_w2 ///
	future_drive_w2 

			
			
		foreach var of global pap_mob {		
			reghdfe `var' driving_T##wusool_T $controls, ///
			absorb(group_strata)  vce(cluster file_nbr)
			eststo `var'_1

			* grab control mean
			sum `var' if e(sample) & treatment==0
			estadd scalar cmean = r(mean)	
		}
		



* Write to latex
	esttab saudidrive_w2_1 license_w2_1 expect_comm_1 drive_lastm_w2_1 ///
	drive_month_w2_1 future_drive_w2_1  using ///
	"$output_rct/robustness/PAP_w2_mobility1_strataPAP_likert_`c(current_date)'.tex", ///
	label se scalars(N "cmean Control Group Mean" ) nogaps nobaselevels ///
	keep( *wusool_T *driving_T) b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) ///	
	mtitles("\shortstack{Started driver's\\training}" ///
	"\shortstack{Received\\license}" ///
	"\shortstack{Expected cost\\of commute\\on e-hailing\\including any\\discount}" ///
	"\shortstack{Drove in the\\previous month}" ///
	"\shortstack{Driving frequency:\\estimated number\\of trips per\\month}" ///
	"\shortstack{Expected\\likelihood of\\driving in the\\future}") ///
	coeflabels(1.driving_T "$\beta\textsubscript{1}$: Driving training" 1.wusool_T "$\beta\textsubscript{2}$: Rideshare subsidy" ///
	1.driving_T#1.wusool_T "$\beta\textsubscript{3}$: Driving training x Rideshare subsidy") ///
	replace nonotes fragment modelwidth(15)


	
	