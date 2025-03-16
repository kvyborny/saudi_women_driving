/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 		Imputation for regression control variables (moving missings to 0)
				
********************************************************************************
********************************************************************************
********************************************************************************/


// NOTES: We will replace missing values for control variables with the sample mean
// We have no missing values for: employed_BL edu_category married cars
// Missing 2 from BLsearch, causing missing for unemployed_BL
// Missing 1 from age (and age_4group)
// Missing 80 from household_size
// Missing 4 from marital group



* age (PAP version)
gen miss_age_PAP = 0
replace miss_age_PAP = 1 if age_4group==.
lab var miss_age_PAP "Missing value for age (PAP version)"

replace age_4group_BL = 0 if age_4group_BL==.


* household_size
gen miss_household_size = 0
replace miss_household_size = 1 if household_size==.
lab var miss_household_size "Missing value for household_size"

replace household_size = 0 if household_size==.


* Cars

	* create one missing tag(since missing for the same people)
	gen miss_cars = 0
	replace miss_cars = 1 if cars==.
	lab var miss_cars "Missing value for cars"
	
	* dummy for one car
	replace one_car = 0 if one_car==.

	* dummy for 2+ cars
	replace mult_cars = 0 if mult_cars==.

	
	
* Relationship status (updated categories)

	* create one missing tag (since missing for the same people)
	gen miss_relationship	= 0
	replace miss_relationship = 1 if rel_status_BL==.
	lab var miss_relationship "Missing value for relationship status"
	
	
	* married
	replace married = 0 if married==.


	* divorced/separated
	replace divorced_separated = 0 if divorced_separated==.


	* single
	replace single = 0 if single==.


	* widowed
	replace widowed = 0 if widowed==.
	

	
* unemployed_BL
gen miss_unemployed_BL = 0 
replace miss_unemployed_BL = 1 if unemployed_BL==.
lab var miss_unemployed_BL "Missing value for unemployed_BL"

replace unemployed_BL = 0 if unemployed_BL==.


* edu_category
gen miss_edu_category = 0 
replace miss_edu_category = 1 if edu_category==.
lab var miss_edu_category "Missing value for edu_category"

replace edu_category = 0 if edu_category==.



