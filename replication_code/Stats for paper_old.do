*****************************************************************
* STATISTICS FOR PAPER
*****************************************************************


* Median survey length
use "$data/RCT wave 3/Cleaned/Combined_allwaves_fullwave3vars_cleaned.dta", clear
destring Durationinseconds, replace
sum Durationinseconds, detail
di 1742/60
// 29 min

* pull in data
	do "$github/paper_replication_RR/1 - Pull in data.do"
	
/* STATS FOR RESPONSE TO: "The interaction effect for husband/co-parent and its 
	impacts on being allowed to make a purchase without permission is almost 
	identical to the point estimate on if the individual is employed. You 
	interpret the former as evidence of men getting more strict, but another 
	interpretation could be that they were able to spend more before because it 
	was their own money from their job. I think it would be very helpful in 
	understanding this result if you could also provide information about how 
	these values changed from baseline to the follow up, in addition to the 
	differential change that you report." 
*/

	
	* Control group: share of working women able to spend
	tab G1_3_abovemed if employed_w3==1 & treatment==0
	// 50% able to spend
	
	* Control group: share of not working women able to spend
	tab G1_3_abovemed if employed_w3==0 & treatment==0
	// 48% able to spend
	
	* Full sample: share of working women not able to spend
	tab G1_3_abovemed if employed_w3==1 
	// 52% not able to spend
	
	* Control group: share of not working women able to spend
	tab G1_3_abovemed if employed_w3==0 & treatment==0
	// 48% able to spend
	
	* Full sample: share of not working women able to spend
	tab G1_3_abovemed if employed_w3==0 
	// 43%
	
	* Control group: women who completely disagree they can meet with a friend (leave house)
	tab G1_2_likert if treatment==0
	// 51%
	
	* Control group: women who completely disagree that they can make a purchase
	tab G1_3_likert if  treatment==0
	// 31% 
	
	* Control group: share of working women who completely or somewhat disagree that they can make a purchase
	tab G1_3_likert if  treatment==0 & employed_w3==1
	// 32% 
	
	
	
* Share of sample that owns more than one car
	tab mult_cars
	// 16.13%

* Share of respondents working at endline who report not being able to make purchase without permission
	tab G1_3_abovemed if employed_w3==1
	// 52.34% are below the median
	
	tab G1_3_likert if employed_w3==1 
	// 21.88% completely disagree, 25.78% completely or somewhat disagree
	
* Share of respondents not working at endline who report being able to make purchase without permission
	tab G1_3_abovemed if employed_w3==0
	// 42.61% above median
	
	tab G1_3_likert if employed_w3==0 
	// 42.61% completely agree, 55.68% somewhat or completely agree
	
* Share of employed women in control group who can/can't make purchasing decisions
	tab employed_w3 G1_3_abovemed if treatment==0, row
	// 50%	
	
* Share of not married women who live with other adults
	tab hh_more18_w if single==1
	// 98.6%
	
* Share of never-married women who live with other adults
	tab hh_more18_w if single==1
	
* Share of women who own more othan one car
tab cars
// 16.13 own 2+ cars

* Edu of widows compared to median 
tab edu_nohs_BL
tab edu_nohs_BL if widowed==1
	
/* 
	RESPONSE TO: "Regarding women's financial autonomy – this is a really 
	important point – but would it be possible to show that women in this sample, 
	including married women, do actually have their earnings going into separate 
	bank accounts?"
	
	SOURCE: PENDING
	[(World Bank, 2021) Global Findex: Surveys and data>Findex Saudi>micro_sau.dta
	does not include marital status]
*/
	
	
	use "$data/Findex Saudi/micro_sau.dta", clear
	
	* share of women with an account
	mean account [pweight=wgt] if female==1
	// 63.5% (matches report)

		mean account_fin [pweight=wgt] if female==1
		// same result

	
	* share of women in the workforce with an account
	mean account [pweight=wgt] if female==1 & emp_in==1
	// 74%
	
	
* pull in data
	do "$github/paper_replication_RR/1 - Pull in data.do"
	
	
* Share who received license, by treatment 
tab license_w3 if treatment==1
// 52.32%	
tab license_w3 if treatment==0
//10.2%	
* number of times left the house (control)
tab M4_1_TEXT if treatment==0
// bottom quartile left fewer than 3 times
// 100-65.71 = 34.29% left 6+ times

