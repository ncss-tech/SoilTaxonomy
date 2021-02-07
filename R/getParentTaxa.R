# get parent taxa

#' Get the higher (parent) taxa associated with a taxon or taxon code
#'
#' Must specify either `taxon` or `code`. `taxon` is used if both are specified. 
#' 
#' @param taxon A character vector of taxa (case-insensitive)
#' @param code A character vector of taxon codes (case sensitive)
#' @param convert Convert results from taxon codes to taxon names? Default: `TRUE`
#'
#' @return A named list, where names are taxon codes and values are character vectors representing parent taxa
#' @export
#'
#' @examples
#' 
#' getParentTaxa("ultic haploxeralfs")
#' 
#' getParentTaxa("folists")
#' 
getParentTaxa <- function(taxon = NULL, code = NULL, convert = TRUE) {
  # take taxon names or codes as input
  stopifnot(!is.null(taxon) | !is.null(code))
  
  # convert taxa to codes if needed
  if (!is.null(taxon))
    if (is.null(code))
      code <- taxon_to_taxon_code(taxon)
  
  # decompose codes
  dtc <- decompose_taxon_code(code)
  
  # iterate over list - 1 element/taxon each with composite codes
  lapply(dtc, function(x) {
      if(all(is.na(x)))
        return(NA)
    
      # take all codes except last (self) code
      y <- do.call('c', x[1:(length(x) - 1)])
      
      # convert code to taxon if needed
      if(convert) 
        return(taxon_code_to_taxon(y))
      
      return(y)
    })
}
