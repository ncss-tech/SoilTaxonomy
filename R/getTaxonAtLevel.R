#' Get the Taxon Name at the Soil Taxonomic Order, Suborder, Great Group or Subgroup Level
#'
#' @param x A character vector containing subgroup-level taxonomic names
#' @param level one of `c("order","suborder","greatgroup","subgroup")`
#'
#' @return A named character vector of taxa at specified level, where names are the internal Soil Taxonomy letter codes.
#' @author A.G. Brown
#' @export
#'
#' @examples
#' 
#' # default gets the soil order 
#' getTaxonAtLevel(c("typic haplargids", "typic glacistels")) #, level = "order")
#' 
#' # specify alternate levels
#' getTaxonAtLevel("humic haploxerands", level = "greatgroup")
#' 
#' # can't get subgroup (child) from great group (parent)
#' getTaxonAtLevel("udifolists", level = "subgroup")
#' 
#' # but can do parents of children
#' getTaxonAtLevel("udifolists", level = "suborder")
#' 
getTaxonAtLevel <- function(x, level = c("order","suborder","greatgroup","subgroup")) {
  
  level.names <- c("order","suborder","greatgroup","subgroup")
  
  level = match.arg(level, choices = level.names)
  level.lut <- 1:5
  names(level.lut) <- level.names
  
  levelid <- level.lut[level]
  ncharlevel <- levelid
  
  if (levelid >= 4)
    ncharlevel <- 4:5
  
  # assume "family" has a comma separated list (words separated by commas)
  #   followed by subgroup (2 or more words without commas)
  if (any(grepl(",", x))) {
    x <- gsub(".*, \\b[A-Za-z]+\\b (\\b[^,]*)$", "\\1", x)
  }
  
  needle <- decompose_taxon_code(taxon_to_taxon_code(x))
  res <- sapply(needle, function(y) {
    if (length(y) >= levelid && nchar(y[[levelid]]) %in% ncharlevel) {
      return(tolower(taxon_code_to_taxon(y[[levelid]])))
    }
    return(NA_character_)
  })
  names(res) <- names(needle)
  if(length(res) > 0)
    return(res)
  return(NA_character_)
}
