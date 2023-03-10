#' Create a `data.tree` Object from Taxon Names
#'
#' @param taxon A vector of taxon names
#' @param level One or more of: `"order"`, `"suborder"`, `"greatgroup"`, `"subgroup"`. The lowest level is passed to `getChildLevel()` to generate the leaf nodes.
#' @param root Label for root node. Default: `"Soil Taxonomy"`; `NULL` for "unrooted" tree.
#' @param verbose Print tree output? Default: `TRUE`
#' @param ... Additional arguments to `data.tree::as.Node.data.frame()`
#'
#' @return A `SoilTaxonNode` (subclass of `data.tree` `Node`) object (invisibly). A text representation of the tree is printed when `verbose=TRUE`.
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
                      verbose = FALSE,
                      ...) {
  if (!requireNamespace("data.tree")) {
    stop("package 'data.tree' is required", call. = FALSE)
  }

  level <- tolower(trimws(level))

  # get child taxa at most detailed `level`
  lh <- level_hierarchy(family = FALSE)
  lowest_level <- max(match(level, lh))
  x <- unique(do.call('c', getChildTaxa(taxon,
                                        level = as.character(lh[lowest_level]))))
  y <- getTaxonAtLevel(x, level = level)

  # we build the tree from the terminal/leaf node information
  #  parent taxa are included based on `level`
  y <- y[order(taxon_to_taxon_code(x)),]
  y <- y[stats::complete.cases(y),]

  # create data.tree node
  y$pathString <- apply(data.frame(root, as.data.frame(lapply(level, function(z) {
    paste0("/", y[[z]])
  }))), MARGIN = 1, FUN = paste0, collapse = "")
  n <- data.tree::as.Node(y, ...)

  # allow for S3 dispatch for "soil  taxonomic data.tree objects" SoilTaxonNode
  attr(n, "class") <- c("SoilTaxonNode", attr(n, "class"))

  if (isTRUE(verbose)) {
    print(n)
  }

  invisible(n)
}

#' @export
print.SoilTaxonNode <- function(x,
                                special.chars = "|",
                                ...) {
  res <- as.data.frame(x, ...)

  # replace unicode markup
  special.chars.default <- c("\u00a6", "\u00b0", "--")
  if (is.null(special.chars) || length(special.chars) == 0) {
    special.chars <- "|"
  }

  special.chars <- rep(special.chars, 3)[1:3]
  for (i in 1:3) {
    res$levelName <- gsub(special.chars.default[i], special.chars[i], res$levelName, fixed = TRUE)
  }

  cat(res$levelName, sep = "\n")
}