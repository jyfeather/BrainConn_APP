library(shiny)

shinyUI(fluidPage(
  # first: upload data
  titlePanel("Introduction to Brain Connectivity"),
  sidebarLayout(
    sidebarPanel(
      helpText('Note: A demo is shown at the right. Each row = each subject, while each column = each ROI region'),
      fileInput('fileAD', 'Upload files for AD (Alzheimer)', accept = c('text/csv', '.csv')), 
      actionButton('showAD', 'Quick look'),
      tags$hr(),
      fileInput('fileMCI', 'Upload files for MCI (Mild Cognitive Impairment)', accept = c('text/csv', '.csv')), 
      actionButton('showMCI', 'Quick look'),
      tags$hr(),
      fileInput('fileNL', 'Upload files for NL (Normal)', accept = c('text/csv', '.csv')),
      actionButton('showNL', 'Quick look'),
      tags$hr(),
      actionButton('showResult', 'See Result')
    ),
    mainPanel(
      tableOutput('table')
    )
  ),
  tags$hr(),
  
 # second: choose parameter
 absolutePanel(
   bottom = 20, right = 20, width = 300, draggable = TRUE,
   wellPanel(
     sliderInput('lambda', 'Choose Penalty to Control Network Sparsity', min = 0, max = 0.1, value = 0.001),
     style = "opacity: 0.9"
   )
 ),
 
 # third: compare two groups
 plotOutput('plot')
))