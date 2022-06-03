## Tidy tables for display
######### Trip ################
trip_vars<-c("trip_id","observer","operator","guide","day_type","meteo","sst","sea_state","visibility","meduses","salpes","krill","trichodesmium","trichodesmium_pct")
trip_display <- trip %>% select(all_of(trip_vars))

########### shark sightings #############
shark_sightings_vars<-c("left_id","right_id","sex","size","scars","localisation","taille_chasse","behaviour","code_of_conduct","avoidance_behaviour","end_encounter","boats_min","boats_max","biopsy","tag","tag_no","prey","prey_tube_number","prey_bio_tube_no","shark_name_known","shark_uuid")
# biopsy number doesn't show here...
shark_sightings_display <- shark_sightings %>% 
  select(all_of(shark_sightings_vars))%>%
  rename(sighting_id=shark_uuid)%>%
  mutate(sighting_id=str_remove_all(sighting_id,"uuid:"))

##### Megafauna data ########

##### Shark scars data ########



##### Merge tables ######
unknown_sharks<-pics%>%
  mutate(shark_sighting_id=str_remove_all(shark_sighting_id,"uuid:"))%>%
  rename(sighting_id=shark_sighting_id)%>%
  full_join(shark_sightings_display,by="sighting_id")%>%
  filter(is.na(known))%>%
  select(sighting_id,shark_name_known)

  
