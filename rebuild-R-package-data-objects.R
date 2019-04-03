## 2019-04-02
## D.E. Beaudette
##
## Rebuild copies of data used within the SoilTaxonomy R package


# ST to the subgroup level, simple data.frame
ST <- read.csv('ST-data/ST-full-fixed.csv', stringsAsFactors = FALSE)

save(ST, file='R_pkg/data/ST.rda')


# extract unique levels and save to a list
ST_unique_list <- list()
ST_unique_list$tax_order <- unique(ST$tax_order)
ST_unique_list$tax_suborder <- unique(ST$tax_suborder)
ST_unique_list$tax_greatgroup <- unique(ST$tax_greatgroup)
ST_unique_list$tax_subgroup <- unique(ST$tax_subgroup)

save(ST_unique_list, file='R_pkg/data/ST_unique_list.rda')
