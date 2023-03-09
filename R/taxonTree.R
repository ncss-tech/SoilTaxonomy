
#' Create a `data.tree` Object from Taxon Names
#'
#' @param taxon A vector of taxon names
#' @param root Label for root node. Default: `"Soil Taxonomy"`; `NULL` for "unrooted" tree.
#' @param verbose Print tree output? Default: `TRUE`
#' @param ... Additional arguments to `data.tree::as.Node.data.frame()`
#'
#' @return A data.tree object (invisibly). A text representation of the tree is printed when `verbose=TRUE`.
#' @export
#' @examplesIf !inherits(requireNamespace("data.tree", quietly = TRUE), 'try-error')
#' @examples
#' taxonTree(c("hapludults", "hapludalfs"))
taxonTree <- function(taxon, root = "Soil Taxonomy", verbose = TRUE, ...) {
  if (!requireNamespace("data.tree")) {
    stop("package 'data.tree' is required", call. = FALSE)
  }

  x <- unique(do.call('c', getChildTaxa(taxon)))
  y <- getTaxonAtLevel(x, level = c("order", "suborder", "greatgroup", "subgroup"))
  y <- y[order(taxon_to_taxon_code(x)),]
  y <- y[complete.cases(y),]

  y$pathString <- with(y, paste0(ifelse(length(root) > 0, paste0(root, "/"), ""),
                                 order, "/", suborder, "/", greatgroup, "/", subgroup))
  n <- data.tree::as.Node(y, ...)
  if (isTRUE(verbose)) {
    print(n, limit = NULL)
  }

  invisible(n)
}

taxonTree("alfisols")
