#' Determine taxonomic level of specified taxa
#'
#' Taxa that resolve to a subgroup level taxon and contain a comma `","` are assumed to be `"family"`-level.
#'
#' @param taxon character vector of taxon names at Order, Suborder, Great Group or Subgroup level.
#'
#' @return character of taxonomic hierarchy levels (such as "order", "suborder", "greatgroup", "subgroup", "family") for each element of input vector.
#' 
#' @export
#'
#' @examples
#' 
#' # get the taxonomic levels for various taxa
#' 
#' taxon_to_level(c("gelisols", NA, "foo", "typic folistels", "folistels"))
#' 
taxon_to_level <- function(taxon) {
  
  # convert taxon names to codes, then assign levels based on number of code characters
  code <- taxon_to_taxon_code(taxon)
  
  # used for family check
  ncode <- nchar(code)
  
  level <- code_to_level(code)
  
  # if taxon contains commas, taxon_to_taxon_code extracts subgroup
  level[ncode >= 4 & grepl(",", taxon)] <- "family"
  
  level
}

#' Determine taxonomic level of a taxonomic letter code
#'
#' @param code A character vector of taxon codes (case sensitive)
#'
#' @return A character vector containing `"order"`, `"suborder"`, `"greatgroup"` or `"subgroup"`
#' @export
#'
#' @examples
#' 
#' # order level code (1 character)
#' code_to_level("B")
#' 
#' # subgroup level code (4 characters)
#' code_to_level("ABCD")
#' 
#' # subgroup level code (5 characters, 4 uppercase + 1 lowercase)
#' code_to_level("IFFZh")
#' 
code_to_level <-  function(code) {
  ncode <- nchar(code)
  level <- rep(NA_character_, length(ncode))
  level[ncode == 1] <- "order" # e.g. A
  level[ncode == 2] <- "suborder" # e.g. AB
  level[ncode == 3] <- "greatgroup" # e.g. ABC
  level[ncode >= 4] <- "subgroup" # e.g. ABCD or in large keys ABCDe
  level[ncode > 5] <- NA_character_ # invalid code
  level
}

#' Get all taxa at specified level
#' 
#' Convenience method for getting taxa from `ST_unique_list`
#' 
#' @param level character. One or more of "order", "suborder", "greatgroup", "subgroup"
#'
#' @return A character vector of taxa at the specified level
#' 
#' @export
#' 
#' @examples 
#' 
#' # get all order and suborder level taxa
#' 
#' level_to_taxon(level = c("order","suborder"))
#' 
level_to_taxon <- function(level = c("order","suborder","greatgroup","subgroup")) {
  ST_unique_list <- NULL
  
  load(system.file("data/ST_unique_list.rda", package = "SoilTaxonomy")[1])
  
  level <- match.arg(level, names(ST_unique_list), several.ok = TRUE)
  
  do.call('c', lapply(level, function(aLevel) ST_unique_list[[aLevel]]))
}

