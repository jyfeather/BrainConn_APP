# Load packages
library(networkD3)
library(glasso)

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
# dataobs <- read.csv(file = "MRI_AD.csv", header = T)
# datacov <- cov(dataobs)
# nodes <- read.csv(file = "AAL_Yan.csv")
# # refer to matlab toolbox: https://sites.google.com/site/bctnet/
# measure = c("Global Efficiency", "Local Efficiency", 
#                            "Small World Index", "Clustering Coef",
#                            "Assortivity", "Degree", "Mordularity")
# statsTable <- data.frame(measure, value = rep(NA, length(measure)))

# shiny server
shinyServer(function(input, output) {
  inputdata <- reactive({
    inFile <- input$inputFile
    if (is.null(inFile)) {
      return(NULL)
    }
    read.csv(inFile$datapath, header = TRUE)
  })
  
  output$sampletable <- renderTable({
    tmp <- inputdata()
    tmp[1:10, 1:10]
  })
  
  # generate inverse covariance matrix given lambda
#   wi <- reactive({
#     res <- glasso(s = datacov, rho = input$lambda)
#     res <- res$wi
#   })
#   
#   # network plot
#   output$networkPlot <- renderForceNetwork({
#      links <- wi2link(wi())
#      forceNetwork(Nodes = nodes, 
#                   Links = links[which(links$weight>input$thershold),],
#                   Source = "from", Target = "to",
#                   Value = "weight", NodeID = "name",
#                   Group = "region", zoom = TRUE, legend = input$legend)
#   })
#   
#   # stats plot
#   output$stats <- renderTable({
#     statsTable  
#   })
})
################### Logic END ###################