sum M4_1_TEXT if treatment==0, detail

* share of trips unaccompanied (control)
tab trips_unaccompanied_w3 if treatment==0
// 100-87.28=12.72% left unchaperoned more than 6 times

* share employed (control)
tab employed_w3 if treatment==0

* share unemployed (control)
tab unemployed_w3 if treatment==0

* share out of LF (control)
tab not_in_LF_w3 if treatment==0

* share employed at BL
tab employed_BL if treatment==0 & start_survey_w3==1

* Share of women who "agree" or "completely agree" that they can leave the house and make purchases
	* Can leave the house
	tab G1_2_likert if treatment==0
	di 8.74+24.04 		// These are the shares that agree and completely agree, respectively
	// 32.78%
	
	* Can make purchases
	tab G1_3_likert if treatment==0
	di 12.09+48.35		// These are the shares that agree and completely agree, respectively
	// 60.44%
	
* Share of employed women that disagree/strongly disagree that they can make a purchase 
	
	tab G1_3_likert if treatment==0 & employed_w3==1
	// 31.58% completely or somewhat disagree
	
	
* Avg BL income among those who were employed at BL
tab salary_BL_cat if employed_BL==1 
// median woman is in the 3000-4999 range

/*	share of median salary that the 1000 SAR purchase permission question would make up:
		- low end of salary range: 33%
		- high end of salary range: 20%
*/	

	* # of women in sample who report living with no other adults
	tab hh_more18
	// 587 total responses, 125 report living alone (hh_more18==1)
	
	* share of women reporting men they know agreeing/disagreeing with 
	* "ok for women to have priorities outside the home" and "ok for mothers 
	* to work"
		* Male Family
		tab G8_1_propor 
		* 59% disagreeing with "ok for women to have priorities outside home"
		tab G10_1_propor
		* 57% disagreeing with "ok to work"
		
		* Male social network
		tab G8_3_propor 
		* 58% of men disagreeing with "ok for women to have priorities outside home"
		tab G10_3_propor
		* 55% disagreeing with "ok to work"
		
	* # who took part in the drive training program
	tab s_train_bi
	
	* share of women enrolled with someone else from their household
	duplicates tag file_nbr, gen(mult_hh_mem)
		
		* mult_hh_mem == 0 means they're the only one from their HH
		tab mult_hh_mem
		// 356 or 58.8% of our sample of 606 are the only respondent from their HH, so 
		// 41.2% of our sample have at least one other HH member in the sample
		
	distinct file_nbr
	// 461 distinct households 
	
	di (461-356)/461
	//22.8% of households in our sample have more than one member included
	
* Share of control women who completely disagree that they can meet a friend without permission
tab G1_2_likert if treatment==0
// 51% completely disagree

* Share of control women who completely disagree that they can make a purchase without permission
tab G1_3_likert if treatment==0
// 31.3% completely disagree

	
*** OTHER STATS


	
	* mean age
	sum age_BL
	
	* cars per adult in the household
	gen cars_per_adult = cars/hh_more18
	sum cars_per_adult
	
	* share of households with at least 1 respondent
	duplicates tag file_nbr, gen(part_per_hh)
	tab part_per_hh
	* 41.25% come from households with more than 1 participant
	

	
* Checking details on Wusool (rideshare) subsidy
	* Wusool eligibility
	tab work_experience_BL
	count if work_experience_BL<=3 & work_experience_BL!=.
	* 451 out of 524 for whom we have responses

	di 451/524
	* 86.1%	

/*	* share that had NOT YET heard about the Wusool program already at BL
	count if inlist(Haveyouheardaboutthisprogra, "No", "no", "Not") & wusool_T==1
	// 141
*/	
		* find share by dividing # respondents who hadn't heard about it by # who responded
		di 141/288
		* .48958
	
* Take-up rates for driving treatment
	tab saudi_drive_training treatment
	* 83 started and failed/stopped and 172 completed. We have responses for 317 of the 375.

	di 172+83
	* 255

	di 255/317
	* .8044164

