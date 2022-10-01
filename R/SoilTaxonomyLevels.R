#' Get (Ordered) Factors based on Soil Taxonomy Key position
#'
#' @param level One of: `"order"`, `"suborder"`, `"greatgroup"`, `"subgroup"`
#' @param as.is Return character labels rather than an (ordered) factor? Default: `FALSE`
#' @param ordered Create an ordinal factor? Default: `TRUE`
#'
#' @return an (ordered) factor or character vector (when `as.is=TRUE`)
#' @export
#'
#' @examples
#'
#' SoilTaxonomyLevels("order")
#'
#' SoilTaxonomyLevels("order", ordered = FALSE)
#'
#' SoilTaxonomyLevels("order", as.is = TRUE)
#'
#' SoilTaxonomyLevels("suborder")
#'
SoilTaxonomyLevels <- function(level = c("order", "suborder", "greatgroup", "subgroup"),
                               as.is = FALSE, ordered = TRUE) {
  ST_unique_list <- NULL
  load(system.file("data/ST_unique_list.rda", package = "SoilTaxonomy")[1])

  # create ordered factors, dropping unused levels, ignore case
  res <- factor(tolower(ST_unique_list[[level]]), levels = ST_unique_list[[level]], ordered = ordered)

  if (as.is) {
    return(as.character(res))
  }
  res
}
