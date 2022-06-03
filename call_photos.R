url<-"https://kf.kobotoolbox.org/api/v2/assets/auGernDyweh3vYtE46BjfH/data.json"

rawdata<-GET(url,authenticate(u,pw),progress())
p<-jsonlite::parse_json(rawdata)
results<-p$results

pics<-rbindlist(results,fill=TRUE)

pics<-pics%>%
  unnest_wider("begin_repeat_oxFsJYZiU")%>%
  unnest_wider("_attachments")

colnames(pics)<-str_remove_all(colnames(pics),"begin_repeat_oxFsJYZiU/")


pics<-pics%>%
  select(shark_sighting_id,known,ws_id,shark_name,download_url)


