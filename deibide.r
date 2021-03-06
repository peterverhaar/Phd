
setwd("C:\\Users\\Peter\\Documents\\PhD\\CaseStudy\\R") ;

library(ggplot2)
require(graphics)


m <- read.csv("data.csv" , header = TRUE )
q <- quantile( m$deibide_N , 0.95  )

ms <- m[ which( m$deibide_N >= q ) , ]
ms$title = rownames(ms)
ms <- ms[ order( -ms$deibide_N ) , ]


a <- ggplot( ms , aes( x= reorder( rownames( ms ) , ms$deibide_N )   , y= deibide_N  ) ) ;
a <- a + geom_bar(stat='identity', binwidth = 1 , fill = "#6E797D" ) ; 

a <- a +  coord_flip() ;
#a <- a + scale_fill_manual(values=colours)
a <- a + xlab("Deibhide rhyme") + ylab("Normalised counts") ;

print(a) ;