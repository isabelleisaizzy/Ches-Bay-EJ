# Title: A4_clean_Parcel_data.R
# Created: 09/22/22
# Created by: Patrick Walsh, US EPA/NCEE. walsh.patrick.j@epa.gov
# Purpose: Import and clean the parcel data from MD.
#          Idea is to calculate average property assessed value by blockgroup
#          so that it can be compared to the water quality, shoreline, and other CB geographic
#          data.
#
# Clear Workspace
rm(list = ls())
# Load Libraries
library(tidyverse)
library(sf)
library(mapview)
library(here)
library(dplyr)
library(data.table)

# Set directory
data_path <- here('data') #relative path to the data folder
#

# Import the parcel data.
Parcels <- st_read(file.path(data_path,"Property/MDParcelPolygons.shp"))
# Since we are just merging these with the BGs and aggregating, we really only need the
# relevant variables
Parcels <- Parcels %>% select(NFMLNDVL,NFMIMPVL,NFMTTLVL,geometry)
# load up the Block Group data from task A3.
cb_acs_SSTRU <-st_read(file.path(data_path,'cb_acs_SSTRU.shp'))
# First, get the Parcel data into the same crs as the census data
Parcels <- st_transform(Parcels,st_crs(cb_acs_SSTRU))


# Join the census data to the parcels

Parcels <- Parcels[!st_is_empty(Parcels),,drop=FALSE]
# Hrm. Some problems with the geometry. So switch off spherical.
sf::sf_use_s2(FALSE)

Parcels_BG <- st_join(Parcels,cb_acs_SSTRU, join=st_nearest_feature,left=TRUE)

# calculate the average assessed value, by BG, of land, structures, and total
Parcels_BG <- Parcels_BG %>% group_by(GEOID) %>%
  mutate(TotLdVlM = (sum(NFMLNDVL,na.rm = TRUE)/1000000),
         TotStVlM = (sum(NFMIMPVL,na.rm = TRUE)/1000000),
         TotVlM = (sum(NFMTTLVL,na.rm = TRUE)/1000000),
         MnLndVal = mean(NFMLNDVL,na.rm = TRUE),
         MnStrVal = mean(NFMIMPVL,na.rm = TRUE),
         MnVal = mean(NFMTTLVL,na.rm = TRUE)) %>%
  ungroup()
# Export the Parcels file for later analysis.
st_write(Parcels_BG,here(data_path,"MD_Parcels_BG.shp" ),append=FALSE)

# collapse down to the BG level.
# Eliminate variables that are parcel specific
BG_SSTRU_Parcels <- Parcels_BG %>%
  select(-NFMLNDVL,-NFMIMPVL,-NFMTTLVL)
# Now get to one observation per BG/structure combo.
BG_SSTRU_Parcels <- BG_SSTRU_Parcels  %>% group_by(GEOID) %>%
  mutate(Panel_ID = row_number()) %>% ungroup()
BG_SSTRU_Parcels  <- BG_SSTRU_Parcels  %>% filter(Panel_ID==1) %>%
  select(-Panel_ID) %>% ungroup()

# only keep relevant variables and GEOID, then re-merge to the BG polygons.
BG_Parcels_Slim <- BG_SSTRU_Parcels %>%
  select(GEOID,TotLdVlM,TotVlM,TotStVlM,MnLndVal,MnStrVal,MnVal)
BG_Parcels_Slim <- data.table(BG_Parcels_Slim)
# Join back up to the BG SSTRU dataset
cb_acs_SSTRU_Parcels <- left_join(cb_acs_SSTRU,BG_Parcels_Slim,by='GEOID' )


# export.
st_write(cb_acs_SSTRU_Parcels ,here(data_path,"cb_acs_SSTRU_Parcels.shp" ),append=FALSE)


# $$$$$$$$$$$$$$$$$$$$$$$$$
# Troubleshooting
MD_cbacsSSTRU_Parcels <- cb_acs_SSTRU_Parcels %>% filter(state==24)
mapview(MD_cbacsSSTRU_Parcels,zcol= "MnVal")
# WTF. Lots of NAs here.
WTFsMDcbac <- MD_cbacsSSTRU_Parcels %>% filter(is.na(MnVal))
mapview(WTFsMDcbac,zcol= "MnVal")
WTFsMD <- data.table(WTFsMDcbac) %>% select(GEOID)
WTFsMD <- WTFsMD %>% mutate(Bleh = 1)
ParcelsWTF <- left_join(Parcels_BG,WTFsMD,by='GEOID' )
# Should this have been a right join?
ParcelsWTF <- ParcelsWTF %>% mutate(SumBlehs = sum(Bleh,na.rm=TRUE))


# CREATE LIST OF BLOCKGROUPS with missing MnVal
cb_bg_Miss <- unique(WTFsMDcbac$GEOID)
#STEP 3) SUBSET Parcel DATASET See WTF happened
ParcelsMiss <- Parcels_BG %>%
  filter(GEOID %in% cb_bg_Miss)



