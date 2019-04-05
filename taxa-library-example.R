# https://zachary-foster.github.io/ropensci_taxonomy_community_call/voting_example.html
# https://zachary-foster.github.io/ropensci_taxonomy_community_call/


library(SoilTaxonomy)
library(metacoder)

# hierarchy to the subgroup
data("ST", package = 'SoilTaxonomy')

# convert to Taxmap class
x <- parse_tax_data(ST, class_cols = names(ST), named_by_rank = TRUE)


x %>% 
  filter_taxa(taxon_names == "alfisols", subtaxa = TRUE) %>%
  heat_tree(node_label = taxon_names,
            node_size = n_obs, 
            node_color = n_obs,
            node_color_axis_label = "Number of subgroups",
            output_file = "alfisols_tree.pdf")


set.seed(4)
x %>% 
  filter_taxa(!is_leaf) %>%
  heat_tree(node_label = taxon_names,
            node_size = n_obs, 
            node_color = n_obs,
            tree_label = taxon_names,
            node_color_axis_label = "Number of subgroups",
            layout = "da",
            output_file = "soil_tree.pdf")




# what does this do?
# https://grunwaldlab.github.io/metacoder_documentation/example.html
heat_tree(x)


## TODO:
# check out functionality in `taxa` package
# compare with data.tree