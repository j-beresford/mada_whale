url<-"https://kf.kobotoolbox.org/api/v2/assets/aJ5NwkApvziLAUE7i9eHcn/data.json"

# Call form_meta API and Parse JSON
rawdata<-GET(url,authenticate(u,pw),progress())
p<-jsonlite::parse_json(rawdata)
results<-p$results

lists<-c("megaf_repeat", "rb_repeat","_attachments","_geolocation","_tags","_notes","_validation_status")

trip<-lapply(results, function(x) x[!(names(x) %in% lists)])
trip<-rbindlist(trip,fill=TRUE)
colnames(trip)<-str_remove_all(colnames(trip),"Faune/")
trip<-trip%>%rename("trip_id"="_id")

megaf_sightings<-lapply(results, function(x) x[(names(x)=="megaf_repeat")])
names(megaf_sightings)<-trip$trip_id
megaf_sightings<-rbindlist(megaf_sightings,idcol="trip_id")
megaf_sightings<-megaf_sightings%>%unnest_wider(megaf_repeat)
colnames(megaf_sightings)<-str_remove_all(colnames(megaf_sightings),"megaf_repeat/")

rb<-lapply(results, function(x) x[(names(x)=="rb_repeat")])
shark_sightings<-unlist(rb,recursive = FALSE)
names(shark_sightings)<-trip$trip_id
shark_sightings<-lapply(shark_sightings, function(x) rbindlist(x,fill = TRUE))
shark_sightings<-rbindlist(shark_sightings,fill=TRUE,idcol='trip_id')
colnames(shark_sightings)<-str_remove_all(colnames(shark_sightings),"rb_repeat/")

shark_scars<-shark_sightings%>%
  unnest_wider(scar_number)%>%
  select(trip_id,shark_uuid,starts_with("rb_rep"))%>%
  rename(sighting_id=shark_uuid)%>%
  mutate(sighting_id=str_remove_all(sighting_id,"uuid:"))


shark_sightings<-shark_sightings%>%
  select(-scar_number)%>%
  distinct()%>%
  rename(sighting_id=shark_uuid)%>%
  mutate(sighting_id=str_remove_all(sighting_id,"uuid:"))


colnames(shark_scars)<-str_remove_all(colnames(shark_scars),"rb_repeat\\/scar_number\\/")

