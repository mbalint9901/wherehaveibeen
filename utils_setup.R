library(tidyverse)

data <- readxl::read_xlsx("data/country_year_tier.xlsx") %>% 
  clean_names() %>%
  mutate(country_code = countrycode::countrycode(country, origin = "country.name",
                                                 destination = "iso2c"),
         image_link = str_c(
           "https://cdn.rawgit.com/lipis/flag-icon-css/master/flags/4x3/", tolower(country_code), ".svg"
         ))

data_geom <- 
  left_join(data,
            sf::st_as_sf(maps::map('world', plot = F, fill = T)) %>% # world map
              mutate(country_code = countrycode::countrycode(ID, origin = "country.name",
                                                             destination = "iso2c"))
  ) %>% 
  sf::st_as_sf()

factpal <- colorFactor(c("#2f4c3e", "#A36352", 
                         "#5A6E9F",  "#D44B51","white"), data$tier)

save(
  data, data_geom, factpal,
  file = "data/data_render.RData"
)
