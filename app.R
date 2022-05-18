library(shiny)
library(leaflet)
library(dplyr)
library(plotly)
library(jsonlite)
library(shinyjs)


source("utils.R", local = T)
source("modules/leafletModule.R", local = T)


ui <- fluidPage(
    useShinyjs(),
    tags$div(id = 'splash_screen',
        tags$div(
            class = 'splash_screen_icons',
            tags$img(src='svg/logo.svg', class = 'splash_logo'),
        )
    ),
    tags$div(
        class = "main-container",
        tags$head(tags$link(rel="Biodiversity Dashboard", href="svg/logo.svg")),
        tags$img(src = "svg/logo.svg", class = "main-logo"),
        fluidRow(
            column(
                class = "buttons",
                uiOutput("species_choices"),
                tags$button(
                    id = "help",
                    class = "helplink",
                    onclick = "Shiny.onInputChange('help_me', Date.now())",
                    img(src = "svg/help.svg", height = 24, width = 25)
                ),
                width = 12
            ),
            uiOutput("stat_cards"),
            fluidRow(
                class = "map-pies",
                column(width = 6, plotContainer(leafletUI("main_map", width = 12), "Location of Species")),
                column(width = 6, plotContainer(plotlyOutput("subplots"), "Top 5 Kingdoms, Families, and Cities"))
            ),
            fluidRow(
                class = "barplots",
                column(plotContainer(plotlyOutput("barchart"), "Number of Species Per City"), width = 12)
            ),
            includeCSS("www/css/custom_styles.css"),
            includeScript("www/js/script.js"),
            includeScript("www/js/intro.min.js")
        )
    )

)

server <- function(input, output, session) {
    raw_data <- read.csv(file = "data/poland.csv", sep = ",") 
    initial_stats <- getStatistics(raw_data)

    # Picker for selecting/searching species.
    output$species_choices <- renderUI(
        shinyWidgets::pickerInput(
            inputId = "species_name",
            label = "Vernacular or Scientific Name",
            multiple = T,
            choices = initial_stats["species_names"],
            selected = c("Orthilia secunda", "Lentinus tigrinus", "Corvus frugilegus"),
            options = list(
              `actions-box` = TRUE,
              `live-search` = TRUE,
              `live-search-placeholder` = "Search",
              `none-selected-text` = "Select Fields",
              `tick-icon` = "",
              `virtual-scroll` = 10,
              `size` = 6
            )
        )
    )

    output$stat_cards <- renderUI(infoBox(initial_stats))
    
    output$subplots <- renderPlotly(plotSubplots(initial_stats))

    output$barchart <- renderPlotly(plotBarchart(initial_stats$cities))

    state <- reactiveValues()

    leafletServer("main_map", state)

    runjs("
        setTimeout(function() {
          $('#splash_screen').fadeOut(300, function() { $(this).remove(); });
          Shiny.setInputValue('help_me', Math.random());
        }, 2000);"
    )
    

    observeEvent(input$species_name, {
        state$data <- raw_data %>%
            filter(
                vernacularName %in% input$species_name | scientificName %in% input$species_name
            )
        state$stats <- getStatistics(state$data)
        output$stat_cards <- renderUI(infoBox(state$stats))
        output$subplots <- renderPlotly(plotSubplots(state$stats))
        output$barchart <- renderPlotly(plotBarchart(state$stats$cities))
        print(nrow(state$data))
    })

    
    observeEvent(input$help_me, {
        help_content <- list(
            c("1", "Select Species | Species can be selected by their vernacular or scientific names.", "#species_choices", "auto"),
            c("2", "Statistics | These statistics are summaries extracted for the selected data.", ".card", "auto"),
            c("3", "Map | The map shows where the species have been found.", "#main_map-map", "auto"),
            c("4", "Pie Charts | The pie charts show the data for top 5 most common types.", "#subplots", "auto"),
            c("5", "Barchart | Number of Species Per Polish City.", "#barchart", "auto")
        )

        help_content_colnames <- c("step","intro","element","position")
        help_content_df <- data.frame(matrix(unlist(help_content), nrow=length(help_content), byrow=T), stringsAsFactors = FALSE)
        colnames(help_content_df) <- help_content_colnames
        session$sendCustomMessage(type="startHelp", message=list(steps=toJSON(help_content_df)))
    })

}

shinyApp(ui = ui, server = server)
