# A2_construct_CB_acs_data.R
# Date: August 29, 2022 | Updated: August 29, 2022
# Created by: NCEE (Peiley Lau, lau.peiley@epa.gov)
# Note: This script pulls out the ACS data for block groups
# that intersect with the Chesapeake Bay watershed boundary


#SET-UP
library(tidyverse)
library(sf)
library(mapview)
library(tigris) #for census data

#load data
data_path <- here('data') #relative path to the data folder

  #load acs data
#  load(file.path(data_path,'acs_data/acs_data_2020_block group.RData'))
load(file.path(data_path,'acs_data/acs_data_2020_county.RData'))

  #load blockgroup shapefile for states in the chesapeake bay
  state_vec <- c('New York', 'Pennsylvania', 'West Virginia',
                 'Maryland', 'Delaware', 'Virginia', 'DC')
  cb_county_sf <- map_dfr(state_vec, function(my_state){
    counties(state = my_state)
  })

  #load CB watershed boundary shapefile
  cb_sf <- st_read(here(data_path, 'watershed boundary', 'Chesapeake_Bay_Watershed_Boundary.shp')) %>%
    st_transform(st_crs(cb_county_sf)) #reproject to have same crs as cb_bg_sf


#STEP 1) SUBSET BLOCK GROUPS TO THOSE WITHIN CB WATERSHED
  cb_county_sf <- cb_county_sf %>%
    st_intersection(cb_sf)

#STEP 2) CREATE LIST OF BLOCKGROUPS INSIDE THE WATERSHED
  cb_county_vec <- unique(cb_county_sf$GEOID)

#STEP 3) SUBSET ACS DATASET TO LIST OF BLOCKGROUPS
  cb_acs_df <- data %>%
    filter(GEOID %in% cb_county_vec)

#STEP 4) SAVE THE DATASETS
  st_write(cb_county_sf,
           here(data_path, 'watershed boundary', 'Chesapeake_Bay_Watershed_Boundary_2020county.shp'))

  save(cb_acs_df,
       file = file.path(data_path, 'acs_data/CB_acs_data_2020_county.RData'))















