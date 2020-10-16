#' Check for valid order | suborder | greatgroup | subgroup.
#' 
#' This function can be used to quickly test for valid levels within the 
#' Soil Taxonomy hierarchy, a defined within the 13th edition of The Keys to Soil Taxonomy.
#' Matches are case insensitive.
#' 
#' @param needle vector of taxa
#' @param level single level of Soil Taxonomy hierarchy: tax_order, tax_suborder, tax_greatgroup, tax_subgroup
#' 
#' @return logical vector, same lenght as needle
#' 
#' @examples
#' 
#' # note specfifcation of taxonomic level
#' isValidST('typic haploxeralfs', level = 'tax_subgroup')
#' 
#' @export
isValidST <- function(needle, level = c('tax_order', 'tax_suborder', 'tax_greatgroup', 'tax_subgroup')) {
  
  # safely match level
  level <- match.arg(level)
  
  # for R CMD check
  ST_unique_list <- NULL
  
  # load local copy of unique taxa
  load(system.file("data/ST_unique_list.rda", package="SoilTaxonomy")[1])
  
  # load required elements
  haystack <- ST_unique_list[[level]]
  
  # matching is done in lower case
  needle <- tolower(needle)
  res <- match(needle, haystack)
  
  res <- ! sapply(res, is.na)
  return(res)
}

