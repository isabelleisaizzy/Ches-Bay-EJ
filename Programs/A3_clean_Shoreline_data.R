# Title: A3_clean_Shoreline_data.R
# Created: 09/14/22
# Created by: Patrick Walsh, US EPA/NCEE. walsh.patrick.j@epa.gov
# Purpose: Import and clean the shoreline data from VIMS.
#          Currently the MD data is stored in different shapefiles for each
#         MD county, whereas the VA data is all in one file.
#         Need to get into one file and prepare for analysis.
# VIMS data can be found at:
#     https://www.vims.edu/ccrm/research/inventory/index.php
#
# Clear Workspace
rm(list = ls())
# Load Libraries
library(tidyverse)
library(sf)
library(mapview)
library(here)
library(dplyr)
library(ggplot2)
library(gmodels)
# Set directory
data_path <- here('data') #relative path to the data folder
#

# Write a program to import and combine the different files.
# first get a list of all the sstru files stored in the MD sstru folder
# Shit. Going to have to do this in two parts, since the 2020 updated files have
#   Different f'ing variables than the earlier counterparts.
file_list2020 <- list.files(path=file.path('data\\Shoreline\\MDsstruFiles'), pattern = "2020.shp$", full.names = TRUE)
sf_list2020 <- lapply(file_list2020, st_read)
# Note how bind_rows is used here since it is a clusterfuck of different columns
#   across the different datasets.
MDsstru2020 <- do.call(bind_rows, sf_list2020)
# Clean some of the columns
# In Dorcester, lgth_miles=length.
# In Anne Arundel, miles matches manual measurements. Not sure what length_mil is
MDsstru2020 <- MDsstru2020 %>%
  mutate(structure = coalesce(Structures,Structure,STRUCTURES),
         LgthMi = coalesce(miles,lgth_miles,Lgth_miles)) %>%
  mutate(LgthMr = LgthMi*1609.34,
         YearAssessed = 2020, State = 'MD') %>%
  select(-Structures,-Structure,-STRUCTURES,-length_mil,-miles,
         -lgth_miles,-Lgth_miles,-length,-Inventory,-Imagery,-Id)

# Now for the older files.
file_list_old <- list.files(path=file.path('data\\Shoreline\\MDsstruFiles'), pattern = "sstru.shp$", full.names = TRUE)
sf_list_old <- lapply(file_list_old, st_read)
MDsstru_old <- do.call(bind_rows, sf_list_old)
# Clean up the columns
# LENGTH is Meters in stmco, wicom, wor, som, kent, balt, carmd, cecil
# SHAPE_Leng: pg, qa, har, char
MDsstru_old <- MDsstru_old %>%
  mutate(structure = coalesce(structure,STRUCTURE),
         LgthMr = coalesce(LENGTH,SHAPE_Leng,Shape_Leng)) %>%
  mutate(LgthMi = LgthMr*0.000621371,
         YearAssessed = 2006, County = county, State = 'MD') %>%
  select(-LENGTH,-SHAPE_Leng,-Shape_Leng,-STRUCTURE,-WICOM_SSTR,-WICOM_SSTR.1,-LPOLY_,-RPOLY_,
         -FNODE_,-TNODE_,-remote,-REMOTE,-GPS_DATE,-county)

# Now stick them on top of each other.
MDsstru = rbind(MDsstru_old,MDsstru2020 )
# mapview(MDsstru)
# Now export for GIS:
st_write(MDsstru, here(file.path('data\\Shoreline'),"MD_SSTRU.shp" ),append=FALSE)

# bring in va data
VAsstru <- st_read(here(file.path('data/Shoreline'),"VA_sstru_2006_2019_utm18.shp"))
# To combine MD and VA sstru data, first need to clean Va data
VAsstru <- VAsstru %>%
  rename(structure = STRUCTURE,
         County = COUNTY,
         YearAssessed = INVENTORY,
         LgthMr = Shape_Leng) %>%
  mutate(LgthMi = LgthMr*0.000621371,
         State = 'VA') %>%
  select(-Field_Date,-SURVEYED,-PubYear,-SHORELINE,-FIPS,-FIPSCode,-REMOTE,-GPS_Date)
