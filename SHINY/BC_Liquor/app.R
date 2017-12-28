library(shiny)
library(ggplot2)
library(dplyr)
bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)
#str(bcl)

ui <- fluidPage(
  
  titlePanel("BC Liquor Store prices"),
  sidebarLayout(
    sidebarPanel(sliderInput("priceInput", "Price", min = 0, max = 200,
                             value = c(10, 40), pre = "$"),
                 radioButtons("typeInput", "Product type",
                              choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                              selected = "WINE"),
                 uiOutput("subtype"),
                 uiOutput("countryInput")
                 ),
    mainPanel(plotOutput("coolplot"),
              br(),
              h2(textOutput("countresult")),
              br(),br(), # to provide gap as this command is for breakline
              tableOutput("results")
              )
  )
   
  )

server <- function(input, output) {
  
  filtered <-reactive({
    if (is.null(input$countryInput)) {
      return(NULL)                   }
    
    bcl %>%
      filter(Price >= input$priceInput[1],
             Price <= input$priceInput[2],
             Type == input$typeInput,
             Country == input$countryInput,
             Subtype == input$subtype
      )
  })
  output$coolplot <- renderPlot({
    
    ggplot(filtered(), aes(Alcohol_Content)) +
      geom_histogram(fill='green')+theme_dark()
  })
  output$results <- renderTable({
        filtered()
    })
  output$countresult <- renderText({
    summarycount <- nrow(filtered())
    
    print(paste("Total number of results :",summarycount))
                                  })
  
  output$subtype <- renderUI({
    filtered1 <-bcl %>%
      filter(Price >= input$priceInput[1],
             Price <= input$priceInput[2],
             Type == input$typeInput,
             Country == input$countryInput)
    selectInput("subtype", "Product SubType",
                sort(unique(filtered1$Subtype)),selected = "TABLE WINE RED"
                )
                            })
  
  output$countryInput <- renderUI({
    
  selectInput("countryInput", "Country",
              sort(unique(bcl$Country)),
              selected = "CANADA")
                                  })
}

shinyApp(ui = ui, server = server)
