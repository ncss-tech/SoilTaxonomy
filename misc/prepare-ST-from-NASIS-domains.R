## 2019-04-02
## D.E. Beaudette
## Prepare 99.9% of the Soil Taxonomy hierarchy from NASIS domains, current ST edition
##


# using the NASIS domains for ST, re-construct the ST hierarchy from order / suborder / great group / subgroup taxa
# result is 99% accurate, see ST-manual-fixes.diff for manual edits required

library(RODBC)
library(SoilTaxonomy)


channel <- RODBC::odbcDriverConnect(connection="DSN=nasis_local;UID=NasisSqlRO;PWD=nasisRe@d0n1y365")

ST.orders <- RODBC::sqlQuery(channel, "SELECT ChoiceName as soilorder FROM MetadataDomainDetail WHERE DomainID = 132 AND ChoiceObsolete = 0", stringsAsFactors=FALSE)
ST.suborders <- RODBC::sqlQuery(channel, "SELECT ChoiceName as suborder FROM MetadataDomainDetail WHERE DomainID = 134 AND ChoiceObsolete = 0", stringsAsFactors=FALSE)
ST.greatgroups <- RODBC::sqlQuery(channel, "SELECT ChoiceName as greatgroup FROM MetadataDomainDetail WHERE DomainID = 130 AND ChoiceObsolete = 0", stringsAsFactors=FALSE)
ST.subgroups <- RODBC::sqlQuery(channel, "SELECT ChoiceName as subgroup FROM MetadataDomainDetail WHERE DomainID = 187 AND ChoiceObsolete = 0", stringsAsFactors=FALSE)

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



