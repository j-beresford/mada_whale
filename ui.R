rm(list=ls())
source("packages.R")
source("login_creds.R")
source("call_data.R")
source("mapping.R")
source("merges.R")


fluidPage(
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),

  
  navbarPage(title = "Mada Whale Shark Project",collapsible = TRUE,
             
    tabPanel("About",
             h3("Mada whale shark project"),
             p("This website is an internal tool designed to have several uses:"),                     p("(a) viewing survey output tables,"),
             p("(b) automatically producing datasummaries and visualisations,"),
             p("(c) assigning shark IDs to sightings")
           ),
    
    tabPanel("Raw Data",h3("View and download data"),
             sidebarPanel(selectInput("dataset", 
                                      label = h3("Select Dataset"), 
                                      choices = list("Dives",
                                                     "Shark sightings",
                                                     "Shark scar sightings",
                                                     "Megafauna sightings"),
                                      selected = "Shark sightings"),
                          downloadButton("downloadData", "Download")),
             mainPanel(DTOutput('table'))),
    
    navbarMenu("Sightings",
         tabPanel("Unclassified",
            h3("Sightings needing classification"),
            h5("Sharks shown here have a sighting ID, but no photos or ws.org ID"),
            DTOutput("unclassified_sightings")),
         tabPanel("Unusable",
                  h3("Sightings needing classification"),
                  h5("Sharks shown here have a sighting ID, but no photos or ws.org ID"),
                  DTOutput("unusable_sightings")),
         tabPanel("Classified",
            h3("One row per identified shark"),
            DTOutput("classified_sightings"))
         
    ),
    
    tabPanel("Classification form",
             h4("This form links our sighting IDs with I3S shark IDs"),
             selectizeInput("sighting_id", "Enter sighting ID", 
                         choices = unknown_sharks$sighting_id),
             textInput("i3s_id", "Enter I3S ID", ""),
             radioButtons("no_id_reason","File as:",
                choices = list(
                            "Done - I3S ID provided"=NA,  
                            "To do - Bad photo/need advice"="advice_needed",
                            "Discarded - Photo is unusable"="unusable_sighting"),
                selected = NA),
             helpText("If you have an I3S ID, leave as default",
                      "If no I3S ID, leave Q2 blank and select a reason."),
             actionButton("submit", "Submit"),
             tags$hr(),
             DT::dataTableOutput("responses")),
    
    tabPanel("Clean data",
             sidebarPanel(selectInput("clean_dataset", 
                  label = h3("Select Dataset"), 
                  choices = list("Known sharks"),
                  selected = "Known sharks")),
             h3("Table with clean data")),
      
    
    tabPanel("Graphs",h3("Graphs for survey data"),
             sidebarPanel(h3("Filters"),
                          selectInput("sel_frame",
                                      label = h5("Fauna"),
                                      choices = list("Other fauna",
                                                     "Megafauna",
                                                     "Sharks"))),
             mainPanel(plotOutput('plot',height="10")))
  )
) 
