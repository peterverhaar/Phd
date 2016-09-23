
setwd("P:\\My Documents\\PhD\\Data Analysis 2016\\2016-03-17") ;



library(ggplot2)
require(graphics)


m <- read.csv("data.csv" , header = TRUE )
q <- quantile( m$deibide_N , 0.95  )

ms <- m[ which( m$deibide_N >= q ) , ]

ms2 <- ms[ order( - ms$deibide_N ) , ]


colours = c( "#e57248" , "#339933", "#00CC00", "#70DB70" , "#CCFF66" ,  "#0099CC", "#00CCFF", "#99CCFF" , "#CCCCFF")


a <- ggplot( ms , aes( x= reorder( rownames( ms ) , ms$deibide_N )   , y= ms$deibide_N   )) ;
a <- a + geom_bar(stat='identity') ; 

a <- a +  coord_flip() ;
a <- a + scale_fill_manual(values=colours)
a <- a + xlab("Semi-rhyme") + ylab("Normalised counts") ;

print(a) ;