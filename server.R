library(shiny)
library(shinyjs)
library(shinyalert)
library(leaflet)
library(WorldFlora)
# WorldFlora::WFO.remember()

checkInstance <- function(lon,lat,date,sp){
  condition <- TRUE
  if(date=="1990-04-12"){condition <- F}
  if(lon==142.5917 & lat==11.3733){condition <- F}
  if(sp=="scientific name..."){condition <- F}
  if (condition){
    return(FALSE)
  }else{
    return(TRUE)
  }
}

Check.species <- function(sp){
  matches <- WFO.match(spec.data = sp,
            WFO.data = WFO.data,
            Fuzzy = 0,
            Fuzzy.force=FALSE,
            First.dist=FALSE,
            spec.name.tolower=TRUE
  )
  return(matches)
}

function(input, output) {
  
  shinyjs::disable("submit")

  observeEvent(input$Button, {
    if (checkInstance(input$lon, input$lat, input$date, input$text)){
      shinyjs::disable("submit")
    }else{
      shinyjs::enable("submit")
    }
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
        paste(" - You need to add a valid location")
      }else{
        paste(' + <span style="color:green">Location entered:</span> ensure it is correct using the map.', sep="")
      }
    )
  })
  
  output$value <- renderText({ 
    input$Button
    isolate(
      if(input$date=="1990-04-12"){
        paste(" - You need to add a valid date")
      }else{
        paste(' + <span style="color:green">Valid date</span>')
      }
    )
  })
  
  output$text <- renderText({
    input$Button
    isolate(
      if(input$text=="scientific name..."){
        paste(" - You need to add a valid species name")
      }else{
        m <- Check.species(input$text)
        if(m$Matched){
          paste(' + Species: <span style="color:green">',input$text,'</span>', sep="")
        }else{
          paste(' + <span style="color:red">Species not found: </span>',"visit http://www.worldfloraonline.org", sep="")
        }
      }
    )
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