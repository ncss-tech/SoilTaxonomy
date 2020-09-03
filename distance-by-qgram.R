library(stringdist)
library(SoilTaxonomy)
library(reshape2)
library(cluster)
library(ape)

# hierarchy to the subgroup
data("ST", package = 'SoilTaxonomy')

# unique taxa
data("ST_unique_list", package = 'SoilTaxonomy')

# formative element dictionaries
data('ST_formative_elements', package = 'SoilTaxonomy')


x <- explainST('typic haploxeralfs', format = 'text')
cat(x)

# extract formative elements for a single subgroup
# not vectorized
sgfe <- function(x) {
  fm <- SubGroupFormativeElements(x)
  e <- fm$defs[[1]][['element']]
  # keep track of each taxon
  res <- data.frame(taxa = x, elements = e, stringsAsFactors = FALSE)
  return(res)
}

# iterate over all subgroup
taxa.fm <- lapply(ST$tax_subgroup[ST$tax_suborder == 'xeralfs'], sgfe)
taxa.fm <- do.call('rbind', taxa.fm)

# fake column for marking membership
taxa.fm$bool <- TRUE

# ok
str(taxa.fm)

# long -> wide
z <- dcast(taxa.fm, taxa ~ elements, value.var = 'bool', fill = FALSE)

# check: ok
z[1:10, ]

row.names(z) <- z$taxa
d <- daisy(z[, -1])
h <- diana(d)
h <- as.phylo(as.hclust(h))


## hmm... not that interesting
par(mar = c(1,1,1,1))
plot(h, cex = 0.5, label.offset = 0.1)


## TODO: combine formative elements + taxonomic hierarchy -> distance matrix



stringdist('typic haploxeralfs', 'typic xerorthents', method='qgram', q=4, nthread = 1)

stringdist('typic haploxeralfs', c('typic durixeralfs', 'abruptic durixeralfs', 'mollic haploxeralfs', 'typic duraqualfs'), method='qgram', q=4, nthread = 1)


## compare a single SG taxa to all others
z <- ST$tax_subgroup[ST$tax_greatgroup == 'haploxeralfs']
d <- stringdist('typic haploxeralfs', z, method='qgram', q=4, nthread = 1)

# prepare for simple viz
names(d) <- z
d <- sort(d)

# hmm.. this kind of makes sense
# mostly noise
dotchart(d)


## another idea
## compare a single SG taxa to all others
z <- ST$tax_subgroup[ST$tax_greatgroup == 'haploxerolls']
d <- stringdist('typic haploxeralfs', z, method='qgram', q=4, nthread = 1)

# prepare for simple viz
names(d) <- z
d <- sort(d)

# this makes sense
dotchart(d)

## formative elements would be more consistent


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


