# Load packages
library(networkD3)
library(glasso)

# Load data once
dataobs <- read.csv(file = "MRI_AD.csv", header = T)
datacov <- cov(t(dataobs))
res <- glasso(s = datacov, rho = 0.001)
res <- res$wi

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

# prepare dataset for plotting
links <- wi2link(res)
nodes <- read.csv(file = "AAL_Yan.csv")

# shiny server
shinyServer(function(input, output) {
  output$networkPlot <- renderForceNetwork({
     forceNetwork(Nodes = nodes,
                  Links = links[which(links$weight>input$threshold),],
                  Source = "from", Target = "to",
                  Value = "weight", NodeID = "name",
                  Group = "region", opacity = input$opacity_node, 
                  zoom = input$zoom, legend = input$legend,
                  opacityNoHover = input$opacity_text)
  })
})