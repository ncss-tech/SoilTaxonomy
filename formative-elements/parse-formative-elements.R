library(stringi)
library(purrr)
library(stringdist)

# ST to the subgroup level
# this will eventually be placed into an R package data/ dir
ST <- read.csv('../ST-full-fixed.csv', stringsAsFactors = FALSE)

# formative elements
load('formative-elements.rda')





# sample taxa
x <- c('fluvaquentic haplofibrists', 'abruptic durixeralfs', 'typic haploxerolls', 'aquic cumulic hapludolls', 'argic borfundgus', 'barfic ustox', 'typic ustorthents')

parseOrder(x)
parseSubOrder(x)
parseGreatGroup(x)

x <- x[4]
x.p1 <- parseOrder(x)
x.p2 <- parseSubOrder(x)
x.p3 <- parseGreatGroup(x)


txt <- list()
txt[[1]] <- x

txt[[3]] <- makeBars(pos=c(x.p3$char.index, x.p2$char.index, x.p1$char.index))

txt[[4]] <- printExplanation(pos = x.p3$char.index, txt = x.p3$defs$connotation)

txt[[5]] <- makeBars(pos=c(x.p2$char.index, x.p1$char.index))

txt[[6]] <- printExplanation(pos = x.p2$char.index, txt = x.p2$defs$connotation)

txt[[7]] <- makeBars(pos=x.p1$char.index)

txt[[9]] <- printExplanation(pos = x.p1$char.index, txt = x.p1$defs$connotation)

cat(unlist(txt), sep = '\n')

