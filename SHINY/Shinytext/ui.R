library(shiny)

fluidPage(
  
  titlePanel("Shiny Text"),
  sidebarLayout(
    sidebarPanel(
     selectInput("dataset","Choose a dataset:",
                 choices = c('rock','pressure','cars')),
    numericInput("obs","Number of observations to view:",10)
     ),
  
  mainPanel(verbatimTextOutput("summary"),
    tableOutput("view")
  )
 )
)


