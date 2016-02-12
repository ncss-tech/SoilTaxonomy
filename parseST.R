library(RODBC)
library(stringdist)

channel <- RODBC::odbcDriverConnect(connection="DSN=nasis_local;UID=NasisSqlRO;PWD=nasisRe@d0n1y")

ST.orders <- RODBC::sqlQuery(channel, "SELECT ChoiceName as tax_order FROM MetadataDomainDetail WHERE DomainID = 132 AND ChoiceObsolete = 0", stringsAsFactors=FALSE)
ST.suborders <- RODBC::sqlQuery(channel, "SELECT ChoiceName as tax_suborder FROM MetadataDomainDetail WHERE DomainID = 134 AND ChoiceObsolete = 0", stringsAsFactors=FALSE)
ST.greatgroups <- RODBC::sqlQuery(channel, "SELECT ChoiceName as tax_greatgroup FROM MetadataDomainDetail WHERE DomainID = 130 AND ChoiceObsolete = 0", stringsAsFactors=FALSE)
ST.subgroups <- RODBC::sqlQuery(channel, "SELECT ChoiceName as tax_subgroup FROM MetadataDomainDetail WHERE DomainID = 187 AND ChoiceObsolete = 0", stringsAsFactors=FALSE)

# convert to vectors
ST.orders <- ST.orders$tax_order
ST.suborders <- ST.suborders$tax_suborder
ST.greatgroups <- ST.greatgroups$tax_greatgroup
ST.subgroups <- ST.subgroups$tax_subgroup

# compose into single DF, populate with subgroups as starting point
ST <- data.frame(tax_order=NA, tax_suborder=NA, tax_greatgroup=NA, tax_subgroup=ST.subgroups, stringsAsFactors = FALSE)


## tinkering
# http://www.joyofdata.de/blog/comparison-of-string-distance-algorithms/
# http://stats.stackexchange.com/questions/3425/how-to-quasi-match-two-vectors-of-strings-in-r

# # not quite right
# adist(ST$tax_greatgroup[1], ST.suborders$tax_suborder, partial = TRUE, ignore.case=TRUE)
# adist(ST$tax_greatgroup[1], ST.orders$tax_order, partial = TRUE, ignore.case=TRUE)
# 

## TODO: wrap in a function and stored data in aqp and vectorize

# extract parent taxa from lower levels:
# sub group -> great group
# great group -> sub order
# not reliable for sub order -> order, use manual matching
.matchParentTaxa <- function(needle, haystack, qgram.size=4) {
  # when matching lower levels of ST, it is helpful to only use the last sub-string
  # after splitting on white-space
  needle.split <- strsplit(needle, ' ')[[1]]
  needle <- needle.split[length(needle.split)]
  # compute distance between current great group and all possible sub orders
  d <- stringdist(needle, haystack, method='qgram', q=qgram.size)
  # there may be ties in the distance vector, check
  tab <- table(d)
  min.d <- min(d)
  min.idx <- match(min.d, names(tab))
  matching <- haystack[which(d == min.d)]
  # pick the first match
  res <- matching[1]
  # generate a warning with ties flagged
  ## TODO attempt alternate matching strategy here
  if(length(matching) > 1) {
    message(paste0('ties in distance vector: ', needle, ' [', paste0(matching, collapse=','), ']'))
    # ties <- TRUE
  }
  ## TODO flag ties
#   else
#     ties <- FALSE
  
  return(res)
}

## start at the bottom and work-up

# associate sub group with parent great group: OK
for(i in 1:nrow(ST)) ST$tax_greatgroup[i] <- .matchParentTaxa(ST$tax_subgroup[i], ST.greatgroups, qgram.size = 4)

# associate great group with parent sub order:
# mistakes in some gelisols
for(i in 1:nrow(ST)) ST$tax_suborder[i] <- .matchParentTaxa(ST$tax_greatgroup[i], ST.suborders, qgram.size = 4)

# manually parse soil orders from sub groups
ST$tax_order[grep('alfs$', ST$tax_subgroup)] <- 'alfisols'
ST$tax_order[grep('ands$', ST$tax_subgroup)] <- 'andisols'
ST$tax_order[grep('ids$', ST$tax_subgroup)] <- 'aridisols'
ST$tax_order[grep('ents$', ST$tax_subgroup)] <- 'entisols'
ST$tax_order[grep('els$', ST$tax_subgroup)] <- 'gelisols'
ST$tax_order[grep('ists$', ST$tax_subgroup)] <- 'histosols'
ST$tax_order[grep('epts$', ST$tax_subgroup)] <- 'inceptisols'
ST$tax_order[grep('olls$', ST$tax_subgroup)] <- 'mollisols'
ST$tax_order[grep('ox$', ST$tax_subgroup)] <- 'oxisols'
ST$tax_order[grep('ods$', ST$tax_subgroup)] <- 'spodosols'
ST$tax_order[grep('ults$', ST$tax_subgroup)] <- 'ultisols'
ST$tax_order[grep('erts$', ST$tax_subgroup)] <- 'vertisols'


# re-order
ST <- ST[order(ST$tax_order, ST$tax_suborder, ST$tax_greatgroup), ]

## will have to manually edit here
write.csv(ST, file='ST-full.csv', row.names=FALSE)






