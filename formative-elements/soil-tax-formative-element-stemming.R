library(tm)
library(hunspell)
library(alineR)

# https://stackoverflow.com/questions/24443388/stemming-with-r-text-analysis
# https://campus.datacamp.com/courses/intro-to-text-mining-bag-of-words/jumping-into-text-mining-with-bag-of-words?ex=13#skiponboarding
# https://cran.r-project.org/web/packages/hunspell/vignettes/intro.html#stemming_words
# https://stackoverflow.com/questions/7561648/how-to-make-custom-dictionary-for-hunspell

hunspell_stem('mollic haploxeralfs')
?dictionary()
hunspell:::dicpath()


d <- read.csv('formative-elements-corrected.csv', stringsAsFactors = FALSE)

x <- mapply(pattern=d$element, x='mollic haploxeralfs', FUN = grep, ignore.case=TRUE)
unlist(x)

x <- mapply(pattern=d$element, x='typic argixerolls', FUN = grep, ignore.case=TRUE)
unlist(x)

x <- mapply(pattern=d$element, x='abruptic durixerolls', FUN = grep, ignore.case=TRUE)
unlist(x)


z <- aline(rep('abruptic durixeralfs', times=nrow(d)), d$element)
hist(z)
