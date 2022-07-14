mapUpdateUNClassified <- function() {
  source("mapping.R")
  uc<-shark_sightings%>%
    mutate(trip_id=as.numeric(trip_id))%>%
    full_join(trip_display,by="trip_id")%>%
    full_join(mapping,by="sighting_id")%>%
    filter(!no_id_reason %in% c("unusable_sighting")&
           is.na(i3s_id)&
           (left_id=="yes"|right_id=="yes"))
  return(uc)
}


mapUpdateUnusable <- function() {
  source("mapping.R")
  shark_sightings%>%
    mutate(trip_id=as.numeric(trip_id))%>%
    full_join(trip_display,by="trip_id")%>%
    full_join(mapping,by="sighting_id")%>%
    filter(no_id_reason %in% c("unusable_sighting")|left_id=="no")
}


mapUpdateClassified <- function() {
  source("mapping.R")
  shark_sightings%>%
    mutate(trip_id=as.numeric(trip_id))%>%
    full_join(trip_display,by="trip_id")%>%
    full_join(mapping,by="sighting_id")%>%
    filter(!is.na(i3s_id))
}


mapUpdateKnownSharks <- function() {
  source("mapping.R")
  unique_sharks<-shark_sightings%>%
    mutate(trip_id=as.numeric(trip_id))%>%
    full_join(trip_display,by="trip_id")%>%
    full_join(mapping,by="sighting_id")%>%
    filter(!is.na(i3s_id))%>%
    select(i3s_id,size,sex,scars,left_id,right_id,tag,drone,prey)%>%
    mutate(size=as.numeric(size))%>%
    group_by(i3s_id)%>%
    mutate(scars=if_else(sum(scars=="yes",na.rm=TRUE)>0,"yes","no"))%>%
    mutate(left_id=if_else(sum(left_id=="yes",na.rm=TRUE)>0,"yes","no"))%>%
    mutate(right_id=if_else(sum(right_id=="yes",na.rm=TRUE)>0,"yes","no"))%>%
    mutate(tag=sum(tag=="yes",na.rm=TRUE))%>%
    mutate(drone=sum(drone=="yes",na.rm=TRUE))%>%
    mutate(prey=sum(prey=="yes",na.rm=TRUE))%>%
    mutate(size=mean(size,na.rm=TRUE))%>%
    mutate(sightings=n())%>%
    mutate(sex=case_when(
      mean(sex=="male",na.rm=TRUE)>mean(sex=="female",na.rm=TRUE)~"male",
      mean(sex=="male",na.rm=TRUE)<mean(sex=="female",na.rm=TRUE)~"female",
      mean(sex=="male",na.rm=TRUE)==mean(sex=="female",na.rm=TRUE)~"Undetermined"))%>%
    ungroup()%>%
    distinct()
  return(unique_sharks)
}


mapUpdateUniqueTripSightings <- function() {
  source("mapping.R")
  unique_sharks<-shark_sightings%>%
    mutate(trip_id=as.numeric(trip_id))%>%
    full_join(trip_display,by="trip_id")%>%
    full_join(mapping,by="sighting_id")%>%
    filter(!is.na(i3s_id))%>%
    select(date,i3s_id,size,sex,scars,left_id,right_id,tag,drone,prey)%>%
    mutate(size=as.numeric(size))%>%
    group_by(i3s_id,date)%>%
    mutate(scars=if_else(sum(scars=="yes",na.rm=TRUE)>0,"yes","no"))%>%
    mutate(left_id=if_else(sum(left_id=="yes",na.rm=TRUE)>0,"yes","no"))%>%
    mutate(right_id=if_else(sum(right_id=="yes",na.rm=TRUE)>0,"yes","no"))%>%
    mutate(tag=sum(tag=="yes",na.rm=TRUE))%>%
    mutate(drone=sum(drone=="yes",na.rm=TRUE))%>%
    mutate(prey=sum(prey=="yes",na.rm=TRUE))%>%
    mutate(size=mean(size,na.rm=TRUE))%>%
    mutate(sex=case_when(
      mean(sex=="male",na.rm=TRUE)>mean(sex=="female",na.rm=TRUE)~"male",
      mean(sex=="male",na.rm=TRUE)<mean(sex=="female",na.rm=TRUE)~"female",
      mean(sex=="male",na.rm=TRUE)==mean(sex=="female",na.rm=TRUE)~"Undetermined"))%>%
    ungroup()%>%
    distinct()
  return(unique_sharks)
}