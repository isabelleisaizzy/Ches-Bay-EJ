# Title: AgCensusClean.R
# Created: 04/17/23
# Created by: Patrick Walsh, US EPA/NCEE. walsh.patrick.j@epa.gov
# Purpose:
# This file imports and cleans the data from the USDA Ag Census
# Downloaded the full dataset from
# https://www.nass.usda.gov/Publications/AgCensus/2017/Online_Resources/County_Profiles/index.php
# In April 2023
# The dataset is pretty big.7 million plus observations
# Side note: apparently there is tidyUSDA, which allows an API-based pull of these data.


# Clear Workspace
rm(list = ls())
# Load Libraries
library(tidyverse)
library(sf)
library(mapview)
library(here)
library(ggplot2)
library(gmodels)
library(naniar)
# Set directory
data_path <- here('data') #relative path to the data folder

AgCensus <- read.csv(file.path(data_path,"USDA Data/AgCensus2017Full.csv"))
# For now, just want the demographic data
AgCensusDemo <- AgCensus %>% filter(SECTOR_DESC =="DEMOGRAPHICS")
# Now, we only want MD, DC, VA, WV, PA, NY, and DE, right?
AgCenDemoChes <- AgCensusDemo %>%
  filter(STATE_ALPHA=="MD" |STATE_ALPHA=="DC" |STATE_ALPHA=="VA" |STATE_ALPHA=="WV" |STATE_ALPHA=="PA" |STATE_ALPHA=="NY" | STATE_ALPHA=="DE")
# No farmers in DC... right?
# for memory, get rid of larger files for now.
rm(AgCensus)
rm(AgCensusDemo)
# Hrm, there are also still a lot of unreasonable variables.
# Ah. There are multiple state-level variables in here.
AgCenDemoChes <- AgCenDemoChes  %>% filter(COUNTY_CODE!="NULL")

# To further get these counties down to only those in the watershed, we can do some spatial selection.
#    But first have to merge these data to the spatial data.
Counties <- st_read(here(data_path,'cb_2018_us_county_500k.shp'))

#load CB watershed boundary shapefile
cb_sf <- st_read(here(data_path, 'watershed boundary', 'Chesapeake_Bay_Watershed_Boundary.shp')) %>%
  st_transform(st_crs(Counties)) #reproject to have same crs as the County layer
# Now intersect the two
CB_Counties <- Counties %>%
  st_intersection(cb_sf)
rm(Counties)
rm(cb_sf)
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Right, now merge the AgCensus data to this shapefile.
# First, we need to drop down to only the variables that we really want and get this into wide form
# The plan is to create a new variable with the desired title for each variable.
# Then filter out all observations that don't have an entry there, and go from wide to long.
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "AG LAND, OWNED, IN FARMS - ACRES","AgLandOwnAcres", "." )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "AG LAND, RENTED FROM OTHERS, IN FARMS - ACRES","AgLandRentAcres", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS - AGE, AVG, MEASURED IN YEARS","AvgAgeProducers", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, (ALL) - NUMBER OF PRODUCERS","NumProducers", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, (ALL), FEMALE - NUMBER OF PRODUCERS","NumFemProducers", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, (ALL), MALE - NUMBER OF PRODUCERS","NumMaleProducers", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, AGE GE 75 - NUMBER OF PRODUCERS","NumProducersGE75", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRIMARY OCCUPATION, FARMING - NUMBER OF PRODUCERS","NumProdFarmPrimary", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL - YEARS ON ANY OPERATION, AVG, MEASURED IN YEARS","AvgYrAnyFarmPrin", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL - YEARS ON PRESENT OPERATION, AVG, MEASURED IN YEARS","AvgYrThisFarmPrin", AgCenDemoChes$VarDesc )

AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, AMERICAN INDIAN OR ALASKA NATIVE - ACRES OPERATED","AcresAmIndAKNat", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, AMERICAN INDIAN OR ALASKA NATIVE - NUMBER OF OPERATIONS","NumOpAmIndAKNat", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, AMERICAN INDIAN OR ALASKA NATIVE - NUMBER OF PRODUCERS","NumProdAmIndAKNat", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, AMERICAN INDIAN OR ALASKA NATIVE - ACRES OPERATED","AcresAmIndAKNatPrin", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, AMERICAN INDIAN OR ALASKA NATIVE - NUMBER OF OPERATIONS","NumOpAmIndAKNatPrin", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, AMERICAN INDIAN OR ALASKA NATIVE - NUMBER OF PRODUCERS","NumProdAmIndAKNatPrin", AgCenDemoChes$VarDesc )

AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, ASIAN - ACRES OPERATED","AcresAsian", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, ASIAN - NUMBER OF OPERATIONS","NumOpAsian", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, ASIAN - NUMBER OF PRODUCERS","NumProdAsian", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, ASIAN - ACRES OPERATED","AcresAsianPrin", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, ASIAN - NUMBER OF OPERATIONS","NumOpAsianPrin", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, ASIAN - NUMBER OF PRODUCERS","NumProdAsianPrin", AgCenDemoChes$VarDesc )

AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, BLACK OR AFRICAN AMERICAN - ACRES OPERATED","AcresBlack", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, BLACK OR AFRICAN AMERICAN - NUMBER OF OPERATIONS","NumOpBlack", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, BLACK OR AFRICAN AMERICAN - NUMBER OF PRODUCERS","NumProdBlack", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, BLACK OR AFRICAN AMERICAN - ACRES OPERATED","AcresBlackPrin", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, BLACK OR AFRICAN AMERICAN - NUMBER OF OPERATIONS","NumOpBlackPrin", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, BLACK OR AFRICAN AMERICAN - NUMBER OF PRODUCERS","NumProdBlackPrin", AgCenDemoChes$VarDesc )

AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, FEMALE - ACRES OPERATED","AcresFemale", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, FEMALE - NUMBER OF OPERATIONS","NumOpFemale", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, FEMALE - NUMBER OF PRODUCERS","NumProdFemale", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, FEMALE - ACRES OPERATED","AcresFemalePrin", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, FEMALE - NUMBER OF OPERATIONS","NumOpFemalePrin", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, FEMALE - NUMBER OF PRODUCERS","NumProdFemalePrin", AgCenDemoChes$VarDesc )

AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, HISPANIC - ACRES OPERATED","AcresHisp", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, HISPANIC - NUMBER OF OPERATIONS","NumOpHisp", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, HISPANIC - NUMBER OF PRODUCERS","NumProdHisp", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, HISPANIC - ACRES OPERATED","AcresHispPrin", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, HISPANIC - NUMBER OF OPERATIONS","NumOpHispPrin", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, HISPANIC - NUMBER OF PRODUCERS","NumProdHispPrin", AgCenDemoChes$VarDesc )

AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, WHITE - ACRES OPERATED","AcresWhite", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, WHITE - NUMBER OF OPERATIONS","NumOpWhite", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, WHITE - NUMBER OF PRODUCERS","NumProdWhite", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, WHITE - ACRES OPERATED","AcresWhitePrin", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, WHITE - NUMBER OF OPERATIONS","NumOpWhitePrin", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, WHITE - NUMBER OF PRODUCERS","NumProdWhitePrin", AgCenDemoChes$VarDesc )

AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, MULTI-RACE - ACRES OPERATED","AcresMulti", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, MULTI-RACE - NUMBER OF OPERATIONS","NumOpMulti", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, MULTI-RACE - NUMBER OF PRODUCERS","NumProdMulti", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, MULTI-RACE - ACRES OPERATED","AcresMultiPrin", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, MULTI-RACE - NUMBER OF OPERATIONS","NumOpMultiPrin", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, MULTI-RACE - NUMBER OF PRODUCERS","NumProdMultiPrin", AgCenDemoChes$VarDesc )

AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER - ACRES OPERATED","AcresHIpac", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER - NUMBER OF OPERATIONS","NumOpHIpac", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER - NUMBER OF PRODUCERS","NumProdHIpac", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER - ACRES OPERATED","AcresHIpacPrin", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER - NUMBER OF OPERATIONS","NumOpHIpacPrin", AgCenDemoChes$VarDesc )
AgCenDemoChes$VarDesc <- ifelse(AgCenDemoChes$SHORT_DESC == "PRODUCERS, PRINCIPAL, NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER - NUMBER OF PRODUCERS","NumProdHIpacPrin", AgCenDemoChes$VarDesc )

# !!!!!!!!!!!!!!!!!!!!!!! Time to go to wide form
AgCenDemoChes <- AgCenDemoChes %>% filter(VarDesc!=".")
AgCenDemoChes <- AgCenDemoChes %>%select( -CENSUS_COLUMN,-CENSUS_CHAPTER,-CENSUS_TABLE,-CENSUS_ROW,-SECTOR_DESC,-SHORT_DESC,-COMMODITY_DESC,-AGG_LEVEL_DESC,-STATE_NAME,DOMAINCAT_DESC)
# Now for some reason there are duplicate entries for some of the numProd variables. Same value and all else except for the census table chapter and row values.
# should not therefore be relevant for our purposes
# So lets drop those duplicates on Value VarDesc, state and county
AgCenDemoChes <- distinct(AgCenDemoChes)
# The Value variable is also still a character variable, because there are a number of them with "(D)", where the data is withheld due to a low number, so
#     as not to identify individual farms. Which is  different than none...
# So first need to replace (D) with NAs, and then turn to a numeric variable.
AgCenDemoChes <- AgCenDemoChes %>% replace_with_na(replace = list(VALUE = "(D)"))
AgCenDemoChes$VALUE <- as.numeric(gsub(",","",AgCenDemoChes$VALUE))
AgCenDemoChesWide <-AgCenDemoChes %>% pivot_wider(id_cols = c(STATE_FIPS_CODE,COUNTY_CODE,COUNTY_NAME,STATE_ALPHA), names_from=VarDesc,values_from=VALUE)
# OK, now join to the spatial data for figures

