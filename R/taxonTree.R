
#' Create a `data.tree` Object from Taxon Names
#'
#' @param taxon A vector of taxon names
#' @param level One or more of: `"order"`, `"suborder"`, `"greatgroup"`, `"subgroup"`. The lowest level is passed to `getChildLevel()` to generate the leaf nodes.
#' @param root Label for root node. Default: `"Soil Taxonomy"`; `NULL` for "unrooted" tree.
#' @param verbose Print tree output? Default: `TRUE`
#' @param ... Additional arguments to `data.tree::as.Node.data.frame()`
#'
#' @return A `data.tree` object (invisibly). A text representation of the tree is printed when `verbose=TRUE`.
#' @export
#' @importFrom stats complete.cases
#' @examplesIf !inherits(requireNamespace("data.tree", quietly = TRUE), 'try-error')
#' @examples
#'
#' # hapludults and hapludalfs (to subgroup level)
#' taxonTree(c("hapludults", "hapludalfs"))
#'
#' # alfisols suborders and great groups
#' taxonTree("alfisols", root = "Alfisols", level = c("suborder", "greatgroup"))
taxonTree <- function(taxon,
                      level = c("order", "suborder", "greatgroup", "subgroup"),
                      root = "Soil Taxonomy",
                      verbose = TRUE,
                      ...) {
  if (!requireNamespace("data.tree")) {
    stop("package 'data.tree' is required", call. = FALSE)
  }

  level <- tolower(trimws(level))
  lowest_level <- max(match(level, level_hierarchy(family = FALSE)))
  x <- unique(do.call('c', getChildTaxa(taxon, level = level[length(level)])))
  y <- getTaxonAtLevel(x, level = level)
  y <- y[order(taxon_to_taxon_code(x)),]
  y <- y[stats::complete.cases(y),]

  y$pathString <- apply(data.frame(root, as.data.frame(lapply(level, function(z) {
    paste0("/", y[[z]])
  }))), MARGIN = 1, FUN = paste0, collapse = "")

  n <- data.tree::as.Node(y, ...)
  if (isTRUE(verbose)) {
    print(n, limit = NULL)
  }
  invisible(n)
}
