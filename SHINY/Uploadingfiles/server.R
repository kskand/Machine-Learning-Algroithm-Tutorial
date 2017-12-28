library(shiny)

function(input,output){
  
output$Contents <- renderTable({
    x1<-input$filex
    
    if(is.null(x1))
      return(NULL)
    
    read.csv(x1$datapath, header = input$head, sep = input$sep, quote = input$qt)
    
    })
  
}


    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    
   