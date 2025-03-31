/*******************************************************************************
********************************************************************************
********************************************************************************

Purpose: 		Settings for Saudi commute project 
				
********************************************************************************
********************************************************************************
*******************************************************************************/

	* Root folder globals 
		
	if "`c(username)'" == "pc" {
	
		global 		github "C:/Users/pc/Documents/GitHub/saudi_female_commute"
		global 		dropbox "C:/Users/pc/OneDrive/Female_Transport_Riyadh"
		global 		onedrive "C:/Users/pc/OneDrive/Female_Transport_Riyadh"		
		global 		data "$dropbox/Surveys and data"
		global 		results "$dropbox/Results"
		global		box "$dropbox" 


	}
		

	
		if "`c(username)'" == "Kendal" | "`c(username)'" == "kendalswanson" {
		global 		mainfolder "/Users/kendalswanson/OneDrive - Duke University/saudi_women_driving"
		global 		output "/Users/kendalswanson/OneDrive - Duke University/saudi_women_driving/results"
	}
	
	

		
	
********************************************************************************
* Subfolder globals 
********************************************************************************/


global rep_code "$mainfolder/replication_code"
global data "$mainfolder/data"
global output_descr "$output/descriptive"
global output_rct "$output/RCT/tables"
global logs "$output/log_files"
