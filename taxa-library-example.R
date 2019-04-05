# https://zachary-foster.github.io/ropensci_taxonomy_community_call/voting_example.html
# https://zachary-foster.github.io/ropensci_taxonomy_community_call/


library(SoilTaxonomy)
library(metacoder)

# hierarchy to the subgroup
data("ST", package = 'SoilTaxonomy')

# convert to Taxmap class
x <- parse_tax_data(ST, class_cols = names(ST), named_by_rank = TRUE)

# what does this do?
# https://grunwaldlab.github.io/metacoder_documentation/example.html
heat_tree(x)


## TODO:
# check out functionality in `taxa` package
# compare with data.tree