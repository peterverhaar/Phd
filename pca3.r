
setwd("C:\\Users\\Peter\\Documents\\PhD\\CaseStudy\\R") ;
library("ggplot2")
#library(directlabels)
 
d <- read.csv( "dataZ.csv" , head = TRUE ) ;  
#l <- d$label
l <- rownames(d)
d <- d[ , 6:16 ]

pca <- prcomp( d , center = TRUE, scale. = TRUE)
scores <- data.frame( pca$x[,1:3])



# plot and add labels
plot( pca$x[,1], pca$x[,2])
text( pca$x[,1], pca$x[,2],labels= l , pos = 1)
