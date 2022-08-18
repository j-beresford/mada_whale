daily_dives_sst<-displayTrip(trip_vars)%>%
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
  mutate(`Sex (mode)`=if_else(is.na(`Sex (mode)`),"Undetermined",`Sex (mode)`))%>%
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




map<-map_data("world","Madagascar")%>%
  filter(!subregion  %in% c("Ile Sainte-Marie"))%>%
  mutate(subregion=if_else(is.na(subregion),"Mainland",subregion))%>%
  mutate(subregion=fct_reorder(subregion,lat,mean))%>%
  ggplot(aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill=subregion))+
  theme(panel.background = element_rect(fill = "lightblue"),
        panel.grid = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank())+
  coord_fixed(1.3)+
  scale_fill_manual(values = c("darkgreen","red"))+
  labs(fill="",color="",x="",y="")

megaf_cords=megaf_sightings%>%
  filter(!is.na(megaf_geo))%>%
  mutate(lat=word(megaf_geo,1))%>%
  mutate(long=word(megaf_geo,2))%>%
  mutate(group=1)%>%
  select(espece,group,megaf_count,megaf_number,long,lat)%>%
  mutate(espece=factor(espece))%>%
  mutate(long=as.numeric(long))%>%
  mutate(lat=as.numeric(lat))
  
megaf_map<-map+geom_point(data=megaf_cords, aes(x=long, y=lat,color=espece),
                          alpha=0.5,size=1)
megaf_map<-ggplotly(megaf_map)%>%layout(height=600,width=600)

megaf_density<-map+geom_density2d(data=megaf_cords,aes(x=long, y=lat))
megaf_density<-ggplotly(megaf_density)%>%layout(height=600,width=600)


shark_cords=shark_sightings%>%
  filter(!is.na(shark_geo))%>%
  mutate(lat=word(shark_geo,1))%>%
  mutate(long=word(shark_geo,2))%>%
  mutate(group=1)%>%
  select(sex,size,scars,code_of_conduct,long,lat,group)%>%
  mutate(long=as.numeric(long))%>%
  mutate(lat=as.numeric(lat))

shark_map<-map+geom_point(data=shark_cords, aes(x=long, y=lat,color=sex),
                          alpha=0.5,size=1)
shark_map<-ggplotly(shark_map)%>%layout(height=600,width=600)

shark_density<-map+geom_density2d(data=shark_cords,aes(x=long, y=lat))
shark_density<-ggplotly(shark_density)%>%layout(height=600,width=600)


