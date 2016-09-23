
setwd("C:\\Users\\Peter\\Documents\\PhD\\CaseStudy\\R") ;

library(ggplot2)
library(reshape)

setwd("C:\\Users\\Peter\\Documents\\PhD\\CaseStudy\\R")

d <- read.csv("a.csv") ; 
 
d2 <- cbind( ( d$all / d$tokens ) , ( ( d$t1+ d$t2 +d$t3 +d$t4 )  / d$tokens )  ) 
d2 <- as.data.frame( d2 ) ; 
colnames(d2) <- c( "all1", "all2" ) ; 
rownames(d2) <- d$poem

d2 <- d2[ which( d2$all2 != 0 ) , ]


p <- ggplot( d2 , aes( x= all1 , y = all2 , label = rownames(d2) ) )  + geom_point( size = 2 ) + geom_text(  aes( alpha=ifelse( ( ( d2$all1 >0.2) | (d2$all2>0.1) ) ,0.8 , 0.2 ) , size = 3 , vjust = -0.8 ) ) + xlab("Type-token ratio") + ylab("Word length") + theme(legend.position="none") + xlab("Alliteration") + ylab("Nested, coupled, alternating alliteration")

print( p ) ; 