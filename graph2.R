# Load package
library(networkD3)


setwd("C:\\Users\\Peter\\Documents\\PhD\\CaseStudy\\R") ;

 
data <- read.csv( "data.csv" , head = TRUE ) ;  



 
#### Tabular data example.
# Load data

nodes <- read.csv("nodes.txt", head = TRUE ) ; 
links <- read.csv("links.txt", head = TRUE ) ; 

 
# Create graph
p <- forceNetwork(Links = links, Nodes = nodes, Source = "source",
Target = "target", Value = "value", NodeID = "label", opacityNoHover = 1 , fontFamily = "Verdana" ,
Group = "group", opacity = 1 , fontSize = 12.5 , zoom = TRUE , legend = TRUE , 
charge = -275 
, linkDistance = 100  
#, height = 800 
#, width = 1000
  )
 
print(p)
 