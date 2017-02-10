library(leaflet)
library(shiny)
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


server <- function(input, output, session) {
  # Reactive expression for the data subsetted to what the user selected
  filteredData <- reactive({
    table13_cities[table13_cities$date >= input$range[1] &
                     table13_cities$date <= input$range[2], ]
  })
  
  filteredData2 <- reactive({
    table14_cities[table14_cities$date >= input$range2[1] &
                     table14_cities$date <= input$range2[2], ]
  })
  datapoints <- reactive({
    if (input$year == "disability.df") {
      return(disability.df)
    } else if (input$year == "ethnicity.df") {
      return (ethnicity.df)
    } else if (input$year == "gender.df") {
      return (gender.df)
    } else if (input$year == "genderidentity.df") {
      return (genderidentity.df)
    } else if (input$year == "race.df") {
      return (race.df)
    } else if (input$year == "raceethnicityancestry.df") {
      return (raceethnicityancestry.df)
    } else if (input$year == "religion.df") {
      return (religion.df)
    } else if (input$year == "sexualorientation.df") {
      return (sexualorientation.df)
    }
  })
  
  datapoints2 <- reactive({
    if (input$year2 == "didnotreport.df") {
      return(didnotreport.df)
      
    }
  })
  
  
  output$map <- renderLeaflet ({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(table13_cities) %>% addProviderTiles("Stamen.Toner", options = providerTileOptions(maxZoom = 11)) %>%
      fitBounds( ~ min(longitude),
                 ~ min(latitude),
                 ~ max(longitude),
                 ~ max(latitude))
  })
  
  output$map2 <- renderLeaflet ({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(table14_cities) %>% addProviderTiles("Stamen.Toner", options = providerTileOptions(maxZoom = 9)) %>%
      fitBounds( ~ min(longitude),
                 ~ min(latitude),
                 ~ max(longitude),
                 ~ max(latitude))
  })
  
  # Incremental changes to the map (in this case, replacing the
  # circles when a new color is chosen) should be performed in
  # an observer. Each independent set of things that can change
  # should be managed in its own observer.
  observe({
    leafletProxy("map", data = filteredData()) %>% clearShapes() %>% clearMarkerClusters() %>% addMarkers(clusterOptions = markerClusterOptions())
  })
  # Use a separate observer to recreate the legend as needed.
  observe({
    leafletProxy("map", data = datapoints()) %>% clearShapes() %>% clearMarkerClusters() %>% addMarkers(clusterOptions = markerClusterOptions())
  })
  
  
  
  observe({
    leafletProxy("map2", data = filteredData2()) %>% clearShapes() %>% clearMarkerClusters() %>% addMarkers(clusterOptions = markerClusterOptions(),
                                                                                                            popup = (table14_cities$place_name))
  })
  
  observe({
    leafletProxy("map2", data = datapoints2()) %>% clearShapes() %>% clearMarkerClusters() %>% addMarkers(clusterOptions = markerClusterOptions())
  })
}
shinyApp(ui, server)
