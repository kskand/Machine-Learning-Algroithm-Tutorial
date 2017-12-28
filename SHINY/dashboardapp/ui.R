library(shiny)
library(shinydashboard)

dashboardPage(
  
    dashboardHeader(disable=TRUE,title = "First Dashboard",
                    dropdownMenu(type = "messages",
                                 messageItem(
                                   from = "Sales Dept",
                                   message = "Sales are steady this month."
                                 ),
                                 messageItem(
                                   from = "New User",
                                   message = "How do I register?",
                                   icon = icon("question"),
                                   time = "13:45"
                                 ),
                                 messageItem(
                                   from = "Support",
                                   message = "The new server is ready.",
                                   icon = icon("life-ring"),
                                   time = "2014-12-01"
                                 )
                    ),
                    dropdownMenu(type = "notifications",
                                 notificationItem(
                                   text = "5 new users today",
                                   icon("users")
                                 ),
                                 notificationItem(
                                   text = "12 items delivered",
                                   icon("truck"),
                                   status = "success"
                                 ),
                                 notificationItem(
                                   text = "Server load at 86%",
                                   icon = icon("exclamation-triangle"),
                                   status = "warning"
                                 )
                    ),
                    dropdownMenu(type = "tasks", badgeStatus = "success",
                                 taskItem(value = 90, color = "green",
                                          "Documentation"
                                 ),
                                 taskItem(value = 17, color = "aqua",
                                          "Project X"
                                 ),
                                 taskItem(value = 75, color = "yellow",
                                          "Server deployment"
                                 ),
                                 taskItem(value = 80, color = "red",
                                          "Overall project"
                                 )
                    )
                    ),
  
  
  dashboardSidebar(
    p("Date & Time : ", span(id = "time", date()), a(id = "update", "Update")),
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Widgets", tabName = "widgets", icon = icon("th"))
  )),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
    
    fluidRow(
      
      box(plotOutput("plot1",height = 250)),
      box(title = "Control1",
        sliderInput("slide1","value1", min = 1,max = 1000,animate = TRUE,value = 150))
    ),
    tags$hr(style="border-color: black;")# to draw horizontal rule.
      ),
    
        tabItem(tabName = "widgets",
                
    fluidRow(
      
      box(plotOutput("plot2",height = 250)),
      box(title = "Control2",
          sliderInput("slide2","value2", min = 1,max = 1000,animate = TRUE,value = 150))
         )
        )
   )
 )
) 

