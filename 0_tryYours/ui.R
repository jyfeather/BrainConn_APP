library(shiny)
library(d3heatmap)

shinyUI(fluidPage(
  titlePanel("Brain Connectivity Platform"),
  h3("Try Your Data"),
  hr(),
  
  # first: upload data
  h4("Upload Your Data:"),
  helpText('Only support csv file currently, check homepage for more details'),
  fluidRow(
    column(4, fileInput('fileAD', 'Upload files for AD', accept = c('text/csv', '.csv'))),
    column(4, fileInput('fileNL', 'Upload files for NL', accept = c('text/csv', '.csv'))),
    column(4, fileInput('fileMCI', 'Upload files for MCI', accept = c('text/csv', '.csv')))
  ),
  hr(),
  
  h4("Choose Parameters:"),
  hr(),
  h4("Results:")
  
 
)) # end shinyUI