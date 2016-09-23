setwd("C:\\Users\\Peter\\Documents\\PhD\\CaseStudy\\R") ;


library(ggplot2)
library(reshape)
library(grid)

dT <- read.csv("countsImgDev.csv" , head = TRUE )
dT$paronymy <- NULL
#dT <- t(d)
#dT <- as.data.frame(dT)
#colnames(dT) <- rownames(d)
dT$img <- rownames(dT)
#d$img <- rownames(d)


dM <- melt(dT , id= c( "img" ) )

hm <- ggplot( dM, aes( img , variable , fill = value )) + geom_tile( colour = "white") ;
hm <- hm + scale_fill_gradient(low = "white",  high = "steelblue" ) ;


# "#990000"
base_size <- 9

hm <- hm + theme_grey(base_size = base_size) + labs(x = "",y = "") 
hm <- hm + scale_x_discrete(expand = c(0, 0)) + scale_y_discrete(expand = c(0, 0)) ;
hm <- hm + theme(legend.position = "none", axis.ticks = element_blank(), axis.text.x = element_text(size = base_size * 0.8, angle = 450, hjust = 0.5, colour = "grey50")) 


print( hm )
