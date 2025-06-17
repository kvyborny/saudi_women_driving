Description:
The code in this replication package cleans and produces the analysis files for four data sources: primary data collected by our Riyadh-based partners at Alnahda (baseline, administrative data provided by Alnahda at baseline, interim follow-up, and main follow-up) and three secondary sources (Global Findex Database 2021; Saudi Education and Training Survey 2017; and Saudi Labor Force Survey 2018). The analysis files produce the 30 tables (3 main exhibits and 27 appendix) and 5 appendix figures included in the paper, "Drivers of change: employment responses to the lifting of the Saudi female driving ban" (authors: Chaza Abou Daher, Erica Field, Kendal Swanson, and Kate Vyborny). 
Software used: Stata Version 18

Data and Data Availability Statements: 
Our primary survey data were collected by our field partners at Alnahda. Data were collected at baseline (and merged with administrative records at Alnahda), during an interim follow up, and during a main followup.
- Baseline data (which includes administrative data provided by Alnahda) can be found in "data/RCT admin and wave 1". The raw data file is "data/RCT admin and wave 1/Raw/deidentified commute dataset-20191017". An exclusion sheet (data/RCT admin and wave 1/Raw/Exclusion Sheet.xlsx) indicates baseline respondents who met inclusion/exclusion criteria and were included in the study. This Exclusion Sheet is used in the cleaning code to remove respondents not included in the study. The cleaned baseline data file is "data/RCT admin and wave 1/Final/Wave1.dta".
- Interim follow up data can be found in data/RCT wave 2. The raw data file is "data/RCT wave 2/Raw/Commute Wave 2 round 1-raw-deidentified/xlsx". The cleaned interim follow up data file is "data/RCT wave 2/Final/Wave2.dta". This file gets merged with the cleaned baseline data file; this merged version is "data/RCT wave 2/Final/Combined_waves1and2_final.dta".
- The raw data files for the main follow-up can be found in "data/RCT wave 3/Raw". The cleaned data file is merged with the cleaned data files from baseline and the interim follow up, and it is this merged file that is used in analysis. This analysis data file can be found in "data/RCT wave 3/Final/Combined_allwaves_final.dta".

Please note: Raw data files included IP addresses and neighborhoods of work and residence. We remove these in case they could be used to partially identify households. Removal of these potentially identifying variables was done manually across datasets except for the IP Addresses, which was done using <replication_code/cleaning/Anonymize IP address in link data_Wave 3.do> as the IDs were used as a measure the number of different individuals that clicked on a link to information about a leadership program (as part of the main follow up).

We also include in this replication package publicly available data that we used to generate statistics as well as figures and tables in the paper. This includes: 
- Global Findex Database 2021 (source: World Bank; found in "data/Findex Saudi/micro_sau.dta"). 
- Education and Training Survey 2017 (Source: Saudi Arabia GASTAT; found in "data/Government admin data/education_and_training_surveyen_1.xlsx")
- Labor Force Survey 2018 (source: Saudi Arabia GASTAT; found in "data/Government admin data/gastat_lfp_levels.dta").

Rights: //
-[x] I certify that the authors of the manuscript have legitiment access to and permission to use the data used in this manuscript.
All data are publicly available.

Details on each data source:
| Data Name | Data file(s) | Location | Citation |
|---|:---:| :---:| :--- |
| "Drivers of Change Survey Data" | Combined_allwaves_final.dta | data/RCT wave 3/Final/Combined_allwaves_final.dta | Drivers of Change (2025) |
| "Global Findex Database 2021" | micro_sau.dta | data/Findex Saudi/ | World Bank (2021) |
| "Education and Training Survey 2017" | education_and_training_surveyen_1.xlsx | data/Government admin data/ | Saudi Arabia GASTAT (2017) |
| "Labor Force Survey 2018" | gastat_lfp_levels.dta | data/Government admin data/ | Saudi Arabia GASTAT (2018) |

