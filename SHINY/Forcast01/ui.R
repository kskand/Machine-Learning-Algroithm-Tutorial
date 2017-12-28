library(shiny)
library(shinydashboard)


dashboardPage(skin = "yellow",
  dashboardHeader(title = "FORCASTING Model"),
  dashboardSidebar(
    fileInput("file1","Upload CSV file which is in time series format",
              accept= c(
                "text/csv",
                "text/comma-separated-values,text/plain",
                ".csv")
              ),
    tags$hr(),
  sidebarMenu(
    menuItem("Visualize Time Series", tabName = "tsplot", icon = icon("area-chart")),
    menuItem("Check for Stationarity", tabName = "stn", icon = icon("list-ul")),
    menuItem("To remove Stationarity", tabName = "diff", icon = icon("list-ul")),
  # menuItem("'ACF & PACF Plot", tabName = "statn", icon = icon("anchor")),
    menuItem("Prediction", tabName = "Pred", icon = icon("calendar")),
    
    
    radioButtons("Transformation",label = "Transformation",
                 choices = c("Average Moving Range"="amr",
                             "Exponential Moving Range"="emr"))
  )
  ),
  dashboardBody(
# Time series plot
        tabItems(
      tabItem(tabName = "tsplot",
              
              fluidRow(
                box(title = "Time Series", width= 6,collapsible = TRUE,background = "olive",
                  plotOutput("timeseries")),
              
                box(offset=0,
                  radioButtons("plot",label = h5("Graph Frequency"),width = 3,
                               choices = c("Yearly",
                                           "Quarterly",
                                           "Monthly"),selected="Yearly"))
              ),
              fluidRow(   
               
 #Time series details               
               box(title = "START Date", width= 3,solidHeader = TRUE,height = "200px",
                                    tableOutput("stdt")
               ),
               box(title = "END Date", width= 3,solidHeader = TRUE,height = "200px",
                 tableOutput("endt")
               ),  
              box(title = "Frequency", width= 3,solidHeader = TRUE,height = "200px",
                  "If '12' data is on monthly basis",br(),"If '4' data is on Quaterly basis and so on...",
                  tableOutput("frqn")
                    
               ),
              box(title = "Data Class", width= 3,solidHeader = TRUE,height = "200px",
                  "If 'ts' then it's a Time Series data",br(), "else need to convert data",
                  tableOutput("cls")
               
              )
            )
           ),
# Stationry Check
#Augmented Dickey-Fuller(ADF) Test
        tabItem(tabName = "stn",
             fluidRow(
                box(title = "Select appropriate data type for Augmented Dickey-Fuller(ADF) Test for'Stationarity'",status = "success", solidHeader = TRUE,width = 4,
                  radioButtons("adf1",label = "",
                                choices = c("Data without transformation",
                                            "Log transformed data",
                                            "Differenced Data"),selected = "Data without transformation")
                  ),
                  box(title = "P- Value",width = 4, status = "success", solidHeader = TRUE,
                      tableOutput("adf2")
                  ),
                  box(title = "Alternative hypothesis",width = 4, status = "success", solidHeader = TRUE,
                      tableOutput("adf3")
                  )
                ),
                fluidRow(   
                  box(title = "Decomposed Graph to understand the composition",background = "light-blue",width = NULL,
                      plotOutput("decomp",height = 350))
                  
                  
                  ),
            fluidRow(
              
                  box( title = "An augmented Dickey-Fuller test (ADF)",width = NULL, background = "maroon",
                  "An augmented Dickey-Fuller test (ADF) tests the null hypothesis that a unit root is present in a time series sample. The alternative hypothesis is different depending on which version of the test is used, but is usually stationarity or trend-stationarity.
                   A linear stochastic process has a unit root if 1 is a root of the process's characteristic equation. Such a process is non-stationary but does not always have a trend.
                  If the other roots of the characteristic equation lie inside the unit circle-that is, have a modulus (absolute value) less than one-then the first difference of the 
                   process will be stationary; otherwise, the process will need to be differenced multiple times to become stationary. Due to this characteristic, unit root processes are also called difference stationary.")
            )
            ),
    

#'Difference' the time series until you obtain a stationary time series 
        tabItem(tabName = "diff",
          tabBox(width = NULL,
            tabPanel("Differencing Time Series",
                fluidRow(
              box(title = "Differencing Time Series",width= NULL, background = "teal",solidHeader = TRUE,collapsible = TRUE,
              plotOutput("differenced")
          )),
          fluidRow(
            box( title = "Title 3",width = 8, background = "maroon",
                 "Choose the differencing value 'd' for ARIMA(p,d,q) model, where d is the order of differencing used.
                 This is done to stationarized the time series."),
            box(width = 4,
              numericInput("order",label = "Choose the order of differencing used",
                           min=0, max=50, value = 1)
           )
          )
        ),
         tabPanel("ACF & PACF calculation",
# ACF & PACF calculation   
         fluidRow(
             box(title = "ACF(Auto Correlation Function) Plot", background = "teal",solidHeader = TRUE,collapsible = TRUE,
               plotOutput("acfplot",height="300")
             ),
             box(title = "PACF (Partial Auto Correlation Function) Plot", background = "olive",solidHeader = TRUE,collapsible = TRUE,
               plotOutput("pacfplot",height="300")
             )
             ),
             
             
          fluidRow( 
             box(radioButtons("station",label = "Stationarize the Series",
                              choices = c("Detrending"="dtr",
                                          "Differencing"="dff",
                                          "Seasonality"="seasn"))
             )
             
           ),
          fluidRow(
            box( title = "Finding the appropriate value of 'p' & 'q'",width = NULL, background = "maroon",
                 "The ACF (autocorrelogram function) helps in finding 'q' value is zero after lag 3
                 whereas the PACF (partial autocorrelogram function) helps in finding 'p' valueis zero after lag 3")
            )
           )
          )
         ),

#Prediction model   
       tabItem(tabName = "Pred",
               fluidRow(
             column(width=4,
             
             box(title = "Choose appropriate 'p', 'd & 'q' value for different Model as mentioned below",width = NULL, status = "info", solidHeader = TRUE,
                        collapsible = TRUE,
                  radioButtons("model",label = "Choose the model",
                               choices = c("ARIMA",
                                           "Auto ARIMA (will choose 'p', 'q' & 'd' value automatically"
                                           )
                        
                        
                    )
                 ),  
                                 
             box(title = "Choose appropriate 'p', 'd' & 'q' value for different Model as mentioned below",width = NULL, status = "info", solidHeader = TRUE,
                 collapsible = TRUE,
                 numericInput("pvalue",label = "Choose the value for 'p'",# partial autocorrelogram (PACF)
                              min=0, max=20, value = 1),
                 numericInput("dvalue",label = "Choose the value for 'd'",
                              min=0, max=20, value = 1),
                 numericInput("qvalue",label = "Choose the value for 'q'", #autocorrelogram (ACF)
                              min=0, max=20, value = 1)
               
               ),
             
             box(title = "Prediction Period",width = NULL, status = "info", solidHeader = TRUE,
                 collapsible = TRUE,
               numericInput("period",label = "Choose the number of periods for Forcasting",
                              min=1, max=20, value = 12)
           )),
           column(width=2,
           box(title = "Predicted Value",width = NULL, status = "success", solidHeader = TRUE,
               collapsible = TRUE,
             tableOutput("predictedvalue"))
           ),
           column(width=6,
                  box(title = "Time Series Plot with Predicted Value(-----)",width = NULL,status = "success",color = "navy", solidHeader = TRUE,
                    plotOutput("predictedplot"))
           )
               ),
           fluidRow(
             box( title = "Different Forcasting Model",width = NULL, background = "maroon",
                  "AR(Auto Regression) Model when 'd' & 'q'= 0,
                   MR(Moving Range) when 'p' & 'd'= 0,
                   ARMA(Auto Regression Moving Range) when 'd'= 0,
                   ARIMA(Auto Regression Integrated Moving Range) when 'p', d' & 'q'not equal to 0, 
                  An 'AR'model is usually used to model a time series which shows longer term dependencies between successive observations.
                  A MA model is usually used to model a time series that shows short-term dependencies between successive observations.")
           )
           
    )
   )
  )
 )

