
#' Get last child taxon in Keys at specified taxonomic level
#'
#' @param level Get child taxa from keys at specified level. One of: `"order"`, `"suborder"`, `"greatgroup"`
#'
#' @return A `data.frame` containing `key` (parent key), `taxon` (last taxon name), `code` (letter code), `position` (relative taxon position)
#' @export
#'
#' @examples
#' 
#' # get last taxa in suborder-level keys
#' x <- getLastChildTaxon(level = "suborder")
#' 
#' # proportion of keys where last taxon has "Hap" formative element
#' prop.table(table(grepl("^Hap", x$taxon)))
getLastChildTaxon <- function(level = c("order","suborder","greatgroup")) {
  lvls <- c("order","suborder","greatgroup")
  level <- match.arg(level, lvls)
  
  level.idx <- match(level, lvls)
  ST_unique_list <- NULL
  load(system.file("data", "ST_unique_list.rda", package = "SoilTaxonomy")[1])
  
  suborders <- taxon_to_taxon_code(ST_unique_list[[level]])
  ggposition <- relative_taxon_code_position(taxon_to_taxon_code(ST_unique_list[[lvls[level.idx + 1]]]))
  
  res <- lapply(suborders, function(so) {
    x <- ggposition[grep(paste0("^", so), names(ggposition))]
    names(x[which.max(x)])
  })
  
  codes <- taxon_to_taxon_code(as.character(res)) 
  
  data.frame(
    key = names(res),
    taxon = taxon_code_to_taxon(as.character(res)),
    code = as.character(res),
    position = relative_taxon_code_position(codes),
    row.names = NULL
  )
}
