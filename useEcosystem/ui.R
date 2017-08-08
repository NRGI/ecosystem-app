
library(shiny)
library(shinythemes)
library(shinyjs)

shinyUI(fluidPage(
  useShinyjs(),
  theme= "nrgi-ecosystems-portal.css",
  
  # Application title
  ##titlePanel("Data Use Case Ecosystem"),
  
  # Sidebar
  sidebarLayout(
    
    sidebarPanel(
      width=2,   
      
      # selectInput(inputId="data_select",
      #             label="Select an ecosystem",
      #             choices=c("Data portals"="portals","Data use cases"="uses")),
      #actionButton(inputId="show",
      #             label="Click for Info"),
      uiOutput("countryChoices"),
      uiOutput("dataChoices"),
      uiOutput("productChoices")
      
    ),
    # Main
    mainPanel(
      
      actionButton(inputId="show",
                   label=HTML('<span class="glyphicon glyphicon-question-sign"></span>')),
      width=10,
      #tableOutput("sample"),
      DT::dataTableOutput("data.type"),
      textOutput("textout")
    )
  )
)
)




#add country