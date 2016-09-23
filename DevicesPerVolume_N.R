


setwd("C:\\Users\\Peter\\Documents\\PhD\\CaseStudy\\R") ;


d <- read.csv("data.csv", header= TRUE )

d1 <- d[ which( d$volume == 'Poems') , ]
P <- c( sum( d1$perfectRhyme_N ) , sum( d1$assonanceRhyme_N ), sum( d1$consonanceRhyme_N ), sum( d1$internalRhyme_N ), sum( d1$semiRhyme_N ), sum( d1$deibide_N ) )

d1 <- d[ which( d$volume == 'TheEarthCompels') , ]
TEC <- c( sum( d1$perfectRhyme_N ) , sum( d1$assonanceRhyme_N ), sum( d1$consonanceRhyme_N ), sum( d1$internalRhyme_N ), sum( d1$semiRhyme_N ), sum( d1$deibide_N ) )

d1 <- d[ which( d$volume == 'AutumnJournal') , ]
AJ <- c( sum( d1$perfectRhyme_N ) , sum( d1$assonanceRhyme_N ), sum( d1$consonanceRhyme_N ), sum( d1$internalRhyme_N ), sum( d1$semiRhyme_N ), sum( d1$deibide_N ) )

d1 <- d[ which( d$volume == 'PlantAndPhantom') , ]
PP <- c( sum( d1$perfectRhyme_N ) , sum( d1$assonanceRhyme_N ), sum( d1$consonanceRhyme_N ), sum( d1$internalRhyme_N ), sum( d1$semiRhyme_N ), sum( d1$deibide_N ) )

d1 <- d[ which( d$volume == 'SpringBoard') , ]
SB <- c( sum( d1$perfectRhyme_N ) , sum( d1$assonanceRhyme_N ), sum( d1$consonanceRhyme_N ), sum( d1$internalRhyme_N ), sum( d1$semiRhyme_N ), sum( d1$deibide_N ) )


d1 <- d[ which( d$volume == 'HolesInTheSky') , ]
HIS <- c( sum( d1$perfectRhyme_N ) , sum( d1$assonanceRhyme_N ), sum( d1$consonanceRhyme_N ), sum( d1$internalRhyme_N ), sum( d1$semiRhyme_N ), sum( d1$deibide_N ) )

d1 <- d[ which( d$volume == 'Solstices') , ]
S <- c( sum( d1$perfectRhyme_N ) , sum( d1$assonanceRhyme_N ), sum( d1$consonanceRhyme_N ), sum( d1$internalRhyme_N ), sum( d1$semiRhyme_N ), sum( d1$deibide_N ) )

d1 <- d[ which( d$volume == 'Visitations') , ]
V <- c( sum( d1$perfectRhyme_N ) , sum( d1$assonanceRhyme_N ), sum( d1$consonanceRhyme_N ), sum( d1$internalRhyme_N ), sum( d1$semiRhyme_N ), sum( d1$deibide_N ) )


d1 <- d[ which( d$volume == 'AutumnSequel') , ]
AS <- c( sum( d1$perfectRhyme_N ) , sum( d1$assonanceRhyme_N ), sum( d1$consonanceRhyme_N ), sum( d1$internalRhyme_N ), sum( d1$semiRhyme_N ), sum( d1$deibide_N ) )

d1 <- d[ which( d$volume == 'TenBurntOfferings') , ]
TBO <- c( sum( d1$perfectRhyme_N ) , sum( d1$assonanceRhyme_N ), sum( d1$consonanceRhyme_N ), sum( d1$internalRhyme_N ), sum( d1$semiRhyme_N ), sum( d1$deibide_N ) )

d1 <- d[ which( d$volume == 'TheBurningPerch') , ]
TBP <- c( sum( d1$perfectRhyme_N ) , sum( d1$assonanceRhyme_N ), sum( d1$consonanceRhyme_N ), sum( d1$internalRhyme_N ), sum( d1$semiRhyme_N ), sum( d1$deibide_N ) )

   
vols <- as.data.frame( cbind( P , TEC , AJ , PP , SB, HIS , AS , TBO , S , V , TBP  ) )

vols <- as.data.frame(t( vols ))
colnames(vols) <- c("perfectRhyme", "assonanceRhyme","consonanceRhyme","internalRhyme","semiRhyme","deibideRhyme")
   
#colours <- c( "#2E2E83","#363699","#3E3EAF","#4545C5","#4D4DDB","#5F5FDF","#7171E2","#8282E6","#9494E9","#A6A6ED","#B8B8F1" ) ; 
   
   
par( mfrow = c(2,3) )

#7f50ff

barplot( vols$perfectRhyme , names.arg = rownames(vols) , main="Perfect rhyme", ylab= "Total",
   beside=TRUE, col= "#6E797D" , las = 2 )

barplot( vols$assonanceRhyme , names.arg = rownames(vols) , main="Assonance rhyme", ylab= "Total",
   beside=TRUE, col= "#6E797D" , las = 2 )


barplot( vols$consonanceRhyme , names.arg = rownames(vols) , main="Consonance rhyme", ylab= "Total",
   beside=TRUE, col= "#6E797D" , las = 2 )


barplot( vols$internalRhyme , names.arg = rownames(vols) , main="Internal rhyme", ylab= "Total",
   beside=TRUE, col= "#6E797D" , las = 3 )

barplot( vols$semiRhyme , names.arg = rownames(vols) , main="Semi rhyme", ylab= "Total",
   beside=TRUE, col= "#6E797D" , las = 3 )

barplot( vols$deibide , names.arg = rownames(vols) , main="Deibide rhyme", ylab= "Total",
   beside=TRUE, col= "#6E797D" , las = 3 )

