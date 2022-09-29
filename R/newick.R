#' Generate Newick Tree Format Parenthetic Strings
#'
#' This function generates [Newick tree format](https://en.wikipedia.org/wiki/Newick_format) strings for a single tree. Taxa are assigned relative positions within their parent to indicate the order that they "key out."
#'
#' @details The output from this function is a character string with parenthetical format encoding a single tree suitable for input into functions such as `ape::read.tree()`. Multiple trees can be combined together in the file or text string supplied to your tree-parsing function of choice.
#' @param x Optional: a taxon name to get children of.
#' @param level Level to build the tree at. One of `"suborder"`, `"greatgroup"`, `"subgroup"`. Defaults to `"suborder"` when `x` is not specified. When `x` is specified but `level` is not specified, `level` is calculated from `taxon_to_level(x)`.
#' @param what Either `"taxon"` (default; for taxon names (quoted for subgroups)) or `"code"`
#' @return character. A single tree in parenthetical Newick or New Hampshire format.
#' @export
#' @examples
#' if (requireNamespace("ape")) {
#'   par(mar = c(0, 0, 0, 0))
#'
#'   # "fan"
#'   mytr <- ape::read.tree(text = newick_string(level = "suborder"))
#'   plot(mytr, "f", rotate.tree = 180, cex = 0.75)
#'
#'   # "cladogram"
#'   mytr <- ape::read.tree(text = newick_string("durixeralfs", level = "subgroup"))
#'   plot(mytr, "c")
#'
#'   # "cladogram" (using taxon codes instead of subgroups)
#'   mytr <- ape::read.tree(text = newick_string("xeralfs", level = "subgroup", what = "code"))
#'   plot(mytr, "c")
#'
#'   dev.off()
#' }
newick_string <- function(x = NULL,
                          level = c("suborder", "greatgroup", "subgroup"),
                          what = c("taxon", "code")) {
  level <- match.arg(level, c("suborder", "greatgroup", "subgroup"))
  what <- match.arg(what, c("taxon", "code"))
  if (is.null(x)) {
    ord <- level_to_taxon(level = "order")
  } else {
    lv <- taxon_to_level(x)
    if (lv == "order") {
      ord <- getTaxonAtLevel(x, level = lv)
    } else {
      ord <- getTaxonAtLevel(x, level = parent_level(lv))
    }
    if (missing(level)) {
      level <- lv
    }
  }
  rt1 <- "(" # ifelse(is.null(x), "(", "")
  rt2 <- ")" # ifelse(is.null(x), ")", "")
  paste0(rt1, paste0(sapply(1:length(ord), function(i) {
    if (is.null(x)) {
      y <- ord[i]
      ct <- getChildTaxa(y)[[1]]
    } else {
      y <- x
      ct <- getChildTaxa(x)[[1]]
    }
    if (level == "subgroup" && what == "taxon") {
      tx <- paste0("'", ct, "'")
    } else tx <- ct
    z <- data.frame(
        parent = as.character(y),
        code = names(ct),
        taxon = tx,
        level = code_to_level(names(ct)),
        position = relative_taxon_code_position(names(ct))
      )
    z <- z[order(z$code), ]
    l <- split(z, cumsum(z$level == parent_level(level)))
    paste0(sapply(seq_along(l), function(j) {
      zsub <- l[[j]]
      zsub <- zsub[which(zsub$level == level), ]
      id <- ifelse(length(l) == 1, i, j)
      zsub$position <- as.numeric(factor(zsub$position))
      if (what == "code") {
        zsub$taxon <- taxon_to_taxon_code(zsub$taxon)
      }
      paste0("(", paste(sprintf("%s:%s", zsub$taxon, zsub$position), collapse = ","), "):", id)
    }), collapse = ",")
  }), collapse = ","), rt2, ";")
}
