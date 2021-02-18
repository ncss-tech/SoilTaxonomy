library(SoilTaxonomy)
data("ST_unique_list")

multiword <- ST_unique_list$tax_subgroup[grep(" .* ", ST_unique_list$tax_subgroup)]

res <- lapply(multiword, function(x) { print(x); try(cat(explainST(x), 
                                                         file = "misc/formative-elements/explainST-multiword.txt", 
                                                         append = TRUE)) } )

bad.idx <- which(sapply(res, function(x) inherits(x, 'try-error')))
                  
explainST(multiword[bad.idx])
getTaxonAtLevel(multiword[bad.idx], level = "soilorder")
