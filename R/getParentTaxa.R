# get parent taxa

#' Get the higher (parent) taxa for a taxon name or code
#'
#' Must specify either `taxon` or `code`. `taxon` is used if both are specified. 
#' 
#' @param taxon A character vector of taxa (case-insensitive)
#' @param code A character vector of taxon codes (case sensitive)
#' @param convert Convert results from taxon codes to taxon names? Default: `TRUE`
#' @param level level	Filter results to specific level? Default: `"order"`,`"suborder"`,`"greatgroup"`,`"subgroup"`
#' 
#' @return A named list, where names are taxon codes and values are character vectors representing parent taxa
#' @export
#'
#' @examples
#' 
#' getParentTaxa("ultic haploxeralfs")
#' 
#' getParentTaxa(code = c("ABCD", "DABC"))
#' 
#' getParentTaxa("folists", convert = FALSE)
#' 
getParentTaxa <- function(taxon = NULL, code = NULL, convert = TRUE, 
                          level = c("order","suborder","greatgroup","subgroup")) {
  level <- match.arg(level, c("order","suborder","greatgroup","subgroup"), several.ok = TRUE)
  
  # take taxon names or codes as input
  stopifnot(!is.null(taxon) | !is.null(code))
  
  # convert taxa to codes if needed
  if (!is.null(taxon))
    if (is.null(code))
      code <- taxon_to_taxon_code(taxon)
  
  # allow for family-level input
  remove_self <- rep(TRUE, length(code))
  if(!is.null(taxon)) {
    remove_self[which(taxon_to_level(taxon) == "family")] <- FALSE
  }
  
  # decompose codes
  dtc <- decompose_taxon_code(code)
  
  # iterate over list - 1 element/taxon each with composite codes
  res <- lapply(seq_along(dtc), function(i) {
      x <- dtc[[i]]
      
      if (all(is.na(x)) || is.na(taxon_to_level(taxon_code_to_taxon(code[i])))) {
        return(NA)
      }
      
      # take all codes except last (self) code
      y <- do.call('c', x[1:(length(x) - as.integer(remove_self[i]))])
      
      if (length(level) < 4) {
        # filter
        y <- y[code_to_level(y) %in% level]
      }
      
      # convert code to taxon if needed
      if (convert) 
        return(taxon_code_to_taxon(y))
      
      return(y)
    })
  
  # use input (code) as names
  names(res) <- code
  if (!is.null(taxon)) {
    names(res) <- taxon
  }
  return(res)
}
