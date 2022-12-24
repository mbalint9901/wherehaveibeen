
library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  visited_countries <- reactive({
    data %>% 
      sf::st_as_sf() %>% 
      filter(first_visit <= input$year_input)
  })
  
  
  map <- leaflet() %>% 
    setView(lng = -50, lat = 30, zoom = 2) %>% 
    addTiles() %>% 
    addProviderTiles(providers$CartoDB.PositronNoLabels) 
  
  output$leafletmap <- renderLeaflet({
      map %>% 
      addPolygons(data = visited_countries(), color = ~factpal(tier), weight = 1,
                  layerId = data$country_code,
                  smoothFactor = 0.5, fillOpacity = 0.8,
                  opacity = 1,
                  highlightOptions = highlightOptions(color = "white", weight = 2,
                                                      bringToFront = TRUE),
                  popup= ~str_c('<strong>', country ,
                                '</strong><br/>Tier:', tier,
                                '<br/>First visited:', first_visit,
                                '<br/><a href = "https://www.wikipedia.org/wiki/', 
                                country, 
                                '"> Wikipedia link </a>'),
                  label = 
                    ~sprintf(
                      "<strong>%s</strong><br/>First visited: %s<br/>Tier: %s",
                      country, first_visit, tier
                    ) %>% lapply(htmltools::HTML))
    })

  
  output$datatable <- renderDataTable({
    data %>% 
      filter(first_visit <= input$year_input) %>% 
      select(country, tier) %>% 
      arrange(tier) %>% 
      rename_all(str_to_sentence) %>% 
      datatable(options = list(dom="t", pageLength = 10)) %>% 
      formatStyle("Tier",
                  color = "white",
                  backgroundColor = styleEqual(
                    unique(data$tier), alpha(factpal(unique(data$tier)),0.4)
                  ))
  })
  
  output$timefilter_box <- renderUI({
    sliderInput("year_input",
                "",
                min = min(data$first_visit),
                value = min(data$first_visit),
                max = max(data$first_visit),
                ticks = FALSE, sep = "")
  })
  })
