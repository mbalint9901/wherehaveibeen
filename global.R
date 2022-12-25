library(stats)
library(countrycode)
library(leaflet)
library(DT)
library(readxl)
library(janitor)
library(tidyverse)
library(shinycssloaders)
library(sf)

load("data/data_render.RData")

options(spinner.color="#2f4c3e", spinner.color.background="#ffffff", spinner.size=1)