library(shiny)
library(networkD3)

shinyUI(fluidPage(
  
  # Load D3.js
  tags$head(
    tags$script(src = 'http://d3js.org/d3.v3.min.js')
  ),
  
  # Application title
  titlePanel('Brain Connectivity Network Simulator'),
  
  h3("Single Group Analysis"),
  hr(),
  
  fluidRow(
    column(4, sliderInput('lambda', 
                          label = 'choose penalty to control sparsity',
                          min = 0.001, max = 0.005, step = 0.001, value = 0.002)),
    column(4, sliderInput('thershold', 
                          label = 'choose threshold to control sparsity',
                          min = 0, max = 1, step = 0.1, value = 0.3)),
    column(4, checkboxInput('legend', label = 'show legends', value = FALSE))
  ),
  
  fluidRow(
    # Show network graph
    column(8,
      h3("Network Visualization"),
      forceNetworkOutput('networkPlot')
    ),
    
    # show network stats
    column(4,
      h3("Complex Network Statistics"),
      tableOutput("stats")
    )
  )
))