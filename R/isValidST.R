#' Check for valid taxonomic level (Order, Suborder, Great Group, Subgroup)
#' 
#' Checks `needle` for matches against a single level of Soil Taxonomy hierarchy: `order`, `suborder`, `greatgroup`, `subgroup`. Matches are case-insensitive.
#' 
#' @param needle vector of taxa
#' @param level single level of Soil Taxonomy hierarchy; one of: `"order"`, `"suborder"`, `"greatgroup"`, `"subgroup"`
#' 
#' @return `logical` vector, same length as needle
#' 
#' @examples
#' 
#' isValidST('typic haploxeralfs', level = 'subgroup')
#' 
#' @export
isValidST <- function(needle, level = c('order', 'suborder', 'greatgroup', 'subgroup')) {
  
  # safely match level
  level <- match.arg(level)
  
  # for R CMD check
  ST_unique_list <- NULL
  
  # load local copy of unique taxa
  load(system.file("data", "ST_unique_list.rda", package="SoilTaxonomy")[1])
  
  # load required elements
  haystack <- ST_unique_list[[level]]
  
  # matching is done in lower case
  needle <- tolower(needle)
  res <- match(needle, haystack)
  
  res <- !sapply(res, is.na)
  return(res)
}

