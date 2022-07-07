###### Get mapping file
gs4_auth(cache=".secrets", 
         email="justintberesford@gmail.com")


mapping<-read_sheet(gs4_get("https://docs.google.com/spreadsheets/d/1yx7zDs0S4H9gK78mAab2-eyy__AbG84ZpBOy9mbM6Vk/edit#gid=0"))

