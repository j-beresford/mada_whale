url<-"https://kf.kobotoolbox.org/api/v2/assets/auGernDyweh3vYtE46BjfH/data.json"

rawdata<-GET(url,authenticate(u,pw),progress())
p<-jsonlite::parse_json(rawdata)
results<-p$results

shark<-rbindlist(results,fill=TRUE)

shark<-shark%>%
  unnest_wider("begin_repeat_oxFsJYZiU")%>%
  unnest_wider("_attachments")

colnames(shark)<-str_remove_all(colnames(shark),"begin_repeat_oxFsJYZiU/")


pics<-shark%>%
  select(shark_sighting_id,known,ws_id,shark_name,download_url)


