#obsolete code
#from making intermediate datasets: making manual_zip and cb_zip:
library(tidyverse)
library(here)
data_path <- here('data') #relative path to the data folder

zip <- st_read(here(data_path, 'zipcodes', 'tl_2020_us_zcta520.shp')) #zip code shapefiles originally taken from https://www2.census.gov/geo/tiger/TIGER2020/ZCTA520/
zip<- zip |> select(-CLASSFP20,-MTFCC20,-FUNCSTAT20,-ALAND20,-AWATER20) #filtering to relevant variables
cb_sf <- st_read(here(data_path, 'watershed boundary', 'Chesapeake_Bay_Watershed_Boundary.shp')) #Chesapeake Bay shapefile

#make all cb zips:
cb_sf <- cb_sf |> st_transform(st_crs(zip)) #convert to same CRS as zipcode data
cb_zip <- st_filter(zip, cb_sf)#filter zip codes to just those spatially within CB boundary
cb_zip <- cb_zip |>
  mutate(ZIP=as.numeric(ZCTA5CE20))
save(cb_zip,file=here(data_path,"intermediate_datasets","cb_zip.Rdata"))

#make zip manual
zip_manual <- zip |>
  mutate(ZIP=ZCTA5CE20|>as.numeric())|>
  filter(between(ZIP,8000,8400)|
           between(ZIP,15500,15599)|
           between(ZIP,17000,17699)|
           between(ZIP,18000,18199)|
           between(ZIP,19000,19999)|
           between(ZIP,20000,24199)|
           between(ZIP,24500,24599)|
           between(ZIP,25400,25499)|
           between(ZIP,26700,26799)|
           between(ZIP,27200,27999))
save(zip_manual,file=here(data_path,"intermediate_datasets","manual_zip.Rdata"))

#For demonstration purposes: a map of the CB border (cb_zip zip codes), zip_manual, and what zip codes ppl come from to fish.
#CB border is orange, zip_manual is red, fishing zip codes are indigo

#group tripcatch by zip code
tripcatch_2022_zip <- trip_catch_2022 |>
  group_by(ZIP)|>
  reframe(num_anglers = ID_CODE |> unique() |> length(),
          num_eaten = sum(landing), #we are assuming that all those in CLAIM, eg caught and available for interviewer. excludes reported harvest, which are dead, filleted, released dead, given away...
  ) |>
  mutate(fish_per_angler = num_eaten/num_anglers)

#construct shapefile of zip codes where there has been at least 1 fish caught by a fisherman from there
fishing_zips <- tripcatch_2022_zip |>
  filter(fish_per_angler>0)
fishing_zips <- zip |>
  mutate(ZIP=as.numeric(ZCTA5CE20))|>
  right_join(fishing_zips,by=c("ZIP"="ZIP"))

ggplot()+
  geom_sf(data=zip_manual,
          fill="Red",
          color="Red",
          alpha =0.5)+
  geom_sf(data=fishing_zips,
          fill="Blue",
          alpha=0.5)+
  geom_sf(data=cb_sf,
          color="Orange",
          alpha=0)+
  xlim(90,70)+
  ylim(32,43)
