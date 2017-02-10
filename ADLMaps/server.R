function(input, output, session) {
  
  
  
  # Reactive expression for the data subsetted to what the user selected
  filteredData <- reactive({
    table13_cities[table13_cities$date >= input$range[1] & table13_cities$date <= input$range[2],]
  })
  
  filteredData2 <- reactive({
    table14_cities[table14_cities$date >= input$range2[1] & table14_cities$date <= input$range2[2],]
  })
  datapoints <- reactive({
    if(input$year=="disability.df"){
      return(disability.df) 
    }else if(input$year=="ethnicity.df"){
      return (ethnicity.df)
    }else if(input$year=="gender.df"){
      return (gender.df)
    }else if(input$year=="genderidentity.df"){
      return (genderidentity.df)
    }else if(input$year=="race.df"){
      return (race.df)
    }else if(input$year=="raceethnicityancestry.df"){
      return (raceethnicityancestry.df)
    }else if(input$year=="religion.df"){
      return (religion.df)
    }else if(input$year=="sexualorientation.df"){
      return (sexualorientation.df)
    }
  })
  
  datapoints2 <- reactive({
    if(input$year2=="didnotreport.df"){
      return(didnotreport.df) 
      
    }
  })
  
  
  output$map <- renderLeaflet ({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(table13_cities) %>% addProviderTiles("Stamen.Toner", options = providerTileOptions(maxZoom = 11)) %>%
      fitBounds(~min(longitude), ~min(latitude), ~max(longitude), ~max(latitude))
  })
  
  output$map2 <- renderLeaflet ({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(table14_cities) %>% addProviderTiles("Stamen.Toner", options = providerTileOptions(maxZoom = 9)) %>%
      fitBounds(~min(longitude), ~min(latitude), ~max(longitude), ~max(latitude))
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
    
    leafletProxy("map2", data = filteredData2()) %>% clearShapes() %>% clearMarkerClusters() %>% addMarkers(clusterOptions = markerClusterOptions(), popup=(table14_cities$place_name))
  })
  
  observe({
    
    leafletProxy("map2", data = datapoints2()) %>% clearShapes() %>% clearMarkerClusters() %>% addMarkers(clusterOptions = markerClusterOptions())
  })
}
