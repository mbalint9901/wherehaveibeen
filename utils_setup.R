library(countrycode)
library(leaflet)
library(DT)
library(readxl)
library(janitor)
library(tidyverse)

data <- readxl::read_xlsx("data/country_year_tier.xlsx") %>% 
  clean_names() %>%
  mutate(country_code = countrycode::countrycode(country, origin = "country.name",
                                                 destination = "iso3c")) %>%
  left_join(
    sf::st_as_sf(maps::map('world', plot = F, fill = T)) %>% # world map
      mutate(country_code = countrycode::countrycode(ID, origin = "country.name",
                                                destination = "iso3c"))
  ) %>% 
  sf::st_as_sf()

factpal <- colorFactor(c("#2f4c3e", "#A36352", "#D44B51",
                           "#5A6E9F", "white"), data$tier)
