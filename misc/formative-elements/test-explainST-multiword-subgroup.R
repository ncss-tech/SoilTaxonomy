library(SoilTaxonomy)
data("ST_unique_list")

multiword <- ST_unique_list$subgroup[grep(" .* ", ST_unique_list$subgroup)]

res <- lapply(multiword, function(x) { print(x); try(cat(explainST(x), "\n\n\n", 
                                                         file = "misc/formative-elements/explainST-multiword.txt", 
                                                         append = TRUE)) } )

bad.idx <- which(sapply(res, function(x) inherits(x, 'try-error')))
                  
explainST(multiword[bad.idx])
getTaxonAtLevel(multiword[bad.idx], level = "order")
