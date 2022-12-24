
library(shiny)
library(shinythemes)
library(leaflet)

shinyUI(
  navbarPage(
    theme = shinythemes::shinytheme("flatly"), collapsible = TRUE,
    windowTitle = "Where Have I Been?",
    id="nav",
    title = 
        "Where Have I Been?",
    
    tabPanel("World Map", 
             
             div(
               class = "outer",
               tags$head(includeCSS("styles.css")),
               tags$head(tags$link(rel="shortcut icon", href="favicon.png")),
               leafletOutput("leafletmap", width="100vw", height="100vh"),
               
               absolutePanel(id = "controls", 
                             class = "panel panel-default",
                             top = "20%", left = "5%", width = "25%", fixed=TRUE,
                             draggable = TRUE, height = "60%",
                             h4("Year", align = "center"),
                             uiOutput("timefilter_box", align = "center"),
                             h4("Top 10 countries to date", align = "center"),
                             dataTableOutput("datatable")
               ),
               
               absolutePanel(id = "logo", class = "card", bottom = 20, left = 20, width = 100, fixed=TRUE, draggable = FALSE, height = "auto",
                             tags$a(href='https://balintmazzag.netlify.app/', tags$img(src='bmazzag_logo.png',
                                                                                       height='100%',width='100%')))
             ))
  )
)



