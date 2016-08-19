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


## TODO: where does this come from?
# MLRAs where used, possible to have > 1 / series
q.mlra <- "SELECT soilseriesiidref AS soilseriesiid, areasymbol as mlra
FROM soilseriesmlrasusing
INNER JOIN area ON soilseriesmlrasusing.mlraareaiidref = area.areaiid ;"


# setup connection to our pedon database 
channel <- odbcConnect('nasis_local', uid='NasisSqlRO', pwd='nasisRe@d0n1y')

# exec queries
d.series <- sqlQuery(channel, q.series, stringsAsFactors=FALSE)
d.min <- sqlQuery(channel, q.min, stringsAsFactors=FALSE)
d.mlra <- sqlQuery(channel, q.mlra, stringsAsFactors=FALSE)

# close connection
odbcClose(channel)

# flatten mineralogy class into single record / series
d.min.flat <- ddply(d.min, 'soilseriesiid', .fun=function(i) {
  paste(i$tax_minclass, collapse = '|')
})
names(d.min.flat) <- c('soilseriesiid', 'tax_minclass')

# flatten MLRA  into single record / series
d.mlra.flat <- ddply(d.mlra, 'soilseriesiid', .fun=function(i) {
  paste(i$mlra, collapse = '|')
})
names(d.mlra.flat) <- c('soilseriesiid', 'mlra')


## join elements together
d <- join(d.series, d.min.flat, by='soilseriesiid', type='left')
d <- join(d, d.mlra.flat, by='soilseriesiid', type='left')


write.csv(d, file=gzfile('SC-database.csv.gz'), row.names=FALSE)

# create intial Postgresql table defs-- modify accordingly
cat(postgresqlBuildTableDefinition(PostgreSQL(), name='taxa', obj=d[1, ], row.names=FALSE))

# 
# # fun stuff
# library(Cairo)
# library(lattice)
# library(plyr)
# library(latticeExtra)
# 
# ## count series est. per year:
# s.per.year <- table(d$establishedyear)
# s.per.year <- data.frame(year=as.integer(names(s.per.year)), count=as.integer(s.per.year))
# s.per.year <- subset(s.per.year, subset=year > 1883)
# s.per.year$cumulative <- cumsum(s.per.year$count)
# 
# # save file for later
# write.csv(s.per.year, file='series-per-year.csv', row.names=FALSE)
# 
# # plot:
# p.1 <- xyplot(count ~ year, data=s.per.year, type=c('l', 'g'), ylab='Number of Soil Series', xlab='Year', col='RoyalBlue')
# p.2 <- xyplot(cumulative ~ year, data=s.per.year, type=c('l', 'g'), ylab='Number of Soil Series', xlab='Year', col='RoyalBlue')
# 
# p.12 <- c(p.2, p.1, layout=c(1,2))
# 
# p.12 + layer(panel.text(x=s.per.year$year[73], y=s.per.year$count[73]), labels=as.character(s.per.year$year[73]))
# 
# pdf(file='series-per-year-brevik.pdf', width=8, height=5, pointsize=8)
# update(p.12, ylab=c('Total soil series', 'Soil series added per year'), lwd=2, scales=list(cex=0.75, y=list(rot=0), x=list(alternating=3, tick.number=20)), xlim=c(1895, 2020))
# dev.off()
# 
# ## series / order / year
# s.order <- as.data.frame(xtabs(~ establishedyear + tax_order, data=d), stringsAsFactors=FALSE)
# s.order$establishedyear <- as.integer(s.order$establishedyear)
# s.order <- subset(s.order, subset=establishedyear > 1883)
# s.order.cumulative <- ddply(s.order, 'tax_order', function(i) data.frame(establishedyear=i$establishedyear, cumulative=cumsum(i$Freq)))
# 
# p.3 <- xyplot(Freq ~ establishedyear | tax_order, data=s.order, type=c('l', 'g'), ylab='Number of Soil Series', xlab='Year', as.table=TRUE, scales=list(alternating=1, y=list(relation='free')), strip=strip.custom(bg=grey(0.8)), col='RoyalBlue')
# p.4 <- xyplot(cumulative ~ establishedyear | tax_order, data=s.order.cumulative, type=c('l', 'g'), ylab='Cumulative Number of Soil Series', xlab='Year', as.table=TRUE, scales=list(alternating=1, y=list(relation='free')), strip=strip.custom(bg=grey(0.8)), col='RoyalBlue')
# 
# CairoPNG(file='series-per-year.png', width=1000, height=900)
# print(p.12, position=c(0, 0.5, 1, 1), more=TRUE)
# print(p.4, position=c(0, 0.0, 1, 0.525), more=FALSE)
# dev.off()
# 	

