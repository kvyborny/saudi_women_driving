/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 		Controls for regressions (where missings have been moved to 0)
				
********************************************************************************
********************************************************************************
********************************************************************************/

// NOTE: 	DECISION TO BE MADE ON WHETHER TO UPDATE MARITAL STATUS CONTROLS TO MATCH
//			NEW CATEGORIES FOR HTE

* 	Main models

global 	controls_orig i.age_4group_BL miss_age_PAP i.edu_category_BL miss_edu_category ///
		married single widowed miss_relationship household_size ///
		miss_household_size one_car mult_cars miss_cars employed_BL ///
		unemployed_BL miss_unemployed 
		
* HTE with 'has husband/co-parent' (drops marital status dummies)

global 	controls_HTE_orig i.age_4group_BL miss_age_PAP i.edu_category_BL miss_edu_category ///
		household_size miss_household_size one_car mult_cars miss_cars employed_BL ///
		unemployed_BL miss_unemployed  
		
		
		
	
		






