

setwd("C:\\Users\\Peter\\Documents\\PhD\\CaseStudy\\R") ;


d <- read.csv("data.csv", header= TRUE )

d1 <- d[ which( d$volume == 'Poems') , ]
P <- c( sum(d1$Bell) / sum(d1$nrWords) ,  sum(d1$Disease) / sum(d1$nrWords), sum(d1$Drinks)/ sum(d1$nrWords) , sum(d1$Food) / sum(d1$nrWords), sum(d1$Industry) / sum(d1$nrWords), sum(d1$Ireland)/ sum(d1$nrWords) , sum(d1$Light) / sum(d1$nrWords), sum(d1$Money) / sum(d1$nrWords), sum(d1$Plants) / sum(d1$nrWords), sum(d1$Quest) / sum(d1$nrWords), sum(d1$Religion)/ sum(d1$nrWords) , sum(d1$Stone)/ sum(d1$nrWords) , sum(d1$Temperature)/ sum(d1$nrWords) , sum(d1$Thread) / sum(d1$nrWords), sum(d1$Transportation)/ sum(d1$nrWords) , sum(d1$War)/ sum(d1$nrWords) , sum(d1$Water)/ sum(d1$nrWords) , sum(d1$Wind)/ sum(d1$nrWords) )

d1 <- d[ which( d$volume == 'TheEarthCompels') , ]
TEC <- c( sum(d1$Bell) / sum(d1$nrWords) ,  sum(d1$Disease) / sum(d1$nrWords), sum(d1$Drinks)/ sum(d1$nrWords) , sum(d1$Food) / sum(d1$nrWords), sum(d1$Industry) / sum(d1$nrWords), sum(d1$Ireland)/ sum(d1$nrWords) , sum(d1$Light) / sum(d1$nrWords), sum(d1$Money) / sum(d1$nrWords), sum(d1$Plants) / sum(d1$nrWords), sum(d1$Quest) / sum(d1$nrWords), sum(d1$Religion)/ sum(d1$nrWords) , sum(d1$Stone)/ sum(d1$nrWords) , sum(d1$Temperature)/ sum(d1$nrWords) , sum(d1$Thread) / sum(d1$nrWords), sum(d1$Transportation)/ sum(d1$nrWords) , sum(d1$War)/ sum(d1$nrWords) , sum(d1$Water)/ sum(d1$nrWords) , sum(d1$Wind)/ sum(d1$nrWords) )

d1 <- d[ which( d$volume == 'AutumnJournal') , ]
AJ <- c( sum(d1$Bell) / sum(d1$nrWords) ,  sum(d1$Disease) / sum(d1$nrWords), sum(d1$Drinks)/ sum(d1$nrWords) , sum(d1$Food) / sum(d1$nrWords), sum(d1$Industry) / sum(d1$nrWords), sum(d1$Ireland)/ sum(d1$nrWords) , sum(d1$Light) / sum(d1$nrWords), sum(d1$Money) / sum(d1$nrWords), sum(d1$Plants) / sum(d1$nrWords), sum(d1$Quest) / sum(d1$nrWords), sum(d1$Religion)/ sum(d1$nrWords) , sum(d1$Stone)/ sum(d1$nrWords) , sum(d1$Temperature)/ sum(d1$nrWords) , sum(d1$Thread) / sum(d1$nrWords), sum(d1$Transportation)/ sum(d1$nrWords) , sum(d1$War)/ sum(d1$nrWords) , sum(d1$Water)/ sum(d1$nrWords) , sum(d1$Wind)/ sum(d1$nrWords) )


d1 <- d[ which( d$volume == 'PlantAndPhantom') , ]
PP <- c( sum(d1$Bell) / sum(d1$nrWords) ,  sum(d1$Disease) / sum(d1$nrWords), sum(d1$Drinks)/ sum(d1$nrWords) , sum(d1$Food) / sum(d1$nrWords), sum(d1$Industry) / sum(d1$nrWords), sum(d1$Ireland)/ sum(d1$nrWords) , sum(d1$Light) / sum(d1$nrWords), sum(d1$Money) / sum(d1$nrWords), sum(d1$Plants) / sum(d1$nrWords), sum(d1$Quest) / sum(d1$nrWords), sum(d1$Religion)/ sum(d1$nrWords) , sum(d1$Stone)/ sum(d1$nrWords) , sum(d1$Temperature)/ sum(d1$nrWords) , sum(d1$Thread) / sum(d1$nrWords), sum(d1$Transportation)/ sum(d1$nrWords) , sum(d1$War)/ sum(d1$nrWords) , sum(d1$Water)/ sum(d1$nrWords) , sum(d1$Wind)/ sum(d1$nrWords) )


