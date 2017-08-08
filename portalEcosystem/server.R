
library(shiny)
library(shinythemes)
library(shinyjs)
library(data.table)
library(DT)


#Data portals

#use <- read.csv('C:/Users/TRM/Documents/GitHub/R projects/NRGI/Shiny app/Ecosystem3/Ecocsystem3/useCases.csv', stringsAsFactors = FALSE)
#portal <- read.csv('C:/Users/TRM/Documents/GitHub/R projects/NRGI/Shiny app/Ecosystem3/Ecocsystem3/dataPortals2.csv', stringsAsFactors = FALSE)

#Native

#use <- read.csv('useCases.csv', stringsAsFactors = FALSE)
#portal <- read.csv('dataPortals2.csv', stringsAsFactors = FALSE)

##Google sheets
#portal <- read.csv("https://docs.google.com/spreadsheets/d/1q1tvFxDmDK_neBBhx73mPjJRZ8H5UZfp4Ys88eY703c/pub?gid=1584017053&single=true&output=csv", stringsAsFactors=FALSE)

portal <- read.csv("https://docs.google.com/spreadsheets/d/1aQNFphK8yS9ntV898Y8YN-zo-EdH-H-_Yrypy1u-lWQ/pub?gid=0&single=true&output=csv", stringsAsFactors = FALSE)
#https://docs.google.com/spreadsheets/d/1q1tvFxDmDK_neBBhx73mPjJRZ8H5UZfp4Ys88eY703c/pub?gid=1584017053&single=true&output=csv
#https://docs.google.com/spreadsheets/d/1q1tvFxDmDK_neBBhx73mPjJRZ8H5UZfp4Ys88eY703c/pub?output=csv

#use <- read.csv("https://docs.google.com/spreadsheets/d/1ym3cHEvCZRPnYd15HTiH75pVjysr-VPzqD_gdzbwlHE/pub?gid=2037077924&single=true&output=csv", stringsAsFactors=FALSE)

##AWS only

#use <- read.csv('https://s3.amazonaws.com/trm5892/useCases.csv', stringsAsFactors = FALSE)
#portal <- read.csv('https://s3.amazonaws.com/trm5892/dataPortals.csv', stringsAsFactors = FALSE)
###


setDT(portal)

#use <- use[order(Project)]
portal <- portal[order(Project)]

#attr(use,"name") <- "use"
attr(portal,"name") <- "portal"

# use$Data.type2 <- paste(lapply(strsplit(use$Data.type, ','), function(x){paste0('<li>',x,'</li>', collapse='')}))
# use$Data.type <- paste(lapply(strsplit(use$Data.type,','), paste0, "<br>", collapse=''))
# use$Product.type <- paste(lapply(strsplit(use$Product.type,','), paste0, "<br>", collapse=''))
# use$Methodology <- paste(lapply(strsplit(use$Methodology,','), paste0, "<br>", collapse=''))
# use$Project <- paste0('<a target="_blank" href="',use$Link,'">',use$Project,'</a>')
# 
# use$Case.study
# 
# use[, Case.study := ifelse(Case.study=="", "", paste0('<a target="_blank" href="',Case.study,'">',"Link",'</a>'))]
# 
# paste0('<a target="_blank" href="',use$`Case Study`,'">',"Link",'</a>')
# 
# use <- use[, c("Project","Data.type2","Product.type","Country","Organization","Year","Overview","Case.study", "Data.type"), with=FALSE]
# names(use) <- c("Project","Data Type","Product Type","Country","Organization","Year","Overview","Case Study", "Data.type")
# 

portal$Data.type2 <- paste(lapply(strsplit(portal$Data.type, ','), function(x){paste0('<li>',x,'</li>', collapse='')}))
portal$Data.type <- paste(lapply(strsplit(portal$Data.type,','), paste0, "<br>", collapse=''))
portal$Data.format <- paste(lapply(strsplit(portal$Data.format,','), paste0, "<br>", collapse=''))
portal$Methodology <- paste(lapply(strsplit(portal$Methodology,','), paste0, "<br>", collapse=''))
portal$Project <- paste0('<a target="_blank" href="',portal$Link,'">',portal$Project,'</a>')


