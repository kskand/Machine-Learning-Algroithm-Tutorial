library(shiny)
library(datasets)

shinyServer(function(input,output){
  
  datasetinput <- reactive({
    switch(input$dataset,
           "rock" = rock,
           "pressure" = pressure,
           "cars" = cars)
  })
  
  output$summary <- renderPrint({
    summary(datasetinput())
   
  })
  
  output$view <- renderTable({
         head(datasetinput(),n = input$obs)
    
  })
  
})
