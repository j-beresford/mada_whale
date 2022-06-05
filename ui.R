rm(list=ls())
source("packages.R")
source("login_creds.R")
source("call_data.R")
source("call_photos.R")
source("merges.R")

fluidPage(
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),

  
  navbarPage(title = "Mada Whale Shark Project",collapsible = TRUE,
             
    tabPanel("About",h3("Mada whale shark project"),
                      h5("Here is some blah blah about whale sharks")),

    tabPanel("Graphs",h3("Graphs for survey data"),
                      sidebarPanel(h3("Filters"),
                                   selectInput("sel_frame",
                                                label = h5("Fauna"),
                                                choices = list("Other fauna",
                                                               "Megafauna",
                                                               "Sharks"))),
                      mainPanel(plotOutput('plot',height="10"))),
    tabPanel("Sightings Data",h3("View and download data"),
                      sidebarPanel(selectInput("dataset", 
                                           label = h3("Select Dataset"), 
                                           choices = list("Dives",
                                                          "Shark sightings",
                                                          "Shark scar sightings",
                                                          "Megafauna sightings"),
                                             selected = "Shark sightings"),
                                   downloadButton("downloadData", "Download")),
                      mainPanel(DTOutput('table'))),
    
    tabPanel("Unclassified sharks",
             h3("Sightings needing classification"),
             h5("Sharks shown here have a sighting ID, but no photos or ws.org ID"),
             DTOutput("unknown_sharks")),
    
    tabPanel("Known sharks",h3("One row per identified shark"),
             DTOutput("known_sharks"))
    
  )
) 
  