* Descriptive stats from control group
	* Take up rates in control
	tab saudi_drive_training if treatment==0
	// 9.94% and 9.36% completed or started, respectively
	di 9.94+9.36
	// 19.3%

	* Received license in control
	tab license_w3 if treatment==0
	// 10.18%

	* Share in control that drove in past month
	tab drive_any_mo_bi_w3 if treatment==0
	// 33.5%

	
	
	
	
* Share of Alnahda beneficiaries interested in driving/registering for training
use  "$data/RCT admin and wave 1/Data/Final/Wave1.dta", clear
	
tab wouldregister_less3000_BL if Institution=="Alanahda"
// 83.4%

do "$github/paper_replication_RR/1 - Pull in data.do"
	
* Sample stats for national comparison table
	* Employment
	tab ever_employed_BL if start_survey_w3==1
	// .393

	tab employed_BL if start_survey_w3==1
	// .185

	tab unemployed_BL if start_survey_w3==1
	// .652
	
	* Age (note that we are missing age for one person so denominator is 605)
	tab age_BL if start_survey_w3==1
	// 503 responses (this is our denominator)
	count if inrange(age_BL, 15,29) & start_survey_w3==1
	di 185/503
	// .368
	
	count if inrange(age_BL, 30,44) & start_survey_w3==1
	di 207/503
	// .412
	
	count if age_BL>=45 & age_BL!=. & start_survey_w3==1
	di 111/503
	// .221
	
	* Marital status
	tab rel_status_BL if start_survey_w3==1
	// Div/sep = .356 ; Marr = .202 ; single = .338 ; widow = .104
	
	* Education
	tab edu_category if start_survey_w3==1
	// 494 responses (this is our denominator)
/*	count if less_than_primary==1 & start_survey_w3==1
	di 30/494
	// .061
	
	count if elementary==1 & start_survey_w3==1
	di 147/494
	// .298
	
	count if highschool==1 & start_survey_w3==1
	di 168/494
	// .340
	
	count if education_diploma==1 & start_survey_w3==1
	di 75/494
	// .152
	
	count if (education_college==1 | education_masters==1) & start_survey_w3==1
	di 74/494
	// .150
*/	
	
* Balance table: N inconsistency in employment questions

preserve
	* merge into wave 1 orginal vars 
	keep 	participantid treatment start_survey_w3 ever_employed_BL work_experience_BL ///
			work_experience_cond_BL salary_BL_cat
	merge 	1:1 participantid using "$data/RCT admin and wave 1/Data/Final/Wave1.dta"
	
restore	

/*  * Ever employed
		tab ever_employed_BL randomization_cohort if start_survey_w3==1, m
		// 198 report ever working
		
		* Years experience conditional on ever working (Intotalhowmanyyearsdidyou and BD)
		tab Intotalhowmanyyearsdidyou randomization_cohort if start_survey_w3==1 & ever_employed_BL==1,m
		tab BD randomization_cohort if start_survey_w3==1 & ever_employed_BL==1,m
		// consistend across both that 11 didn't get the qn and 2 didn't respond

		* Check this against the var we combine those two in:
		tab work_experience_BL randomization_cohort if start_survey_w3==1 & ever_employed_BL==1,m
		// 11 didn't get the question and 2 didn't respond
		
		* now look at salary
		tab Whatisyourcurrentmonthlysal randomization_cohort if start_survey_w3==1 & ever_employed_BL==1,m
		// 11 didn't get the question, 10 didn't or refused to respond, 16 gave non-sensical responses
		* Check this against the cleaned version of the var:
		tab salary_BL_cat randomization_cohort if start_survey_w3==1 & ever_employed_BL==1,m
		
		
	* Number of treated women who took up training
	tab saudidrive_w2 if treatment==1,m
*/	
	
	
*** SAMPLE CREATION
use  "$data/RCT admin and wave 1/Data/Final/Wave1.dta", clear

	* distribution across orgs
	tab Institution
	// 186 from Insaan
	// 82 from Mawaddah
	
	tab Institution Exclusion,m
	// 140 included in the final RCT sample from Insaan (47  were dropped)
	// 76 included in the final RCT sample from Mawaddah (6  were dropped)
	// This comes out to 216 included from the other orgs
	// 2+45+1+5 = 52 excluded from Insaan/Mawaddah
	
	
	* create var for interest in registering for driving training
