raw <- read_excel("backdata/MWSP_2019 Masterfile Final.xlsx", sheet = "WS_2019")


raw<-raw%>%
  mutate(Date=as_date(Date))%>%
  select(-...26,-...27)


trip=c("Date","Heure","Type de sortie",
       "Scientifique","Guide","Person","Nom","Nombre de bateaux","Waypoint",
       "Fin de la rencontre")

shark_identifiers=c("Sexe","Taille","Link whaleshark.org","ID ws.org",
                    "ID Gauche","ID Droite","Cicatrices","Partie cicatrices",
                    "Cicatrice 2","Partie cicatrices 2","Photo sexe",
                    "Stereo-video","Biopsie","Historique","Taille")

shark_behaviour=c("Taille chasse","Comportement","Alimentation",
                  "Notes si 'Autre'","Notes","Vu avec un autre requin")

admin=c("Scan","Added to 2019 cat","Added to All_cat","Charte","Match cat")


dives<-raw%>%select(trip)%>%distinct()
known_sharks<-raw%>%select(all_of(shark_identifiers))%>%distinct()
shark_sightings<-raw%>%select(all_of(shark_behaviour))%>%distinct()
trip_admin<-raw%>%select(all_of(admin))%>%distinct()

