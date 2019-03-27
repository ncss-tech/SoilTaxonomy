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


d <- read.csv('https://raw.githubusercontent.com/ncss-tech/SoilTaxonomy/master/formative-elements/formative-elements-corrected.csv', stringsAsFactors = FALSE)

x <- mapply(pattern=d$element, x='mollic haploxeralfs', FUN = grep, ignore.case=TRUE)
unlist(x)

x <- mapply(pattern=d$element, x='typic argixerolls', FUN = grep, ignore.case=TRUE)
unlist(x)

x <- mapply(pattern=d$element, x='abruptic durixerolls', FUN = grep, ignore.case=TRUE)
unlist(x)

x <- mapply(pattern=d$element, x='abruptic durixeralfs', FUN = grep, ignore.case=TRUE)
unlist(x)


z <- aline(rep('abruptic durixeralfs', times=nrow(d)), d$element)
hist(z)


## this is close to what we would like to make
## ASCII is neat, but a graphic would suffice
## SVG with selectable / linkable text?

# abruptic durixeralfs
#    |      |   |  |
#    |      |   |  |
#  an abrupt change in texture
#           |   |  |
#       presence of a silica-cemented, sub-surface horizon
#               |  |
#            cool, wet winters and hot, dry summers
#                  |
#     an alfisol: sub-surface accumulation of clay, nutrient-rich
           

# another approach

library(stringi)
library(purrr)

# get ST down to the subgroup level
x <- read.csv('https://raw.githubusercontent.com/ncss-tech/SoilTaxonomy/master/ST-full-fixed.csv', stringsAsFactors = FALSE)

# split into tokens
z <- stri_split_fixed(x$tax_subgroup, pattern=' ')

# there should be 2--4
range(sapply(z, length))

# unique set of sub group modifiers
subgroup.modifiers <- unique(unlist(z))

# remove great group labels
subgroup.modifiers <- sort(setdiff(subgroup.modifiers, x$tax_greatgroup))

# only 163 ! I can work with that
length(subgroup.modifiers)


# save these for later
write.csv(data.frame(sgm=subgroup.modifiers, text=''), file='subgroup-modifier-dictionary.csv', row.names = FALSE)


taxa <- 'abruptic durixeralfs'
taxa.tokens <- unlist(stri_split_fixed(taxa, pattern=' '))

# search subgroup pieces
m <- unlist(stri_match_all(taxa, regex=paste0('^', subgroup.modifiers), opts_regex=list(case_insensitive=TRUE)))
as.vector(na.omit(m))

# search formative elements
m <- lapply(taxa.tokens, stri_match_all, regex=d$element, opts_regex=list(case_insensitive=TRUE))

lapply(m, function(i) {
  unique(as.vector(na.omit(unlist(i))))
})