/*	* would register for training if it were less 3000 SAR
	gen wouldregister_less3000_BL = يقولونأنالتكاليفيمكنأنتصلا 
	replace wouldregister_less3000_BL = "1" if wouldregister_less3000_BL=="نعم" ///
		| wouldregister_less3000_BL=="0" | wouldregister_less3000_BL== ///
		"أفضل عدم الإجابة على هذا السؤال"
	replace wouldregister_less3000_BL = "0" if wouldregister_less3000_BL== "لا"
	lab var wouldregister_less3000_BL "Would register for training if it was <3000 SAR"
	destring wouldregister_less3000_BL, replace
*/	// NOTES: We made this unconditional - '0's were coded to yes, because they had previously
	// said they were interested in the training. 

	* sample creation among AlNahda beneficiaries
	preserve
	
	keep if Institution=="Alanahda"
	tab Exclusion,m
	di 794-178
	// 178 graduates, so we start with a full sample of 616 from AlNahda
	
	* drop the graduates
	drop if Exclusion=="1.1.B"
	
	* registered before BL
	tab drivingschool_register2 Exclusion,m
	// 55 who already registered 
	
	* not interested in registering, even if price was <3000 SAR
	
	
	tab wouldregister_less3000_BL Exclusion, m
	// 95 who weren't interested even if cost was reduced
	
	* other no baseline/non-eligible
	tab Exclusion,m
	di 222-55-95
	
	* number of households
	bysort file_nbr: gen hhcount = 1 if _n ==1
	count if hhcount==1
	// 381 distinct households
	
	restore
	
	
	* Insan
	preserve
	
	keep if Institution=="Insan"
	tab Exclusion,m
	// 2 didn't answer the call
	
	* registered before BL
	tab drivingschool_register2 Exclusion,m
	// 32 who already registered

	tab wouldregister_less3000_BL Exclusion, m

	tab Exclusion,m
	// 12 others excluded
	
	restore
	
	
	* Mawaddah
	preserve
	
	keep if Institution=="Mawaddah"
	tab Exclusion,m
	// 1 didn't answer the call
	
	* registered before BL
	tab drivingschool_register2 Exclusion,m
	// 5 who already registered

	tab wouldregister_less3000_BL Exclusion, m

	tab Exclusion,m
	// 12 others excluded
	
	restore
	
	
	
	
	
	
	
	
	* sample creation from full sample (all orgs)
	* registered before BL
	tab drivingschool_register2 Exclusion,m
	// 96 already registered, 93 were excluded
	
	* share of original sample excluded because they had already registered:
	di 93/1062
	// 8.76%
	
	* not interested in registering, even if price was <3000 SAR
	tab يقولونأنالتكاليفيمكنأنتصلا Exclusion, m
	// 98 excluded under "No baseline/non-eligible" and 7 excluded for being a graduate
	* likelihood of driving
	tab  driving_likely_likert_BL Excluded,m
	// 92 reporting unlikely and were excluded (47 not excluded)
	di 92/1062
	// 8.66% excluded because of disinterest
	
	

	* merge in full baseline data
	rename participantid new_id 
	merge 1:1 new_id using ///
	"$data/RCT admin and wave 1/Data/Exclusion_sheet.dta"
	drop _merge


	* excluded grads of AlNahda (exclusion reason 1.1.B)
	count if Exclusion=="1.1.B" 

	/* NOTES: We start with 1,062. 456 are excluded for the following reasons:
	
	   - 1 for reason 1.1.A (respondent didn't consent to participate the first 
	   few attempts and was not included in the randomization, they were then called
	   and completed the baseline but wasn't entered into the randomization)
	   - 178 for reason # 1.1.B (explanation: EXCLUDE ALL GRADUATES FROM THE RCT 
	   SAMPLE AS WE DETERMINED GRADUATION WOULD NOT BE AFFECTED BY TREATMENT 
	   STATUS.)
	    - 5 for reason 1.1.C (they didn't answer the call but did not know their 
	   treatment status beforehand)
	   - 272 due to "no baseline or non-eligible"
	   
	   This leaves us with 606.	
	   
	   (Using the "Timeline by cohort" doc - https://docs.google.com/spreadsheets/d/1rlWdSUJWndSvKlSo890RyEyRNQoRcR1CHajdRd-buhQ/edit#gid=0)
	*/
	
	/* let's tag observations that we have accounted for as being excluded for \
	   non-interest or having already registered for driving training */
	   gen exclude_account = 1 if (drivingschool_register2=="Yes, I registered" | ///
	   يقولونأنالتكاليفيمكنأنتصلا=="لا") & Exclusion=="No baseline/non-eligible"
	   lab var exclude_account "Excluded for being already registered or no interest regargless of cost"
	   
	   tab driving_likely_likert_BL Exclusion if exclude_account!=1
	   // doesn't look like likelihood of driving is explaining any of the other
	   // "No baseline/non-eligible" observations
	 
	 * Let's look at the final categorization of exclusions
	 tab Exclusion exclude_account,m
	 
	 
	/* ADDITIONAL NOTES:
	
	- We have a "universe" of 884
	- 89 are excluded for having already registered for the driving training
	- 98 are excluded for not being interested, even if the price of the course
	  was less than SAR 3000
	- 6 are excluded for non-response/non-consent
	- leaving 85 excluded under "No baseline/non-eligible"; unable to pin down 
	  further at this point
	
	*/

