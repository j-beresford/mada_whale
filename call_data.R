url<-"https://kf.kobotoolbox.org/api/v2/assets/avrGxX9DAKuDYcNf5oq52t/data.json"


u<-"madawhale"
pw<-"W3dn3sday1!"
rawdata<-GET(url,authenticate(u,pw),progress())
print(paste0("Status Code: ",rawdata$status_code))

p<-jsonlite::parse_json(rawdata)

# Nearly there but containts a couple of lists
results<-p$results

df<-rbindlist(results, fill = TRUE)

dfm<-df%>%
  select(Enter_a_date,
        Why_don_t_you_fill_i_some_free_form_text,Record_your_current_location,
        Point_and_shoot_Use_mera_to_take_a_photo,
        What_color_was_it)%>%
  distinct()