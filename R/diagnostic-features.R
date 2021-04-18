#' Get Diagnostic Surface and Subsurface Horizons, Characteristics and Features
#'
#' All parameters to this function are optional (default `NULL`). If specified, they are used as filters.
#' 
#' This is a wrapper method around the package data set `ST_features`. 
#' 
#' @param group optional filtering vector; one of: "Surface", "Subsurface", "Mineral", "Organic", "Mineral or Organic"
#' @param chapter optional filtering vector; only chapter `3` currently
#' @param name optional filtering vector; these are the "names" of features used in headers
#' @param page optional filtering vector; page number (12th Edition Keys to Soil Taxonomy)
#' @param multiline_sep default `"\\n"` returns `criteria` column as a character vector concatenated with `"\\n"`. Use `NULL` for list 
#' @return a data.frame  
#' @export
#' @seealso ST_features
#' @examples 
#' 
#' # get all features
#' str(get_ST_features())
#' 
#' # get features in chapter 3
#' str(get_ST_features(chapter = 3))
#' 
#' # get features on pages 18, 19, 20
#' get_ST_features(page = 18:20)
#' 
#' # get the required characteristics for the mollic epipedon from list column
#' str(get_ST_features(name = "Mollic Epipedon")$criteria)
#' 
get_ST_features <- function(group = NULL,
                            chapter = NULL,
                            name = NULL,
                            page = NULL,
                            multiline_sep = "\\n") {
  ST_features <- NULL
  load(system.file("data/ST_features.rda", package = "SoilTaxonomy")[1])
  
  # get full set of features
  res <- ST_features
  
  filtargs <- c(
    "group" = !is.null(group),
    "chapter" = !is.null(chapter),
    "name" = !is.null(name),
    "page" = !is.null(page)
  )
  
  # we assume most users don't want a list column in their data.frame
  if (!is.null(multiline_sep)) {
    res$criteria <- sapply(res$criteria, 
                           function(x) paste0(x, collapse = multiline_sep))
  }
  
  if (all(!filtargs)) {
    return(res)
  }
  
  # list of logical vector matching argument criteria
  filtres <- sapply(paste0(names(filtargs)[filtargs]), 
                    function(x) eval(parse(text = x), res) %in% eval(parse(text = x)))
  
  # reduce if needed
  if (ncol(filtres) > 1){
      filtres <- (rowSums(filtres) == ncol(filtres))  
  }
  
  # subset
  res[which(filtres),]
}
