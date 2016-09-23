setwd("C:\\Users\\Peter\\Documents\\PhD\\CaseStudy\\R") ;


m <- read.csv("meterType.csv" , head = TRUE ) ; 


colours <- c( "#394DBF" , "#D6B706"  ) ;

barplot( as.matrix( m ), main = "Metrical patterns" ,
horiz = FALSE , las = 1 , col = colours ,  cex.lab = 1.5, cex.main = 1.4, beside=TRUE) ; 

legend("topright", row.names( m ) , cex=1.3, bty="n", fill=colours )

