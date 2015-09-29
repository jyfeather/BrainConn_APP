library(shiny)
library(d3heatmap)

shinyUI(fluidPage(
  titlePanel('Brain Connectivity Network Simulator'),
  tags$h3('Dr. Shuai Huang\'s work'),
  hr(),
  
  navlistPanel(
    "Compare NL, MCI and AD",
    tabPanel("Matrix View",
             tabsetPanel(
               tabPanel("NL", d3heatmapOutput("heat_NL", width = "1000px", height = "800px")),
               tabPanel("MCI", d3heatmapOutput("heat_MCI", width = "1000px", height = "800px")),
               tabPanel("AD", d3heatmapOutput("heat_AD", width = "1000px", height = "800px"))
             ),
             sliderInput('lambda', label = "Select Penalty", min = 0.001, max = 0.01, step = 0.0005, value = 0.001)),
    tabPanel("Connectivity Difference"),
    tabPanel("Connectivity Strength"),
    
    widths = c(3,9)
  )
))