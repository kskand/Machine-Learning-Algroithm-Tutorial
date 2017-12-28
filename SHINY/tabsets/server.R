library(shiny)


shinyServer(function(input,output){
  
  datasetinput <- reactive({
    
    distribution <-switch(input$dist,
           "norm" = rnorm,
           "unif" = runif,
           "lnorm" = rlnorm,
           "exp" = rexp)
    distribution(input$n)
  })
  
  output$Plot <- renderPlot({
    
    hist(datasetinput(),main = paste('r',input$dist,'(',input$n,')',sep = ""))
  })
  
  output$Summary <- renderPrint({
    summary(datasetinput())
  })
  
  output$Table <- renderTable({
    data.frame(datasetinput())
  })
  
  
})