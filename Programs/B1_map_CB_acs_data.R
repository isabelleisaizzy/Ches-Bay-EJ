# B1_map_CB_acs_data.R
# Date: August 29, 2022 | Updated: August 29, 2022
# Created by: NCEE (Peiley Lau, lau.peiley@epa.gov)
# Note: This script maps the ACS data for block groups
# that intersect with the Chesapeake Bay watershed boundary


#SET-UP
library(tidyverse)
library(sf)
library(mapview)
library(RColorBrewer) #for color palettes

#load data
data_path <- here('data') #relative path to the data folder

  #load acs data
  load(file.path(data_path,'acs_data/CB_acs_data_2020_block group.RData'))

  #load CB blockgroup shapefile
  cb_bg_sf <- st_read(here(data_path, 'watershed boundary', 'Chesapeake_Bay_Watershed_Boundary_2020blockgroups.shp'))

#1. CLEAN UP ACS DEMOGRAPHIC DATASETS
  cb_acs_df_clean <- cb_acs_df %>%
    st_drop_geometry() %>%
    pivot_wider(names_from=variable,values_from=estimate) %>%
    mutate(white_pct=(white/pop)*100,
           minority_black=(black/pop)*100,
           minority_other=((pop-(white + black))/pop)*100,
           minority_hispanic=(hispanic/hispanic_denominator)*100,
           #compute percent below poverty threshold -->
           # pov50 (# below 0.5) and pov 99 (# between 0.5 and 0.99)
           pov99=(pov99+pov50)/pop*100,
           pov50=pov50/pop*100,
           income=income,
           state = substr(GEOID, 1, 2))


#2. CREATE MAPS
  #Percent Black
  cb_bg_sf_pctblack <- cb_bg_sf %>%
    left_join(cb_acs_df_clean %>% dplyr::select(GEOID, minority_black),
              by = 'GEOID')
  mapview(cb_bg_sf_pctblack,
          zcol = 'minority_black',
          col.regions=brewer.pal(9, "Blues"),
          alpha.regions = 0.8,
          layer.name = '% Black')
