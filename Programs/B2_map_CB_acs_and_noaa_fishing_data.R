# B2_map_CB_acs_and_noaa_fishing_data.R
# Date: August 29, 2022 | Updated: August 29, 2022
# Created by: NCEE (Peiley Lau, lau.peiley@epa.gov)
# Note: This script maps the ACS data for block groups
# that intersect with the Chesapeake Bay watershed boundary
# with the NOAA MRIP fishing data


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

#load NOAA datasets
  #Public Fishing Access dataset
  access_df <- read.csv(here('data', 'NOAA MRF', 'Public Fishing Access Site Register', 'SITE.csv'))

#STEP 1) Clean the Public Fishing dataset
  #keep sites within the CB watershed boundary
  state_vec <- c('MD', 'VA', 'DE') #NB - there are no DC, PA or WV sites
      #Also, not including NY b/c the sites don't overlap with the watershed

  cb_access_df <- access_df %>%
    filter(STATE %in% state_vec) %>%
    rename_all(tolower) %>%
    filter(status == 'Active')

  cb_access_sf <- cb_access_df %>%
    st_as_sf(coords = c(x = 'site_long',
             y = 'site_lat'),
             crs = 4326) %>%
    st_transform(st_crs(cb_bg_sf))

  mapview(cb_access_sf)

#STEP 2) ACS data
  #CLEAN UP ACS DEMOGRAPHIC DATASETS
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


  #CREATE SF OBJECT
  cb_bg_sf_ej<- cb_bg_sf %>%
    left_join(cb_acs_df_clean %>% dplyr::select(GEOID,
                                                minority_black,
                                                minority_other,
                                                pov99),
              by = 'GEOID') %>%
    mutate(minority = minority_black + minority_other)


#STEP 3) Map the Public Fishing Access locations w/ demographic data
  # % Black
  mapview(cb_bg_sf_ej,
          zcol = 'minority_black',
          col.regions=brewer.pal(9, "Blues"),
          alpha.regions = 0.8,
          layer.name = '% Black') + mapview(cb_access_sf)


  # % Minority
  mapview(cb_bg_sf_ej,
          zcol = 'minority',
          col.regions=brewer.pal(9, "Greens"),
          alpha.regions = 0.8,
          layer.name = '% Black') + mapview(cb_access_sf)



























































