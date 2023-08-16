# Title: A6_clean_BMPdata.R
# Created: 05/02/23
# Created by: Patrick Walsh, US EPA/NCEE. walsh.patrick.j@epa.gov
# Purpose: Import and clean the BMP Implementation data, do some
#            basic visualization and analysis
#  Inputs : BMPImplemented2021.csv - the CAST output for county-level BMP implementation
#              There was some basic cleaning done on the initial file in Stata (sorry)
#              which gave variable names and pivoted the data from long to wide
#              --> done in BMPimport.do
#           ChesBay_AgCensusDemographics.shp - has a subset of demographic variables
#             From USDA's Ag Census matched to a county GIS shapefile.
#              --> Done in AgCensusClean.r
#
#


#
# Clear Workspace
rm(list = ls())
# Load Libraries
library(tidyverse)
library(sf)
library(mapview)
library(here)
library(dplyr)
library(janitor)

data_path <- here('data') #relative path to the data folder
# import the BMP implementation data.
# This file
BMPImpl <- read.csv( file.path(data_path,"BMP/BMPImplemented2021.csv"))

# Bring in the county layer with Census Attributes from the AgCensusClean.r file.
CB_AgCenDemo <- st_read(here(data_path, 'USDA Data', 'ChesBay_AgCensusDemographics.shp'))

# Bring in the Normal Census data. Do some quick cleaning.
load(file.path(data_path,'acs_data/CB_acs_data_2020_County.RData'))
cb_acs_df_clean <- cb_acs_df %>%
  st_drop_geometry() %>%
  pivot_wider(names_from=variable,values_from=estimate) %>%
  mutate(white_pct=(white/pop)*100,
         black_pct=(black/pop)*100,
         other_pct=((pop-(white + black))/pop)*100,
         hispanic_pct=(hispanic/hispanic_denominator)*100,
         asian_pct = (asian/pop)*100,
         #compute percent below poverty threshold -->
         # pov50 (# below 0.5) and pov 99 (# between 0.5 and 0.99)
         pov99_pct=(pov99+pov50)/pop*100,
         pov50_pct=pov50/pop*100,
         income=income,
         state = substr(GEOID, 1, 2))

# Now join all these up. Quite a few variables. (Should I nest all of this in one call?)
BMPImpl$GEOID <- as.character(BMPImpl$FIPS)

CB_County <- left_join(CB_AgCenDemo,BMPImpl, by="GEOID") %>%
  left_join(cb_acs_df_clean, by="GEOID")
CBAgCen_Cen <- left_join(CB_AgCenDemo,cb_acs_df_clean, by="GEOID")


# Make sure the projection matches still.
# CB_County <- CB_County %>% st_transform(st_crs(cb_acs_df)) %>% clean_names
# Export and save file for use elsewhere
st_write(CB_County,
         here(data_path, 'CBimpl_AgCen_Cen.shp'),append=FALSE)
# Crap. Bunch of errors saving as shapefile.


# Test export of these:
st_write(CBAgCen_Cen,
         here(data_path, 'CBAgCen_Cen.shp'),append=FALSE)
# Definitely some problems in the export. At least, ArcGIS has trouble importing this.
# Likely due to filenames?
# That confirms that it is the implementation data.


# Poke around.

mapview(CB_County,
        zcol = 'ImplConservationTillage',
        alpha.regions = 0.8,
        layer.name = 'Cons TIll Implemented (%)')
mapview(CB_County,
        zcol = 'ImplConservationTillage',
        alpha.regions = 0.8,
        layer.name = 'Cons TIll Implemented (%)')

utils::View(CB_County)

