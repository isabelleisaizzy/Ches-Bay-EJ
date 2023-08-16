

clear all
global CBdata "C:\Users\PWALSH01\OneDrive - Environmental Protection Agency (EPA)\Documents\EPA2\Water\Ches Bay EJ\Data\"

import delimited "${CBdata}trip_catch_2022_piv_acs.csv", case(preserve) asdouble 
destring unemployment- unemployment_quartile, replace force
destring hrsf age ffdays2 cntrbtrs gear gender, replace force
table prim_caught, statistic(mean prop_eaten)
twoway (scatter prop_eaten unemployment)
table prim_caught, statistic(mean prop_eaten)
table prim_caught, statistic(mean not_english)

table intsite, statistic(mean wave)
* Dont use gear. There is no real variation in the variable. 
* pweights are sampling weights, iweight is importance weight. Probably use sampling weight.

keep if tot_cat_1>0
* Basic regression to test if results match R
reg prop_eaten unemployment not_english black i.mode_fx hrsf age ffdays2 cntrbtrs i.wave i.gender i.intsite  [pweight = wp_int]

reg prop_eaten unemployment not_english black i.mode_fx hrsf age ffdays2 cntrbtrs gear i.intsite [iweight = wp_int]
reg prop_eaten unemployment not_english black i.mode_fx hrsf age ffdays2 cntrbtrs gear i.intsite

reg prop_eaten unemployment not_english black i.mode_fx hrsf age ffdays2 cntrbtrs gear i.intsite [pweight = wp_int]
reg prop_eaten unemployment not_english black i.mode_fx hrsf age ffdays2 cntrbtrs  i.gender i.wave i.intsite  [pweight = wp_int]
reg prop_eaten unemployment not_english black i.mode_fx hrsf c.age##c.age ffdays2 cntrbtrs  i.gender i.wave i.intsite  [pweight = wp_int]
reg prop_eaten unemployment not_english black i.mode_fx hrsf c.age##c.age ffdays2 cntrbtrs  i.gender i.wave   [pweight = wp_int]

reg prop_eaten unemployment not_english nonwhite i.mode_fx hrsf c.age##c.age ffdays2 cntrbtrs  i.gender i.wave i.intsite  [pweight = wp_int]
reg prop_eaten unemployment not_english nonwhite i.mode_fx hrsf c.age##c.age ffdays2 cntrbtrs  i.gender i.intsite  [pweight = wp_int]


xtset intsite
xtreg prop_eaten unemployment not_english black i.mode_fx hrsf age ffdays2 cntrbtrs gear i.gender i.wave 
 [pweight = wp_int]


reg prop_eaten unemployment not_english black i.mode_fx hrsf c.age##c.age ffdays2 cntrbtrs  i.gender i.wave if mode_fx!=5 & mode_fx!=4  [pweight = wp_int] 
reg prop_eaten unemployment not_english black i.mode_fx hrsf c.age##c.age ffdays2 cntrbtrs  i.gender i.wave i.intsite if mode_fx!=5 & mode_fx!=4  [pweight = wp_int] 


