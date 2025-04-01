/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 		Master replication file for Saudi commute project 
				
********************************************************************************
********************************************************************************
*******************************************************************************/
cap log close


*** FIRST, SET UP AND RUN SETTINGS.DO IN MAIN FOLDER


* Install necessary packages
local install = 0

if `install' == 1 {
ssc install 		swindex
ssc install 		reghdfe
ssc install 		ihstrans
ssc install 		winsor2
ssc install			outreg2
ssc install			grc1leg
ssc install			scto
ssc install			ietoolkit

}



* Run cleaning files

	* Log the process
	log using "$logs/Data cleaning_`c(current_date)'.smcl", replace

	set 	seed 20190228
	set 	sortseed 20190228
	
	do		"$rep_code/cleaning/Wave 1 cleaning.do"
	do		"$rep_code/cleaning/Wave 2 cleaning.do"
	do 		"$rep_code/cleaning/Wave 1 & 2 merge.do"
	do		"$rep_code/cleaning/Wave 3 cleaning.do"
	do 		"$rep_code/cleaning/Weighting.do"
	
	log close

* Run tables and figures in the order in which they appear in paper

	* Main tables
	do		"$rep_code/tables/Main Tables/T1 PanelsAB - driving_mobility_labor_ind decision.do"
	do		"$rep_code/tables/Main Tables/T1 PanelC - Permissions_attitudes women working.do"
	do 		"$rep_code/tables/Main Tables/T2_T3 - Lic_employed_ability to purchase_multiple HTE.do"
	
	
	* Appendix figures
	// 		Figure A1: Timeline was created outside of stata
	do 		"$rep_code/figures/Appendix Figures/FA2 - 2nd order beliefs bar chart.do"
	do 		"$rep_code/figures/Appendix Figures/FA3 - Bar chart_treatment effects on trips without male chaperone.do"
	do 		"$rep_code/figures/Appendix Figures/FA4 - Bar Chart_treatment effects on travel freq.do"
	do 		"$rep_code/figures/Appendix Figures/FA5 - Saudi LFP graph.do"
	

	
	* Appendix A tables 
	//		Table A1: Legal rights of women by marital status was created outside of stata
	/*		Table A2: Comparison of experimental sample and pop. rep. stats was created 
					  outside of stata. See "$rep_code/Stats for paper.do" 
					  for generation of sample stats. 	*/
	do		"$rep_code/tables/Appendix tables/Appendix A/TA3 - Balance across arms among responders.do"	
	do 		"$rep_code/tables/Appendix tables/Appendix A/TA4 - Balance across arms_full sample.do"	
	do 		"$rep_code/tables/Appendix tables/Appendix A/TA5 - descriptive stats on wave 2 travel patterns in control group.do"
	do 		"$rep_code/tables/Appendix tables/Appendix A/TA6 - Attrition table with and without controls.do"
	do 		"$rep_code/tables/Appendix tables/Appendix A/TA7-TA8 - Attrition_multipleHTE.do"
	do 		"$rep_code/tables/Appendix tables/Appendix A/TA9 Panels A B - driv_mob_lab_inddec_nocontrols_nostrata_lee.do"
	do 		"$rep_code/tables/Appendix tables/Appendix A/TA9 Panel C - permissions_attitudes_nocontrols_nostrata_lee.do"
	do 		"$rep_code/tables/Appendix tables/Appendix A/TA10 Panels AB - driving_mobility_labor_ind decision_nocontrols.do"
	do 		"$rep_code/tables/Appendix tables/Appendix A/TA10 Panel C - permissions_attitudes women working_nocontrols.do"
	do 		"$rep_code/tables/Appendix tables/Appendix A/TA11 - labor_outcomes_weighted_age-edu_emp.do"
	do 		"$rep_code/tables/Appendix tables/Appendix A/TA12 - First order beliefs_soccont_swindex.do"			
	do 		"$rep_code/tables/Appendix tables/Appendix A/TA13 - Approval of gender policy.do"
	do 		"$rep_code/tables/Appendix tables/Appendix A/TA14 - Civic Engagement.do"
	do 		"$rep_code/tables/Appendix tables/Appendix A/TA15 - Permission to purchase_weighted.do"
	do 		"$rep_code/tables/Appendix tables/Appendix A/TA16 - 2nd order gender attitudes_swindex_binary.do"
	do 		"$rep_code/tables/Appendix tables/Appendix A/TA17 - Employed_HTE marital robustness to treatment interactions with BL characteristics.do"



	
	* Appendix B tables
	/*		"$rep_code/tables/Appendix tables/Appendix B/Anderson_2008_fdr_sharpened_qvalues.do" generates 
			FDR corrected q-values for Tables B1-B6; it will run as part of the Table do files below	*/
	do 		"$rep_code/tables/Appendix tables/Appendix B/TB1 - MHT_emp_unemp_empsearch.do"
	do 		"$rep_code/tables/Appendix tables/Appendix B/TB2 Panels AB_TB3 Panel B - MHT_emp_unemp_empsearch_HTE_age_edu_LF.do"
	do 		"$rep_code/tables/Appendix tables/Appendix B/TB2 Panel C - MHT_emp_unemp_empsearch_HTE_marital.do"
	do 		"$rep_code/tables/Appendix tables/Appendix B/TB3 Panel A - MHT_emp_unemp_empsearch_HTE_husbcopar.do"
	do 		"$rep_code/tables/Appendix tables/Appendix B/TB4 - MHT_mob and spending control.do"
	do 		"$rep_code/tables/Appendix tables/Appendix B/TB5 Panels A B_TB6 Panel B - MHT_mob and spending control_HTE_age_edu_LF.do"
	do 		"$rep_code/tables/Appendix tables/Appendix B/TB5 Panel C - MHT_mob and spending control_HTE_marital.do"
	do 		"$rep_code/tables/Appendix tables/Appendix B/TB6 Panel A - MHT_mob and spending control_HTE_husbcopar.do"
	do 		"$rep_code/tables/Appendix tables/Appendix B/TB7 - PAP_training_lic_commute_mobility.do"
	do 		"$rep_code/tables/Appendix tables/Appendix B/TB8 - PAP_job search.do"
	do 		"$rep_code/tables/Appendix tables/Appendix B/TB9 - wusool interaction_stacked_training_mobility_LFP.do"
	do 		"$rep_code/tables/Appendix tables/Appendix B/TB10 Panels A B - driving_mobility_labor_ind decision_strata.do"
	do 		"$rep_code/tables/Appendix tables/Appendix B/TB10 Panel C - permissions_attitudes women working_strata.do"
	

	* Robustness / results referenced in text
	do 		"$rep_code/Stats_for_paper.do"	// Stats referred to in text
	do 		"$rep_code/tables/Robustness referred to in paper/BL char and diff attrition.do"
	do 		"$rep_code/tables/Robustness referred to in paper/Alt Table 1_altunemp.do"
	do 		"$rep_code/tables/Robustness referred to in paper/Alt Table A11_altunemp.do"
	do 		"$rep_code/tables/Robustness referred to in paper/Alt Table A17 - Employed_treatment interactions_marital dummies.do"
	

	
	
	
	

	






