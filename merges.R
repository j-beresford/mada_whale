# 
# 
# 
# #### Merge tables ######
# sharks<-shark_sightings%>%
#    mutate(trip_id=as.numeric(trip_id))%>%
#    full_join(trip_display,by="trip_id")%>%
#    full_join(mapping,by="sighting_id")
# 
# ##### MEGA Table #########
# mega<-trip%>%
#   mutate(trip_id=as.character(trip_id))%>%
#   full_join(shark_sightings,by="trip_id")%>%
#   mutate(survey_start=as_datetime(survey_start))%>%
#   mutate(survey_end=as_datetime(survey_end))%>%
#   select(-"formhub/uuid",-"client_identifier",-"meta/instanceID",-"_xform_id_string",-"_uuid",-"__version__",-"_submission_time",-"_submitted_by",-"_status",-"sighting_number")
# 
# ########### shark sightings #############
# shark_sightings_display <- mega %>% 
#   select(all_of(shark_sightings_vars))%>%
#   mutate(survey_start=as_datetime(survey_start))
