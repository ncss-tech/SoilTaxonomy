library(data.tree)
library(plyr)

# SC database
# subset down to series, family, suborder
SC <- read.csv('databases/SC-database.csv.gz', stringsAsFactors = FALSE)
SC <- SC[, c('soilseriesname', 'taxclname', 'tax_subgrp', 'tax_partsize', 'tax_ceactcl', 'tax_tempcl', 'tax_reaction', 'tax_minclass')]
names(SC) <- c('series', 'family', 'tax_subgroup', 'tax_partsize', 'tax_ceactcl', 'tax_tempcl', 'tax_reaction', 'tax_minclass')
SC$tax_subgroup <- tolower(SC$tax_subgroup)

# # tabulate number of series / family per subgroup
# series.stats <- ddply(SC, 'tax_subgroup', .fun=summarize, n_series=length(unique(series)), n_family=length(unique(family)))

# this is the manually corrected version
ST.clean <- read.csv('ST-full-fixed.csv', stringsAsFactors = FALSE)

# latest series level stats from SoilWeb
series.stats <- read.csv('databases/series_stats.csv.gz', stringsAsFactors = FALSE)

## combine 

# join SC to stats by seriesname
SC <- join(SC, series.stats)

# join tree to series names and basic stats
ST.clean <- join(ST.clean, SC)


## TODO: finish this... 
# set NA acreage, n_series, n_family to 0
ST.clean$ac[which(is.na(ST.clean$ac))] <- 0
ST.clean$n_polygons[which(is.na(ST.clean$n_polygons))] <- 0

# clean missing data
ST.clean$series[which(is.na(ST.clean$series))] <- '(series)'

ST.clean$tax_partsize[is.na(ST.clean$tax_partsize)] <- '(particle size class)'
ST.clean$tax_ceactcl[is.na(ST.clean$tax_ceactcl)] <- '(CEC activity class)'
ST.clean$tax_tempcl[is.na(ST.clean$tax_tempcl)] <- '(STR)'
ST.clean$tax_reaction[is.na(ST.clean$tax_reaction)] <- '(reaction class)'
ST.clean$tax_minclass[is.na(ST.clean$tax_minclass)] <- '(mineralogy class)'


## init data.tree representation

# setup tree path, note that there has to be a "parent" level that sits above orders
ST.clean$pathString <- paste('ST', ST.clean$tax_order, ST.clean$tax_suborder, ST.clean$tax_greatgroup, ST.clean$tax_subgroup,  ST.clean$tax_partsize, ST.clean$tax_minclass, ST.clean$tax_ceactcl, ST.clean$tax_tempcl, ST.clean$series, sep='/')

# just alfisols for now
n <- as.Node(ST.clean[which(ST.clean$tax_suborder == 'xeralfs'), ])

## pruning
# missing series
Prune(n, function(x) x$name != '(series)')

## TODO prune missing elements from tree, but not necessarily the children
# ideas: https://cran.r-project.org/web/packages/data.tree/vignettes/applications.html#prune

# check: OK
print(n)

# compute acreage for parent nodes
n$Do(function(node) node$ac <- Aggregate(node, attribute = "ac", aggFun = sum), traversal = "post-order")

# check: OK
print(n$alfisols$xeralfs$durixeralfs, 'ac')



## JSON export
n.list <- ToListExplicit(n$alfisols$xeralfs$haploxeralfs$`typic haploxeralfs`, unname = TRUE, nameName = "taxon", childrenName = "children")

# JSON
n.json <- toJSON(n.list, pretty = TRUE, auto_unbox = TRUE)

cat(n.json, file = 'haploxeralfs-with-series.json')


## to slow
## doesn't work with missing data
library(networkD3)
n.small <- n$alfisols$xeralfs$durixeralfs$`abruptic durixeralfs`
nn <- ToDataFrameNetwork(n.small, "series")
simpleNetwork(nn, fontSize = 10, zoom=TRUE)



## doesn't work with missing data

g <- as.igraph(n$alfisols$xeralfs$haploxeralfs$`typic haploxeralfs`, directed = TRUE, direction = "climb", vertexAttributes='ac')
v.ac <- V(g)$ac
V(g)$size <- ifelse(v.ac == 0, 4, log(v.ac, base=10))
# V(g)$color <- ifelse(v.ac == 0, 'orange', 'lightblue')

png(file='xeralfs-with-series-graph.png', width=1000, height=1000, type='quartz', antialias = 'subpixel')
par(mar=c(1,1,1,1))
plot(g, edge.arrow.size=0.15, vertex.label.cex=0.85, layout=layout_with_fr, vertex.label.family='sans', vertex.label.color='black')
legend('bottomright', legend=c('No Acres Mapped'), pch=21, pt.bg='orange', bty='n')
# plot(g, edge.arrow.size=0.15, vertex.label.cex=0.5, layout=layout_with_lgl, vertex.label.family='sans', vertex.label.color='black')
dev.off()



