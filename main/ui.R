library(shiny)
library(d3heatmap)
library(networkD3)

shinyUI(fluidPage(
  titlePanel(tags$a(href = "http://brainconnectivity.cc/", "Brain Connectivity")),
  helpText("!", tags$a(href = "https://github.com/jyfeather/BrainConn_APP/issues/new", "Bug Report")),
  hr(),
  
  ###
  sidebarLayout(
    sidebarPanel(
      fileInput('file', 'Upload PET scan files', accept = c('text/csv', '.csv')), 
      helpText('Note: Each row represents one observation while each column represents one ROI,
               refer to sample dataset in the homepage for more information.'),
      tags$hr(),
      sliderInput('lambda', 'Choose Lambda:', min = 0.001, max = 0.005, step = 0.0002, value = 0.004),
      tags$hr(),
      actionButton('updateNet', 'update')
    ), # end sidebarPanel
    
    mainPanel(
      tabsetPanel(
        tabPanel('Data', tableOutput('table')),
        tabPanel('Interactive Network', br(), forceNetworkOutput('networkPlot')),
        tabPanel('Interactive Checkbox', br(), d3heatmapOutput('checkboxPlot', width = '1000', height = '800')),
        tabPanel('Network for Download', br(), plotOutput('igraph'), br(), downloadButton('downloadGraph', 'Download Graph')),
        tabPanel('Network Statistics', br(), tableOutput('stats'), br(), downloadButton('downloadStats', 'Download Stats'))
      )
    ) # end mainPanel
  ) # end sidebarLayout
)) # end shinyUI