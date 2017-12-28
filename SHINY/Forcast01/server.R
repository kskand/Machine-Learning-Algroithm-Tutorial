library(shiny)
library(shinydashboard)
library(ggplot2)
library(forecast)
library(tseries)

function(input, output) { 
  

#File Input
  
    # output$contents <- renderTable({
  #   
  #   # input$file1 will be NULL initially. After the user selects and uploads a 
  #   # file, it will be a data frame with 'name', 'size', 'type', and 'datapath' 
  #   # columns. The 'datapath' column will contain the local filenames where the 
  #   # data can be found.
  #   
  #   inFile <- input$file1
  #   
  #   if (is.null(inFile))
  #     return(NULL)
  #   
  #   read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote)
  
  # })
  
  airP = AirPassengers
  
# Time Series data details  
  output$stdt <-renderTable({
    print(start(airP))
  })
  
  output$endt <-renderTable({
    print(end(airP))
  })
  
  output$frqn <-renderTable({
    print(frequency(airP))
  })
  
  output$cls <-renderTable({
    print(class(airP))
  })
    
  
# Time Series plot
  
     output$timeseries <- renderPlot({
       freq <- switch(input$plot,
                      Yearly= 1,
                      Quarterly=3,
                      Monthly=12
                      )
      airP_ts <- ts(airP,start=start(airP),end=end(airP),frequency=freq) 
    plot.ts(airP_ts,ylab= " No of Air Passengers",type="b",pch = 20,cex = 1.5,col='red')
  })
     

#Data type selection for ADF test          
     adfinput <- reactive({
       switch(input$adf1,
              "Data without transformation"=airP,
              "Log transformed data"=log(airP),
              "Differenced Data"=diff(airP)
       )
       
     })
     
#Augmented Dickey-Fuller Test
     
       output$adf2 <- renderTable({

       adfsumm <-adf.test(adfinput(), alternative = "stationary")
       print(adfsumm$p.value)

     })
       
       output$adf3 <- renderTable({
         
         adfsumm <-adf.test(adfinput(), alternative = "stationary")
         print(adfsumm$alternative)
         
       })
       
       
       
#Decomposed graph       
       output$decomp <- renderPlot({
         
         plot(decompose(adfinput()))
         
         
       })

     
#Differencing Time Series
     
     output$differenced <- renderPlot({
       
       airp.diff <- diff(airP, differences=input$order)
       plot.ts(airp.diff,ylab= " No of Air Passengers",type="b",pch = 20,cex = 1.5,col='red')
     })
     
     
     
# ACF & PACF Plot
     
     output$acfplot <- renderPlot({
       
       acf(adfinput(),lag.max=20)
       
     })
     
     output$pacfplot <- renderPlot({
       
       pacf(adfinput(),lag.max=20)
       
     })
     


#Holt-Winters Filtering
     
     
#selection between arima and autoarima Prediction model          
     modelinput <- reactive({
       switch(input$model,
              "ARIMA"=arima(),
              "Auto ARIMA (will choose 'p', 'q' & 'd' value automatically"=auto.arima()
              )

     })
     
#Prediction Value     
     output$predictedvalue <- renderTable({
       
       if(modelinput()==arima())
       
         {if(adfinput()==airP)
         { 
           fit <- arima(adfinput(), order=c(input$pvalue,input$dvalue,input$qvalue ),seasonal = list(order = c(0, 1, 1), period = 12))
           pred <- predict(fit, n.ahead = input$period)
           pred1 <- pred$pred
           pred1
         }
         else{
           if(adfinput()==log(airP))
               {fit <- arima(adfinput(), order=c(input$pvalue,input$dvalue,input$qvalue ),seasonal = list(order = c(0, 1, 1), period = 12))
                      pred <- predict(fit, n.ahead = input$period)
                      pred1 <-2.718^pred$pred
                      pred1
               }
           
           else{
             fit <- arima(adfinput(), order=c(input$pvalue,input$dvalue,input$qvalue ),seasonal = list(order = c(0, 1, 1), period = 12))
                            pred <- predict(fit, n.ahead = input$period)
                            pred1 <- pred$pred
                            pred1
                        }
           }
       }
         
       else
       {fit <- auto.arima(adfinput())
       pred <- predict(fit, n.ahead = input$period)
       pred1 <-2.718^pred$pred
       pred1}
       
       })
     
#Prediction plot 
     
     output$predictedplot <- renderPlot({
       
       if(adfinput()==airP)
       { 
         fit <- arima(adfinput(), order=c(input$pvalue,input$dvalue,input$qvalue ),seasonal = list(order = c(0, 1, 1), period = 12))
         pred <- predict(fit, n.ahead = input$period)
         ts.plot(airP,pred$pred,lty = c(1,3))
       }
         else{
           if(adfinput()==log(airP))
           {fit <- arima(adfinput(), order=c(input$pvalue,input$dvalue,input$qvalue ),seasonal = list(order = c(0, 1, 1), period = 12))
           pred <- predict(fit, n.ahead = input$period)
           pred1 <-2.718^pred$pred
           ts.plot(airP,pred1, log = "y", lty = c(1,3))
           }
           
           else{
             fit <- arima(adfinput(), order=c(input$pvalue,input$dvalue,input$qvalue ),seasonal = list(order = c(0, 1, 1), period = 12))
             pred <- predict(fit, n.ahead = input$period)
             ts.plot(airP,pred$pred,lty = c(1,3))
           }
         }

    
     })
  
  }