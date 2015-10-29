# Load packages
library(networkD3)
library(glasso)
library(d3heatmap)
library(igraph)

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
measure = c("Assortivity", "Cliques", "Transitivity")
statsTable <- data.frame(measure, value = rep(NA, length(measure)),
                         meaning = c("The assortativity coefficient is positive is similar vertices (based on some external property) tend to connect to each, and negative otherwise.",
                                     "The size of the largest clique",
                                     "Transitivity measures the probability that the adjacent vertices of a vertex are connected. This is sometimes also called the clustering coefficient."))

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
  
  # update statistical table
  statsTable2 <- reactive({
    tmp <- wi()
    tmp[which(tmp!=0)] <- 1
    tmp.g <- graph.adjacency(tmp, mode = "undirected") # create igraph object given adjacency matrix
    # update graph statistics
    statsTable[statsTable$measure=="Assortivity","value"] <- assortativity_degree(tmp.g)
    statsTable[statsTable$measure=="Cliques","value"] <- clique_num(tmp.g)
    statsTable[statsTable$measure=="Transitivity","value"] <- transitivity(tmp.g, type = "undirected")
    statsTable
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
                Group = "region", zoom = TRUE)
  })
  output$networkPlot <- renderForceNetwork({
    networkPlot() 
  })

  # output: checkbox network plot
  checkboxPlot <- eventReactive(input$updateNet, {
    tmp <- wi()
    tmp[which(tmp!=0)] <- 1
    diag(tmp) <- 0
    d3heatmap(tmp, Rowv = FALSE, Colv = "Rowv", colors = grey(c(1, 0)),
                labRow = nodes$name, labCol = nodes$name)
  })
  output$checkboxPlot <- renderD3heatmap({
    checkboxPlot() 
  })
  
  # output: statistics
  stats <- eventReactive(input$updateNet, {
    statsTable2()
  })
  output$stats <- renderTable({
    stats()
  })
  
  ## download
  output$downloadStats <- downloadHandler(
    filename = c('brain_connectivity.csv'),
    content = function(file) {
      write.csv(statsTable2(), file)
    }
  )
})
################### Logic END ###################