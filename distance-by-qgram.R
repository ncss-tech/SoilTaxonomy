library(stringdist)
library(SoilTaxonomy)


# hierarchy to the subgroup
data("ST", package = 'SoilTaxonomy')

# unique taxa
data("ST_unique_list", package = 'SoilTaxonomy')

# formative element dictionaries
data('ST_formative_elements', package = 'SoilTaxonomy')

stringdist('typic haploxeralfs', 'typic xerorthents', method='qgram', q=4, nthread = 1)

stringdist('typic haploxeralfs', c('typic durixeralfs', 'abruptic durixeralfs', 'mollic haploxeralfs', 'typic duraqualfs'), , method='qgram', q=4, nthread = 1)


n <- length(ST$tax_subgroup)

g <- expand.grid(A = ST$tax_subgroup, B = ST$tax_subgroup, sstringsAsFactors = FALSE)

d <- stringdist(g$A, g$B, method='qgram', q=4, nthread = 6)

m <- matrix(d, ncol = n, nrow = n)
dimnames(m)[[1]] <- ST$tax_subgroup
dimnames(m)[[2]] <- ST$tax_subgroup

m.dist <- as.dist(m)
str(m.dist)

# not too bad!
m['typic haploxeralfs', c('typic durixeralfs', 'abruptic durixeralfs', 'mollic haploxeralfs', 'typic duraqualfs', 'lithic argiudolls')]

# how does this compare with distances computed from unordered factor levels of hierarchy?


