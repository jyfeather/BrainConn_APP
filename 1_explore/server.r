# Load packages
library(d3Network)
library(glasso)

# Load data once
dataobs <- read.table(file = "./data/PET_Yan.csv", header = T)
datacov <- cov(t(dataobs))
res <- glasso(s = datacov, rho = 0.001)
res <- res$wi

# convert inverse covariance matrix to links
wi2link <- function(mat) {
  mat <- abs(mat)
  links <- data.frame(from = NA, to = NA, weight = NA)
  for (i in 1:nrow(mat)) {
    for (j in 1:ncol(mat)) {
      if (mat[i,j] != 0 & i != j) {
        links <- rbind(links, c(i-1,j-1,mat[i,j]))
      } 
    } 
  }
  return(links[-1,])
}

# prepare dataset for plotting
links <- wi2link(res)
nodes <- read.csv(file = "./data/AAl_Yan.csv")

# shiny server
shinyServer(function(input, output) {
  output$networkPlot <- renderPrint({
     d3ForceNetwork(Nodes = nodes,
                    Links = links,
                    Source = "from", Target = "to",
                    Value = "weight", NodeID = "name",
                    Group = "region", opacity = 0.8, standAlone = FALSE,
                    parentElement = '#networkPlot', zoom = TRUE)
  })
})