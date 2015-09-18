# load preset data
dataobs_AD <- read.csv(file = "MRI_AD.csv", header = T)
dataobs_NL <- read.csv(file = "MRI_NL.csv", header = T)
dataobs_MCI <- read.csv(file = "MRI_MCI.csv", header = T)
nodes <- read.csv(file = "AAL_Yan.csv")
rownames(dataobs_AD) <- nodes$name

shinyServer(function(input, output) {
  output$table <- renderTable({
    t(dataobs_AD[1:6, 1:18])
  })
})