# Now stack them
CBsstru <- rbind(MDsstru,VAsstru)
# Do some cleaning of the structure variable. Several different versions of each entry
# with(CBsstru, CrossTable(structure))
BW <- c("breakwater")
BH <- c("bulkhead")
Deb <- c("Debri", "debris")
Deb2 <- c("Debriss")
DB <- c("dilapidated bulkead", "Dilapidated Bulkead", "dilapidated bulkhead",  "Dilapidated bulkhead")
Gr <- c("groin field",  "Groin Field", "Groinfield", "Groins")
Gr2 <- c("groin")
Jet <- c(" jetty",  "Jetty")
Mar <- c("marina < 50 slips",  "Marina < 50 slips",  "marina <50 slips", "Marina <50 slips",
         "marina > 50 slips", "Marina > 50 slips",  "marina >50 slips", "Marina >50 slips", "Marina <50 slips",
         "marina > 50 slips", "Marina > 50 slips", "marina >50 slips",  "Marina >50 slips", "marina, <50 slips","marina, >50 slips")
Mar2 <- c("marina")
Marsh <- c("Marsh Toe Revetment")
Marsh2 <- c("marsh toe")
RR <- c("riprap")
Un <- c("Unconventional")
Wha <- c("wharf")
BWsub <-paste(BW , collapse="|")
BHsub <-paste(BH , collapse="|")
Debsub <-paste(Deb, collapse="|")
Debsub2 <-paste(Deb2, collapse="|")
DBsub <-paste(DB , collapse="|")
Grsub <-paste(Gr , collapse="|")
Grsub2 <-paste(Gr2 , collapse="|")
Jetsub <-paste(Jet , collapse="|")
Marsub <-paste(Mar , collapse="|")
Marsub2 <-paste(Mar2 , collapse="|")
Marshsub <-paste(Marsh , collapse="|")
Marshsub2 <-paste(Marsh2 , collapse="|")
RRsub <-paste(RR , collapse="|")
Unsub <-paste(Un , collapse="|")
Whasub <-paste(Wha , collapse="|")
CBsstru$structure <- gsub(DBsub,"DlBH",CBsstru$structure, perl=TRUE, ignore.case=TRUE)
CBsstru$structure <- gsub(BWsub,"BKW",CBsstru$structure, perl=TRUE, ignore.case=TRUE)
CBsstru$structure <- gsub(BHsub,"BH",CBsstru$structure, perl=TRUE, ignore.case=TRUE)
CBsstru$structure <- gsub(Debsub,"DBR",CBsstru$structure, perl=TRUE, ignore.case=TRUE)
CBsstru$structure <- gsub(Debsub2,"DBR",CBsstru$structure, perl=TRUE, ignore.case=TRUE)
CBsstru$structure <- gsub(Grsub,"Gr",CBsstru$structure, perl=TRUE, ignore.case=TRUE)
CBsstru$structure <- gsub(Grsub2,"Gr",CBsstru$structure, perl=TRUE, ignore.case=TRUE)
CBsstru$structure <- gsub(Jetsub,"Jt",CBsstru$structure, perl=TRUE, ignore.case=TRUE)
CBsstru$structure <- gsub(Marsub,"Marina",CBsstru$structure, perl=TRUE, ignore.case=TRUE)
CBsstru$structure <- gsub(Marsub2,"Marina",CBsstru$structure, perl=TRUE, ignore.case=TRUE)
CBsstru$structure <- gsub(Marshsub,"MsTo",CBsstru$structure, perl=TRUE, ignore.case=TRUE)
CBsstru$structure <- gsub(Marshsub2,"MsTo",CBsstru$structure, perl=TRUE, ignore.case=TRUE)
CBsstru$structure <- gsub(RRsub,"RR",CBsstru$structure, perl=TRUE, ignore.case=TRUE)
CBsstru$structure <- gsub(Unsub,"Uncnv",CBsstru$structure, perl=TRUE, ignore.case=TRUE)
CBsstru$structure <- gsub(Whasub,"Whf",CBsstru$structure, perl=TRUE, ignore.case=TRUE)
# there are also a bunch of unknown structures. Maryland has an absolte shitload.
# Turn these into unknown?
CBsstru$structure <- gsub("No","Unknown",CBsstru$structure, perl=TRUE, ignore.case=FALSE)
CBsstru$structure <- gsub("Uncnv","miscellaneous",CBsstru$structure, perl=TRUE, ignore.case=FALSE)
CBsstru$structure <- gsub("miscellaneous","misc",CBsstru$structure, perl=TRUE, ignore.case=FALSE)
CBsstru$structure[is.na(CBsstru$structure)]="Unknown"
# with(CBsstru, CrossTable(structure))
# throw out marinas and debris. That is not what we are looking for.
# Use a tab to double check this:
CBsstru <- CBsstru %>% filter(structure!='Marina', structure!= 'DBR', structure!="Unknown" )
# export combined file for GIS:
st_write(CBsstru, here(file.path('data\\Shoreline'),"CB_SSTRU.shp" ),append=FALSE)

