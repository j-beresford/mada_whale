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

    tabPanel("Photos",h3("ID images"),
             uiOutput("picture")),
    
    tabPanel("Graphs",h3("Graphs for survey data"),
                      sidebarPanel(h3("Filters"),
                                   selectInput("sel_frame",
                                                label = h5("Fauna"),
                                                choices = list("Other fauna",
                                                               "Megafauna",
                                                               "Sharks"))),
                      mainPanel(plotOutput('plot',height="10"))),
    tabPanel("Data Tables",h3("View and download data"),
                      sidebarPanel(selectInput("dataset", 
                                           label = h3("Select Dataset"), 
                                           choices = list("Dive details",
                                                          "Shark sightings",
                                                          "Shark scars",
                                                          "Megafauna sightings",
                                                          "Photo IDs"),
                                             selected = "Shark sightings"),
                                   downloadButton("downloadData", "Download")),
                      mainPanel(DTOutput('table'))),
    
    tabPanel("Outstanding sharks",
             h3("sightings needing classification"),
             h5("Sharks shown here have a sighting ID, but no photos or ws.org ID"),
             DTOutput("unknown_sharks"))
    
    
  )
) 
  