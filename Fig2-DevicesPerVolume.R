


setwd("C:\\Users\\Peter\\Documents\\PhD\\CaseStudy\\R") ;


vols <- read.csv("dataVolumes.csv", header= TRUE )
   
#colours <- c( "#2E2E83","#363699","#3E3EAF","#4545C5","#4D4DDB","#5F5FDF","#7171E2","#8282E6","#9494E9","#A6A6ED","#B8B8F1" ) ; 
   
   
par( mfrow = c(2,3) )


barplot( vols$perfectRhyme_N , names.arg = rownames(vols) , main="Perfect rhyme", ylab= "Total",
   beside=TRUE, col= "#7f50ff" , las = 2 )

barplot( vols$assonanceRhyme_N , names.arg = rownames(vols) , main="Assonance rhyme", ylab= "Total",
   beside=TRUE, col= "#7f50ff" , las = 2 )


barplot( vols$consonanceRhyme_N , names.arg = rownames(vols) , main="Consonance rhyme", ylab= "Total",
   beside=TRUE, col= "#7f50ff" , las = 2 )


barplot( vols$internalRhyme_N , names.arg = rownames(vols) , main="Internal rhyme", ylab= "Total",
   beside=TRUE, col= "#7f50ff" , las = 2 )

barplot( vols$semiRhyme_N , names.arg = rownames(vols) , main="Semi rhyme", ylab= "Total",
   beside=TRUE, col= "#7f50ff" , las = 2 )

barplot( vols$deibide_N , names.arg = rownames(vols) , main="Deibide rhyme", ylab= "Total",
   beside=TRUE, col= "#7f50ff" , las = 2 )

