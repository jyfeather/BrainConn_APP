library(shiny)
library(networkD3)

shinyUI(fluidPage(
  
  # Load D3.js
  tags$head(
    tags$script(src = 'http://d3js.org/d3.v3.min.js')
  ),
  
  # Application title
  titlePanel('Brain Connectivity Network Simulator'),
  
  tags$h3("Explore Brain Network"),
  hr(),
  
  sidebarLayout(
    # Show network graph
    mainPanel(
      forceNetworkOutput('networkPlot')
    ),
    
    sidebarPanel(
      sliderInput('threshold', label = 'choose threshold to control amounts of links',
                  min = 0, max = 1, step = 0.1, value = 0.2),
      sliderInput('opacity_node', label = 'choose opacity for nodes',
                  min = 0, max = 1, step = 0.2, value = 0.8),
      sliderInput('opacity_text', label = 'choose opacity for labels',
                  min = 0, max = 1, step = 0.5, value = 0),
      
      checkboxInput('legend', label = 'show legends', value = FALSE),
      checkboxInput('stats', label = 'show stats', value = FALSE),
      checkboxInput('zoom', label = 'trigger zoom', value = FALSE)
    )
  )
))