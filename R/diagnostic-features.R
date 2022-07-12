#' Get diagnostic horizons, characteristics and features
#'
#' All parameters to this function are optional (default `NULL`). If specified, they are used as filters.
#'
#' This is a wrapper method around the package data set `ST_features`.
#'
#' @param group optional filtering vector; one of: "Surface", "Subsurface", "Mineral", "Organic", "Mineral or Organic"
#' @param chapter optional filtering vector; only chapter `3` currently
#' @param name optional filtering vector; these are the "names" of features used in headers
#' @param page optional filtering vector; page number (12th Edition Keys to Soil Taxonomy)
#' @param multiline_sep default `"\n"` returns `multiline_col` column as a character vector concatenated with `"\\n"`. Use `NULL` for list
#' @param multiline_col character. vector of "multiline" column names to concatenate. Default: `"criteria"`; use `NULL` for no concatenation.
#' @return a subset of `ST_features` _data.frame_
#' @export
#' @seealso `ST_features`
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
                            multiline_sep = "\n",
                            multiline_col = "criteria") {
  ST_features <- NULL
  load(system.file("data/ST_features.rda", package = "SoilTaxonomy")[1])

  .data_filter(
    .data = ST_features,
    group = group,
    chapter = chapter,
    name = name,
    page = page,
    multiline_sep = multiline_sep,
    multiline_col = multiline_col
  )
}
