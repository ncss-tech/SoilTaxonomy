
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

  .get_SMR_element_connotation <- function() {
    data.frame(element = c("ids",
                           "per", "aqu", "torr", "ud", "ust", "xer", "sapr", "hem", "fibr", "wass",
                           "torri", "ud", "ust", "xer", "aqu",
                           "ud", "ust", "xer"),
               level = c("order",
                         "suborder", "suborder", "suborder", "suborder", "suborder", "suborder", "suborder", "suborder", "suborder", "suborder",
                         "greatgroup", "greatgroup", "greatgroup", "greatgroup", "greatgroup",
                         "subgroup", "subgroup", "subgroup"),
               connotation = c("aridic (torric)",
                               "perudic", "aquic", "aridic (torric)", "udic", "ustic", "xeric", "aquic", "aquic", "aquic", "peraquic",
                               "aridic (torric)", "udic", "ustic", "xeric", "aquic",
                               "udic", "ustic", "xeric"),
               stringsAsFactors = FALSE)
  }

  # get SMR formative element connotation LUT
  co <-  .get_SMR_element_connotation()

  res <- vapply(taxon, function(taxon) {

    # extract formative elements
    el <- FormativeElements(taxon)

    # determine taxon level and position
    el$defs$hierarchy <- level_hierarchy(el$defs$level)
    th <- min(el$defs$hierarchy, na.rm = TRUE)

    # only consider SMR formative elements at or below taxon level
    el$defs <- el$defs[grepl(paste0(co$element, collapse = "|"), el$defs$element) & th <= el$defs$level, ]
    maxlevel <- suppressWarnings(max(el$defs$hierarchy, na.rm = TRUE))
    el$defs <- el$defs[el$defs$hierarchy == maxlevel, ]

    # THEN get highest level taxon SMR connotation
    co2 <- co[!is.na(pmatch(co$element, el$defs$element, duplicates.ok = TRUE)) &
                co$level %in% el$defs$level &
                co$level == maxlevel, ]
    nrx <- nrow(co2)
    if (nrx == 1) {
      co2$connotation
    } else NA_character_
  }, character(1))

  if (as.is) {
    return(res)
  }

  res <- factor(res, levels = SoilMoistureRegimeLevels(as.is = TRUE), ordered = ordered)
  if (droplevels) {
    return(droplevels(res))
  }

  names(res) <- taxon
  res
}
