
.st_levels <- function() c("order", "suborder", "greatgroup", "subgroup", "family")

#' Parent/Child Hierarchy
#'
#' @param level character. Initial level name of a taxon. Vectors include values that are one of: `"order"`, `"suborder"`, `"greatgroup"`, `"subgroup"`, `"family"`
#' @param n Number of levels above/below (parent/child). Default: `1`
#'
#' @return character. Level name of parent or child at specified level above input `level`.
#' @export
#' @rdname hierarchy
#' @examples
#' parent_level('subgroup')
#'
#' child_level('greatgroup')
#'
#' parent_level('family', 3)
#'
#' # no level above order
#' parent_level('family', 5)
parent_level <- function(level, n = 1) {
 lv <- .st_levels()
 idx <- match(level, lv) - n
 idx[idx == 0] <- NA
 lv[idx]
}

#' @export
#' @rdname hierarchy
child_level <- function(level, n = 1) {
  parent_level(level, -n)
}
