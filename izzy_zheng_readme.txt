This readme explains the following files, which were made to analyze fishing in the Chesapeake Bay and how fishing consumption relates to historically vulnerable groups:
1. making_buffer_zip.qmd (Ches Bay EJ > Programs) 
2. making_trip_catch_2022.qmd (Ches Bay EJ > Programs)
3. 2022_visualizations - subsistence_buffer.qmd (Ches Bay EJ > Programs)
4. making_trip_catch_2022_piv_acs.qmd (Ches Bay EJ > Programs)
5. 2022_summstat.qmd (Ches Bay EJ > Figures)
6. correlation_tables.qmd (Ches Bay EJ > Figures)
7. tentative_regressions.qmd (Ches Bay EJ > Programs)

1. making_buffer_zip.qmd (Ches Bay EJ > Programs) 
Function: Creates an sf object called buffer_zip that includes all zip codes within a 100 mile radius of the nearest sitepoint and stores it in data > intermediate_datasets. Also creates active_sites, an sf object that contains all active CB fishing sites. It also contains a map of all fishing zip codes that send fishers to the Chesapeake overlaid with the buffer_zip zips and the Chesapeake Bay watershed boundary, for context of what zip codes are being filtered into the dataset. 
Inputs: Census shapefile data from https://www2.census.gov/geo/tiger/TIGER2020/ZCTA520/ - data > zipcodes > tl_2020_us_zcta520.shp, NOAA's public fishing access site database - data > NOAA MRF> Public Fishing Access Site Register > SITE.csv. For the map, it also uses trip_catch_2022.RData, which is made using making_intermediate_datasets.qmd, and the Chesapeake Bay watershed boundary - data > watershed boundary > Chesapeake_Bay_Watershed_Boundary.shp.
Use in other files: buffer_zip is used in making_trip_catch_2022.qmd and 2022_visualizations - subsistence_buffer.qmd, active_sites used in 2022_visualizations - subsistence_buffer.qmd

2. making_trip_catch_2022.qmd (Ches Bay EJ > Programs)
Function: This file creates trip_catch_2022, a good dataset to use for mapping aggregate fish data across species. It is at the trip ID-species level, which means there is one data observation for every species in every interview. trip_catch_2022 is made by joining all of the trip and catch data from 2022 in the APAIS survey, and then filtering to just zip codes in buffer_zip. 
Inputs: NOAA APAIS survey data - all catch.csv and trip.csv files in data > NOAA MRF, buffer_zip from making_buffer_zip.qmd
Use in other files: trip_catch_2022 used in 2022_visualizations - subsistence_buffer.qmd (Ches Bay EJ > Programs)

3. 2022_visualizations - subsistence_buffer.qmd (Ches Bay EJ > Programs)
Function: Wrangles trip_catch_2022 into a zip code level dataset. Makes maps and graphs of number of claim, percentage eaten of total catch, total weight, number of trips. Also creates some bivariate maps that show percentage of families who speak a non-English language at home against percentage eaten of total catch. 
Inputs: trip_catch_2022 from making_trip_catch_2022.qmd, buffer_zip from making_buffer_zip.qmd, active_sites from making_buffer_zip.qmd, 
Use in other files: None

4. making_trip_catch_2022_piv_acs.qmd (Ches Bay EJ > Programs)
Function: Creates acs_economic_cleaner, acs_imm_cleaner, and acs_race_cleaner, which are the cleaned zip code level ACS variable datasets. Creates trip_catch_2022_piv_acs, which is for running regressions. trip_catch_2022_piv_acs is made by pivoting the trip_catch_2022 data to be at trip ID level, meaning 1 observation per interview (which can correspond to multiple fishermen). It is then joined with the cleaned ACS datasets. The finished dataset trip_catch_2022_piv_acs is trip-level data that has ACS EJ variables.  
Inputs: trip_catch_2022 from making_trip_catch_2022.qmd, ACS zip code level data (one download URL is https://data.census.gov/table?g=040XX00US09$8600000,10$8600000,11$8600000,24$8600000,34$8600000,36$8600000,37$8600000,42$8600000,51$8600000,54$8600000&d=ACS+5-Year+Estimates+Data+Profiles&tid=ACSDP5Y2021.DP02) - ACSDP5Y2021.DP03-Data.csv from data > acs_data > acs_economic, ACSDP5Y2021.DP02-Data.csv from data > acs_data > acs_imm, ACSDP5Y2021.DP05-Data.csv from data > acs_data > acs_race, 
Use in other files: trip_catch_2022_piv_acs used in tentative_regressions.qmd (Ches Bay EJ > Programs), 2022_sum mstat.qmd (Ches Bay EJ > Figures), correlation_tables.qmd (Ches Bay EJ > Figures)

5. 2022_summstat.qmd (Ches Bay EJ > Figures)
Function: Creates summary statistic tables/frequency tables of all regression variables in trip_catch_2022_piv_acs. When changing some code back from being commented out, you can also see the nonregression variable statistics. Can be rendered somewhat easily. 
Inputs: trip_catch_2022_piv_acs from making_trip_catch_2022_piv_acs
Use in other files: none
	
6. correlation_tables.qmd (Ches Bay EJ > Figures)
Function: Creates correlation table of all EJ variables
Inputs: trip_catch_2022_piv_acs from making_trip_catch_2022_piv_acs
Use in other files: none

7. tentative_regressions.qmd (Ches Bay EJ > Programs)
Function: runs preliminary regressions to see if there are relationships between EJ variables and percentage of fish eaten. 
Inputs: trip_catch_2022_piv_acs from making_trip_catch_2022_piv_acs
Use in other files: none

