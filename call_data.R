url<-"https://kf.kobotoolbox.org/api/v2/assets/aJ5NwkApvziLAUE7i9eHcn/data.json"

# Call form_meta API and Parse JSON
rawdata<-GET(url,authenticate(u,pw),progress())
p<-jsonlite::parse_json(rawdata)
results<-p$results

df<-tibble(list_col=results)%>%
  hoist(list_col,'sighting_repeat')%>%
  hoist(list_col,'_attachments')%>%
  hoist(list_col,'_geolocation')%>%
  hoist(list_col,'_tags')%>%
  hoist(list_col,'_notes')%>%
  hoist(list_col,'_validation_status')%>%
  unnest_wider('_geolocation')%>%
  unnest_wider(list_col)%>%
  rename("trip_id"="_id")%>%
  rename_with(~str_remove(., 'Faune/'))

factors<-c("operator","trip_id","sighting_id","observer","left_id","right_id","sex","scars","localisation","taille_chasse","behaviour","code_of_conduct","avoidance_behaviour","end_encounter","biopsy")


numbers<-c("sighting_number","size","boats_min","boats_max")

all_sightings=df%>%
  unnest_longer(sighting_repeat)%>%
  unnest_wider(sighting_repeat)%>%
  rename_with(~str_remove(., 'sighting_repeat/'))%>%
  rename(sighting_id=shark_uuid)%>%
  mutate(sighting_id=str_remove_all(sighting_id,"uuid:"))%>%
  mutate(sighting_id=str_sub(sighting_id,1,13))%>%
  mutate_at(factors,factor)%>%
  mutate_at(numbers,as.numeric)


shark_sightings=all_sightings%>%
  filter(megaf_or_shark=="shark")

megaf_sightings=all_sightings%>%
  filter(megaf_or_shark=="megaf")



shark_scar_sightings<-shark_sightings%>%
  filter(scars=="yes")%>%
  unnest_longer(scar_number)%>%
  unnest_wider(scar_number)%>%
  rename_with(~str_remove(., 'sighting_repeat/scar_number/'))
