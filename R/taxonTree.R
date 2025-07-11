#' Create a `data.tree` Object from Taxon Names
#'
#' This function takes one or more taxon names and taxonomic levels as input.
#'
#' A subclass of data.tree `Node` object is returned. This object has a custom `print()` method
#'
#' @param taxon A vector of taxon names
#' @param level One or more of: `"order"`, `"suborder"`, `"greatgroup"`, `"subgroup"`. The lowest level is passed to `getChildLevel()` to generate the leaf nodes.
#' @param root Label for root node. Default: `"Soil Taxonomy"`; `NULL` for "unrooted" tree.
#' @param verbose Print tree output? Default: `TRUE`
#' @param special.chars Characters used to print the tree to console. Default: `c("|--", "|", "|", "-")`. For fancy markup try: `c("\u251c","\u2502", "\u2514", "\u2500 ")`
#' @param file Optional: path to output file. Default: `""` prints to standard output connection (unless redirected by `sink()`)
#' @param ... Additional arguments to `data.tree::as.Node.data.frame()`
#'
#' @return A `SoilTaxonNode` (subclass of `data.tree` `Node`) object (invisibly). A text representation of the tree is printed to stdout when `verbose=TRUE`.
#' @export
#' @importFrom stats complete.cases
#' @examplesIf requireNamespace("data.tree")
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
                      special.chars = c("|--", "|", "|", "-"),
                      file = "",
                      ...) {
  if (!requireNamespace("data.tree")) {
    stop("package 'data.tree' is required", call. = FALSE)
  }

  level <- tolower(trimws(level))

  # get child taxa at most detailed `level`
  lh <- level_hierarchy(family = FALSE)
  lowest_level <- max(match(level, lh))
  x <- unique(c(taxon, do.call('c',
                  getChildTaxa(taxon,  level = as.character(lh[lowest_level]))
                )))
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
    print(n, special.chars = special.chars, file = file)
  }

  invisible(n)
}

#' @export
print.SoilTaxonNode <- function(x,
                                special.chars = "|",
                                file = "",
                                ...) {
  res <- as.data.frame(x, ...)

  # replace unicode markup
  special.chars.default <- c("\u00a6-", "\u00a6", "\u00b0", "-+")
  if (is.null(special.chars) || length(special.chars) == 0) {
    special.chars <- "|"
  }

  special.chars <- rep(special.chars, 4)[1:4]
  for (i in 1:4) {
    res$levelName <- gsub(special.chars.default[i], special.chars[i], res$levelName)
  }

  cat(res$levelName, sep = "\n", file = file)
}
