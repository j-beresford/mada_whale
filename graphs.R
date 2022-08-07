daily_dives_sst<-displayTrip(trip_vars)%>%
  mutate(sst=as.numeric(sst))%>%
  group_by(date)%>%
  summarise(mean_sst=mean(sst,na.rm=TRUE),trips=n())%>%
  ungroup()%>%
  ggplot(aes(date,trips,fill=mean_sst))+
  geom_col()+
  scale_fill_distiller(type = "seq",palette = "Blues",direction = 1)+
  theme_minimal()+
  theme(text = element_text(size=14),
        panel.grid = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())+
  labs(y="Daily Dives",x="",fill="Sea surface temperature")

sightings_sex <-mapUpdateUniqueTripSightings()%>%
  mutate(`Sex (mode)`=if_else(is.na(`Sex (mode)`),"undetermined",`Sex (mode)`))%>%
  ggplot(aes(Date,fill=`Sex (mode)`))+
  geom_bar(stat = "count")+
  theme_minimal()+
  theme(text = element_text(size=14),
        panel.grid = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())+
  scale_fill_brewer(type="qual",palette = "Pastel1")+
  labs(y="Unique daily sightings",x="")

megaf_all<-megaf_sightings%>%
  mutate(espece=str_replace_all(espece,"_"," "))%>%
  mutate(espece=fct_infreq(espece))%>%
  mutate(espece=str_to_title(espece))%>%
  mutate(date=as_date(survey_start))%>%
  ggplot(aes(date,fill=espece))+
  geom_bar(stat="count",fill="#00BCFF")+
  facet_wrap(.~espece)+
  theme_minimal()+
  theme(legend.position = "none",
        strip.background = element_rect(fill="#00BCFF",color="white"),
        strip.text = element_text(color="white",size=14),
        text = element_text(size=14),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())+
  labs(x="",y="Number of sightings")



correls<-displayTrip(trip_vars)%>%
  select(all_sightings,sst,meteo,sea_state,trichodesmium_pct)%>%
  rename(sea_surface_temperature=sst)%>%
  gather(key=var,value=val,-all_sightings)%>%
  ggplot(aes(val,all_sightings))+
  geom_point(color="#00BCFF")+
  geom_smooth(method="lm",color="#00BCFF",se=TRUE,fill="lightblue",size=0.5)+
  facet_wrap(.~var,scales = "free")+
  theme_minimal()+
  theme(legend.position = "none",
        strip.background = element_rect(fill="#00BCFF",color="white"),
        strip.text = element_text(color="white",size=14),
        text = element_text(size=14),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())+
  labs(x="",y="Number of sightings")




labs=data.frame(
  long=c(45,45.4,45.2),
  lat=c(-14,-14.2,-13.8),
  group=c(1,1,1),
  type=c("shark","shark","megafauna"))


map<-map_data("world","Madagascar")%>%
  mutate(subregion=if_else(is.na(subregion),"Mainland",subregion))%>%
  mutate(subregion=fct_reorder(subregion,lat,mean))%>%
  ggplot(aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill=subregion))+
  coord_fixed(1.3)+
  geom_point(data=labs, aes(x=long, y=lat,color=type),size=2)+
  scale_fill_brewer(palette = "Accent")+
  theme_void()+
  labs(fill="",color="")

