library(data.tree)
library(jsonlite)
library(plyr)

## application:
# http://soilmap2-1.lawr.ucdavis.edu/seriesTree/index.php?series=sierra

## other ideas:
# http://soilmap2-1.lawr.ucdavis.edu/dylan/seriesTree/dev/index.html
# http://soilmap2-1.lawr.ucdavis.edu/dylan/seriesTree/dev/search.html


## inspiration
# https://bl.ocks.org/jjzieve/a743242f46321491a950#index.html
# http://bl.ocks.org/robschmuecker/7880033

## hacks to use JSON with tidy tree (D3 v.4)
# http://stackoverflow.com/questions/38440928/how-do-i-create-a-tree-layout-using-json-data-in-d3-v4-without-stratify

# docs
# https://cran.r-project.org/web/packages/data.tree/vignettes/data.tree.html
# https://cran.r-project.org/web/packages/data.tree/vignettes/applications.html

## soil series DB
s <- read.csv('SC-database.csv.gz', stringsAsFactors = FALSE)

# iterate over all subgroups (1712) and save JSON to files
d_ply(s, 'tax_subgrp', .progress='text', .fun=function(s.sub) {
  
  # get current subgroup
  sgrp <- unique(s.sub$tax_subgrp)
  
  # testing
  # sgrp <- 'typic haploxeralfs'
  # s.sub <- s[which(s$tax_subgrp == sgrp), ]
  
  # clean missing data
  s.sub$tax_partsize[is.na(s.sub$tax_partsize)] <- '(particle size class)'
  s.sub$tax_ceactcl[is.na(s.sub$tax_ceactcl)] <- '(CEC activity class)'
  s.sub$tax_tempcl[is.na(s.sub$tax_tempcl)] <- '(STR)'
  s.sub$tax_reaction[is.na(s.sub$tax_reaction)] <- '(reaction class)'
  
  # setup tree path, note that there has to be a "parent" level that sits above orders
  s.sub$pathString <- paste(sgrp, s.sub$tax_partsize, s.sub$tax_ceactcl, s.sub$tax_tempcl, s.sub$soilseriesname, sep='/')
  
  # add URL to SDE
  s.sub$url <- paste0('http://casoilresource.lawr.ucdavis.edu/sde/?series=', sapply(s.sub$soilseriesname, URLdecode))
  
  # init data.tree object with following attributes
  n <- as.Node(s.sub[, c('pathString', 'taxclname', 'mlraoffice', 'series_status', 'url')])
  
  ## note arguments for D3 JSON compatibility
  ST.list <- ToListExplicit(n, unname = TRUE, nameName = "name", childrenName = "children")
  ST.json <- toJSON(ST.list, pretty = TRUE, auto_unbox = TRUE, force=TRUE)
  
  ## filename
  # note: converting spaces to underscores
  f.name <- paste0('subgroups/', gsub(' ', '_', sgrp), '.json')
  # dump file
  cat(ST.json, file = f.name)
})

# archive for sending to soilmap
tar('subgroups.tgz', 'subgroups', compression = 'gzip')