* Wave 2: Conditional on working, # trips taken yesterday for work
use  "$data/RCT wave 2/Data/cleaned_wave2_dataset_full.dta", clear

forval i=1/10 {
	gen trip`i'_work = 0 if trip`i'_purpose!=""
	replace trip`i'_work = 1 if trip`i'_purpose=="(Work/School Commute) - Work commute"
}

egen tripsyest_work_emp_w2 = rowtotal(trip1_work trip2_work trip3_work trip4_work ///
trip5_work trip6_work trip7_work trip8_work trip9_work trip10_work)	
* move to missing if trip diaries are missing
replace tripsyest_work_emp_w2 = . if trip1_work==. & trip2_work==. & trip3_work==. ///
& trip4_work==. & trip5_work==. & trip6_work==. & trip7_work==. & trip8_work==. ///
& trip9_work==. & trip10_work==. 
* now replace with 0 if no trips were taken yesterday
replace tripsyest_work_emp_w2 = 0 if tripnb_yesterday==0
* move to missing if not employed
replace tripsyest_work_emp_w2=. if currentlyemployed!=1
lab var tripsyest_work_emp_w2 "Number of trips to work yesterday | employed"
* let's flag women who were asked about trips during a week day
generate surveydate = string(startdate, "%td")
tab surveydate
gen weekday_trips_w2 = 1 if inlist(surveydate, "12nov2019", "02jan2020", "03jan2020", ///
"22jan2020", "23jan2020", "29jan2022", "30jan2020", "03feb2020", "13feb2020")
replace weekday_trips_w2 = 1 if inlist(surveydate, "17feb2020", "18feb2020", "19feb2020", "20feb2020", "24feb2020", "25feb2020")
replace weekday_trips_w2 = 1 if inlist(surveydate, ///
"26feb2020", "27feb2020", "02mar2020", "03mar2020", "02apr2020", "03apr2020")
replace weekday_trips_w2 = 1 if inlist(surveydate,  ///
"02jun2020", "03aug2020", "02sep2020", "02oct2020", "02nov2020", "02dec2020")

* Mean of work trips taken yesterday cond. on 'yesterday' being a week day (Sun-Thurs)
sum tripsyest_work_emp_w2 if weekday_trips_w2==1
// mean = .575, sd = .522
	
	
* HH EMPLOYMENT STATUS IN ALNAHDA COVID SURVEY
use "$data/RCT wave 3/Final/Wave 3 and AlNahda COVID survey.dta", clear

// data set is wide (employment var for each member) - start by creating a single
// employment indicator for the household

forval i = 1/10 {
	gen employed`i' = 1 if empl`i'=="Working"
	replace employed`i' = 0 if inlist(empl`i', "Housewife", ///
	"Not working, and looking for work", "Not working, and not looking for work", ///
	"Student", "Unable to work/impaired")
	
	gen person`i' = 1 if empl`i'!=""
}

