getStatistics <- function(raw_data) {
  # Picker input options
  scientific_name <- unique(raw_data$scientificName)
  vernacular_name <- unique(raw_data$vernacularName)
  species_names <- c(scientific_name, vernacular_name)
  
  raw_data <- raw_data %>% mutate(locality = gsub("Poland - ", "", locality))
  # Statistics
  cities <- table(raw_data$locality)
  kingdom <- table(raw_data$kingdom)
  family <- table(raw_data$family)
  individual_counts <- sum(raw_data$individualCount)
  
  data <- list(
    species_names = species_names,
    cities = cities,
    kingdoms = kingdom,
    families = family,
    count = individual_counts
  )
  return(data)
}


infoBox <- function(stats) {
  icons <- list(
    cities = "globe",
    kingdoms = "group",
    families = "user",
    count = "pie-chart"
  )
  lapply(names(stats), function(x) {
    if (x == "species_names") return ()
    column(
      width = 3,
      tags$div(
        class = "card",
        tags$div(
          class = "mini-class-icon",
          tags$i(class = "mini-stat-icon"),
          icon(icons[[x]], class = paste0("icons-rounded", " icon-", x), lib = "font-awesome")
        ),
        tags$div(
          class = "stats-card",
          tags$div(
            class = "main-text",
            toupper(x)
          ),
          tags$div(
            class = "values-container",
            tags$div(
              class = "main-value",
              if (x == "count") stats[[x]] else length(names(stats[[x]]))
            ),
            tags$div(
              class = "small-value",
            )
          )
        )
      )
    )
  })
}


plotSubplots <- function(stats) {
  colors <- c("#E8C07D", "#9FC088", "#CC704B", "#614124", "#E4AEC5")
  fig <- plot_ly(
    marker = list(
      colors = colors
    )
  )

  fig <- fig %>%
    add_pie(labels = names(sort(stats$kingdoms, T)[1:5]), values = sort(stats$kingdoms, T)[1:5], name = "Kingdom", domain = list(x = c(0, 0.4), y = c(0.4, 1)))

  fig <- fig %>%
    add_pie(labels = names(sort(stats$families, T)[1:5]), values = sort(stats$families, T)[1:5], name = "Families", domain = list(x = c(0.25, 0.75), y = c(0, 0.6)))

  fig <- fig %>%
    add_pie(labels = names(sort(stats$cities, T)[1:5]), values = sort(stats$cities, T)[1:5], name = "Citites", domain = list(x = c(0.6, 1), y = c(0.4, 1)))

  fig <- fig %>% layout(
    #title = "Pie Charts for most common Kingdoms, Families, and Citites",
    showlegend = F,
    xaxis = list(
      showgrid = FALSE,
      zeroline = FALSE,
      showticklabels = FALSE
    ),
    yaxis = list(
      showgrid = FALSE,
      zeroline = FALSE,
      showticklabels = FALSE
      ),
    margin = list(t = 40)
    )

  return (fig)
}


plotContainer <- function(plot, title) {
  tags$section(
      class = "dimension_chart_parent_section",
      tags$div(
        class = "dimension_chart_parent",
        style = "position:relative",
        tags$div(
          class = "dimension_chart_header",
          tags$div(class = "chart-title", title)
        ),
        tags$div(
          class = "dimension_chart_body",
          tags$div(plot),
          header = TRUE,
          status = "primary"
        )
      )
  )
}


plotBarchart <- function(stats) {
  colors <- c("#E8C07D", "#9FC088", "#CC704B", "#614124", "#E4AEC5")
  fig <- plot_ly(
    x = names(stats),
    y = stats,
    type = 'bar',
    text = names(stats),
    marker = list(
      color = "#CC704B",
      line = list(
        color = "#CC704B",
        width = 1.5
      )
    )
  )

  fig <- fig %>% layout(
    title = "",
    xaxis = list(title = "Cities in Poland"),
    yaxis = list(title = "Number of Occurrences")
  )

  return(fig)
}
