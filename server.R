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

  ####### About Text ##############
  
  output$about_naturedb <- renderUI(HTML(
    "NatureDB is designed to be used in conjuction with the <a href='https://ee.kobotoolbox.org/x/PME7pT8m'>this survey</a>. It has several use cases: 
  <ul>
  <li>Raw survey outputs are available to view in near real-time.</li>
  <li>Summary statistics and data visualisation are automised and available to view in the <i>clean data</i> and <i>graphs</i> tabs.</li>
  <li>The 'classifier' lets users assign I&sup3;S ID's to shark sightings. Armed with this information, NatureDB automates the merging of  
  <dfn title='A sighting is defined as any shark for which a left ID is taken'>
  <u style='text-decoration:underline dotted'>shark sightings</u></dfn>
  into 
  <dfn title='A known shark is any shark to which we have assigned an  I&sup3;S ID'>
  <u style='text-decoration:underline dotted'>known sharks.</dfn></li> 
  </ul>"))

  output$about_instructions <- renderUI(HTML(
    "<ol>
    <li>While at sea, fill in the survey</li>
    <li>Check your sightings have appeared in <i>raw data</i> (you can filter by your name and date)</li>
    <li>Upload your photos to I&sup3;S and, where possible, make a note of the I&sup3;S ID for each of your sightings.</li>
    <li>Go to <i>classifier</i> and file each of your sightings as 'done'.</li>
    <li>Check that your sighting information appears in the <i>clean data</i> tabs</li>
    </ol>"
))
  
  output$about_fieldcollect <- renderUI(HTML(
    "A totally awesome start up founded by Justin Beresford. 
          This is an example of what we'll do.
    <ul>
      <li>Survey design</li>
      <li>Dashboarding and Analytics</li>
      <li>Data storage</li>
      </ul>"
  ))
      
  formData <- reactive({
    data <- sapply(fields, function(x) input[[x]])
    data
  })
  
  # When the Submit button is clicked, save the form data
  observeEvent(input$submit, {
    if (input$sighting_id=="" && input$i3s_id=="") {
      output$error_message<-renderUI({
        HTML(as.character(div(style="color: red;",
                              "Required: sighting ID and I3S ID")))})
      } else if (input$sighting_id %in% is_not_allowed()$sighting_id)  {
        output$error_message<-renderUI({
          HTML(as.character(div(style="color: red;",
                                "Sighting ID has already been mapped")))})
      } else if (input$no_id_reason %in% c("advice_needed","unusable_sighting") && 
        input$i3s_id!="") {
      output$error_message<-renderUI({
        HTML(as.character(div(style="color: red;",
        "If I3S ID available, sighting should be marked 'done'.")))})
      } else if (!input$no_id_reason %in% c("advice_needed","unusable_sighting") &&
               input$i3s_id=="") {
        output$error_message<-renderUI({
          HTML(as.character(div(style="color: red;",
        "No I3S ID is given but sighting filed as done.")))})
      } else{
      saveData(formData())
      aws.s3::put_object(file = "mapping",object="mapping",bucket="mada-whales")
      output$error_message<-renderUI({HTML(as.character(""))})
    }
  })
  
  # Show details for selected sighting

  output$sighting_observer <- renderUI({
    HTML(if (input$sighting_id==""){
      as.character(div(style="color: grey;","No sighting ID selected"))
    } else {
    obs=all_sightings%>%filter(sighting_id==input$sighting_id)%>%pull(observer)
    sighting_number=all_sightings%>%filter(sighting_id==input$sighting_id)%>%
      pull(sighting_number)
    date=all_sightings%>%filter(sighting_id==input$sighting_id)%>%
      mutate(survey_start=as_date(survey_start))%>%
      pull(survey_start)
    as.character(div(style="color: grey;",
                     paste("Shark",sighting_number,"seen by",obs,"on",date)))}
  )})
  
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
           "Dives" = displayTrip(trip_vars),
           "Shark sightings" = displaySharkSightings(shark_sightings_vars),
           "Shark scar sightings" = displaySharkScars(shark_scar_vars),
           "Megafauna sightings" = displayMegaf(megaf_vars)
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
    uc<-mapUpdateUNClassified()
    
    if (input$show_advice_needed==TRUE){
      uc<-uc%>%
        filter(no_id_reason=="advice_needed")
    } else {
      uc<-uc%>%
        filter(!no_id_reason %in% c("advice_needed"))
    }
    uc},
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
  
  output$summary_stats<-renderDataTable({
    get_summary_stats(mapUpdateKnownSharks())
  })
  
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
  start_date=trip%>%filter(date==min(date))%>%select(date)%>%distinct()%>%pull()
  end_date=trip%>%filter(date==max(date))%>%select(date)%>%distinct()%>%pull()
  trip_days=trip%>%mutate(day=yday(date))%>%
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
