library(shiny)
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

# shiny server
shinyServer(function(input, output) {
  # reactive data
  dat <- reactive({
    inFile <- input$fileAD
    if (is.null(inFile)) {
      return(NULL) 
    }
    tmpdat <- read.csv(inFile$datapath, header = input$header)
    t(tmpdat)
  })
  
  # tab1: data preview
  output$table <- renderTable({
    tmpdat <- dat()
    tmpdat[1:10, 1:10]
  })
  
  # tab2: heatmap
  output$heat <- renderD3heatmap({
    cov <- cov(dat())
    fit <- glasso(s = cov, rho = input$lambda)
    gh <- matScale(fit$wi)
    dendrogram <- getDendrogram(gh)
    d3heatmap(gh, Rowv = NA, dendrogram = 'none')
  })
}) # shinyServer end