# Filename: CBEJ_EJSCREEN.r
# Date created: 10/28/21
# 
# Purpose: This file uses the OBOD facility locations in an EJSCREEN analysis
# 
# Notes: The OBOD facilitiy data were obtained from Paul Diss.
# Inputs: FacilitiesOBOD.csv 
# 
#
# install.packages('devtools')
rm(list = ls())

library(devtools)
install_github(repo = "USEPA/EJSCREENbatch")
require(mapview)
library(EJSCREENbatch)
library(maps)
library(ggplot2)

setwd('E:/EPA2/Water/Ches Bay EJ/Data/GIS')
raster.path <- 'C:/Users/pwalsh01/OneDrive - Environmental Protection Agency (EPA)/Documents/EPA2/Land/OBOD/Data/geotiff'
export.path <- 'E:/EPA2/Water/Ches Bay EJ/Data/GIS'

# Now bring in the shoreline structures data. 
anne_bulkST   = st_read('AnneArundel_sstru_2020_bulkheads.shp')
anne_riprap = st_read('AnneArundel_sstru_2020_riprap.shp')
anne_jetty  = st_read('AnneArundel_sstru_2020 jetty.shp')
anne_groin  = st_read('AnneArundel_sstru_2020_groin.shp')

anne_bulk   = st_as_sf(anne_bulkST)

EJ.data.Anne_bulk <- EJfunction(data_type = "landbased",
                          facility_data = anne_bulk, 
                          gis_option = "fast", 
                          buff_dist = 1,
                          raster_data = raster.path)

View(EJ.Test.AnneBulk[["EJ.facil.data"]][["facil_intersection_radius1mi"]])

# Note how in this version of the EJ Screen tool, we use buffer instead
# of buff_dist
EJ.Test.AnneBulk <- EJfunction(data_type = 'landbased',
                               LOI_data = anne_bulk,
                               gis_option = "fast",
                               buffer = 1,
                               raster_data = raster.path)

EJ.Test.AnneBulk <- EJfunction(data_type = 'landbased', 
)             
 
EJ.Test.AnneBulk <- EJfunction()               
