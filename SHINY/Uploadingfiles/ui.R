library(shiny)

fluidPage(
 
    titlePanel("Uploading Files"),
  sidebarLayout(
    sidebarPanel(
      fileInput("filex","Choose CSV File",
                accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")
      ),
      tags$hr(style="border-color: black;"), # a horizontal rule to divide text and UI elements in sidebar
      checkboxInput("head","Header",TRUE),
      radioButtons("sep","Separator",
                   c(Comma=",",
                               Semicolon=";",
                               Tab="\t"),"Comma"),
      radioButtons("qt","Quote",
                   c(None="",'Single Quote'="'",
                               'Double Quote'='"'),"Single Quote")
    ),
    
    mainPanel(
      tableOutput("Contents")
    )
    
  )
)



#Important notes:
#.This feature does not work with Internet Explorer 9 and earlier (not even with Shiny Server).
#.By default, Shiny limits file uploads to 5MB per file. 
#You can modify this limit by using the shiny.maxRequestSize option. 
#For example, adding options(shiny.maxRequestSize=30*1024^2) to the top of server.R would increase the limit to 30MB.