portal <- portal[, c("Project","Data.type2","Data.format","Data.license","Country","Organization","Year","Overview", "Data.type"), with=FALSE]
names(portal) <- c("Project","Data Type","Data Availability","Data License","Country","Organization","Year","Overview", "Data.type")
portal <- portal[, c("Project","Country","Organization","Data Type", "Data Availability","Year","Overview", "Data License","Data.type")]

################################################################################################################################
################################################################################################################################

shinyServer(function(input, output) {
  
  addClass(class="sidebar", selector=".col-sm-2")
  
  observeEvent(input$show, {
    showModal(modalDialog(
      title = "FAQs",
      HTML("Welcome to NRGI's Data Portal Explorer. <br><br>
           
           This tool showcases the different places around the web where stakeholders can access data on the extractives industry. <br><br>
           
           Data portals allow users to download or view data on a variety of extractive industry topics, including concession areas, company ownership and payments 
           to governments. You can search for different data portals by country, data type and data availability. <br><br>
           
           There are currently over 30 data portals in the data ecosystem. NRGI will be updating the database periodically and appreciates any suggestions for additions. Please email info@resourcegovernance.org with suggestions or comments.")      ))
  })
  
  dat <- reactive({
    portal
  })
  
  column_names <- reactive({
    if(input$data_select=="portals") {
      #return(c("Butt"=1, "Data Type"=2, "Product Type"=3,"Whatever"=4))
      c("PROJECT","Data Type","Data Format","Data License","Country","Organization","Year","Overview","Data.type")
    } else {
      #return(c("Project"=1, "Data Type"=2, "Data Format"=3, "Data License"=4))
      
    }
  })
  
  second_checkbox <- reactive({
    "Data availability"
    })
  
  output$dataChoices <- renderUI({
    datas <- unique(unlist(strsplit(paste(dat()[!(Data.type%in%c(""," ","<br>"," <br>"))]$Data.type, collapse=''), split='<br>')))
    # checkboxGroupInput(inputId="data.type.check",
    #                    choices=datas[order(datas)],
    #                    label="Select one or more data types")
    selectizeInput(inputId = "data.type.check",
                   label="Select one or more data types",
                   choices=datas[order(datas)],
                   multiple=TRUE,
                   selected=NULL)
    
  })
  
  output$productChoices <- renderUI({
    #datas <- unique(gsub("<br>","", unlist(strsplit(paste(dat()$Product.type, collapse=''), split='<br>'))))
    datas <- unique(gsub("<br>","", unlist(strsplit(paste(dat()[!(dat()[["Data Availability"]]%in%c(" ","","<br>"))][["Data Availability"]], collapse=''), split='<br>'))))
    # checkboxGroupInput(inputId="product.type.check",
    #                    choices=datas[order(datas)],
    #                    label=second_checkbox())#"Select a product type")
    selectizeInput(inputId = "product.type.check",
                   label="Select a product type",
                   choices=datas[order(datas)],
                   multiple=TRUE,
                   selected=NULL)
  })
  output$countryChoices <- renderUI({
    datas <- unique(unlist(lapply(strsplit(dat()$Country, ','), trimws)))
    
    selectizeInput(inputId='country.check',
                   label="Select one or more countries",
                   choices=datas[order(datas)],
                   multiple=TRUE,
                   selected=NULL)
    
  })
  
  dataType <- reactive({
    if(is.null(input$data.type.check)) {
      return('AXX')
      #return(c("Imagery","Geospatial","Legislative","Production","Concession","EITI","Company level","Ownership","Corporate","News","Revenue","Environmental"))
    } else { input$data.type.check }
  })
  
  productType <- reactive({
    if(is.null(input$product.type.check)) {
      return('AXX')
      #return(c("Analysis", "Database", "Data portal", "Interactive tool", "Research paper", "Visualization"))
    } else { input$product.type.check }
  })
  
  countryType <- reactive({
    if(is.null(input$country.check)) {
      return('AXX')
      #return(c("MENA","Africa","N America","SE Asia","Global"))
    } else { input$country.check }
  })
  
  dataTypeList <- reactive({
    a <- list()
    for(i in 1:length(dataType())) {
      a[[i]] <- grep(dataType()[i], dat()$Data.type)
    }
    a
  })
  
  productTypeList <- reactive({
    a <- list()
    for(i in 1:length(productType())) {
      a[[i]] <- grep(productType()[i], dat()[["Data Availability"]])#dat()$Product.type)
    }
    a
  })
  
  countryTypeList <- reactive({
    a <- list()
    for(i in 1:length(countryType())) {
      a[[i]] <- grep(countryType()[i], dat()$Country)
    }
    a
  })
  
  output$data.type <- DT::renderDataTable({
    
    #names(data()) <- c("PROJECT","Data Type","Data Format","Data License","Country","Organization","Year","Overview","Data.type")
    
    if(dataType()[1]=='AXX' & productType()[1]=='AXX' & countryType()[1]=='AXX') {
      dat()[, -c('Data.type'), with=FALSE]
    } else if(dataType()[1]!='AXX' & productType()[1]!='AXX' & countryType()[1]=='AXX') {
      #data & product
      dat()[Reduce(intersect, append(dataTypeList(), productTypeList())), -c('Data.type'), with=FALSE]
    } else if(dataType()[1]!='AXX' & productType()[1]=='AXX' & countryType()[1]!='AXX') {
      #data & country
      dat()[Reduce(intersect, append(dataTypeList(), list(unlist(countryTypeList())))), -c('Data.type'), with=FALSE]
    } else if(dataType()[1]=='AXX' & productType()[1]!='AXX' & countryType()[1]!='AXX') {
      #product & country
      dat()[Reduce(intersect, append(productTypeList(), list(unlist(countryTypeList())))), -c('Data.type'), with=FALSE]
    } else if(dataType()[1]=='AXX' & productType()[1]=='AXX' & countryType()[1]!='AXX') {
      #country
      dat()[Reduce(intersect, list(unlist(countryTypeList()))), -c('Data.type'), with=FALSE]
    } else if(dataType()[1]=='AXX' & productType()[1]!='AXX' & countryType()[1]=='AXX') {
      #product
      dat()[Reduce(intersect, productTypeList()), -c('Data.type'), with=FALSE]
    } else if(dataType()[1]!='AXX' & productType()[1]=='AXX' & countryType()[1]=='AXX') {
      #data
      dat()[Reduce(intersect, dataTypeList()), -c('Data.type'), with=FALSE]
    } else {
      #data & product & country
      dat()[Reduce(intersect, list(unlist(dataTypeList()), unlist(productTypeList()), unlist(countryTypeList()))), -c('Data.type'), with=FALSE]
    }
  },
  escape=FALSE, 
  rowname=FALSE,
  options = list(#sDom  = '<"top">flrtp<"bottom">i',
                 dom='pftl',
                 pageLength = 5,
                 
                 columnDefs = list(list(className = 'dt-bottom', targets = 0:4),
                                   list(className = 'col-md-3 col-sm-3', targets = 6),
                                   #list(className = '', targets = 6),
                                   list(className = 'dt-head-center', targets = 0:7),
                                   list(className = 'dt-center', targets = 5),
                                   #list(width='100px', targets=1:2),
                                   #list(width='50px', targets=5),
                                   list(width='100px', targets=7),
                                   list(width='100px', targets=0:5)),
                 initComplete = JS(
                   "function(settings, json) {",
                   "$(this.api().table().body()).css({'text-align': 'left', 'vertical-align':'top'});",
                   "$(this.api().table().header()).css({'background-color': '#ff6e49', 'color': '#fff'});",
                   "}")
  )  
  )
  
  
  
  # output$textout <- renderText({second_checkbox()})
  
  
  #})
  
  })



