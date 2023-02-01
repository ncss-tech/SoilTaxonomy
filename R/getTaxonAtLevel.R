#' Get the taxon name at the Soil Order, Suborder, Great Group or Subgroup level
#'
#' @param x A character vector containing subgroup-level taxonomic names
#' @param level one of `c("order","suborder","greatgroup","subgroup")`
#' @param simplify Return a vector when `level` has length `1`? Default: `TRUE`. Otherwise, a data.frame is returned.
#'
#' @return A named character vector of taxa at specified level, where names are the internal Soil Taxonomy letter codes.  When `length(level) > 1`?  a data.frame is returned with column names for each `level`.
#'
#'
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
#' # specify multiple levels (returns a list element for each level)
#' getTaxonAtLevel("hapludolls", c("order", "suborder", "greatgroup", "subgroup"))
getTaxonAtLevel <- function(x, level = "order", simplify = TRUE) {

  level.names <- c("order", "suborder", "greatgroup", "subgroup")

  level = match.arg(tolower(trimws(level)), choices = level.names, several.ok = TRUE)
  level.lut <- 1:4
  names(level.lut) <- level.names

  levelid <- level.lut[level]
  ncharlevel <- levelid

  res <- lapply(levelid, function(i) {
    if (i == 4)
      ncharlevel <- 4:5

    needle <- decompose_taxon_code(taxon_to_taxon_code(x))
    res <- sapply(needle, function(y) {
      if (length(y) >= i && nchar(y[[i]]) %in% ncharlevel) {
        return(tolower(taxon_code_to_taxon(y[[i]])))
      }
      return(NA_character_)
    })
    names(res) <- x
    if (length(res) > 0)
      return(res)
    return(NA_character_)
  })

  if (length(res) == 1 && simplify) {
    return(res[[1]])
  } else {
    names(res) <- level
    return(as.data.frame(res))
  }
}
