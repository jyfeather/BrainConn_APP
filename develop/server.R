library(glasso)
library(d3heatmap)

# function definition
matScale <- function(mat, diag = FALSE) {
  mat <- abs(mat)
  if (!diag) {
    diag(mat) <- 0
  }
  mat <- apply(mat, MARGIN = 2, FUN = function(x) {(x - min(x))/diff(range(x))})
  return(mat)
}

# for d3heatmap use
reorderfun <- function(d, w) {
  return(d)
}

# get dendrogram for reorder
getDendrogram <- function(mat) {
  distance <- dist(mat)
  cluster <- hclust(distance, method = "ward.D")
  dendrogram <- as.dendrogram(cluster)
  Rowv <- rowMeans(mat)
  dendrogram <- reorder(dendrogram, Rowv)
  return(dendrogram)
}

# Load data
dataobs_AD <- read.csv(file = "MRI_AD.csv", header = T)
dataobs_NL <- read.csv(file = "MRI_NL.csv", header = T)
dataobs_MCI <- read.csv(file = "MRI_MCI.csv", header = T)
nodes <- read.csv(file = "AAL_Yan.csv")
dataobs_AD <- dataobs_AD[sort(nodes$id),]
dataobs_NL <- dataobs_NL[sort(nodes$id),]
dataobs_MCI <- dataobs_MCI[sort(nodes$id),]

# glasso
cov_AD <- cov(t(dataobs_AD))
cov_NL <- cov(t(dataobs_NL))
cov_MCI <- cov(t(dataobs_MCI))

shinyServer(function(input, output) {
  # heatmap plot
  output$heat_AD<- renderD3heatmap({
    fit_AD <- glasso(s = cov_AD, rho = input$lambda)
    gh_AD <- matScale(fit_AD$wi)
    dendrogram <- getDendrogram(gh_AD)
    if (input$same) {
      d3heatmap(gh_AD, Rowv = FALSE, Colv = "Rowv", colors = grey(8:2/8),
                labRow = nodes[order(nodes$id),"name"], labCol = nodes[order(nodes$id),"name"]) 
    } else {
      d3heatmap(gh_AD, Rowv = dendrogram, Colv = "Rowv", reorderfun = reorderfun, colors = grey(8:2/8))
    }
  })
  output$heat_NL<- renderD3heatmap({
    fit_NL <- glasso(s = cov_NL, rho = input$lambda)
    gh_NL <- matScale(fit_NL$wi)
    dendrogram <- getDendrogram(gh_NL)
    if (input$same) {
      d3heatmap(gh_NL, Rowv = FALSE, Colv = "Rowv", colors = grey(8:2/8),
                labRow = nodes[order(nodes$id),"name"], labCol = nodes[order(nodes$id),"name"]) 
    } else {
      d3heatmap(gh_NL, Rowv = dendrogram, Colv = "Rowv", reorderfun = reorderfun, colors = grey(8:2/8)) 
    }
  })
  output$heat_MCI<- renderD3heatmap({
    fit_MCI <- glasso(s = cov_MCI, rho = input$lambda)
    gh_MCI <- matScale(fit_MCI$wi)
    dendrogram <- getDendrogram(gh_MCI)
    if (input$same) {
      d3heatmap(gh_MCI, Rowv = FALSE, Colv = "Rowv", colors = grey(8:2/8),
                labRow = nodes[order(nodes$id),"name"], labCol = nodes[order(nodes$id),"name"])
    } else {
      d3heatmap(gh_MCI, Rowv = dendrogram, Colv = "Rowv", reorderfun = reorderfun, colors = grey(8:2/8)) 
    }
  })
})