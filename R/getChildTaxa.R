#' Get the lower (child) taxa for a taxon name or code
#'
#' @param taxon A character vector of taxa (case-insensitive)
#' @param code A character vector of taxon codes (case sensitive)
#' @param convert Convert results from taxon codes to taxon names? Default: TRUE
#' @param level Filter results to specific level? Default: `"order"`,`"suborder"`,`"greatgroup"`,`"subgroup"`
#'
#' @return A named list, where names are taxon codes and values are character vectors representing parent taxa
#' @export
#'
#' @examples
#'
#' # suborder children of "Mollisols"
#' getChildTaxa("Mollisols", level = "suborder")
#'
#' # get all children within a great group, given a subgroup
#' getChildTaxa(getTaxonAtLevel("Ultic Haploxeralfs", "greatgroup"))
#'
getChildTaxa <- function(taxon = NULL, code = NULL, convert = TRUE,
                         level = c("order","suborder","greatgroup","subgroup")) {

  level <- match.arg(level, c("order","suborder","greatgroup","subgroup"),
                     several.ok = TRUE)

  if (!is.null(taxon)) {
    code <- taxon_to_taxon_code(taxon)
  }

  # for R CMD check
  ST_higher_taxa_codes_12th <- NULL

  # load local copy of taxon code lookup table
  load(system.file("data/ST_higher_taxa_codes_12th.rda", package = "SoilTaxonomy")[1])

  out <- lapply(code, function(x) {
    idx <- grep(paste0("^", x, "."), ST_higher_taxa_codes_12th$code)

    res <- ST_higher_taxa_codes_12th$code[idx]

    if (length(level) < 4) {
      # filter
      res <- res[code_to_level(res) %in% level]
    }

    if (convert)
      res <- taxon_code_to_taxon(res)
    res
  })
  names(out) <- code
  if (!is.null(taxon))
    names(out) <- taxon
  out
}