Dataset list:
| Data File | Source | Notes | Provided |
|---|:---:| :---:| :--- |
| data/RCT admin and wave 1/Raw/deidentified commute dataset-20191017 | Drivers of Change (2025) | Raw baseline data | Yes |
| data/RCT admin and wave 1/Raw/Exclusion sheet.xlsx (.dta) | Drivers of Change (2025) | Provides indicator for baseline respondents included in the study | Yes |
| data/RCT admin and wave 1/Final/Wave1.dta | Drivers of Change (2025) | Cleaned (Final) baseline data | Yes |
| data/RCT wave 1/Raw/Commute Wave 2 round 1-raw-deidentified.xlsx | Drivers of Change (2025) | Raw interim follow up data | Yes |
| data/RCT wave 1/Raw/block randomizer.xlsx | Drivers of Change (2025) | Provides randomized survey block order for interim follow up data | Yes |
| data/RCT wave 1/Cleaned/block randomizer.dta | Drivers of Change (2025) | Cleaned randomized survey block order for interim follow up data | Yes |
| data/RCT wave 1/Cleaned/Wave2_raw.dta | Drivers of Change (2025) | Raw interim follow up data, removing duplicate observations | Yes |
| data/RCT wave 1/Cleaned/cleaned_wave2_dataset_full.dta | Drivers of Change (2025) | Cleaned interim follow up data | Yes |
| data/RCT wave 1/Final/Wave2.dta | Drivers of Change (2025) | Cleaned (final) interim follow up data | Yes |
| data/RCT wave 1/Final/Combined_waves1and2_final.dta | Drivers of Change (2025) | Cleaned (final) interim follow up data merged with cleaned (final) baseline data | Yes |
| data/RCT wave 3/Raw/Wave 3 - High Freq 1_redownload with module randomizer info_August 26, 2022.xlsx | Drivers of Change (2025) | Raw main follow up (longer survey version) after rephrasing question on pace of societal change | Yes |
| data/RCT wave 3/Raw/Wave 3 new wording survey - Raw.dta | Drivers of Change (2025) | Raw main follow up (longer survey version), formatted for Stata | Yes |
| data/RCT wave 3/Raw/Wave 3 - High Freq 1_pre wording change for govt progress.xlsx | Drivers of Change (2025) | Raw main follow up (longer survey version), pre-rephrasing question on pace of societal change | Yes |
| data/RCT wave 3/Raw/Wave 3 full survey - Raw.dta | Drivers of Change (2025) | Combined raw data for main follow up, with some missing respondent IDs | Yes |
| data/RCT wave 3/Raw/Wave 3 IDs for missing respondents_5Oct2022.xlsx | Drivers of Change (2025) | Respondent IDs merged into main follow up data (excel version)  | Yes |
| data/RCT wave 3/Raw/Wave 3 IDs for missing respondents_5Oct2022.dta | Drivers of Change (2025) | Respondent IDs merged into main follow up data (Stata version)  | Yes |
| data/RCT wave 3/Raw/Wave 3 - Limited Version_October 4, 2022_08.36.xlsx | Drivers of Change (2025) | Raw data from shortened main follow up survey | Yes |
| data/RCT wave 3/Raw/Wave 3 - combined full and lim survey.dta | Drivers of Change (2025) | Combined raw data for main follow up  | Yes |
| data/RCT wave 3/Raw/Qudra Follow-up_September 21, 2022_14.47.xlsx | Drivers of Change (2025) | Volunteer program (Qudra) data for main follow up  | Yes |
| data/RCT wave 3/Data for survey embedding/Feb 2022 Limited Survey/Wave_3__Limited_Version-Distribution_History_AlNahda survey links_27Feb2022.csv | Drivers of Change (2025) | Respondent IDs merged into main follow up data  | Yes |
| data/RCT wave 3/Cleaned/Wave3_combinedrawdata.dta | Drivers of Change (2025) | Raw main follow up data, cleaned to be merged with baseline and interim follow up data | Yes |
| data/RCT wave 3/Cleaned/Wave3raw_mergedwaves1and2.dta | Drivers of Change (2025) | Raw main follow up data merged with baseline and interim follow up data | Yes |
| data/RCT wave 3/Cleaned/Combined_allwaves_fullwave3vars_cleaned.dta | Drivers of Change (2025) | Cleaned survey data (baseline, interim, and main follow up merged) | Yes |
| data/RCT wave 3/Final/Combined_allwaves_final.dta | Drivers of Change (2025) | Cleaned (final) survey data file - used in analysis for paper | Yes |
| data/Government admin data/gastat_lfp_levels.dta | Saudi Arabia GASTAT (2018) | Data from Saudi Labor Force Survey 2018 | Yes |
| data/Government admin data/education_and_training_surveyen_1.xlsx | Saudi Arabia GASTAT (2017) | Data from Saudi Education and Training Survey 2017 | Yes |
| data/Findex Saudi/micro_sau.dta | World Bank (2021) | Data from Findex | Yes |

Software requirements:
Stata (code was last run with version 18)
- swindex
- reghdfe
- ihstrans
- winsor2
- outreg2
- grc1leg
- scto
- ietoolkit
- blindschemes
- texdoc
- estout
- The program "replication_code/Master.do" will (in addition to running all data cleaning and analysis files for results in the paper) install necessary user-written packages


Order of execution:
To run this replication package and generate the figures and tables found in the paper, please follow these steps:
1) Open <replication_code/settings_rep_package.do. On line 18 replace "[INSERT FILE PATH TO REP PACKAGE]" with the file path to where you have saved the <saudi_women_driving> replication package. Then run this file.
2) Open <replication_code/Master.do>. Run this file. <Master.do> will load all necessary Stata packages, load and prepare analysis ready data, and generate all figures and tables included in the paper. It will also run all robustness and statistics referred to in the paper. The run time for this file (and the accompanying do files that will run automatically as part of it) takes approximately 5 minutes.
3) Additionally, each do file in <replication_code> includes a preamble at the top describing what the code in the file does.
4) All results and log files generated from <Master.do> can be found in the results folder. Each result is saved as the figure or table number as it appears in the paper (e.g. "Tabel_1_Panel_A.tex" corresponds to Table 1, Panel A in the paper).
5) Results stored in <replication_code/tables/Robustness and stats referred to in paper> after running <replication_code/Master.do> include alternate versions of some tables as referenced in the text or table footnotes.
6) Log files from data cleaning and from the robustness section after running <replication_code/Master.do> will be saved in <results/log_files>.


