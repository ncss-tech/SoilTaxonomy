library(data.tree)
library(plyr)

# SC database
# subset down to series, family, suborder
SC <- read.csv('SC-database.csv.gz', stringsAsFactors = FALSE)
SC <- SC[, c('soilseriesname', 'taxclname', 'tax_subgrp')]
names(SC) <- c('series', 'family', 'tax_subgroup')
SC$tax_subgroup <- tolower(SC$tax_subgroup)

# tabulate number of series / family per subgroup
series.stats <- ddply(SC, 'tax_subgroup', .fun=summarize, n_series=length(unique(series)), n_family=length(unique(family)))

# this is the manually corrected version
ST.clean <- read.csv('https://raw.githubusercontent.com/ncss-tech/SoilTaxonomy/master/ST-full-fixed.csv', stringsAsFactors = FALSE)

## this is the most detailed acreage accounting
# subgroup acreages from SoilWeb / SSURGO
# script to compute is at:
# S:\NRCS\Archive_Dylan_Beaudette\Soil-Taxonomy\series-area-taxonomy-treemaps\
sg.ac <- read.table(file='taxsubgrp-stats.txt.gz', header = FALSE, sep="|", stringsAsFactors = FALSE)
names(sg.ac) <- c('tax_subgroup', 'ac', 'n_polygons')

# normalize names
sg.ac$tax_subgroup <- tolower(sg.ac$tax_subgroup)

# join tree to subgroup level stats
ST.clean <- join(ST.clean, sg.ac)

 
## TODO: finish this...
# join tree to series names and basic stats
ST.clean <- join(ST.clean, SC)
ST.clean <- join(ST.clean, series.stats)

## TODO: finish this... 
# # set NA acreage, n_series, n_family to 0
# ST.clean$ac[which(is.na(ST.clean$ac))] <- 0
# ST.clean$n_polygons[which(is.na(ST.clean$n_polygons))] <- 0
# ST.clean$n_series[which(is.na(ST.clean$n_series))] <- 0
# ST.clean$n_family[which(is.na(ST.clean$n_family))] <- 0

## init data.tree representation


# setup tree path, note that there has to be a "parent" level that sits above orders
ST.clean$pathString <- paste('ST', ST.clean$tax_order, ST.clean$tax_suborder, ST.clean$tax_greatgroup, ST.clean$tax_subgroup, ST.clean$family, ST.clean$series, sep='/')


# just alfisols
ST <- as.Node(ST.clean[which(ST.clean$tax_order == 'alfisols'), ])


# experimental
# interactive D3 treemap
# https://github.com/ncss-tech/SoilTaxonomy/issues/2

library("magrittr")
library("D3partitionR")

D3partitionR() %>%
  add_data(ST.clean, steps=c('tax_order','tax_suborder','tax_greatgroup','tax_subgroup', 'family', 'series'), count='ac') %>%
  add_title('Soil Taxonomy') %>%
  plot()



