library(aqp)
library(soilDB)
library(knitr)

## soil classification DB snapshot
tf <- tempfile()
download.file('https://github.com/ncss-tech/SoilTaxonomy/raw/master/databases/SC-database.csv.gz', destfile = tf)
sc <- read.csv(tf, stringsAsFactors = FALSE)

## MLRA membership snapshot
tf <- tempfile()
download.file('https://github.com/ncss-tech/SoilTaxonomy/raw/master/databases/series-mlra-overlap.csv.gz', destfile = tf)
mlra <- read.csv(tf, stringsAsFactors = FALSE)

## series stats
tf <- tempfile()
download.file('https://github.com/ncss-tech/SoilTaxonomy/raw/master/databases/series_stats.csv.gz', destfile = tf)
ss <- read.csv(tf, stringsAsFactors = FALSE)


## check
head(sc)
head(mlra)
head(ss)

kable(mlra[mlra$series == 'SIERRA', ], row.names = FALSE)
kable(mlra[mlra$series == 'MAGNOR', ], row.names = FALSE)
