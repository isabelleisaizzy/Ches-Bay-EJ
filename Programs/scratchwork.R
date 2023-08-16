#going from block to block group to zip
#import ACS data and zip-block relationship file
load(file.path(data_path,'acs_data/acs_data_2020_block group.Rdata'))
zip_block <- read.csv(here('data', 'acs_data', 'zcta_block.txt'),sep="|")

#limit both relation file zip_block and ACS data to being in the zip_manual zip codes
##keep only relevant variables + zip codes where fishers come from
zip_block_cb <- zip_block |>
  select(GEOID_ZCTA5_20,GEOID_TABBLOCK_20,NAMELSAD_TABBLOCK_20,GEOMETRY)|>
  filter(GEOID_ZCTA5_20 %in% tripcatch_2022_zip$ZIP)
#join the block-zip relationship file to trip catch in zip format
##join tripcatch to census block. this is meant to be a key that links
##tripcatch's zip codes to blocks to block groups. don't worry about the other
##variables.
zip_block_bg <- tripcatch_2022_zip |>
  left_join(zip_block_cb,by=c("ZIP"="GEOID_ZCTA5_20"))|>#will add all of the blocks as new observations to each zip code, so the new unit of obs will be the blocks. recall tripcatch_2022_zip is at the zip code level.
  mutate(GEOID_bg=GEOID_TABBLOCK_20|>substr(1,12))#add block group variable by indexing first 12 digits of block geo id
rm(zip_block)

#make a key bg_zip that sorts block group to appropriate zip code
##sort block group to zip code that has the highest number of that block group's blocks. lowkey it would probably better to code this through weight, but that's too much for me to think about rn.
block_zip <- zip_block_bg |>
  group_by(GEOID_bg,ZIP)|>
  reframe(obs = n()) #obs represents the number of blocks in the given block group that belong to the given zip code
bg_zip<- block_zip|>
  group_by(GEOID_bg)|>
  reframe(ZIP_final = case_when(
    obs == max(obs) ~ ZIP #pick the zip code with the max amount of blocks from that block group
  )) |>
  na.omit()|>
  group_by(GEOID_bg)|>
  reframe(ZIP_final = ZIP_final[1]) #if there are multiple max amounts of blocks, pick the first zip code

##limit both relation file zip_block and ACS data to reflect zip codes where ppl
##came from to fish in CB
zip_block_cb <- zip_block |>
  select(GEOID_ZCTA5_20,GEOID_TABBLOCK_20,NAMELSAD_TABBLOCK_20)|>
  filter(GEOID_ZCTA5_20 %in% tripcatch_2022_zip$ZIP)

#clean acs data for joining (thanks peiley!)
cb_acs_df_clean <- cb_acs_df %>%
  st_drop_geometry() %>%
  pivot_wider(names_from=variable,values_from=estimate) %>%
  mutate(
    #compute percent below poverty threshold -->
    # pov50 (# below 0.5) and pov 99 (# between 0.5 and 0.99)
    pov99=(pov99+pov50)/pop*100,
    pov50=pov50/pop*100,
    income=income,
    state = substr(GEOID, 1, 2))

#convert acs to zipcode level using bg_zip
zip_acs <- cb_acs_df_clean |>
  inner_join(bg_zip,by=c("GEOID"="GEOID_bg")) |>
  group_by(ZIP_final)|>
  reframe(pct_minority = (sum(black)+sum(indian)+sum(asian)+sum(hispanic))/sum(pop),
          pct_black = sum(black)/sum(pop),
          pct_50=sum(pov50)/sum(pop),#percent of ppl under half the fed poverty income threshold
          pct_100=(sum(pov50)+sum(pov99))/sum(pop),
          pct_indian = sum(indian)/sum(pop),
          pct_hispanic = sum(hispanic)/sum(pop),
          pct_asian=sum(asian)/sum(pop))#pct ppl under fed pov income threshold

#join with tripcatch by zip code
tripcatch_2022_acs <- tripcatch_2022_zip|>
  inner_join(zip_acs,by=c("ZIP"="ZIP_final"))
