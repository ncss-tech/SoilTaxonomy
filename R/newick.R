#' Generate Newick/New Hampshire Format Parenthetic Strings
#'
#' This function generates Newick or New Hampshire format strings for a single tree. Taxa are assigned relative positions within their parent to indicate the order that they "key out."
#'
#' @details The output from this function is a character string with parenthetical format encoding a single tree suitable for input into functions such as `ape::read.tree()`. Multiple trees can be combined together in the file or text string supplied to your tree-parsing function of choice.
#' @param x Optional: a taxon name to get children of.
#' @param level Level to build the tree at. One of `"suborder"`, `"greatgroup"`, `"subgroup"`. Defaults to `"suborder"` when `x` is not specified. When `x` is specified but `level` is not specified, `level` is calculated from `taxon_to_level(x)`.
#'
#' @return character. A single tree in parenthetical Newick or New Hampshire format.
#' @export
#' @examples
#' if (requireNamespace("ape")) {
#'   par(mar = c(0, 0, 0, 0))
#'
#'   mytr <- ape::read.tree(text = newick_string(level = "suborder"))
#'   plot(mytr, "c", rotate.tree=180)
#'
#'   mytr <- ape::read.tree(text = newick_string("durixeralfs", level = "subgroup"))
#'   plot(mytr, "c", rotate.tree=180)
#'
#'   dev.off()
#' }
newick_string <- function(x = NULL, level = "suborder") {
  if (is.null(x)) {
    ord <- level_to_taxon(level = "order")
  } else {
    ord <- getTaxonAtLevel(x, level = "order")
    if (missing(level)) {
      level <- taxon_to_level(x)
    }
  }
  rt1 <- ifelse(is.null(x), "(", "")
  rt2 <- ifelse(is.null(x), ")", "")
  paste0(rt1, paste0(sapply(1:length(ord), function(i) {
    if (is.null(x)) {
      y <- ord[i]
      ct <- getChildTaxa(y)[[1]]
    } else {
      y <- x
      ct <- getChildTaxa(x)[[1]]
    }
    z <- data.frame(
        parent = as.character(y),
        code = names(ct),
        taxon = { if (level == "subgroup") sQuote(ct, q = FALSE) else ct },
        level = code_to_level(names(ct)),
        position = relative_taxon_code_position(names(ct))
      )
    z <- z[which(z$level == level), ]
    z$position <- as.numeric(factor(z$position))
    paste0("(", paste(sprintf("%s:%s", z$taxon, z$position), collapse = ","), "):", i)
  }), collapse = ","), rt2, ";")
}
