source("packages.R")
source("call_data.R")

fluidPage(
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),

  
  navbarPage(title = "Mada Whale Shark Project",collapsible = TRUE,
    tabPanel("About",h3("Mada whale shark project"),
                      h5("Here is some blah blah about whale sharks")),
    tabPanel("Graphs",h3("Graphs for survey data"),
                      sidebarPanel(h3("Filters"),
                                   dateRangeInput("dates",
                                                  label = h5("Date range"))),
                      mainPanel(plotOutput('plot'))),
    tabPanel("Data Tables",h3("View and download data"),
                      sidebarPanel(h3("Filters"),
                                   dateRangeInput("Dates",
                                                  label = h5("Date range")),
                                   downloadButton("downloadData","Download")),
                      mainPanel(tableOutput('table')))
  )
) 
  