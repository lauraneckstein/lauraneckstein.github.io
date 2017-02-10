library(leaflet)
library(shiny)
library(readr)

ui <-
  navbarPage(
    "ADL Hate Crime Mapping and Visualizations Beta",
    id = "nav",
    tabPanel(
      'Table 13: Bias Motivation Map',
      div(
        class = 'outer',
        tags$head(# Include custom CSS
          includeCSS('style.css')),
        leafletOutput("map", width = "100%", height = "100%"),
        absolutePanel(
          id = "controls",
          class = "panel panel-default",
          fixed = TRUE,
          draggable = TRUE,
          top = 120,
          left = 80,
          right = "auto",
          bottom = "auto",
          width = "400",
          height = "auto",
          h2("Hate Crimes by Bias Motivation"),
          p(
            "Use the time slider and input box below to explore hate crime statistics from the FBI's Table reports on hate crimes from 2004-2015. "
          ),
          sliderInput(
            "range",
            "Years:",
            min(table13_cities$date),
            max(table13_cities$date),
            value = range(table13_cities$date),
            step = 367,
            timeFormat = "%Y",
            round = TRUE,
            dragRange = TRUE
          ),
          selectInput("year", "Hate Crime Bias Motivation:", vars, selected = "Disability")
        )
        
      )
    ),
    tabPanel(
      'Table 14: Hate Crime Zero Map',
      div(
        class = 'outer',
        tags$head(# Include custom CSS
          includeCSS('style.css')),
        leafletOutput("map2", width = "100%", height = "100%"),
        absolutePanel(
          id = "controls",
          class = "panel panel-default",
          fixed = TRUE,
          draggable = TRUE,
          top = 120,
          left = 80,
          right = "auto",
          bottom = "auto",
          width = "400",
          height = "auto",
          h2("Did Not Report and Zero Hate Crime Data for U.S. Cities"),
          p(
            "Use the time slider and input box below to explore hate crime statistics from the FBI's Table reports on hate crimes from 2004-2015. "
          ),
          sliderInput(
            "range2",
            "Years:",
            min(table14_cities$date),
            max(table14_cities$date),
            value = range(table14_cities$date),
            step = 367,
            timeFormat = "%Y"
          ),
          selectizeInput("year2", "Hate Crime Bias Motivation:", vars2, selected = "Did Not Report")
        )
        
      )
    )
  )
