source("login_creds.R")

url<-"https://kf.kobotoolbox.org/api/v2/assets/aJ5NwkApvziLAUE7i9eHcn/data.json"

# Call API and Parse JSON
rawdata<-GET(url,authenticate(u,pw),progress())
p<-jsonlite::parse_json(rawdata)
results<-p$results

lists<-c("megaf_repeat", "rb_repeat","_attachments","_geolocation","_tags","_notes","_validation_status")

trip<-lapply(results, function(x) x[!(names(x) %in% lists)])
trip<-rbindlist(trip,fill=TRUE)
colnames(trip)<-str_remove_all(colnames(trip),"Faune/")


megaf_sightings<-lapply(results, function(x) x[(names(x)=="megaf_repeat")])
megaf_sightings<-rbindlist(megaf_sightings)
megaf_sightings<-megaf_sightings%>%unnest_wider(megaf_repeat)
colnames(megaf_sightings)<-str_remove_all(colnames(megaf_sightings),"megaf_repeat/")
# Add ID, dates etc...

rb<-lapply(results, function(x) x[(names(x)=="rb_repeat")])
shark<-unlist(rb,recursive = FALSE)
shark<-lapply(shark, function(x) rbindlist(x,fill = TRUE))
names(shark)<-trip$`meta/instanceID`
shark<-rbindlist(shark,fill=TRUE,idcol='instanceID')
colnames(shark)<-str_remove_all(colnames(shark),"rb_repeat/")

shark_sightings<-shark%>%
  select(-scar_number)%>%
  distinct()

shark_scars<-shark%>%
  unnest_wider(scar_number)

