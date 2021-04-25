## 2021-04-15
## D.E. Beaudette, A.G. Brown

library(RODBC)
library(SoilTaxonomy)


channel <- RODBC::odbcDriverConnect(connection="DSN=nasis_local;UID=NasisSqlRO;PWD=nasisRe@d0n1y365")

ST.orders <- RODBC::sqlQuery(channel, "SELECT ChoiceName as soilorder FROM MetadataDomainDetail WHERE DomainID = 132 AND ChoiceObsolete = 0", stringsAsFactors=FALSE)
ST.suborders <- RODBC::sqlQuery(channel, "SELECT ChoiceName as suborder FROM MetadataDomainDetail WHERE DomainID = 134 AND ChoiceObsolete = 0", stringsAsFactors=FALSE)
ST.greatgroups <- RODBC::sqlQuery(channel, "SELECT ChoiceName as greatgroup FROM MetadataDomainDetail WHERE DomainID = 130 AND ChoiceObsolete = 0", stringsAsFactors=FALSE)
ST.subgroups <- RODBC::sqlQuery(channel, "SELECT ChoiceName as subgroup FROM MetadataDomainDetail WHERE DomainID = 187 AND ChoiceObsolete = 0", stringsAsFactors=FALSE)
ST.family.classes <- RODBC::sqlQuery(channel, "SELECT DomainID, ChoiceName as classname FROM MetadataDomainDetail WHERE DomainID IN ('126','127','128','131','184','185','186','188','520','5247') AND ChoiceObsolete = 0", stringsAsFactors=FALSE)

ST.family.classes$group <- c(
  `126` = "mineralogy class",
  `127` = "particle-size class",
  `128` = "reaction class",
  `131` = "soil moisture subclass",
  `184` = "other family class",
  `185` = "temperature class",
  `186` = "moisture regime",
  `188` = "temperature regime",
  `520` = "activity class",
  `5247` = "human-altered and human transported class"
)[as.character(ST.family.classes$DomainID)]

# convert to vectors
ST.orders <- ST.orders$soilorder
ST.suborders <- ST.suborders$suborder
ST.greatgroups <- ST.greatgroups$greatgroup
ST.subgroups <- ST.subgroups$subgroup

# compose into single DF, populate with subgroups as starting point
ST <- data.frame(order=NA, suborder=NA, greatgroup=NA, subgroup=ST.subgroups, stringsAsFactors = FALSE)


## tinkering
# http://www.joyofdata.de/blog/comparison-of-string-distance-algorithms/
# http://stats.stackexchange.com/questions/3425/how-to-quasi-match-two-vectors-of-strings-in-r
# 
## start at the bottom and work-up

# associate subgroup with parent greatgroup: OK
ST$greatgroup <- getTaxonAtLevel(ST$subgroup, "greatgroup")

# associate great group with parent sub order:
# mistakes in some gelisols
ST$suborder <- getTaxonAtLevel(ST$subgroup, "suborder")
ST$order <- getTaxonAtLevel(ST$subgroup, "order")

# re-order
ST <- ST[order(ST$order, ST$suborder, ST$greatgroup), ]

# drop taxa that do not exist in lookup tables
ST <- ST[which(complete.cases(ST)),]

## manually edit from here
write.csv(ST, file='misc/ST-data/ST-full.csv', row.names=FALSE, quote = FALSE)

write.csv(ST.family.classes, file='misc/ST-data/ST-family-classes.csv', row.names=FALSE, quote = FALSE)



