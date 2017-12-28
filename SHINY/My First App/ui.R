library(shiny)

shinyUI(fluidPage(
  
  titlePanel("My First App"), 
  sidebarLayout(
       sidebarPanel(sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 100,
                  value = 30)
                   )
               ),
    mainPanel(plotOutput("distplot")
              )
                 )
      )