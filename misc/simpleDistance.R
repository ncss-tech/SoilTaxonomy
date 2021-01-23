##
## establish very simple distances based only on relative position within ST hierarchy
##


library(cluster)

# this is the manually corrected version
ST.clean <- read.csv('ST-full-fixed.csv', stringsAsFactors = FALSE)

# subset to GG level
ST.sub <- unique(ST.clean[, 1:3])

# convert to factors
ST.sub$tax_order <- factor(ST.sub$tax_order)
ST.sub$tax_suborder <- factor(ST.sub$tax_suborder)

# copy GG taxa to rownames
row.names(ST.sub) <- ST.sub$tax_greatgroup

# distance is not likely very meaningful
d <- daisy(ST.sub[, 1:2], metric = 'gower')

table(d)

plot(as.dendrogram(diana(d)))


## TODO: full distance to family level

