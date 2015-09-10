library(shiny)

shinyUI(fluidPage(
  
  # Load D3.js
  tags$head(
    tags$script(src = 'http://d3js.org/d3.v3.min.js')
  ),
  
  # Application title
  titlePanel('Brain Connectivity Network Simulator'),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput('slider', label = 'choose threshold to control amounts of links',
                  min = 0, max = 1, step = 0.1, value = 0.5
      )
    ),
    
    # Show network graph
    mainPanel(
      htmlOutput('networkPlot')
    )
  )
))