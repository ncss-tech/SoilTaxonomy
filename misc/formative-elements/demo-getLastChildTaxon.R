library(SoilTaxonomy)
x <- getLastChildTaxon(level = "suborder")
GreatGroupFormativeElements(x$taxon)
table(sapply(tolower(x$taxon), function(xx) GreatGroupFormativeElements(xx)$defs$element))
