function(input, output) {
  
### Graphs ####

  output$showfile <- renderUI({
    includeHTML("map.html")})

  output$plot <- renderPlot({

    t<-trip%>%
      select(survey_end,`meduses`,`salpes`,`krill`,`trichodesmium`)%>%
      gather(key=faune,value=present,-survey_end)%>%
      ggplot(aes(survey_end,faune,fill=present))+
      geom_tile(color="white")+
      theme_minimal()+
      labs(x="Survey submission",y="",fill="Identified")
    
    s<-shark_sightings%>%
      ggplot(aes(sex,fill=sex))+
      geom_bar(stat="count")+
      theme_minimal()+
      theme(legend.position = "none")+
      scale_fill_brewer(type="qual")
    
    m<-megaf_sightings%>%
      ggplot(aes(espece))+
      geom_bar(stat="count",fill="lightblue")+
      theme_minimal()+
      theme(legend.position = "none")+
      labs(x="",y="Number of sightings")
    
    
    ifelse(input$sel_frame=="Other fauna",print(t),
           ifelse(input$sel_frame=="Sharks",print(s),print(m)))
  }, height=400)
  
### Data download ###

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
  
  ## Show table (unknown)
  output$unknown_sharks <- renderDT(
    unknown_sharks,
    filter = "top",
    options = list(
      pageLength = 10,
      scrollX=TRUE
    )
  )
  ## Show table (known)
  output$known_sharks <- renderDT(
    known_sharks,
    escape = FALSE,
    filter = "top",
    options = list(
      pageLength = 10,
      scrollX=TRUE
    )
  )
  
  
}
