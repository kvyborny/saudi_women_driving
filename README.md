Description:
This replication package cleans the raw data and produces the results included in the paper "Drivers of change: employment responses to the lifting of the Saudi female driving ban" (authors: Chaza Abou Daher, Erica Field, Kendal Swanson, and Kate Vyborny). 
Software used: Stata Version 18

Data: 
Baseline data and administrative data provided by Alnahda can be found in data/RCT admin and wave 1. Interim follow up data can be found in data/RCT wave 2. Main follow-up data can be found in data/RCT wave 3. Within each of the folders the Raw folder contains all raw data and Final folder contains analysis ready data. 
We also include publicly available data used to generate statistics as well as figures and tables in the paper. This includes: Global Findex Database 2021 (source: World Bank; found in data/Findex Saudi); Education and Training Survey 2017 (Source: Saudi Arabia GASTAT; found in data/Government admin data/education_and_training_surveyen_1.xlsx); and Labor Force Survey 2018 (source: Saudi Arabia GASTAT; found in data/Government admin data/gastat_lfp_levels.dta). 

Order of execution:
To run this replication package and generate the figures and tables found in the paper, please follow these steps:
1) Open <replication_code/settings_rep_package.do. On line 18 replace "[INSERT FILE PATH TO REP PACKAGE]" with the file path to where you have saved the <saudi_women_driving> replication package. Then run this file.
2) Open <replication_code/Master.do>. Run this file. <Master.do> will load all necessary Stata packages, load and prepare analysis ready data, and generate all figures and tables included in the paper. It will also run all robustness and statistics referred to in the paper.
3) Additionally, each do file in <replication_code> includes a preamble at the top describing what the code in the file does.
4) All results and log files generated from <Master.do> can be found in the results folder. Each result is saved as the figure or table number as it appears in the paper (e.g. "Tabel_1_Panel_A.tex" corresponds to Table 1, Panel A in the paper).
5) Results stored in <replication_code/tables/Robustness and stats referred to in paper> after running <replication_code/Master.do> include alternate versions of some tables as referenced in the text or table footnotes.
6) Log files from data cleaning and from the robustness section after running <replication_code/Master.do> will be saved in <results/log_files>.
