library(shiny)
library(d3heatmap)

shinyUI(fluidPage(
  titlePanel('Brain Connectivity Network Simulator'),
  tags$h3('Multiple Group Comparison'),
  hr(),
  
  fluidRow(
    column(6, sliderInput('lambda', label = "Select Penalty", min = 0.001, max = 0.01, step = 0.0005, value = 0.001)),
    column(6, checkboxInput('same', 'Same Order for Comparison'))
  ),
  
  tabsetPanel(
   tabPanel("Normal Aging", d3heatmapOutput("heat_NL", width = "1000px", height = "800px")),
   tabPanel("Mild Cognitive Impairment", d3heatmapOutput("heat_MCI", width = "1000px", height = "800px")),
   tabPanel("Alzheimer's Disease", d3heatmapOutput("heat_AD", width = "1000px", height = "800px"))
  )
))