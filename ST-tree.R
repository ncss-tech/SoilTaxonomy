library(data.tree)
library(jsonlite)
library(igraph)

library(SoilTaxonomy)


## further ideas
# https://cran.r-project.org/web/packages/data.tree/vignettes/data.tree.html
# https://cran.r-project.org/web/packages/data.tree/vignettes/applications.html

# load de-normalized version of the current edition, to the subgroup level
data('ST', package = 'SoilTaxonomy')

## this is the most detailed acreage accounting
# subgroup acreages from SoilWeb / SSURGO
sg.ac <- read.table(file='databases/taxsubgrp-stats.txt.gz', header = FALSE, sep="|")
names(sg.ac) <- c('tax_subgroup', 'ac', 'n_polygons')

# normalize names
sg.ac$tax_subgroup <- tolower(sg.ac$tax_subgroup)

# LEFT JOIN to acreage
ST <- merge(ST, sg.ac, by='tax_subgroup', all.x=TRUE)

# set NA acreage to 0
ST$ac[which(is.na(ST$ac))] <- 0

# setup tree path, note that there has to be a "parent" level that sits above orders
ST$pathString <- paste('ST', ST$tax_order, ST$tax_suborder, ST$tax_greatgroup, ST$tax_subgroup, sep='/')

# init data.tree object, rather large
n <- as.Node(ST)
print(n, 'ac', pruneMethod = "dist", limit = 20)

alf <- n$alfisols$xeralfs
print(alf, 'ac')

# compute acreage for parent nodes
alf$Do(function(node) node$ac <- Aggregate(node, attribute = "ac", aggFun = sum), traversal = "post-order")

# check: OK
print(alf, 'ac')

## this only works for small-ish graphs
# plot as network graph
g <- as.igraph(alf, directed = TRUE, direction = "climb", vertexAttributes='ac')
v.ac <- V(g)$ac
V(g)$size <- ifelse(v.ac == 0, 4, log(v.ac, base=10))
V(g)$color <- ifelse(v.ac == 0, 'orange', 'lightblue')

png(file='xeralfs-graph.png', width=1000, height=1000, type='cairo', antialias = 'subpixel')
par(mar=c(1,1,1,1))
plot(g, edge.arrow.size=0.15, vertex.label.cex=0.85, layout=layout_with_fr, vertex.label.family='sans', vertex.label.color='black')
legend('bottomright', legend=c('No Acres Mapped'), pch=21, pt.bg='orange', bty='n')
# plot(g, edge.arrow.size=0.15, vertex.label.cex=0.5, layout=layout_with_lgl, vertex.label.family='sans', vertex.label.color='black')
dev.off()

### wow !!!
## use D3
net <- ToDataFrameNetwork(n$alfisols$xeralfs)
simpleNetwork(net, fontSize = 12)

useRtreeList <- ToListExplicit(n$alfisols$xeralfs, unname = TRUE)
res <- radialNetwork( useRtreeList)
# save to file
saveNetwork(res, 'D3-radial-network-example.html', selfcontained = TRUE)




## this needs some tinkering
## conversion to other formats
alf.list <- ToListExplicit(n$alfisols$xeralfs$haploxeralfs, unname = TRUE, nameName = "taxon", childrenName = "children")

# JSON
alf.json <- toJSON(alf.list, pretty = TRUE, auto_unbox = TRUE)

cat(alf.json, file = 'haploxeralfs.json')

