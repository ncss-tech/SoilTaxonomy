library(SoilTaxonomy)

### DATA DICTIONARIES

# hierarchy to the subgroup
data('ST', package = 'SoilTaxonomy')

# unique taxa
data('ST_unique_list', package = 'SoilTaxonomy')

# formative element dictionaries
data('ST_formative_elements', package = 'SoilTaxonomy')

# codes denoting higher taxonomic parent-child relationships
data('ST_higher_taxa_codes_12th', package = 'SoilTaxonomy')

getTaxonAtLevel('acrudoxic plinthic kandiudults') # level = "order" # default

getTaxonAtLevel('acrudoxic plinthic kandiudults', level = "suborder")

getTaxonAtLevel('acrudoxic plinthic kandiudults', level = "greatgroup")

getTaxonAtLevel('acrudoxic plinthic kandiudults', level = "subgroup")

getTaxonAtLevel('folists')

getTaxonAtLevel('folists', level = "suborder")

getTaxonAtLevel('folists', level = "greatgroup")

getTaxonAtLevel('folists', level = "subgroup")

# label formative elements in the hierarchy with brief explanations

cat(explainST('typic endoaqualfs'))

cat(explainST('abruptic haplic durixeralfs'))

# convert "taxon code" to taxon name (subgroup)
cat(explainST(taxon_code_to_taxon("ABCD"))) # ABCD = gypsic anhyturbels

library(SoilTaxonomy)
library(data.tree)

# load the full hierarchy at the subgroup level
data("ST", package = 'SoilTaxonomy')

# pick 10 taxa
x <- ST[sample(1:nrow(ST), size = 10),]

# construct path
# note: must include a top-level ("ST") in the hierarchy
path <- with(x, paste('ST', tax_subgroup,
                      tax_greatgroup,
                      tax_suborder,
                      tax_order,
                      sep = '/'
))

# convert to data.tree object
n <- as.Node(data.frame(pathString = path), pathDelimiter = '/')

# print
print(n, limit = NULL)
