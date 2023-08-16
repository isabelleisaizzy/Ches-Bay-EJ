# Title: BasicRecFishingRegs.R
# Created: 08/02/23
# Created by: Patrick Walsh, US EPA/NCEE. walsh.patrick.j@epa.gov
#           Using code and data from Izzy Zheng
# Purpose:
#          This file uses MRIP data on fishing consumption that was cleaned by
#         Izzy Zheng. The data were cleaned in 'making_intermediate_datasets.qmd'
#              That file links MRIP, Census, and other data and exports trip_catch_2022_piv_acs.RData
# Note - this file uses only data that come from 2022.
#


rm(list = ls())
# Load Libraries
library(tidyverse)
library(here)
library(ggplot2)
library(gmodels)
library(stargazer)

data_path <- here('data')
results_path <- here('Results/RecFishing')
load(here('data','intermediate_datasets',"trip_catch_2022_piv_acs.RData"))

prop_eaten_reg_data <- trip_catch_2022_piv_acs |>
  filter(tot_cat_1 >0)

prop_eaten_reg_data$waveCH <- as.character(prop_eaten_reg_data$wave)
# Ok, now run regressions. I am getting these to match Stata exactly
# in this set of variables, try with and without wave and intsite
# Start with the simplest regression that omits both
reg1 <- lm(formula = prop_eaten ~ unemployment + income + not_english + black +
             mode_fx + hrsf + age + ffdays2 + cntrbtrs + gender  ,
           data=prop_eaten_reg_data,
           weights = prop_eaten_reg_data$wp_int)
# Put in wave dummies
reg2 <- lm(formula = prop_eaten ~ unemployment +income +  not_english + black +
             mode_fx + hrsf + age + ffdays2 + cntrbtrs + gender  + waveCH ,
           data=prop_eaten_reg_data,
           weights = prop_eaten_reg_data$wp_int)
# Now try with intsite
reg3 <- lm(formula = prop_eaten ~ unemployment + not_english + black +
             mode_fx + hrsf + age + ffdays2 + cntrbtrs + gender  + intsite,
           data=prop_eaten_reg_data,
           weights = prop_eaten_reg_data$wp_int)
# Finally, everything in
reg4 <- lm(formula = prop_eaten ~ unemployment +income +  not_english + black +
             mode_fx + hrsf + age + ffdays2 + cntrbtrs +gender  + waveCH + intsite,
           data=prop_eaten_reg_data,
           weights = prop_eaten_reg_data$wp_int)
# Also, look at nonwhite instead of black
reg5 <- lm(formula = prop_eaten ~ unemployment +income +  not_english + nonwhite +
             mode_fx + hrsf + age + ffdays2 + cntrbtrs + gender  + waveCH + intsite,
           data=prop_eaten_reg_data,
           weights = prop_eaten_reg_data$wp_int)
# Spit this out into a formatted table
stargazer(reg1,reg2,reg3,reg4,reg5,type="text",out=here(results_path,'RegTable1.txt'), title = "Regression Results")

# ########################
# Next, look at some other model variations.
reg_data_NoCharter <- prop_eaten_reg_data |>
  filter( mode_fx!=5 & mode_fx!=4)
# Now test the same regressions as above. Need to come in later and simplify code by defining the
# variable groupings.
reg1_2 <- lm(formula = prop_eaten ~ unemployment +income +  not_english + black +
             mode_fx + hrsf + age + ffdays2 + cntrbtrs + gender  ,
           data=reg_data_NoCharter,
           weights = reg_data_NoCharter$wp_int)
# Put in wave dummies
reg2_2 <- lm(formula = prop_eaten ~ unemployment +income +  not_english + black +
             mode_fx + hrsf + age + ffdays2 + cntrbtrs + gender  + waveCH ,
           data=reg_data_NoCharter,
           weights = reg_data_NoCharter$wp_int)
# Now try with intsite
reg3_2 <- lm(formula = prop_eaten ~ unemployment +income +  not_english + black +
             mode_fx + hrsf + age + ffdays2 + cntrbtrs + gender  + intsite,
           data=reg_data_NoCharter,
           weights = reg_data_NoCharter$wp_int)
# Finally, everything in
reg4_2 <- lm(formula = prop_eaten ~ unemployment +income +  not_english + black +
             mode_fx + hrsf + age + ffdays2 + cntrbtrs + gender  + waveCH + intsite,
           data=reg_data_NoCharter,
           weights = reg_data_NoCharter$wp_int)
# Also, look at nonwhite instead of black
reg5_2 <- lm(formula = prop_eaten ~ unemployment +income +  not_english + nonwhite +
             mode_fx + hrsf + age + ffdays2 + cntrbtrs + gender  + waveCH + intsite,
           data=reg_data_NoCharter,
           weights = reg_data_NoCharter$wp_int)
stargazer(reg1_2,reg2_2,reg3_2,reg4_2,reg5_2,type="text",out=here(results_path,'RegTable2.txt'), title = "Regression Results No Charter")

