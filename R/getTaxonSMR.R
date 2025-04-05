#' Lookup Pre-calculated Soil Moisture Regimes by Taxon
#'
#' Helper function for using  latest version of the Keys to Soil Taxonomy
#' standard lookup table for soil moisture information.
#'
#' @param taxon _character_. Vector of taxon names (order to subgroup level).
#'   These values are converted to taxon "codes"
#' @param code _character_. Vector of taxon codes.
#' @param as.is _logical_. Return character labels rather than an (ordered)
#'   factor? Default: `FALSE`
#' @param droplevels _logical_. Drop unused levels? Default: `FALSE`
#' @param ordered _logical_. Create an ordinal factor? Default: `TRUE`
#'
#' @seealso [extractSMR()] [ST_SMR_13th]
#' @return _character_ or _factor_ (when as.is=FALSE) containing soil moisture
#'   regime labels extracted from 13th edition Keys to Soil Taxonomy taxa using
#'   `extractSMR()`
#' @export
#'
#' @examples
#' getTaxonSMR(c("aridisols", "haploxeralfs", NA, "abruptic durixeralfs", "ustic haplocryalfs"))
getTaxonSMR <- function(taxon = NULL, code = NULL, as.is = FALSE, droplevels = FALSE, ordered = TRUE) {
  ST_SMR_13th <- NULL
  load(system.file("data", "ST_SMR_13th.rda", package = "SoilTaxonomy")[1])

  if (!is.null(taxon) && missing(code)) {
    outnames <- taxon
    code <- taxon_to_taxon_code(taxon)
  } else if (!is.null(taxon) && !is.null(code)) {
    warning("Argument `code` takes precedence over argument `taxon` when both are specified", call. = FALSE)
  } else {
    outnames <- code
  }

  out <- ST_SMR_13th[match(code, ST_SMR_13th$code),]$taxmoistcl

  if (isFALSE(as.is)) {
    out <- factor(out, levels = SoilMoistureRegimeLevels(as.is = TRUE), ordered = ordered)

    if (droplevels) {
      return(droplevels(res))
    }
  }

  names(out) <- outnames

  out
}