egen hh_adults = rownonmiss(person1 person2 person3 person4 person5 person6 person7 ///
person8 person9 person10)

egen working_adults = rowtotal(employed1 employed2 employed3 employed4 employed5 ///
employed6 employed7 employed8 employed9 employed10)
replace working_adults=. if empl1=="" & empl2=="" & empl3=="" & empl4=="" & ///
empl5=="" & empl6=="" & empl7=="" & empl8=="" & empl9=="" & empl10==""

gen share_working_adults = working_adults/hh_adults
replace share_working_adults = 0 if working_adults==0 & inlist(hh_adults, 0,.)

sum share_working_adults

* let's look at sector for respondent
tab sector1 employed1, col
// ~18% are in gov sector (compared to 61% in 2016 nat'l est), ~45% are in priv 
// sector (compared to 28% in nat'l est). None are self-employeed (compared to 
// 5% of nat'l est)
/* source: https://www.moh.gov.sa/en/Ministry/Statistics/Population-Health-Indicators/
Documents/World-Health-Survey-Saudi-Arabia.pdf. */

// now let's look at industry (note we only have sector data for members 1-7)
forval i = 1/7 {

	gen sector`i'_gov = 0 if sector`i'!="" | sector`i'!="Not applicable"
	replace sector`i'_gov = 1 if sector`i'== "Government Sector"
	replace sector`i'_gov = . if employed`i' == 0
	lab var sector`i'_gov "Person `i' in HH works in gov sector | working"
	

	gen sector`i'_hh = 0 if sector`i'!="" | sector`i'!="Not applicable"
	replace sector`i'_hh = 1 if sector`i'== "Household sector"
	replace sector`i'_hh = . if employed`i' == 0
	lab var sector`i'_hh "Person `i' in HH works in HH sector | working"
	
	gen sector`i'_nonprof = 0 if sector`i'!="" | sector`i'!="Not applicable"
	replace sector`i'_nonprof = 1 if sector`i'== "Non-profit organizations"
	replace sector`i'_nonprof = . if employed`i' == 0
	lab var sector`i'_nonprof "Person `i' in HH works in non-profit sector | working"
	
	gen sector`i'_bus = 0 if sector`i'!="" | sector`i'!="Not applicable"
	replace sector`i'_bus = 1 if sector`i'== "Private Business Sector"
	replace sector`i'_bus = . if employed`i' == 0
	lab var sector`i'_bus "Person `i' in HH works in private business sector | working"
	
	gen sector`i'_self = 0 if sector`i'!="" | sector`i'!="Not applicable"
	replace sector`i'_self = 1 if sector`i'== "Self-employed, no workers"
	replace sector`i'_self = . if employed`i' == 0
	lab var sector`i'_self "Person `i' in HH is self-employed | working"
	
	gen sector`i'_state = 0 if sector`i'!="" | sector`i'!="Not applicable"
	replace sector`i'_state = 1 if sector`i'== "State-owned enterprises"
	replace sector`i'_state = . if employed`i' == 0
	lab var sector`i'_state "Person `i' in HH works in state-owned enterprise | working"

	gen sector`i'_other = 0 if sector`i'!="" | sector`i'!="Not applicable"
	replace sector`i'_other = 1 if sector`i'== "Other, please specify:"
	replace sector`i'_other = . if employed`i' == 0
	lab var sector`i'_other "Person `i' in HH works in other category | working"
}

global sec gov hh nonprof bus self state other

foreach sec of global sec {
	egen hh_sector_`sec' = rowtotal(sector1_`sec' sector2_`sec' sector3_`sec' ///
	sector4_`sec' sector5_`sec' sector6_`sec' sector7_`sec')
	replace hh_sector_`sec' = . if sector1_`sec'==. & sector2_`sec'==. & ///
	sector3_`sec'==. & sector4_`sec'==. & sector5_`sec'==. & sector6_`sec'==. & ///
	sector7_`sec'==. 
}


