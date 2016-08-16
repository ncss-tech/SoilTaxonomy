library(data.tree)
library(jsonlite)
library(plyr)

# inspiration
# https://bl.ocks.org/jjzieve/a743242f46321491a950#index.html

# docs
# https://cran.r-project.org/web/packages/data.tree/vignettes/data.tree.html
# https://cran.r-project.org/web/packages/data.tree/vignettes/applications.html

## this is the manually corrected version
ST.clean <- read.csv('ST-full-fixed.csv', stringsAsFactors = FALSE)

## soil series DB
s <- read.csv('SC-database.csv.gz', stringsAsFactors = FALSE)
s <- s[, c('soilseriesname', 'tax_subgrp')]
names(s) <- c('seriesname', 'tax_subgroup')


# join tree to series names by subgroup
ST.clean <- join(ST.clean, s, by='tax_subgroup')

## NOTE: leaving NA in the seriesname results in bogus output from ToListExplicit
# strip records with no seriesname
ST.clean <- ST.clean[!is.na(ST.clean$seriesname), ]

# setup tree path, note that there has to be a "parent" level that sits above orders
ST.clean$pathString <- paste('ST', ST.clean$tax_order, ST.clean$tax_suborder, ST.clean$tax_greatgroup, ST.clean$tax_subgroup, ST.clean$seriesname, sep='/')

# init data.tree object
n <- as.Node(ST.clean[,])

# subset and check
alf <- n$alfisols$xeralfs$haploxeralfs
print(alf)


##
## The entire tree is too big, probably need to split it up, just alfisols for now
##

## note arguments for D3 JSON compatibility
ST.list <- ToListExplicit(n$alfisols, unname = TRUE, nameName = "name", childrenName = "children")
ST.json <- toJSON(ST.list, pretty = TRUE, auto_unbox = TRUE, force=TRUE)
cat(ST.json, file = 'ST.json')


