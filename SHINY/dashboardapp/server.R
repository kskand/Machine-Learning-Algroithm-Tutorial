library(shiny)
library(shinydashboard)

function(input, output) { 
  
  output$plot1 <- renderPlot(
    hist(rnorm(input$slide1),col = 'green')
  )
  output$plot2 <- renderPlot(
    plot(rnorm(input$slide2),type='l',col = 'red')
  )
  
}