library(shiny)
library(leaflet)
library(shinyjs)
library(shinyalert)

fluidPage(
  titlePanel("MIREN sumbission form"),
  br(),
  fluidRow(
    shinyjs::useShinyjs(),
    useShinyalert(),  # Set up shinyalert
    
    column(4, wellPanel(
      dateInput("date", label = "Date", value = "1990-04-12"),
      fluidRow(
        column(6,numericInput("lon", "Longitude:", 142.5917, min = 0, max = 180)),
        column(6,numericInput("lat", "Latitude:", 11.3733, min = 0, max = 90))
      ),
      textInput("text", "Species:", "scientific name..."),
      hr(),
      fluidRow(
        column(12, align="right",
               actionButton("Button" ,"Load", icon("refresh"))
        ))
      )),
    
    column(7,
           fluidRow(
             column(12, align="center",
                    leafletOutput("mymap", width = "100%", height = 300),
             )),
           br(),
           # checkboxInput("somevalue", "Some value", FALSE),
           # verbatimTextOutput("checked"),
           p("Form checks:"),
           pre(class = "header", style="line-height:2; white-space: normal;",
              htmlOutput("location"),
              htmlOutput("value"),
              htmlOutput("text"),
           ),
           fluidRow(br(),
                    column(12, align="right",
                           actionButton("submit", "SUBMIT", class = "btn btn-primary")
                    ))
    )
  )
)