# Next steps:
# Task 1
# Merge to Census block group data.
#  Bring in Census BG data from A2
cb_acs_df_clean <- st_read( here(data_path,"cb_acs_df_cleanF.shp" ))
# Rename variables for consistency
cb_acs_df_clean <- cb_acs_df_clean %>%
  rename(blk_pct = mnrty_b ,
         RaceOther_pct = mnrty_t ,
         hisp_pct = mnrty_h)
#Visualize all three layers if desired:
# mapview(MDsstru, color = "red") + mapview(VAsstru,color="green") + mapview(cb_acs_df_clean, alpha = 0.2,alpha.regions=0.2)

# Clean up workspace to remove memory
rm(MDsstru,MDsstru2020,MDsstru_old,VAsstru)
rm(BH,BHsub,BW,BWsub,DB,DBsub,Deb,Deb2,Debsub,Debsub2,Gr,Gr2,Grsub,Grsub2,Jet,Jetsub,Mar,Mar2,
   Marsh,Marsh2,Marshsub,Marshsub2,Marsub,Marsub2,RR,RRsub,Un,Unsub,Wha,Whasub)
# Merge the census block data to the shoreline data. Keep observation at the shoreline level.
# So we want to join polygons to the shoreline lines.
# First, rename variable that is apparently causing problems
CBsstru <- CBsstru%>% rename(StateN = State)
# First, get the structure data into the same crs as the census data
CBsstru_trans <- st_transform(CBsstru,'EPSG:4269')
# testint <- st_intersection(CBsstru,cb_acs_df_clean)
CBsstru_BG <- st_join(CBsstru_trans,cb_acs_df_clean, join=st_nearest_feature,left=TRUE)
# Double check with this: empties <- CBsstru_BG %>% filter(is.na(GEOID)==1)
# Calculate averages by block group, which is indicated by GEOID.
# First we need the total length of structures in each block group
# Also the total number of structures in each block group.
# Then we need the total length of each category of structure.
# Probably want to do this in meters?
# Then the count of each structure
# Can then use this to calculate the percentages.
# Start with the grouping by Census BG to find the total BG length and # of structures
CBsstru_BG <- CBsstru_BG %>% group_by(GEOID) %>%
  mutate(SumMrBG = sum(LgthMr, na.rm = TRUE),
         Num_BG = n() ) %>% ungroup()
# Next, groupby GEOID and Structure and get the count and total length of each
CBsstru_BG <- CBsstru_BG %>% group_by(GEOID,structure) %>%
  mutate(SuMr = sum(LgthMr, na.rm = TRUE),
         NStrBG = n()) %>%
  ungroup()
# Now create percentages of those
CBsstru_BG <- CBsstru_BG %>%
  mutate(PcL = SuMr/SumMrBG*100,
         PcN = NStrBG/Num_BG*100)
# Then we basically need to go from wide to long, right? Yes, first save and then
# Drop the individual-level variables

