
setwd("C:\\Users\\Peter\\Documents\\PhD\\CaseStudy\\R") 

library(igraph)

# Data format. The data is in 'edges' format meaning that each row records a relationship (edge) between two people (vertices).
# Additional attributes can be included. Here is an example:
#	Supervisor	Examiner	Grade	Spec(ialization)
#	AA		BD		6	X	
#	BD		CA		8	Y
#	AA		DE		7	Y
#	...		...		...	...
# In this anonymized example, we have data on co-supervision with additional information about grades and specialization. 
# It is also possible to have the data in a matrix form (see the igraph documentation for details)

# Load the data. The data needs to be loaded as a table first: 

poems<-read.csv("network.csv") ; 

#specify the path, separator(tab, comma, ...), decimal point symbol, etc.

# Transform the table into

#specify the path, separator(tab, comma, ...), decimal point symbol, etc.

# Transform the table into the required graph format:
poems.network<-graph.data.frame(poems, directed=F) #the 'directed' attribute specifies whether the edges are directed
# or equivelent irrespective of the position (1st vs 2nd column). For directed graphs use 'directed=T'

# Inspect the data:

V(poems.network) #prints the list of vertices (people)
E(poems.network) #prints the list of edges (relationships)
degree(poems.network) #print the number of edges per vertex (relationships per people)



#Subset the data. If we want to exclude people who are in the network only tangentially (participate in one or two relationships only)
# we can exclude the by subsetting the graph on the basis of the 'degree':

#bad.vs<-V(bsk.network)[degree(bsk.network)<3] #identify those vertices part of less than three edges
#bsk.network<-delete.vertices(bsk.network, bad.vs) #exclude them from the graph

# Plot the data.Some details about the graph can be specified in advance.
# For example we can separate some vertices (people) by color:

#V(poems.network)$color<-ifelse(V(poems.network)$name=='CA', 'blue', 'red') #useful for highlighting certain people. Works by matching the name attribute of the vertex to the one specified in the 'ifelse' expression

# We can also color the connecting edges differently depending on the 'grade': 

#E(poems.network)$color<-ifelse(E(poems.network)$grade==9, "red", "grey")

# or depending on the different specialization ('spec'):

#E(poems.network)$color<-ifelse(E(poems.network)$spec=='X', "red", ifelse(E(poems.network)$spec=='Y', "blue", "grey"))

# Note: the example uses nested ifelse expressions which is in general a bad idea but does the job in this case
# Additional attributes like size can be further specified in an analogous manner, either in advance or when the plot function is called:

#V(poems.network)$size<- 5
#here the size of the vertices is specified by the degree of the vertex, so that people supervising more have get proportionally bigger dots. Getting the right scale gets some playing around with the parameters of the scale function (from the 'base' package)

# Note that if the same attribute is specified beforehand and inside the function, the former will be overridden.
# And finally the plot itself:
par(mai=c(0,0,0,0)) 			#this specifies the size of the margins. the default settings leave too much free space on all sides (if no axes are printed)
plot(poems.network,				#the graph to be plotted
layout=layout.fruchterman.reingold,	# the layout method. see the igraph documentation for details
main='Similarity of poems',	#specifies the title
vertex.label.dist=0.3,			#puts the name labels slightly off the dots
vertex.size = 4, 		#the color of the border of the dots 
vertex.color = '#1385AB', 		#the color of the border of the dots 
#vertex.frame.color='green', 		#the color of the border of the dots 
vertex.label.color='black',		#the color of the name labels
vertex.label.family = "sans",			#the font of the name labels
vertex.label=V(poems.network)$name,		#specifies the lables of the vertices. in this case the 'name' attribute is used
vertex.label.cex=0.8			#specifies the size of the font of the labels. can also be made to vary
)

# Save and export the plot. The plot can be copied as a metafile to the clipboard, or it can be saved as a pdf or png (and other formats).
# For example, we can save it as a png:
png(filename="org_network.png", height=800, width=600) #call the png writer
#run the plot
dev.off() #dont forget to close the device
#And that's the end for now.
