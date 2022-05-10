function(input, output) {
  
  output$plot <- renderPlot({
    
    p <- dfm%>%
      ggplot(aes(What_color_was_it))+
      geom_bar(stat = "count",fill="lightblue")+
      theme_minimal()
    
    print(p)
    
  }, height=400)
  
  output$table <- renderTable({
    t<-dfm%>%
      rename(Date=Enter_a_date,
             Comment=Why_don_t_you_fill_i_some_free_form_text,
             Coordinates=Record_your_current_location,
             Colour=What_color_was_it)%>%
      select(-Point_and_shoot_Use_mera_to_take_a_photo)
    print(t)
    })
  
  # Download CSV
  output$downloadData <- downloadHandler(
    filename = "dfm.csv",
    content = function(file) {
      write.csv(dfm, file, row.names = FALSE)
    }
  )
  
}
