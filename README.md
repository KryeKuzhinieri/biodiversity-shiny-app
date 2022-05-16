# Biodiversity Shiny App

- [About The Project](#about-the-project)
- [Getting Started](#getting-started)
- [License](#license)

## About the project
This project aims to display biodiversity in Poland. It displays information such as species' kingdoms, families, cities etc.

## Getting started
To successfully deploy the application, you need the following R dependencies.
```R
library(shiny)
library(leaflet)
library(dplyr)
library(plotly)
library(jsonlite)
library(shinyjs)
```
Module servers are located in the **modules** folder whereas the js ones are in **www**. Graph explanations are done through the introjs module which is located in the **www** folder. 

## License
Distributed under the MIT License. See ```LICENSE``` for more information.