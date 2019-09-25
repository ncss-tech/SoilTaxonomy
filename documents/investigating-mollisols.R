library(data.tree)
library(igraph)
library(SoilTaxonomy)
library(plyr)
library(soilDB)
library(aqp)
library(sharpshootR)
library(colorspace)


options(stringsAsFactors = FALSE)


# set search_path to osd, public;
# 
# CREATE TEMP TABLE mmm AS
# SELECT series, top, bottom, hzname, matrix_wet_color_hue, matrix_wet_color_value, matrix_wet_color_chroma
# FROM
# osd_colors
# WHERE series in (select seriesname from taxa where soilorder = 'mollisols')
# ORDER BY series, top ;
# 
# \copy mmm to 'mollisol-osds.csv' CSV HEADER

x <- read.csv('mollisol-osds.csv.gz')
x$soil_color <- munsell2rgb(x$matrix_wet_color_hue, x$matrix_wet_color_value, x$matrix_wet_color_chroma)

depths(x) <- series ~ top + bottom

x$genhz <- rep(NA, times=nrow(x))
x$genhz[grep('A', x$hzname)] <- 'A Horizons'

a <- aggregateColor(x, groups = 'genhz', col = 'soil_color', k = 8)
aggregateColorPlot(a)

soilPalette <- function(colors, lab, ...) {
  # basic plot
  swatchplot(colors, ...)
  # annotation
  nx <- length(colors)
  x.pos <- seq(from = 0, to = 1, by = 1/nx)[1:nx]
  y.pos <- rep(0.01, times = nx)
  text(x.pos, y.pos, labels = lab, col = "white", font = 2, adj = c(-0.125, -0.33))
}

# hack!
# get the labels about right
lab <- sprintf("%s\n      %i%%", a$scaled.data$`A Horizons`$munsell, round(a$scaled.data$`A Horizons`$weight * 100))

par(mar=c(2,0,2,0))
soilPalette(a$scaled.data$`A Horizons`$soil_color, lab = lab)
title(main='Moist Soil Colors for Mollisols')
mtext('Source: Official Series Descriptions', side = 1, font=2)

## not so useful here
cq <- colorQuantiles(x$soil_color[which(x$genhz == 'A Horizons')])
plotColorQuantiles(cq)




tf <- tempfile()
download.file('https://github.com/ncss-tech/SoilTaxonomy/raw/master/databases/SC-database.csv.gz', destfile = tf)
SC <- read.csv(gzfile(tf), stringsAsFactors = FALSE)

# keep specific columns
SC <- SC[, c('soilseriesname', 'taxclname', 'tax_grtgroup', 'tax_subgrp')]

# re-name and normalize
names(SC) <- c('series', 'family', 'tax_greatgroup', 'tax_subgroup')
SC$tax_subgroup <- tolower(SC$tax_subgroup)


tf <- tempfile()
download.file('https://github.com/ncss-tech/SoilTaxonomy/raw/master/databases/taxsubgrp-stats.txt.gz', destfile = tf)
sg.ac <- read.table(gzfile(tf), header = FALSE, stringsAsFactors = FALSE, sep='|')
names(sg.ac) <- c('tax_subgroup', 'ac', 'n_polygons')

# normalize names
sg.ac$tax_subgroup <- tolower(sg.ac$tax_subgroup)

# ST to the subgroup level
data(ST)

# tabulate number of series / family per subgroup
series.stats <- ddply(SC, 'tax_subgroup', .fun=summarize, n_series=length(unique(series)), n_family=length(unique(family)))

# join {ST} to {acreage by subgroup}
ST <- merge(ST, sg.ac, by='tax_subgroup', all.x=TRUE)

# join {ST + subgroup acreage} to {series stats}
ST <- merge(ST, series.stats, by='tax_subgroup', all.x=TRUE)

# set NA acreage, n_series, n_family to 0
ST$ac[which(is.na(ST$ac))] <- 0
ST$n_polygons[which(is.na(ST$n_polygons))] <- 0
ST$n_series[which(is.na(ST$n_series))] <- 0
ST$n_family[which(is.na(ST$n_family))] <- 0


ST <- ST[which(ST$tax_order == 'mollisols'), ]

str(ST)

length(unique(ST$tax_suborder))
length(unique(ST$tax_greatgroup))
length(unique(ST$tax_subgroup))

sum(ST$n_family)
sum(ST$n_series)


so.stats <- ddply(ST, 'tax_suborder', .fun=summarize, ac=sum(ac, na.rm=TRUE))

knitr::kable(so.stats[order(so.stats$ac, decreasing = TRUE), ], row.names = FALSE)











