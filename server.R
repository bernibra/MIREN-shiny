library(shiny)
library(shinyjs)
library(shinyalert)
library(leaflet)
# library(WorldFlora)
# 
# WFO.sp <- readRDS("./WFOsp.rds")
  
Check.species <- function(sp){
  # matches <- WFO.match(spec.data = sp,
  #           WFO.data = WFO.data,
  #           Fuzzy = 0,
  #           Fuzzy.force=FALSE,
  #           First.dist=FALSE,
  #           spec.name.tolower=TRUE
  # )
  name <- gsub("^\\s+|\\s+$", "", gsub('[[:punct:] ]+',' ',tolower(sp)))
  return(list(name=name, Matched=name %in% WFO.sp))
}

function(input, output) {
  
  shinyjs::disable("submit")
  SubmitReady <- reactiveValues(date = FALSE, loc = FALSE, name = FALSE)
  
  observeEvent(input$Button, {
    shinyjs::disable("submit")
  }) 
  
  observeEvent(input$submit, {
    shinyalert("Thanks!", "Form entry has been submitted", type = "success")
    shinyjs::disable("submit")
  })
  
  # output$checked <- renderText({ input$somevalue })
  
  output$location <- renderText({ 
    input$Button
    isolate(
      if(input$lon==142.5917 & input$lat==11.3733){
        SubmitReady$loc <- F
        paste(" - You need to add a valid location")
      }else{
        SubmitReady$loc <- T
        paste(' + <span style="color:green">Location entered:</span> ensure it is correct using the map', sep="")
      }
    )
  })
  
  output$value <- renderText({ 
    input$Button
    isolate(
      if(input$date=="1990-04-12"){
        SubmitReady$date <- F
        paste(" - You need to add a valid date")
      }else{
        if(as.numeric(strsplit(as.character(input$date), "-")[[1]][1])<2020){
          SubmitReady$date <- F
          paste(' + <span style="color:red">Invalid date: </span>data collected before 2020 is not valid')
        }else{
          SubmitReady$date <- T
          paste(' + <span style="color:green">Valid date</span>')
        }
      }
    )
  })
  
  output$text <- renderText({
    input$Button
    isolate(
      if(input$text=="scientific name..."){
        SubmitReady$name <- F
        paste(" - You need to add a valid species name")
      }else{
        m <- Check.species(input$text)
        if(m$Matched){
          SubmitReady$name <- T
          paste(' + <span style="color:green">Valid species: </span>',input$text, sep="")
        }else{
          SubmitReady$name <- F
          paste(' + <span style="color:red">Species not found: </span>',"visit http://www.worldfloraonline.org", sep="")
        }
      }
    )
  })
  
  observeEvent(input$Button, {
    if (SubmitReady$loc & SubmitReady$date & SubmitReady$name){
      shinyjs::enable("submit")
    }else{
      shinyjs::disable("submit")
    }
  })  
  
  output$mymap <- renderLeaflet({
    input$Button
    isolate(
      leaflet(data=input$lat) %>%
      addTiles() %>%
      setView(lng = input$lon,
              lat = input$lat,
              zoom = 3.5) %>%
      addMarkers(lng=input$lon,lat=input$lat)
      )
  })
  
}