st_write(CBsstru_BG, here(file.path('data\\Shoreline'),"CB_SSTRU_BG.shp" ),append=FALSE)
# Now slim down
BG_SSTRU_MNs <- CBsstru_BG %>%
  select(-LgthMr,-LgthMi)
# Now get to one observation per BG/structure combo.
BG_SSTRU_MNs <- BG_SSTRU_MNs %>% group_by(GEOID,structure) %>%
  mutate(Panel_ID = row_number()) %>% ungroup()
BG_SSTRU_MNs <- BG_SSTRU_MNs %>% filter(Panel_ID==1)
BG_SSTRU_MNs <- BG_SSTRU_MNs %>% select(-Panel_ID)

# Then long to wide.
# Looks like this is the way to go.... but it drops the other Census variables.
#    I guess that is not a problem, since I can just join those up later. Yes. The geometry gets dropped.
# so will definitely have to do that.
BG_SSTRU_MNs <- BG_SSTRU_MNs %>%
  pivot_wider(id_cols = c(GEOID),names_from = structure,
              values_from = c(SuMr,NStrBG,PcL,PcN),
              values_fill = 0)
# Ok, so that corresponds to the unique 1055 GEOIDs that appear in the CBsstru_BG file
# Now, need to match that back up to the block groups
cb_acs_SSTRU <- left_join(cb_acs_df_clean,BG_SSTRU_MNs,by='GEOID' )
# apparently there are 20 empty geometries...
cb_acs_SSTRU <- cb_acs_SSTRU[!st_is_empty(cb_acs_SSTRU),,drop=FALSE]
# Shite. Still need shorter names.


# Save and export for GIS.
st_write(cb_acs_SSTRU,here(data_path,"cb_acs_SSTRU.shp" ),append=FALSE)




# I should probably create a version of this that only has coastal polygons, right?
# Look at earlier version of Peiley's code for that.
# Could bring up the WQ modelling cells and keep BGs that intersect?



# select(-contains("Num"),-contains("Pct"),-contains("SuM"),-state,-deficit,-pop)
# OK, now the names are out of Control. Also don't need a bunch of the variables
cb_acs_SSTRU <- cb_acs_SSTRU %>%
  rename(sumMBulk = SumLMt_Sstru_Bulkhead, sumMRip = SumLMt_Sstru_Riprap,
         sumMGroin = SumLMt_Sstru_Groin,) %>%
  select()


#                   N_Bulk = n(structure=="Bulkhead")
#                   MN_Bulk_LgthM = mean(price, na.rm=TRUE)


# merge back into the block group data.

# Export to GIS.

# make maps/figures

# Calculate the percent of structures, in both count and length, for each type
# Then compare across different income thresholds.

# Task 2:
# Import property sales data (or assessed property data? Probably both?)
# Calculate the average sales price by BG.
# Calculate the average assessed value by BG. For total and structure.
# Compare the % of structures to homes price/assessed value averages.
# What figures would convey that material best?


# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# Code construction graveyard


# For some reason this process has lost some characteristics?
testOutput <- cb_acs_SSTRU %>%
  select(white,income,geometry,pov99)
st_write(testOutput, here(file.path('data\\Shoreline'),"testOutput.shp" ),append=FALSE)
st_write(cb_acs_df_clean, here(data_path,"testOutput.shp" ),append=FALSE)

test_empty <- cb_acs_SSTRU[st_is_empty(cb_acs_SSTRU),,drop=FALSE]
test_NE = cb_acs_SSTRU[!st_is_empty(cb_acs_SSTRU),,drop=FALSE]


#PROJCS["NAD_1983_UTM_Zone_18N",GEOGCS["GCS_North_American_1983",DATUM["D_North_American_1983",SPHEROID["GRS_1980",6378137.0,298.257222101]],PRIMEM["Greenwich",0.0],UNIT["Degree",0.0174532925199433]],PROJECTION["Transverse_Mercator"],PARAMETER["False_Easting",500000.0],PARAMETER["False_Northing",0.0],PARAMETER["Central_Meridian",-75.0],PARAMETER["Scale_Factor",0.9996],PARAMETER["Latitude_Of_Origin",0.0],UNIT["Meter",1.0]]
