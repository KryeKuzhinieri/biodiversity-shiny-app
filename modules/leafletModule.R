leafletUI <- function(id, width, ...) {
  ns <- NS(id)
  column(leafletOutput(ns("map"), ...), width = width)
}


leafletServer <- function(id, state, ...) {
  moduleServer(id, function(input, output, session) {
    ns <- NS(id)
    output[["map"]] <- renderLeaflet({
      leaflet(leafletOptions(scrollWheelZoom = F)) %>%
        addProviderTiles(
            providers$CartoDB.Positron,
            group = "CartoDB"
        ) %>% 
        addProviderTiles(
            providers$Stamen.TonerLines,
            options = providerTileOptions(opacity = 0.5, maxZoom = 22)
        ) %>% 
        setView(
            lat = 52.237049,
            lng = 21.017532,
            zoom = 6
        )
    })


    observe({
      state$data

      if (is.null(state$data)) return ()

      leafletProxy(ns("map")) %>%
        clearShapes() %>%
        clearMarkers() %>%
        clearMarkerClusters() %>%
        addAwesomeMarkers(
          lat = state$data$latitudeDecimal,
          lng = state$data$longitudeDecimal,
          label = state$data$scientificName,
          #popup = NULL,
          icon = awesomeIcons(
            library = "fa",
            icon = ifelse(state$data$kingdom == "Animalia", "paw", ifelse(state$data$kingdom == "Fungi", "globe", "pagelines")),
            markerColor = ifelse(state$data$kingdom == "Animalia", "lightred", ifelse(state$data$kingdom == "Fungi", "lightblue", "lightgreen"))
          ),
          layerId = c(1:nrow(state$data))
        )
    })
  })
}
