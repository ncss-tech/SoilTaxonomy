library(stringi)
library(purrr)
library(stringdist)

# ST to the subgroup level
# this will eventually be placed into an R package data/ dir
ST <- read.csv('../ST-full-fixed.csv', stringsAsFactors = FALSE)

# formative elements
load('formative-elements.rda')

source('local-functions.R')

# sample taxa
x <- c('fluvaquentic haplofibrists', 'abruptic durixeralfs', 'typic haploxerolls', 'aquic cumulic hapludolls', 'argic borfundgus', 'barfic ustox', 'typic ustorthents', 'aridic lithic argixerolls', 'petroferric sombriudox')

# parseOrder(x)
# parseSubOrder(x)
# parseGreatGroup(x)
# parseSubGroup(x)



cat(prettyPrintST(x[9]), sep = '\n')

cat(prettyPrintST(x[8]), sep = '\n')


cat(prettyPrintST(x[1]), sep = '\n')


cat(prettyPrintST('aeric umbric endoaqualfs'), sep='\n')

cat(prettyPrintST('typic endoaqualfs'), sep = '\n')

