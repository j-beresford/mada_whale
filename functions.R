##############################################
############### Raw Data #####################
##############################################

################## Trip ######################
displayTrip <- function(vars){
  trip_display = df %>%
      mutate(date=as_date(survey_start))%>%
      select(all_of(vars))%>%
      select(-survey_start)
  return(trip_display)
}
############### Megafauna #####################
displayMegaf <- function(vars){
  megaf_display = megaf_sightings %>%
        mutate(date=as_date(survey_start))%>%
        filter(megaf_or_shark=='megaf') %>%
        select(all_of(vars))
  return(megaf_display)
}
############# Shark scars data ###############
displaySharkScars <- function(vars){
    shark_scars_display<-shark_scar_sightings%>%
      select(all_of(vars))%>%
      mutate(survey_start=as_date(survey_start))%>%
      rename(date=survey_start)
    return(shark_scars_display)
}
########### shark sightings #############
displaySharkSightings <- function(vars){
  shark_sightings_display<-all_sightings%>%
      mutate(survey_start=as_datetime(survey_start))%>%
      mutate(survey_end=as_datetime(survey_end))%>%
      filter(megaf_or_shark=="shark")%>%
      select(all_of(vars))%>%
      mutate(survey_start=as_datetime(survey_start))
  shark_sightings_display
}
##############################################
############### Classifiers ##################
##############################################

mapUpdateUNClassified <- function() {
  source("mapping.R")
  uc<-shark_sightings%>%
    full_join(mapping,by="sighting_id")%>%
    group_by(sighting_id)%>%
    mutate(t=n())%>%
    ungroup()%>%
    filter(t==1)%>%
    mutate(date=as_date(survey_start))%>%
    select(all_of(map_unclassified_vars))
  return(uc)
}


mapUpdateUnusable <- function() {
  source("mapping.R")
  shark_sightings%>%
    full_join(mapping,by="sighting_id")%>%
    mutate(date=as_date(survey_start))%>%
    filter(no_id_reason %in% c("unusable_sighting")|left_id=="no"|right_id=="no")%>%
    select(all_of(map_unusable_vars))
}


mapUpdateClassified <- function() {
  source("mapping.R")
  shark_sightings%>%
    full_join(mapping,by="sighting_id")%>%
    filter(!is.na(i3s_id))%>%
    mutate(date=as_date(survey_start))%>%
    select(all_of(map_unclassified_vars))
}

is_not_allowed <- function() {
  source("mapping.R")
  not_allowed=mapping%>%
    filter(!no_id_reason %in% c("advice_needed"))
  return(not_allowed)
  }


mapUpdateKnownSharks <- function() {
  source("mapping.R")
  unique_sharks<-mapping%>%
    filter(!no_id_reason %in% c("advice_needed","unusable_sighting"))%>%
    full_join(shark_sightings,by="sighting_id")%>%
    filter(!is.na(i3s_id))%>%
    select(i3s_id,size,sex,scars,left_id,right_id,tag,drone,prey)%>%
    mutate(size=as.numeric(size))%>%
    group_by(i3s_id)%>%
    mutate("Total sightings"=n())%>%
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
    distinct()%>%
    rename("I3S ID"=i3s_id,"Size (mean)"=size,"Sex (mode)"=sex,
           "Identified scars"=scars,"Left ID"=left_id,"Right ID"=right_id,
           "Tag count"=tag,"Drone measurements"=drone,"Prey samples"=prey)
  return(unique_sharks)
}


mapUpdateUniqueTripSightings <- function() {
  source("mapping.R")
  unique_sharks<-mapping%>%
    filter(!no_id_reason %in% c("advice_needed","unusable_sighting"))%>%
    full_join(shark_sightings,by="sighting_id")%>%
    filter(!is.na(i3s_id))%>%
    mutate(date=as_date(survey_start))%>%
    select(date,i3s_id,size,sex,scars,left_id,right_id,tag,drone,prey)%>%
    mutate(size=as.numeric(size))%>%
    group_by(i3s_id,date)%>%
    mutate("Daily sightings"=n())%>%
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
    distinct()%>%
    rename(Date=date,"I3S ID"=i3s_id,"Size (mean)"=size,"Sex (mode)"=sex,
           "Identified scars"=scars,"Left ID"=left_id,"Right ID"=right_id,
           "Tag count"=tag,"Drone measurents"=drone,"Prey samples"=prey)
  return(unique_sharks)
}


get_summary_stats<-function(df){
    summary_stats<-df%>%
    mutate(Year="2022")%>%
    group_by(Year)%>%
    summarise(
          "Total sharks"=n(),
          "Sightings per shark"=round(mean(`Total sightings`),2),
            "Scar %"=round(100*mean(`Identified scars`=="yes"),2),
            "Average size"=round(mean( `Size (mean)`,na.rm=TRUE),2),
            "Male/Female ratio"=round(sum(`Sex (mode)`=="male",na.rm=TRUE)/
              sum(`Sex (mode)`=="female",na.rm=TRUE),2),
            "Tag %"=round(100*mean(`Tag count`,na.rm=TRUE),2),
            "Drone measurement %"=round(100*mean(`Drone measurements`,na.rm=TRUE),2),
            "Prey sample %"=round(100*mean(`Prey samples`,na.rm=TRUE),2))}

