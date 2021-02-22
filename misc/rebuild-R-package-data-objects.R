## 2019-04-02
## D.E. Beaudette
##
## Rebuild copies of data used within the SoilTaxonomy R package


## ST to the subgroup level, simple data.frame
ST <- read.csv('misc/ST-data/ST-full.csv', stringsAsFactors = FALSE)

save(ST, file='data/ST.rda')

## extract unique levels and save to a list
ST_unique_list <- list()
ST_unique_list$order <- unique(ST$order)
ST_unique_list$suborder <- unique(ST$suborder)
ST_unique_list$greatgroup <- unique(ST$greatgroup)
ST_unique_list$subgroup <- unique(ST$subgroup)

save(ST_unique_list, file='data/ST_unique_list.rda')


## formative element dictionaries
# TODO: streamline this
load('misc/formative-elements/formative-elements.rda')
ST_formative_elements <- ST.formative_elements
names(ST_formative_elements) <- c("order","suborder","greatgroup","subgroup")

save(ST_formative_elements, file='data/ST_formative_elements.rda')

