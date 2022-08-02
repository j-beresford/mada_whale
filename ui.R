rm(list=ls())
source("packages.R")
source("login_creds.R")
source("call_data.R")
source("mapping.R")
source("table_vars.R")
source("functions.R")

library(shinythemes)

fluidPage(theme=shinytheme("cerulean"),
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),

  
  navbarPage(title = "NatureDB",collapsible = TRUE,
    navbarMenu("About",
      tabPanel("Instructions",
        h3("The dashboard"),
        uiOutput("about_naturedb"),
        h3("Instructions"),
        uiOutput("about_instructions"),
        img(src="requin-baleine.jpg",width="100%")
               ),
    tabPanel("Field Collect",
        h3("Field Collect"),
        uiOutput("about_fieldcollect"))),
    
    tabPanel("Raw Data",h3("View and download raw data"),
             sidebarPanel(selectizeInput("dataset", 
                                      label = h3("Select Dataset"), 
                                      choices = list("Dives",
                                                     "Shark sightings",
                                                     "Shark scar sightings",
                                                     "Megafauna sightings"),
                                      selected = "Shark sightings"),
                          downloadButton("downloadData", "Download"),
                          width=3),
             mainPanel(DTOutput('table'),width=9)),
    
    navbarMenu("Sightings",
         tabPanel("Unclassified",
            h3("All sightings still needing classification"),
            h5("Sharks shown here have a sighting ID, but no photos or ws.org ID"),
            checkboxInput("show_advice_needed",
                          label = "Show advice needed",
                          value=FALSE),
            DTOutput("unclassified_sightings")),
         tabPanel("Unusable",
                  h3("All sightings that can't be classified"),
                  h5("Sharks shown here have a sighting ID, but no photos or ws.org ID"),
                  DTOutput("unusable_sightings")),
         tabPanel("Classified",
            h3("All sightings that have been classified"),
            DTOutput("classified_sightings"))
         
    ),
    
    tabPanel("Classifier",
             sidebarPanel(
             h4("Classification Form"),
             selectizeInput("sighting_id", "Enter sighting ID", 
                      choices = mapUpdateUNClassified()%>%
                        pull(sighting_id),
                      options = list(
                        placeholder = 'Please type or copy/paste ID',
                        onInitialize = I('function() { this.setValue(""); }'))),
             uiOutput("sighting_observer"),
             br(),
             textInput("i3s_id", "Enter I3S ID", ""),
             radioButtons("no_id_reason","File as:",
                choices = list(
                            "Done - I3S ID provided"="",  
                            "To do - Bad photo/need advice"="advice_needed",
                            "Discarded - Photo is unusable"="unusable_sighting"),
                selected = ""),
             uiOutput("error_message"),
             hr(),
             actionButton("submit", "Submit")),
             mainPanel(
               h4("Mapping file"),
               DT::dataTableOutput("responses"))),
    navbarMenu("Clean data",
    tabPanel("Summary Stats",
             h3("Summary Statistics"),
             p("Unique sharks grouped by year"),
             DTOutput("summary_stats")),
    tabPanel("Unique sharks",
             sidebarPanel(selectInput("clean_dataset", 
                                      label = h3("Select Dataset"), 
                                      choices = list("Known sharks",
                                                     "Unique daily sightings")),
                          downloadButton("downloadCleanData", "Download"),
                          width=3),
             mainPanel(DTOutput('table_clean'),width=9))),
    
    tabPanel("Graphs",
             mainPanel(
               tabsetPanel(
                 tabPanel("Trips",plotOutput('plotTrip',height="400")),
                 tabPanel("Sightings",plotOutput('plotSightings',height="400")),
                 tabPanel("Megafauna",plotOutput('plotMegaf',height="400"))
               )))
  )
) 
