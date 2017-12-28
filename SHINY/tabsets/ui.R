library(shiny)

fluidPage(
  
  titlePanel("Tabsets"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("dist","Distribution Type", 
                   choices = c("Normal"="norm","Uniform"="unif","Log-normal"="lnorm","Exponential"="exp")),
      sliderInput("n","Number of observations:",min = 1,max = 1000,value = 500)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Plot",plotOutput("Plot")),
        tabPanel("Summary",verbatimTextOutput("Summary")),
        tabPanel("Table",tableOutput("Table"))
      )
    )
  )
)