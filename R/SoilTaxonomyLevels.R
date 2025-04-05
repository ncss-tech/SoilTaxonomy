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

  level <- match.arg(level, c("order", "suborder", "greatgroup", "subgroup"))
  ST_unique_list <- NULL
  load(system.file("data", "ST_unique_list.rda", package = "SoilTaxonomy")[1])

  res <- factor(ST_unique_list[[level]], levels = ST_unique_list[[level]], ordered = ordered)

  if (as.is) {
    return(as.character(res))
  }
  res
}

#' @export
#' @rdname SoilTaxonomyLevels
SoilMoistureRegimeLevels <- function(as.is = FALSE, ordered = TRUE) {
  # soilDB::get_NASIS_column_metadata("taxmoistcl")[["ChoiceName"]]
  # note the domain is _not_ an ordered one by default
  d <- data.frame(ChoiceName = c("aridic (torric)", "ustic", "xeric",
                                 "udic", "perudic", "aquic", "peraquic"))
  res <- factor(d$ChoiceName, levels = d$ChoiceName, ordered = ordered)
  if (as.is) {
    return(as.character(res))
  }
  res
}

#' @export
#' @rdname SoilTaxonomyLevels
SoilTemperatureRegimeLevels <- function(as.is = FALSE, ordered = TRUE) {
  # subset(soilDB::get_NASIS_column_metadata("taxtempregime"),
  #        !ChoiceObsolete, select=c("ChoiceSequence", "ChoiceName"))
  # note the domain is _not_ an ordered one by default
  d <- data.frame(ChoiceName = c("gelic", "cryic", "isofrigid", "frigid",
                                 "isomesic", "mesic", "thermic", "isothermic",
                                 "hyperthermic", "isohyperthermic"))
  res <- factor(d$ChoiceName, levels = d$ChoiceName, ordered = ordered)
  if (as.is) {
    return(as.character(res))
  }
  res
}



