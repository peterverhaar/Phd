
setwd("C:\\Users\\Peter\\Documents\\PhD\\CaseStudy\\R") ;

library(lattice)


d <- read.csv("dataZ.csv") ; 

d2 <- d[ , 6:20 ]

irpca <- princomp( d2 )

irpca.plot <- xyplot( irpca$scores[,2] ~ irpca$scores[,1] ,
			panel=function(x, y, ...) {
               panel.xyplot(x, y, ...);
               ltext(x=x, y=y, labels= rownames(d2) , pos=1, offset=1, cex=0.8 , alpha = 0.4 )
            }  )
irpca.plot$xlab <- "First Component"
irpca.plot$ylab <- "Second Component"
print ( irpca.plot )