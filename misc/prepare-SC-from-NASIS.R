## 2019-04-02
## D.E. Beaudette
## Export the current SC database from local NASIS DB
##

library(RODBC)
library(soilDB)

# TODO: remove plyr dependency
library(plyr)

q.series <- "SELECT 
soilseriesname, soiltaxclasslastupdated, mlraoffice, 
soilseriesstatus, 
taxclname, 
taxorder, 
taxsuborder, 
taxgrtgroup, 
taxsubgrp, 
taxpartsize, 
taxpartsizemod, 
taxceactcl, 
taxreaction, 
taxtempcl, 
originyear, establishedyear, descriptiondateinitial, descriptiondateupdated, benchmarksoilflag, statsgoflag, objwlupdated,  recwlupdated, typelocstareaiidref, typelocstareatypeiidref, soilseriesiid, soilseriesdbiidref, grpiidref 
FROM 
soilseries
ORDER BY soilseriesname ;"	

# mineralogy, possible to have > 1 / series
q.min <- "SELECT soilseriesiidref AS soilseriesiid, minorder, taxminalogy
FROM soilseriestaxmineralogy ;"


# setup connection to our pedon database 
channel <- odbcConnect('nasis_local', uid='NasisSqlRO', pwd='nasisRe@d0n1y365')

# exec queries
d.series <- sqlQuery(channel, q.series, stringsAsFactors=FALSE)
d.min <- sqlQuery(channel, q.min, stringsAsFactors=FALSE)

# close connection
odbcClose(channel)

# convert codes -> values
d.series <- uncode(d.series, stringsAsFactors = FALSE)
d.min <- uncode(d.min, stringsAsFactors = FALSE)

# flatten mineralogy class into single record / series
d.min.flat <- ddply(d.min, 'soilseriesiid', .fun=function(i) {
  paste(i$taxminalogy, collapse = '|')
})
names(d.min.flat) <- c('soilseriesiid', 'taxminalogy')


# join elements together
d <- join(d.series, d.min.flat, by='soilseriesiid', type='left')

# save to local repo
write.csv(d, file=gzfile('../inst/extdata/SC-database.csv.gz'), row.names=FALSE)







