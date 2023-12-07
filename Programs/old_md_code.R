tripcatch_site_2022<-tripcatch_site_2022 |>
  mutate(md_adv = case_when(#md rivers that are not in my fishing data: na: anacostia, bynum, middle,rock cr, potomac dam 4 to 5,Potomac River - DC line to Dam #3, potmoac - hancock,potomac - little orleans,potomac - near paw paw wv,bird river,  rewastico creek, rhode & west,patapsco north of ellicott city (have to differentiate bluegill),potomac-town creek, middle river
    #md rivers that are subsetted :Potomac River - 301 Bridge to DC Line, Susquehanna River - Below Conowingo Dam, Potomac: Mouth to 301, back river, magothy, mid bay: middle to patapsco, chester river when accounting for length of fish, susquehanna - above conowingo dam,  chesapeake bay and patapsco inches, patapsco bluegill,  patapsco river-middle branch vs chesapeake bay and tributaries, tred avon river,
    #assumes anglers not removing dark meat and belly fat
    common=="ATLANTIC CROAKER" ~ 4,
    common == "AMERICAN EEL" & water_body == "CHOPTANK R" ~ 1,
    common == "AMERICAN EEL" & water_body == "PATAPSCO R" ~ 0,
    common == "AMERICAN EEL" & water_body == "PATUXENT R" ~ 3,
    common == "AMERICAN EEL" & water_body == "BUSH R" ~ 4,
    common == "AMERICAN EEL" & water_body %in% list("ELK R","SUSQUEHANNA BELOW","BACK R") ~ 0,
    common == "AMERICAN EEL" & water_body == "NORTHEAST R" ~ 1,
    common == "AMERICAN EEL" & water_body == "SOUTH R" ~ 2,
    common == "AMERICAN EEL" & water_body %in% list("POTOMAC 301 DC","MIDDLE R") ~ 0.5,
    common ==  "BLUE CATFISH" & water_body=="CHOPTANK R" & between(tot_len,381,609.6)  ~ 10, #between 15"-24"
    common ==  "BLUE CATFISH" & water_body == "MIDDLE R" & between(tot_len,381,609.6) ~ 10,
    common ==  "BLUE CATFISH" & water_body == "NANTICOKE R" & between(tot_len,381,609.6) ~ 10,
    common ==  "BLUE CATFISH" & water_body == "PATUXENT R" & between(tot_len,381,609.6) ~ 10,
    common ==  "BLUE CATFISH" & water_body == "WICOMICO R" & between(tot_len,381,609.6) ~ 10,
    common ==  "BLUE CATFISH" & water_body == "POTOMAC 301 DC" & between(tot_len,304.8,609.6) ~ 4, #12-24"
    common ==  "BLUE CATFISH" & water_body == "POTOMAC 301 DC" & between(tot_len,609.6,762) ~ 1, #24-30
    common ==  "BLUE CATFISH" & water_body == "POTOMAC 301 DC" & tot_len>762 ~ 0, #30+
    common ==  "BLUE CATFISH" & water_body == "POTOMAC MOUTH 301" & between(tot_len,304.8,381)~ 4,#12-15
    common ==  "BLUE CATFISH" & water_body == "POTOMAC MOUTH 301" & between(tot_len,381,609.6)~ 2,#15-24
    common ==  "BLUE CATFISH" & water_body == "POTOMAC MOUTH 301" & between(tot_len,609.6,762)~ 1,#24-30
    common ==  "BLUE CATFISH" & water_body == "POTOMAC MOUTH 301" & tot_len>762~ 0,#30+
    
    common ==  "BLUEGILL" & water_body %in% list("BUSH R","SUSQUEHANNA ABOVE") ~ 6,
    common ==  "BLUEGILL" & water_body == "CHOPTANK R" ~ 10,
    common ==  "BLUEGILL" & water_body %in% list("GUNPOWDER R","POTOMAC 301 DC") ~ 2,
    common ==  "BLUEGILL" & water_body == "PISCATAWAY CR" ~ 1,
    common == "BLUEGILL" & water_body == "PATAPSCO R" ~ 6,
    common == "BLUEGILL" & water_body == "PATUXENT R" ~ 10,
    common == "BLUEGILL" & water_body == "MAGOTHY R" ~ 5,
    common ==  "BROWN BULLHEAD" & water_body == "BUSH R" ~ 1,
    common ==  "BROWN BULLHEAD" & water_body == "CHESTER R" ~ 10,
    common ==  "BROWN BULLHEAD" & water_body %in% list("ELK R","MIDDLE R") ~ 2,
    common ==  "BROWN BULLHEAD" & water_body %in% list("GUNPOWDER R","BACK R") ~ 4,
    common ==  "BROWN BULLHEAD" & water_body %in% list("NORTHEAST R","SUSQUEHANNA BELOW") ~ 1,
    common ==  "BROWN BULLHEAD" & water_body == "PATAPSCO R" ~ 0.5,
    common ==  "BROWN BULLHEAD" & water_body == "SOUTH R" ~ 6,
    common ==  "BROWN BULLHEAD" & water_body == "WICOMICO R" ~ 7,
    common ==  "BROWN BULLHEAD" & water_body == "MAGOTHY R" ~ 8,
    common ==  "BROWN BULLHEAD" & site_id %in% MID_BAY ~ 5,
    common == "CHANNEL CATFISH" & water_body == "BOHEMIA R" ~ 0.5, 
    common == "CHANNEL CATFISH" & water_body %in% list("BUSH R","SUSQUEHANNA ABOVE") ~ 1,
    common == "CHANNEL CATFISH" & water_body == "CHESEPEAKE - DELAWARE CANAL" ~ 0.5,
    common == "CHANNEL CATFISH" & water_body == "CONOCOCHEAGUE CR" ~ 5,
    common == "CHANNEL CATFISH" & water_body == "ELK R" ~ 1,
    common ==  "CHANNEL CATFISH" & water_body == "GUNPOWDER R" ~ 0.5,
    common ==  "CHANNEL CATFISH" & water_body =="NANTICOKE R" ~ 0.5,
    common ==  "CHANNEL CATFISH" & water_body =="POTOMAC 301 DC" & tot_len < 457.2 ~ 0.5, #20in
    common ==  "CHANNEL CATFISH" & water_body =="POTOMAC 301 DC" & tot_len > 457.2 ~ 0,
    common ==  "CHANNEL CATFISH" & water_body == "NORTHEAST R" ~ 2,
    common ==  "CHANNEL CATFISH" & water_body == "POCOMOKE R" ~ 3,
    common == "CHANNEL CATFISH" & water_body == "CHOPTANK R" ~ 2,
    common == "CHANNEL CATFISH" & water_body == "PATAPSCO R" ~ 0.5,
    common == "CHANNEL CATFISH" & water_body == "PATUXENT R" ~ 2,
    common == "CHANNEL CATFISH" & water_body == "SASSAFRAS R" ~ 2,
    common == "CHANNEL CATFISH" & water_body == "WICOMICO R" ~ 2,
    common == "CHANNEL CATFISH" & water_body %in% list("SUSQUEHANNA BELOW","BACK R","MIDDLE R") ~ 0,
    common == "CHANNEL CATFISH" & water_body == "CHESTER R" & tot_len<508~6,#20 inches
    common == "CHANNEL CATFISH" & water_body == "CHESTER R" & tot_len>508~1,
    common == "COMMON CARP" & water_body == "GUNPOWDER R" ~ 2,
    common == "COMMON CARP" & water_body == "SOUTH R" ~ 2,
    common == "COMMON CARP" & water_body == "BUSH R" ~ 6,
    common == "COMMON CARP" & water_body == "CONOCOCHEAGUE CR" ~ 4,
    common == "COMMON CARP" & water_body %in% list("POTOMAC 301 DC","BACK R") ~ 0,
    common %in% list("LARGEMOUTH BASS","SMALLMOUTH BASS")  & water_body %in% list("BUSH R","POTOMAC 301 DC") ~ 6,
    common %in% list("LARGEMOUTH BASS","SMALLMOUTH BASS")  & water_body == "CONOCOCHEAGUE CR" ~ 4,
    common %in% list("LARGEMOUTH BASS","SMALLMOUTH BASS")  & water_body == "GUNPOWDER R" ~ 4,
    common %in% list("LARGEMOUTH BASS","SMALLMOUTH BASS")  & water_body == "NORTHEAST R" ~ 5,
    common %in% list("LARGEMOUTH BASS","SMALLMOUTH BASS")  & water_body == "PATAPSCO R" ~ 3,
    common %in% list("LARGEMOUTH BASS","SMALLMOUTH BASS")  & water_body %in% list("PATUXENT R","SUSQUEHANNA BELOW") ~ 10,
    common %in% list("LARGEMOUTH BASS","SMALLMOUTH BASS")  & water_body == "SUSQUEHANNA ABOVE" ~ 2,
    common %in% list("LARGEMOUTH BASS","SMALLMOUTH BASS")  & water_body == "MIDDLE R" ~ 1,
    common == "NORTHERN SNAKEHEAD" & water_body == "POTOMAC 301 DC" ~ 3,
    common == "SPOT" ~ 5,
    common == "STRIPED BASS" & site_id %in% PATAPSCO_MIDDLE  & tot_len < 711.2 ~ 2, #28in
    common == "STRIPED BASS" & site_id %in% PATAPSCO_MIDDLE  & tot_len > 711.2 ~ 1,
    common == "STRIPED BASS" & !(site_id %in% PATAPSCO_MIDDLE) & tot_len < 711.2 ~ 3,
    common == "STRIPED BASS" & !(site_id %in% PATAPSCO_MIDDLE) & tot_len > 711.2 ~ 1,
    common == "WHITE CATFISH" & water_body == "NANTICOKE R" ~ 2,
    common == "WHITE CATFISH" & water_body == "PATAPSCO R" ~ 0,
    common == "WHITE CATFISH" & water_body == "POTOMAC 301 DC" ~ 0,
    common == "WHITE CATFISH" & site_id %in% MID_BAY ~ 6,
    common == "WHITE PERCH" & water_body %in% list("BOHEMIA R","BACK R") ~ 2,
    common ==  "WHITE PERCH" & water_body %in% list("BUSH R","POTOMAC 301 DC") ~ 8,
    common ==  "WHITE PERCH" & water_body == "CHESEPEAKE - DELAWARE CANAL" ~ 4,
    common ==  "WHITE PERCH" & water_body %in% list("WYE R","MILES R","ELK R","CHESTER R","TRED AVON R","CHOPTANK R") ~ 10,
    common ==  "WHITE PERCH" & water_body %in% list("GUNPOWDER R", "SOUTH R") ~ 3,
    common ==  "WHITE PERCH" & water_body == "NANTICOKE R" ~ 8,
    common ==  "WHITE PERCH" & water_body == "NORTHEAST R" ~ 3,
    common ==  "WHITE PERCH" & water_body %in% list("PATAPSCO R","POTOMAC MOUTH 301") ~ 6,
    common ==  "WHITE PERCH" & water_body %in% list("PATUXENT R", "WICOMICO R") ~ 10,
    common ==  "WHITE PERCH" & water_body == "POCOMOKE R" ~ 5,
    common ==  "WHITE PERCH" & site_id %in% MID_BAY ~ 5,
    common ==  "WHITE PERCH" & water_body == "MIDDLE R" ~ 0.5,
    common ==  "WHITE PERCH" & water_body %in% list("SASSAFRAS R","SEVERN R") ~ 2,
    common ==  "YELLOW PERCH" & water_body == "BUSH R" ~ 2,
    common ==  "YELLOW PERCH" & water_body %in% list("CHESTER R", "CHOPTANK R","SUSQUEHANNA BELOW") ~ 10,
    
    common ==  "YELLOW PERCH" & water_body == "ELK R" ~ 0.5,
    common ==  "YELLOW PERCH" & water_body == "GUNPOWDER R" ~ 1,
    common ==  "YELLOW PERCH" & water_body == "SEVERN R" ~ 5,
    common ==  "YELLOW PERCH" & water_body == "SOUTH R" ~ 4,
    common ==  "YELLOW PERCH" & water_body == "MAGOTHY R" ~ 3,
    TRUE ~ NA))

#look at all fish-body combinations that have no advisory 
inspect <- tripcatch_site_2022 |> filter(is.na(md_adv) & is.na(common)==FALSE & is.na(va_adv_meals) & state=="VA")|>select(state,common,water_body)|>unique()

#all obs that have different advisories in md and va
inspect<-tripcatch_site_2022|>select(common,water_body,md_adv,va_adv_meals)|>filter(!is.na(md_adv) & !is.na(va_adv_meals))