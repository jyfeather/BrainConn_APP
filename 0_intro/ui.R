library(shiny)
library(d3heatmap)

shinyUI(fluidPage(
  # first: upload data
  titlePanel("Introduction to Brain Connectivity"),
  helpText('This app shows how penalty term controls the sparsity of network.'),
  sidebarLayout(
    sidebarPanel(
      fileInput('fileAD', 'Upload files for AD (Alzheimer\'s Disease)', accept = c('text/csv', '.csv')), 
      checkboxInput('header', 'Header', TRUE),
      helpText('Note: If you want a sample .csv to upload, you can first download the sample',
               a(href='MRI_AD.csv', 'MRI_AD.csv'), ', and then try uploading it.'),
      tags$hr(),
      sliderInput('lambda', 'Choose Lambda:', min = 0, max = 0.01, value = 0.001),
      sliderInput('threshold', 'Choose Threshold:', min = 0, max = 1, value = 0.8),
      tags$hr(),
      actionButton('update', 'update')
    ), # end sidebarPanel
    
    mainPanel(
      tabsetPanel(
        tabPanel('Data', tableOutput('table')),
        tabPanel('Connectivity', d3heatmapOutput('heat'))
      )
    ) # end mainPanel
  ) # end sidebarLayout
)) # end shinyUI