/*
* BASELINE STATS TO COMPARE TO NATIONAL DATA
* pull in data
	do "$github/paper_replication_RR/1 - Pull in data.do"

* labor force participation
tab LF_BL
* 83.97% in LF, much higher than national rate of 22% in 2018 (27% in 2019)
* source:  https://data.worldbank.org/indicator/SL.TLF.CACT.FE.ZS?locations=SA

* look at employed and unemployed
tab LF_BL employed_BL, row
// ~78% are unemployed. This is much higher than the national est of 20.9% in 2018
// (source: https://data.worldbank.org/indicator/SL.UEM.TOTL.FE.NE.ZS?locations=SA)



/* source used for following stats:
GASTAT (saved in Surveys and data>Government admin data>Employment, unemployment, LFP rates 2017-2022_notes.xlsx)
*/


	tab employed_BL
	// ~19% are employed. GASTAT gives an avg for 2018 of 68.6. When we multiply 
	// this by the 2018 avg for LFP, 19.7, we get: .686*.197=.1351. Thus we have 
	// women in our sample more likely to be employed relative to the Saudi avg.

	tab ever_employed_BL
	// ~62% have never been employed, which is a little higher than the 2016 est of 57%

	sum unemployed_BL 
	// .651 relative to .062 (GASTAT - see "Employment, unemployment, LFP rates 2017-2022.xlsx")
	// to get to 31.4 we take the avg unemployment rate of Saudi women across all 2018 quarters
	// we have an avg LFP for Saudi women in 2018 of 19.7, therefore unempl is .197*.314 = .062
	
/* source used for following stats:
https://www.moh.gov.sa/en/Ministry/Statistics/Population-Health-Indicators/
Documents/World-Health-Survey-Saudi-Arabia.pdf
*/ 

	* education
	tab edu_category
	// ~33% attended secondary school, this is only slightly less than the 2016 est 
	// of 35%. ~14% went went to college or grad school, which is much lower than the 
	// 37% from 2016 estimate (although if we include vocational,  this becomes ~30%)

	tab edu_category employed_BL, col

	* marital status
	replace relationship_status_BL = "" if relationship_status_BL=="Prefer not to answer"
	tab relationship_status_BL
	// we have ~36% single (can we assume this means never married though?), which is 
	// higher than the 22% national est in 2016. ~19% are married, much lower than 
	// 67% national est. ~35% are divorced or separated, relative to the 12% est of
	// "formerly married" in nat'l sample.

	tab relationship_status_BL employed_BL, row
	// ~12% of single women are employed (compared to 18% of national sample), 30% of 
	// married are employed (compared to 22% of national sample), and 23% of sep/div
	// are employed (compared to ~37% of national sample)

	* age
	sum age
	
	* create age bins 
	gen agebin = 1 if age>=15 & age<=29
	replace agebin = 2 if age>=30 & age<=44
	replace agebin = 3 if age>=45 & age!=.
	lab def age 1 "15-29" 2 "30-44" 3 "45+"
	lab val agebin age
	
	tab agebin
	// 39% are age 15-29 (only slightly smaller than nat'l est of 42%), 39% are
	// age 30-44 (nearly the same as nat'l est of 38%). 21% are 45-59 (higher than
	// the nat'l est of 14%). <1.5% are above 60 (compared to ~6% nationally)

	tab ever_employed_BL agebin, col
	tab employed_BL agebin, col

	* combine divorced/sep and widow
	gen marital_cat3 = relationship_status_BL
	replace marital_cat3 = "formerly married" if inlist(relationship_status_BL, ///
	"Divorced/seperated", "Widowed")
	tab ever_employed_BL marital_cat3, col
	tab employed_BL marital_cat3, col 
	
	* houehold size
	tab household_size
	sum household_size
	// HH size is ~6.3, a bit higher than 2010 census avg of 6.
	/* Source: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4174546/. */
	// WHS Saudi suggests just 3.7... (34,903 sample size with 9,339 HHs)
	
	
// The source used above differs from The 2016 Demographic Survey in Saudi
// https://www.stats.gov.sa/sites/default/files/en-demographic-research-2016_7.pdf


* Education level
tab edu_category
// 0.621 have gone to high school or higher, similar to 0.648 among nat'l sample who
// have completed highschool. (Note this stat doesn't map directly as our data includes
// those who have at least some high school whereas nat'l sample is for completion.)
// Source: https://data.worldbank.org/indicator/SE.SEC.CUAT.LO.FE.ZS?locations=SA

*/







	
	





	
	
	
	
	
	