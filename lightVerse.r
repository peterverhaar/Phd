
setwd("C:\\Users\\Peter\\Documents\\PhD\\CaseStudy\\R") ;

library(ggplot2)
library(reshape)


d <- read.csv("lv.csv") ; 

d <- d[ which( d$iamb != 0 ) , ]
d <- d[ which( d$rhyme != 0 ) , ]
 
p <- ggplot( d , aes( x= iamb , y = rhyme , label = rownames(d) ) )  + geom_point( size = 2 ) + geom_text( vjust = -0.8 , size =3 , alpha = ifelse( d$iamb > 0.19 | d$rhyme > 0.7 ,1,0.05) ) + theme(legend.position="none") + xlab("Iambic metre") + ylab("Perfect rhyme")

print( p ) ; 