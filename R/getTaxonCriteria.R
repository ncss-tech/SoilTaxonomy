#' Get Taxon Criteria from the Keys to Soil Taxonomy
#'
#' @param taxon _character_. Vector of taxon names (order to subgroup level). These values are converted to taxon "codes"
#' @param code _character_. Vector of taxon codes.
#' @param level _character_. One or more of: "order", "suborder", "greatgroup", "subgroup"
#'
#' @return A named list. Each list element is named based on the input value (either `taxon` or `code`) and contains a data.frame derived from dataset ST_criteria_13th.
#' @seealso [taxon_to_taxon_code()], [ST_criteria_13th]
#' @export
#'
#' @examples
#' getTaxonCriteria(c("mollic haplocryalfs", "abruptic durixeralfs"))
#'
#' getTaxonCriteria(code = "ABC", level = c("greatgroup"))
getTaxonCriteria <- function(taxon = NULL,
                             code = NULL,
                             level = c("order", "suborder", "greatgroup", "subgroup")) {

  level <- match.arg(level, c("order", "suborder", "greatgroup", "subgroup"), several.ok = TRUE)

  if (!is.null(taxon) && missing(code)) {
    outnames <- taxon
    code <- taxon_to_taxon_code(taxon)
  } else if (!is.null(taxon) && !is.null(code)) {
    warning("Argument `code` takes precedence over argument `taxon` when both are specified", call. = FALSE)
  } else {
    outnames <- code
  }

  taxa <- decompose_taxon_code(code)

  ST_criteria_13th <- NULL
  load(system.file("data", "ST_criteria_13th.rda", package = "SoilTaxonomy")[1])

  res <- lapply(taxa, function(x) {
    data.frame(data.table::rbindlist(ST_criteria_13th[unlist(x)[c("order", "suborder", "greatgroup", "subgroup") %in% level]]))
  })
  names(res) <- outnames
  res
}
