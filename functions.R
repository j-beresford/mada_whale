mapUpdateUNClassified <- function() {
  source("mapping.R")
  uc<-shark_sightings%>%
    mutate(trip_id=as.numeric(trip_id))%>%
    full_join(trip_display,by="trip_id")%>%
    full_join(mapping,by="sighting_id")%>%
    filter(!no_id_reason %in% c("unusable_sighting"))%>%
    filter(is.na(i3s_id))
  return(uc)
}


mapUpdateUnusable <- function() {
  source("mapping.R")
  shark_sightings%>%
    mutate(trip_id=as.numeric(trip_id))%>%
    full_join(trip_display,by="trip_id")%>%
    full_join(mapping,by="sighting_id")%>%
    filter(no_id_reason %in% c("unusable_sighting"))
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
    select(i3s_id,size,scars,left_id,right_id,tag,drone,prey)%>%
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
    select(trip_id,i3s_id,size,scars,left_id,right_id,tag,drone,prey)%>%
    mutate(size=as.numeric(size))%>%
    group_by(i3s_id,trip_id)%>%
    mutate(scars=if_else(sum(scars=="yes",na.rm=TRUE)>0,"yes","no"))%>%
    mutate(left_id=if_else(sum(left_id=="yes",na.rm=TRUE)>0,"yes","no"))%>%
    mutate(right_id=if_else(sum(right_id=="yes",na.rm=TRUE)>0,"yes","no"))%>%
    mutate(tag=sum(tag=="yes",na.rm=TRUE))%>%
    mutate(drone=sum(drone=="yes",na.rm=TRUE))%>%
    mutate(prey=sum(prey=="yes",na.rm=TRUE))%>%
    mutate(size=mean(size,na.rm=TRUE))%>%
    mutate(sightings=n())%>%
    ungroup()%>%
    distinct()
  return(unique_sharks)
}