
setwd("C:\\Users\\Peter\\Documents\\PhD\\CaseStudy\\R") ;
library("ggplot2")
library("reshape")

c <- read.csv("c.csv")

#c <- df[,-ncol(df)]       
c$event <- seq.int(nrow(c)) 
 
c <- melt(c, id='event')   

p <- ggplot( c, aes(x = event, y = value, fill = variable)) + geom_bar(stat = "identity")
print (p)