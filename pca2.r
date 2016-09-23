
setwd("C:\\Users\\Peter\\Documents\\PhD\\CaseStudy\\R") ;
library("ggplot2")
#library(directlabels)
 
d <- read.csv( "dataZ.csv" , head = TRUE ) ;  
l <- d$label
d <- d[ , 6:16 ]

pca <- prcomp( d , center = TRUE, scale. = TRUE)
scores <- data.frame( pca$x[,1:3])



p <- ggplot( scores , aes( x = PC1 , y = PC2 , label = rownames(d) ) ) + geom_point( size = 2 , color = "darkblue") + geom_text( alpha = ifelse( scores$PC1>2.5 | scores$PC2 > 2.2 ,1,0.05) , size = 4 , vjust = -0.5  ) 
print(p)