d1 <- d[ which( d$volume == 'SpringBoard') , ]
SB <- c( sum(d1$Bell) / sum(d1$nrWords) ,  sum(d1$Disease) / sum(d1$nrWords), sum(d1$Drinks)/ sum(d1$nrWords) , sum(d1$Food) / sum(d1$nrWords), sum(d1$Industry) / sum(d1$nrWords), sum(d1$Ireland)/ sum(d1$nrWords) , sum(d1$Light) / sum(d1$nrWords), sum(d1$Money) / sum(d1$nrWords), sum(d1$Plants) / sum(d1$nrWords), sum(d1$Quest) / sum(d1$nrWords), sum(d1$Religion)/ sum(d1$nrWords) , sum(d1$Stone)/ sum(d1$nrWords) , sum(d1$Temperature)/ sum(d1$nrWords) , sum(d1$Thread) / sum(d1$nrWords), sum(d1$Transportation)/ sum(d1$nrWords) , sum(d1$War)/ sum(d1$nrWords) , sum(d1$Water)/ sum(d1$nrWords) , sum(d1$Wind)/ sum(d1$nrWords) )


d1 <- d[ which( d$volume == 'HolesInTheSky') , ]
HIS <- c( sum(d1$Bell) / sum(d1$nrWords) ,  sum(d1$Disease) / sum(d1$nrWords), sum(d1$Drinks)/ sum(d1$nrWords) , sum(d1$Food) / sum(d1$nrWords), sum(d1$Industry) / sum(d1$nrWords), sum(d1$Ireland)/ sum(d1$nrWords) , sum(d1$Light) / sum(d1$nrWords), sum(d1$Money) / sum(d1$nrWords), sum(d1$Plants) / sum(d1$nrWords), sum(d1$Quest) / sum(d1$nrWords), sum(d1$Religion)/ sum(d1$nrWords) , sum(d1$Stone)/ sum(d1$nrWords) , sum(d1$Temperature)/ sum(d1$nrWords) , sum(d1$Thread) / sum(d1$nrWords), sum(d1$Transportation)/ sum(d1$nrWords) , sum(d1$War)/ sum(d1$nrWords) , sum(d1$Water)/ sum(d1$nrWords) , sum(d1$Wind)/ sum(d1$nrWords) )


d1 <- d[ which( d$volume == 'Solstices') , ]
S <- c( sum(d1$Bell) / sum(d1$nrWords) ,  sum(d1$Disease) / sum(d1$nrWords), sum(d1$Drinks)/ sum(d1$nrWords) , sum(d1$Food) / sum(d1$nrWords), sum(d1$Industry) / sum(d1$nrWords), sum(d1$Ireland)/ sum(d1$nrWords) , sum(d1$Light) / sum(d1$nrWords), sum(d1$Money) / sum(d1$nrWords), sum(d1$Plants) / sum(d1$nrWords), sum(d1$Quest) / sum(d1$nrWords), sum(d1$Religion)/ sum(d1$nrWords) , sum(d1$Stone)/ sum(d1$nrWords) , sum(d1$Temperature)/ sum(d1$nrWords) , sum(d1$Thread) / sum(d1$nrWords), sum(d1$Transportation)/ sum(d1$nrWords) , sum(d1$War)/ sum(d1$nrWords) , sum(d1$Water)/ sum(d1$nrWords) , sum(d1$Wind)/ sum(d1$nrWords) )


d1 <- d[ which( d$volume == 'Visitations') , ]
V <- c( sum(d1$Bell) / sum(d1$nrWords) ,  sum(d1$Disease) / sum(d1$nrWords), sum(d1$Drinks)/ sum(d1$nrWords) , sum(d1$Food) / sum(d1$nrWords), sum(d1$Industry) / sum(d1$nrWords), sum(d1$Ireland)/ sum(d1$nrWords) , sum(d1$Light) / sum(d1$nrWords), sum(d1$Money) / sum(d1$nrWords), sum(d1$Plants) / sum(d1$nrWords), sum(d1$Quest) / sum(d1$nrWords), sum(d1$Religion)/ sum(d1$nrWords) , sum(d1$Stone)/ sum(d1$nrWords) , sum(d1$Temperature)/ sum(d1$nrWords) , sum(d1$Thread) / sum(d1$nrWords), sum(d1$Transportation)/ sum(d1$nrWords) , sum(d1$War)/ sum(d1$nrWords) , sum(d1$Water)/ sum(d1$nrWords) , sum(d1$Wind)/ sum(d1$nrWords) )



