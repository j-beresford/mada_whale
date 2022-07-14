gs4_auth(cache=".secrets", 
         email="justintberesford@gmail.com")


ss <- gs4_get("https://docs.google.com/spreadsheets/d/1yx7zDs0S4H9gK78mAab2-eyy__AbG84ZpBOy9mbM6Vk/edit#gid=0")


saveData <- function(data) {
  # The data must be a dataframe rather than a named vector
  data <- data %>% as.list() %>% data.frame()
  # Add the data as a new row
  sheet_append(ss, data)
}

loadData <- function() {
  # Read the data
  read_sheet(ss)
}

# Define the fields we want to save from the form
fields <- c("sighting_id", "i3s_id","no_id_reason")


function(input, output, session) {
  
  formData <- reactive({
    data <- sapply(fields, function(x) input[[x]])
    data
  })
  
  # When the Submit button is clicked, save the form data
  observeEvent(input$submit, {
    saveData(formData())
  })
  
  # Show the previous responses
  # (update with current response when Submit is clicked)
  output$responses <- DT::renderDataTable({
    input$submit
    loadData()
  })
  
  ############### Data raw download ###############
  
  ## Table selection
  datasetInput <- reactive({
    switch(input$dataset,
           "Dives" = trip_display,
           "Shark sightings" = shark_sightings_display,
           "Shark scar sightings" = shark_scars_display,
           "Megafauna sightings" = megaf_sightings_display
    )
  })
  
  ## Show table (main panel)
  output$table <- renderDT(
    {datasetInput()},
    filter = "top",
    options = list(
      pageLength = 10,
      scrollX=TRUE
    )
  )
  
  
  ## Download CSV
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$dataset, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(datasetInput(), file, row.names = FALSE)
    }
  )
  
  ###############Classification form###############################


  ############# Sightings (class, unclass, unusable) ##########
  
  ## Show table (unknown)
  output$unclassified_sightings <- renderDataTable({
    input$submit
    mapUpdateUNClassified()},
    options = list(scrollX=TRUE, scrollCollapse=TRUE)
  )
  
  ## Show table (unusable sightings)
  output$unusable_sightings <- renderDataTable({
    input$submit
    mapUpdateUnusable()},
    options = list(scrollX=TRUE, scrollCollapse=TRUE)
  )
  
  ## Show table (known)
  output$classified_sightings <- renderDataTable({
    input$submit
    mapUpdateClassified()},
    options = list(scrollX=TRUE, scrollCollapse=TRUE)
  )

  ############### Clean data download ###############
  
  ## Table selection
  cleanDatasetInput <- reactive({
    switch(input$clean_dataset,
           "Known sharks" = mapUpdateKnownSharks(),
           "Unique daily sightings" = mapUpdateUniqueTripSightings()
    )
  })
  
  ## Show table (main panel)
  output$table_clean <- renderDT(
    {cleanDatasetInput()},
    filter = "top",
    options = list(
      pageLength = 10,
      scrollX=TRUE
    )
  )
  
  
  ## Download CSV
  output$downloadCleanData <- downloadHandler(
    filename = function() {
      paste(input$clean_dataset, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(cleanDatasetInput(), file, row.names = FALSE)
    }
  )
  
  ### Graphs ####
  
  output$plotTrip <- renderPlot({
  start_date=trip_display%>%filter(date==min(date))%>%select(date)%>%distinct()%>%pull()
  end_date=trip_display%>%filter(date==max(date))%>%select(date)%>%distinct()%>%pull()
  trip_days=trip_display%>%mutate(day=yday(date))%>%
    select(day)%>%pull()-yday(floor_date(start_date,"month"))
    calendR(start_date = floor_date(start_date,"month"),
            end_date = ceiling_date(end_date,"month") %m-% days(1),
            special.days = trip_days,
            special.col = "#bfe2f2",
            low.col = "white")  })

  output$plotSightings <- renderPlot({
    mapUpdateClassified()%>%
      ggplot(aes(sex,fill=sex))+
      geom_bar(stat="count")+
      theme_minimal()+
      theme(legend.position = "none",
            panel.grid = element_blank())+
      scale_fill_brewer(type="seq")+
      labs(x="Sex",y="Count")
  })

  output$plotMegaf <- renderPlot({
    megaf_sightings%>%
      mutate(espece=str_replace_all(espece,"_"," "))%>%
      mutate(espece=fct_rev(fct_infreq(espece)))%>%
      ggplot(aes(y=espece))+
      geom_bar(stat="count",fill="lightblue")+
      theme_minimal()+
      theme(legend.position = "none")+
      labs(y="",x="Number of sightings")
  })
    
}
