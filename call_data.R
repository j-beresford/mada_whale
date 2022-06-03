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
shark<-unlist(rb,recursive = FALSE)
names(shark)<-trip$trip_id
shark<-lapply(shark, function(x) rbindlist(x,fill = TRUE))
shark<-rbindlist(shark,fill=TRUE,idcol='trip_id')
colnames(shark)<-str_remove_all(colnames(shark),"rb_repeat/")

shark_sightings<-shark%>%
  select(-scar_number)%>%
  distinct()

shark_scars<-shark%>%
  unnest_wider(scar_number)


