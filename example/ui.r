library(shiny)
library(networkD3)
library(d3heatmap)

shinyUI(fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "temp.css")
  ),
  
  # Application title
  titlePanel(tags$a(href = "http://brainconnectivity.cc/", "Brain Connectivity Example")),
  helpText("!", tags$a(href = "https://github.com/jyfeather/BrainConn_APP/issues/new", "Bug Report")), 
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
  fluidRow(
    column(4, sliderInput('lambda', label = 'choose penalty to control sparsity',
              min = 0.001, max = 0.005, step = 0.0002, value = 0.0035)),
    column(4, actionButton('updateNet', 'Update Network'))
  ),
  hr(),
  
  ###
  helpText('STEP 5: Show Results'),
  tabsetPanel(
    tabPanel('Interactive Network', br(), forceNetworkOutput('networkPlot')),
    tabPanel('Interactive Checkbox', br(), d3heatmapOutput("checkboxPlot", width = '1000', height = '800'), br()),
    tabPanel('Network Statistics', br(), tableOutput("stats"),
             br(), downloadButton('downloadStats', 'Download Data'))
  )
))