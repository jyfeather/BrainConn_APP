# Load packages
library(networkD3)
library(glasso)
library(d3heatmap)

################### Function Definiton Begin ####################
# convert inverse covariance matrix to links
wi2link <- function(mat) {
  mat <- abs(mat)
  diag(mat) <- 0
  min <- min(mat)
  max <- max(mat)
  links <- data.frame(from = NA, to = NA, weight = NA)
  for (i in 1:nrow(mat)) {
    for (j in 1:ncol(mat)) {
      if (mat[i,j] != 0 & i != j) {
        links <- rbind(links, c(i-1,j-1,range01(mat[i,j],min,max)))
      } 
    } 
  }
  return(links[-1,])
}

# scale to range [0,1]
range01 <- function(var, min, max) {
  res <- (var-min)/(max-min)
  return(res)
}

################### Function Definiton END ####################

################### Logic Begin ###################
# Prepare data
nodes <- read.csv(file = "AAL_Yan.csv")
# refer to matlab toolbox: https://sites.google.com/site/bctnet/
measure = c("Global Efficiency", "Local Efficiency", 
                           "Small World Index", "Clustering Coef",
                           "Assortivity", "Degree", "Mordularity")
statsTable <- data.frame(measure, value = rep(NA, length(measure)))

# shiny server
shinyServer(function(input, output) {
  ### sharable data
  inputdata <- reactive({
    inFile <- input$inputFile
    if (is.null(inFile)) {
      return(NULL)
    }
    tmp <- read.csv(inFile$datapath, header = TRUE)
    tmp[,nodes$name]
  })

  # generate inverse covariance matrix given lambda
  wi <- reactive({
    tmp <- glasso(s = cov(inputdata()), rho = input$lambda)
    tmp <- tmp$wi
  })

  ### output
  # output: data table 
  output$sampletable <- renderTable({
    tmp <- inputdata()
    tmp[1:10, 1:10]
  })
  
  # output: interactive network plot
  networkPlot <- eventReactive(input$updateNet, {
    links <- wi2link(wi())
    forceNetwork(Nodes = nodes, Links = links,
                Source = "from", Target = "to",
                Value = "weight", NodeID = "name",
                Group = "region", zoom = TRUE, legend = input$legend)
  })
  output$networkPlot <- renderForceNetwork({
    networkPlot() 
  })

  # output: checkbox network plot
  checkboxPlot <- eventReactive(input$updateNet, {
    tmp <- wi()
    tmp[which(tmp!=0)] <- 1
    d3heatmap(tmp, Rowv = FALSE, Colv = "Rowv", colors = grey(c(1,0)),
                labRow = nodes$name, labCol = nodes$name)
  })
  output$checkboxPlot <- renderD3heatmap({
    checkboxPlot() 
  })
  
  # output: statistics
  stats <- eventReactive(input$updateNet, {
    statsTable  
  })
  output$stats <- renderTable({
    stats()
  })
})
################### Logic END ###################