# Biodiversity Shiny App

- [About The Project](#about-the-project)
- [Getting Started](#getting-started)
- [License](#license)
- [Citation](#citation)

## About the project
This project aims to display species occurrences in Poland. It displays information such as species' kingdoms, families, cities etc. The dataset is extracted from [here](https://www.gbif.org/occurrence/search?dataset_key=8a863029-f435-446a-821e-275f4f641165). The deployed version of the app can be found here https://kryekuzhinieri.shinyapps.io/biodiversity_shiny_app/

## Getting started
To successfully deploy the application, you need the following R dependencies.
```r
library(shiny)
library(leaflet)
library(dplyr)
library(plotly)
library(jsonlite)
library(shinyjs)
```
Module servers are located in the **modules** folder whereas the js ones are in **www/js**. Graph explanations are done through the introjs module which is located in the **www/js** folder. 

## License
Distributed under the MIT License. See ```LICENSE``` for more information.

## Citation
 GBIF.org (15 May 2022) GBIF Occurrence Download https://doi.org/10.15468/dl.kyy2gw 