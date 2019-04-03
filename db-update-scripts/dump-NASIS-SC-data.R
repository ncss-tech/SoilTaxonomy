## 2019-04-02
## D.E. Beaudette
## Export the current SC database from local NASIS DB
##

# TODO: remove plyr dependency

library(RODBC)
library(RPostgreSQL)
library(plyr)

q.series <- "SELECT soilseriesname, soiltaxclasslastupdated, mlraoffice, ss.ChoiceName as series_status, taxclname, tord.ChoiceName as tax_order, tso.ChoiceName as tax_suborder, tgg.ChoiceName as tax_grtgroup, ts.ChoiceName as tax_subgrp, ps.ChoiceName as tax_partsize, psm.ChoiceName as tax_partsizemod, ta.ChoiceName as tax_ceactcl, tr.ChoiceName as tax_reaction, tt.ChoiceName as tax_tempcl, originyear, establishedyear, descriptiondateinitial, descriptiondateupdated, benchmarksoilflag, statsgoflag, objwlupdated,  recwlupdated, typelocstareaiidref, typelocstareatypeiidref, soilseriesiid, soilseriesdbiidref, grpiidref 
FROM 
soilseries

LEFT OUTER JOIN (SELECT * FROM dbo.MetadataDomainDetail WHERE dbo.MetadataDomainDetail.DomainID = 127) AS ps ON soilseries.taxpartsize = ps.ChoiceValue

LEFT OUTER JOIN (SELECT * FROM dbo.MetadataDomainDetail WHERE dbo.MetadataDomainDetail.DomainID = 521) AS psm ON soilseries.taxpartsizemod = psm.ChoiceValue

LEFT OUTER JOIN (SELECT * FROM dbo.MetadataDomainDetail WHERE dbo.MetadataDomainDetail.DomainID = 187) AS ts ON soilseries.taxsubgrp = ts.ChoiceValue

LEFT OUTER JOIN (SELECT * FROM dbo.MetadataDomainDetail WHERE dbo.MetadataDomainDetail.DomainID = 132) AS tord ON soilseries.taxorder = tord.ChoiceValue

LEFT OUTER JOIN (SELECT * FROM dbo.MetadataDomainDetail WHERE dbo.MetadataDomainDetail.DomainID = 134) AS tso ON soilseries.taxsuborder = tso.ChoiceValue

LEFT OUTER JOIN (SELECT * FROM dbo.MetadataDomainDetail WHERE dbo.MetadataDomainDetail.DomainID = 4956) AS ss ON soilseries.soilseriesstatus = ss.ChoiceValue

LEFT OUTER JOIN (SELECT * FROM dbo.MetadataDomainDetail WHERE dbo.MetadataDomainDetail.DomainID = 520) AS ta ON soilseries.taxceactcl = ta.ChoiceValue
LEFT OUTER JOIN (SELECT * FROM dbo.MetadataDomainDetail WHERE dbo.MetadataDomainDetail.DomainID = 128) AS tr ON soilseries.taxreaction = tr.ChoiceValue

LEFT OUTER JOIN (SELECT * FROM dbo.MetadataDomainDetail WHERE dbo.MetadataDomainDetail.DomainID = 185) AS tt ON soilseries.taxtempcl = tt.ChoiceValue
LEFT OUTER JOIN (SELECT * FROM dbo.MetadataDomainDetail WHERE dbo.MetadataDomainDetail.DomainID = 130) AS tgg ON soilseries.taxgrtgroup = tgg.ChoiceValue

ORDER BY soilseries.soilseriesname;"	

# minerology, possible to have > 1 / series
q.min <- "SELECT soilseriesiidref AS soilseriesiid, minorder, a.ChoiceName AS tax_minclass
FROM soilseriestaxmineralogy
LEFT OUTER JOIN (SELECT * FROM dbo.MetadataDomainDetail WHERE dbo.MetadataDomainDetail.DomainID = 126) as a ON soilseriestaxmineralogy.taxminalogy = a.ChoiceValue ;"


# setup connection to our pedon database 
channel <- odbcConnect('nasis_local', uid='NasisSqlRO', pwd='nasisRe@d0n1y365')

# exec queries
d.series <- sqlQuery(channel, q.series, stringsAsFactors=FALSE)
d.min <- sqlQuery(channel, q.min, stringsAsFactors=FALSE)

# close connection
odbcClose(channel)

# flatten mineralogy class into single record / series
d.min.flat <- ddply(d.min, 'soilseriesiid', .fun=function(i) {
  paste(i$tax_minclass, collapse = '|')
})
names(d.min.flat) <- c('soilseriesiid', 'tax_minclass')


# join elements together
d <- join(d.series, d.min.flat, by='soilseriesiid', type='left')

# save to local repo
write.csv(d, file=gzfile('databases/SC-database.csv.gz'), row.names=FALSE)







