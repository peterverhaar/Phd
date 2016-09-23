
setwd("C:\\Users\\Peter\\Documents\\PhD\\CaseStudy\\R") ;

library(ggplot2)
library(reshape)

setwd("C:\\Users\\Peter\\Documents\\PhD\\CaseStudy\\R")

d <- read.csv("data.csv") ; 
nrs <- 1:nrow(d) ;  


dN <- cbind( nrs ,  d$assonance_N , d$consonance_N   ); 
dN <- as.data.frame( dN ) ; 
colnames(dN) <- c( "poem" ,  "Assonance", "Consonance" ) ; 

dM <- melt( dN , id = c("poem") ) 


p <- ggplot( data = dM , aes( x = poem , y = value , colour = variable ) )
p <- p + geom_line(  , size = 1 ) 
#31 , 53 , 77 , 108 , 141 , 172 , 182 , 208 , 232 , 275
#p <- p + geom_line ( aes ( x = 31 , y = -1:1 )  , size = 1 , colour = "#FFFFFF" , linetype = "dashed" )
#p <- p + geom_line ( aes ( x = 53  )  , size = 1 )
#p <- p + geom_line ( aes ( x = 77  )  , size = 1 )
#p <- p + geom_line ( aes ( x = 108  )  , size = 1 )
p <- p + ylim( -0.05 , 0.5 ) +
  scale_x_continuous(breaks = c(50 , 100 , 150 , 200, 250 , 300) ) ; 
 
p <- p + scale_colour_manual( values = c("#ED4113" , "#2D9E08" , "darkblue" ) ) 
p <- p + xlab( "Poems, sorted chronology" ) + ylab("Normalised counts") + geom_vline(xintercept = c( 31, 53 , 77 , 107 , 140 , 172 , 182 , 208 , 231 , 275  ) , col = '#858C85' , linetype = "longdash" )


p <- p + theme( legend.position = "top" , legend.direction = "vertical" , legend.title=element_blank() )

print( p ) ; 