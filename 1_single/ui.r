library(shiny)
library(networkD3)

shinyUI(fluidPage(
  
  # Load D3.js
  tags$head(
    tags$script(src = 'http://d3js.org/d3.v3.min.js')
  ),
  
  # Application title
  titlePanel('Brain Connectivity Example'),
  hr(),
  
  ###
  helpText('STEP 1: Download Sample Data'),
  a('Download PET SCAN of AD patient sample data', 
    href='https://www.dropbox.com/s/h2k3all4018wqfe/PET_AD.csv?dl=0',
    target='_blank'),
  hr(),
  
  ###
  helpText('STEP 2: Upload Your Data'),
  fileInput('inputFile', 'Upload Files', accept = c('text/csv', 'csv')),
  hr(),
  
  ###
  helpText('STEP 3: Show Data Fragment'),
  tableOutput('sampletable'),
  helpText('Due to large dimension, only first 10 observations with first 10 ROIs are shown.'),
  hr(),
  
  ###
  helpText('STEP 4: Choose Penalty Parameter'),
  sliderInput('lambda', label = 'choose penalty to control sparsity',
              min = 0.001, max = 0.005, step = 0.001, value = 0.002),
  hr(),
  
  ###
  helpText('STEP 5: Show Results'),
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
  ),
  hr(),
  
  ###
  helpText('STEP 6: Download Results'),
  hr()

))