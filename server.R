
library(shiny)

#   Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$leafletmap <- renderLeaflet({
    
    data_geom %>%
      filter(first_visit <= input$year_input) %>%
      leaflet() %>%
      setView(lng = -50, lat = 30, zoom = 2) %>%
      addTiles() %>%
      addProviderTiles(providers$CartoDB.PositronNoLabels) %>%
      addPolygons(color = ~factpal(tier), weight = 1,
                  layerId = data$country_code,
                  smoothFactor = 0.5, fillOpacity = 0.8,
                  opacity = 1,
                  highlightOptions = highlightOptions(color = "white", weight = 2,
                                                      bringToFront = TRUE),
                  popup= ~paste0(
                    '<strong>', country ,
                    '</strong><br/>Tier:', tier,
                    '<br/>First visited:', first_visit,
                    '<br/><a href = "https://www.wikipedia.org/wiki/',
                    country,
                    '"> Wikipedia link </a>'),
                  label =
                    ~paste0(
                      "<img src='",image_link,"' height='24px'>",
                      "&nbsp;&nbsp;&nbsp;&nbsp;<strong>", country, "</strong><br/>Click for more info!"
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
  
})
