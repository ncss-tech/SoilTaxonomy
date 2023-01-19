
.st_levels <- function() c("order", "suborder", "greatgroup", "subgroup", "family")

#' Order of Hierarchical Levels in Soil Taxonomy
#'
#' Creates an ordered factor such that different levels (the values used in `level` arguments to various SoilTaxonomy package functions) in the Soil Taxonomy hierarchy can be distinguished or compared to one another.
#'
#' @details The levels of Soil Taxonomy hierarchy include: `"family"`, `"subgroup"`, `"greatgroup"`, `"suborder"`, `"order"`. The `"order"` is a level above `"suborder"`. `"subgroup"` and above are `"taxa above family"`.  Note: `"family"` is always included as the "lowest" level when the result is an ordered factor, even when family-level input is disallowed by `family=FALSE`.
#'
#' @param x Passed as input to `factor()`; defaults to full set: `"order"`, `"suborder"`,  `"greatgroup"`, `"subgroup"`, `"family"`,
#' @param family Allow `"family"` as input in `x`? Used for validating inputs that must be a "taxon above family".
#' @param as.is Return `x` "as is" (after validation)? Shorthand for `unclass(taxon_hierarchy())` to return simple character vector.
#'
#' @return An ordered factor with the values "order", "suborder", "greatgroup", "subgroup". or character when `as.is=TRUE`.
#' @export
#'
#' @examples
#'
#' # is great group a taxon above family?
#'
#' level_hierarchy("greatgroup") > "family"
#'
#' # is order lower level than suborder?
#' level_hierarchy("order") < "suborder"
#'
#' # what levels are above or equal to a particular taxon's level?
#' level_hierarchy(as.is = TRUE)[level_hierarchy() >= taxon_to_level("aquisalids")]
#'
#' ## this produces an error (used for checking for taxa above family)
#' # level_hierarchy("family", family = FALSE)
level_hierarchy <- function(x = c("order", "suborder", "greatgroup", "subgroup", "family"),
                            family = TRUE,
                            as.is = FALSE) {
  lvls <- rev(.st_levels())
  if (!family)
    lvls <- lvls[-1]

  # check allowed level
  if (length(x) > 0) {
    x <- match.arg(tolower(x), lvls, several.ok = TRUE)
  }
  if (as.is) {
    return(x)
  }
  factor(x, levels = lvls, ordered = TRUE)
}


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