AgCenDemoChesWide$STATE_FIPS_CODE_S <- as.character(AgCenDemoChesWide$STATE_FIPS_CODE)
CBcnty_AgCenDemo <- left_join(CB_Counties,AgCenDemoChesWide,by=c( "STATEFP" = "STATE_FIPS_CODE_S", "COUNTYFP"="COUNTY_CODE"))

# Also need to look at Percentages
CBcnty_AgCenDemo <- CBcnty_AgCenDemo %>%
  mutate(PctBlackProd = (NumProdBlack/NumProducers)*100,
         PctWhiteProd = (NumProdWhite/NumProducers)*100,
         PctHispProd = (NumProdHisp/NumProducers)*100,
         PctAsianProd = (NumProdAsian/NumProducers)*100,
         PctGE75 = (NumProducersGE75/NumProducers)*100)


# Save and export this file for use elsewhere.
st_write(CBcnty_AgCenDemo,
         here(data_path, 'USDA Data', 'ChesBay_AgCensusDemographics.shp'))


# Create some maps:
mapview(CBcnty_AgCenDemo,
        zcol = 'NumProdBlack',
        alpha.regions = 0.8,
        layer.name = 'Black Producers') + mapView(CB_Counties)

mapview(CBcnty_AgCenDemo,
        zcol = 'NumProdBlack',
        alpha.regions = 0.8,
        layer.name = 'Black Producers')
mapview(CBcnty_AgCenDemo,
        zcol = 'PctBlackProd',
        alpha.regions = 0.8,
        layer.name = '% Black Producers')
# Pretty different picture between num producers and % producers
mapview(CBcnty_AgCenDemo,
        zcol = 'AcresBlack',
        alpha.regions = 0.8,
        layer.name = 'Acres Black')
# Huh. What does that mean? There is a lot more NAs in the data. How do we have
#      with a lot of black producers, but no black acres? Weird... Check the acres definition
mapview(CBcnty_AgCenDemo,
        zcol = 'PctAsianProd',
        alpha.regions = 0.8,
        layer.name = '% Asian Producers')
mapview(CBcnty_AgCenDemo,
        zcol = 'NumProdAsian',
        alpha.regions = 0.8,
        layer.name = 'Asian Producers')

mapview(CBcnty_AgCenDemo,
        zcol = 'AvgYrThisFarmPrin',
        alpha.regions = 0.8,
        layer.name = 'Avg Yrs This Farm')

mapview(CBcnty_AgCenDemo,
        zcol = 'AvgYrAnyFarmPrin',
        alpha.regions = 0.8,
        layer.name = 'Avg Yrs Any Farm')

mapview(CBcnty_AgCenDemo,
        zcol = 'NumProdBlackPrin',
        alpha.regions = 0.8,
        layer.name = 'Black Principal Producers')

mapview(CBcnty_AgCenDemo,
        zcol = 'NumProdHisp',
        alpha.regions = 0.8,
        layer.name = 'Hispanic Producers')

mapview(CBcnty_AgCenDemo,
        zcol = 'NumProdWhite',
        alpha.regions = 0.8,
        layer.name = 'White Producers')

mapview(CBcnty_AgCenDemo,
        zcol = 'NumProdFemale',
        alpha.regions = 0.8,
        layer.name = 'Female Producers')

mapview(CBcnty_AgCenDemo,
        zcol = 'AgLandRentAcres',
        alpha.regions = 0.8,
        layer.name = 'Rented Ag Land')
mapview(CBcnty_AgCenDemo,
        zcol = 'AgLandOwnAcres',
        alpha.regions = 0.8,
        layer.name = 'Own Ag Land')

mapview(CBcnty_AgCenDemo,
        zcol = 'AvgAgeProducers',
        alpha.regions = 0.8,
        layer.name = 'Average Age')
mapview(CBcnty_AgCenDemo,
        zcol = 'NumProducersGE75',
        alpha.regions = 0.8,
        layer.name = 'Num Older 75')
mapview(CBcnty_AgCenDemo,
        zcol = 'PctGE75',
        alpha.regions = 0.8,
        layer.name = 'Pct Older 75')

