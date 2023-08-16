## Written by: US EPA National Center for Environmental Economics; March 2021

################################################################################
##############################     DOWNLOAD ACS DATA     #######################
################################################################################

####################################################
##########################################  PREAMBLE
####################################################

## Clear worksace
rm(list = ls())
gc()

## This function will check if a package is installed, and if not, install it
pkgTest <- function(x) {
  if (!require(x, character.only = TRUE))
  {
    install.packages(x, dep = TRUE)
    if(!require(x, character.only = TRUE)) stop("Package not found")
  }
}

## These lines load the required packages
packages <- c('tidycensus','tidyverse','data.table','foreach','doSNOW','here','openxlsx', 'mapview', 'sf') ## you can add more packages here
lapply(packages, pkgTest)

# Declare whether data should be redownloaded:
redownload = 1

####################################################
#################################  WORKING DIRECTORY
####################################################
# C:\Users\pwalsh01\OneDrive - Environmental Protection Agency (EPA)\Documents\EPA2\Water\Ches Bay EJ
## SET WORKING DIRECTORY
# Honestly, fuck the 'here' program. 
data_path <- "C:/Users/pwalsh01/OneDrive - Environmental Protection Agency (EPA)/Documents/EPA2/Water/Ches Bay EJ" #relative path to the data folder
setwd(data_path)
###################################################
#################################  GET CENSUS - ACS
###################################################

## This will take approximately 1-2 hours if ACS data are not already downloaded

## census api key
# get one at: https://api.census.gov/data/key_signup.html
# census_api_key("1b4b9cdd9ab6149ccfaa5237b4dfd119e2815683", install=T,overwrite=T)

# geography at which to draw data
geography = "block group"

# year of ACS to draw data
year = 2020

## Get dictionary of ACS variables
acs_variables <- load_variables(year, "acs5", cache = TRUE)
# write.xlsx(acs_variables,"data\\acs_variables_2020.xlsx") # write to optionally search spreadsheet

## Define variables of interest from dictionary
variables = c(pop="B02001_001",white="B02001_002",black="B02001_003",
              indian="B02001_004",asian="B02001_005",
              hispanic="B03003_003",hispanic_denominator="B03003_001",
              pov50="C17002_002",pov99="C17002_003",
              deficit="B17011_001",income="B19013_001")

# cache the geometries downloaded from census
options(tigris_use_cache=TRUE)

# file name for the stored acs data
acs_file = paste0("acs_data_",year,"_",geography,".Rdata")

# download the acs data if it doesn't exist
if (file.exists(file.path("Data\\acs_data",acs_file))) {
  
  print("FileExists")
 #  load(file.path("Data\\acs_data",acs_file))
} else {
  print("File Does not Already Exist")
}

if (redownload == 0) {
  load(file.path("Data\\acs_data",acs_file))
} else {
  
  # setup the cluster to download and process the data
  cl = makeCluster(5,outfile="")
  registerDoSNOW(cl)
  
  # list of state abbreviations plus DC
  #states = c(state.abb,"DC")
  states = c("MD", "PA", "VA", "WV", "VA", "NY", "DC")
  # states = c("CO","DC") ## test pull with only two states, comment this line and uncomment previous line to recover all states + DC
  
  # tidycensus will only return tract or block group data for a single state, so
  # we need to loop through each state and combine the results
  dataCB = foreach (i=1:length(states),.combine=rbind,
                  .packages=c("tidycensus","tidyverse")) %dopar% {
                    print(paste("starting state:",states[i]))
                    get_acs(geography=geography,
                            state=states[i],
                            variables=variables,
                            year=year,
                            geometry=TRUE) %>%
                      select(-NAME,-moe)
                  }
  
  # save the acs data
  if (!dir.exists("Data\\acs_data"))
    dir.create("Data\\acs_data")
  save(file=file.path("Data\\acs_data",acs_file),list="dataCB")
  
  stopCluster(cl)
  
}

## END OF SCRIPT. Have a great day!


# Now, reopen data and export to shapefile. 
load("Data\\acs_data\\acs_data_2020_block group.Rdata")
# The data are currently stored in long form. Want to have them in wide form
data_wideCB <- dataCB %>%  pivot_wider(names_from = variable,
                                   values_from = estimate)
data_wideCB_sf <- st_as_sf(data_wideCB)

# Hrm. Doesn't work with MapView. 
# mapview(data_wideDF)
data_wide_sf %>% 
  ggplot(aes(fill=pop)) +
  geom_sf(color = NA) + 
  scale_fill_viridis_c(option = "magma") 