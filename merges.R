## Tidy tables for display
######### Trip ################
trip_vars<-c("trip_id","observer","operator","guide","day_type","meteo","sst","sea_state","visibility","meduses","salpes","krill","trichodesmium","trichodesmium_pct")
trip_display <- trip %>% select(all_of(trip_vars))

########### shark sightings #############
shark_sightings_vars<-c("left_id","right_id","sex","size","scars","localisation","taille_chasse","behaviour","code_of_conduct","avoidance_behaviour","end_encounter","boats_min","boats_max","biopsy","tag","tag_no","prey","prey_tube_number","prey_bio_tube_no","shark_name_known")
# biopsy number doesn't show here...
shark_sightings_display <- shark_sightings %>% 
  select(all_of(shark_sightings_vars))


##### Megafauna data ########
megaf_vars<-c("espece",'espece_other',"megaf_count","megaf_notes")
megaf_sightings_display <- megaf_sightings %>% 
  select(all_of(megaf_vars))

##### Shark scars data ########
shark_scars_display<-shark_scars%>%
  select(-trip_id,-scar_id,-id_test)

##### Merge tables ######
sharks<-pics%>%
  mutate(shark_sighting_id=str_remove_all(shark_sighting_id,"uuid:"))%>%
  rename(sighting_id=shark_sighting_id)%>%
  full_join(shark_sightings,by="sighting_id")

unknown_sharks<-sharks%>%
  filter(is.na(known))

known_sharks<-sharks%>%
  filter(!is.na(known))%>%
  select(-known)

known_sharks$download_url <- paste0("<a href='",known_sharks$download_url,"'>Photo","</a>")

known_sharks$download_url

##### MEGA Table #########
mega<-trip%>%
  mutate(trip_id=as.character(trip_id))%>%
  full_join(shark_sightings,by="trip_id")%>%
  mutate(survey_start=as_datetime(survey_start))%>%
  mutate(survey_end=as_datetime(survey_end))%>%
  select(-"formhub/uuid",-"client_identifier",-"meta/instanceID",-"_xform_id_string",-"_uuid",-"__version__",-"_submission_time",-"_submitted_by",-"_status",-"sighting_number")


shark_scars
