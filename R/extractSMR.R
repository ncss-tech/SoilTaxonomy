
#' Extract Soil Moisture Regime from Subgroup or Higher Level Taxon
#'
#' @param taxon character. Vector of taxon names.
#' @param as.is Return character labels rather than an (ordered) factor? Default: `FALSE`
#' @param droplevels Drop unused levels? Default: `FALSE`
#' @param ordered Create an ordinal factor? Default: `TRUE`
#'
#' @return an (ordered) factor of Soil Moisture Regimes, or character vector when `as.is=TRUE`
#' @export
#'
#' @examples
#' extractSMR(c("aquic haploxeralfs", "typic epiaqualfs", "humic inceptic eutroperox"))
extractSMR <- function(taxon, as.is = FALSE, droplevels = FALSE, ordered = TRUE) {
  res <- vapply(taxon, .extractSMR, character(1))
  if (as.is) {
    return(res)
  }
  res <- factor(res, levels = SoilMoistureRegimeLevels(as.is = TRUE), ordered = ordered)
  if (droplevels) {
    return(droplevels(res))
  }
  res
}

.extractSMR <- function(taxon) {
  el <- FormativeElements(taxon)
  co <- .get_SMR_element_connotation()
  x <- el$defs[el$defs$element %in% co$element &
               el$defs$level %in% co$level, ][c("element", "level")]
  if (nrow(x) > 0) {
    # todo handle per+aqu and per+ud
    co[x$element == co$element & x$level == co$level, ]$connotation
  } else NA_character_
}

.get_SMR_element_connotation <- function() {
  # x <- get_ST_formative_elements()
  # x[grepl("SMR|wetness", x$connotation) & x$level != "subgroup",][c("element","level")]
  ## NB: currently there is no formative element connotation for "peraquic" soils
  data.frame(element = c("per", "ids", "aqu", "torr", "ud", "ust", "xer", "torri", "ud", "ust", "xer"),
             level = c("suborder", "order", "suborder", "suborder", "suborder", "suborder", "suborder", "greatgroup", "greatgroup", "greatgroup", "greatgroup"),
             connotation = c("perudic", "aridic (torric)", "aquic", "aridic (torric)", "udic", "ustic", "xeric", "aridic (torric)", "udic", "ustic", "xeric"))
}