d1 <- d[ which( d$volume == 'AutumnSequel') , ]
AS <-c( sum(d1$Bell) / sum(d1$nrWords) ,  sum(d1$Disease) / sum(d1$nrWords), sum(d1$Drinks)/ sum(d1$nrWords) , sum(d1$Food) / sum(d1$nrWords), sum(d1$Industry) / sum(d1$nrWords), sum(d1$Ireland)/ sum(d1$nrWords) , sum(d1$Light) / sum(d1$nrWords), sum(d1$Money) / sum(d1$nrWords), sum(d1$Plants) / sum(d1$nrWords), sum(d1$Quest) / sum(d1$nrWords), sum(d1$Religion)/ sum(d1$nrWords) , sum(d1$Stone)/ sum(d1$nrWords) , sum(d1$Temperature)/ sum(d1$nrWords) , sum(d1$Thread) / sum(d1$nrWords), sum(d1$Transportation)/ sum(d1$nrWords) , sum(d1$War)/ sum(d1$nrWords) , sum(d1$Water)/ sum(d1$nrWords) , sum(d1$Wind)/ sum(d1$nrWords) )



d1 <- d[ which( d$volume == 'TenBurntOfferings') , ]
TBO <-c( sum(d1$Bell) / sum(d1$nrWords) ,  sum(d1$Disease) / sum(d1$nrWords), sum(d1$Drinks)/ sum(d1$nrWords) , sum(d1$Food) / sum(d1$nrWords), sum(d1$Industry) / sum(d1$nrWords), sum(d1$Ireland)/ sum(d1$nrWords) , sum(d1$Light) / sum(d1$nrWords), sum(d1$Money) / sum(d1$nrWords), sum(d1$Plants) / sum(d1$nrWords), sum(d1$Quest) / sum(d1$nrWords), sum(d1$Religion)/ sum(d1$nrWords) , sum(d1$Stone)/ sum(d1$nrWords) , sum(d1$Temperature)/ sum(d1$nrWords) , sum(d1$Thread) / sum(d1$nrWords), sum(d1$Transportation)/ sum(d1$nrWords) , sum(d1$War)/ sum(d1$nrWords) , sum(d1$Water)/ sum(d1$nrWords) , sum(d1$Wind)/ sum(d1$nrWords) )



d1 <- d[ which( d$volume == 'TheBurningPerch') , ]
TBP <- c( sum(d1$Bell) / sum(d1$nrWords) ,  sum(d1$Disease) / sum(d1$nrWords), sum(d1$Drinks)/ sum(d1$nrWords) , sum(d1$Food) / sum(d1$nrWords), sum(d1$Industry) / sum(d1$nrWords), sum(d1$Ireland)/ sum(d1$nrWords) , sum(d1$Light) / sum(d1$nrWords), sum(d1$Money) / sum(d1$nrWords), sum(d1$Plants) / sum(d1$nrWords), sum(d1$Quest) / sum(d1$nrWords), sum(d1$Religion)/ sum(d1$nrWords) , sum(d1$Stone)/ sum(d1$nrWords) , sum(d1$Temperature)/ sum(d1$nrWords) , sum(d1$Thread) / sum(d1$nrWords), sum(d1$Transportation)/ sum(d1$nrWords) , sum(d1$War)/ sum(d1$nrWords) , sum(d1$Water)/ sum(d1$nrWords) , sum(d1$Wind)/ sum(d1$nrWords) )

vols <- as.data.frame( cbind( P , TEC , AJ , PP , SB, HIS , AS , TBO , S , V , TBP  ) )

vols <- as.data.frame( t(vols) )
colnames(vols) <- c( "Bell", "Disease", "Drinks", "Food", "Industry", "Ireland", "Light", "Money", "Plants", "Quest", "Religion", "Stone", "Temperature", "Thread", "Transportation", "War", "Water", "Wind")

write.csv( vols, "colours.txt" )
