#' Identify formative elements in Soil Taxonomic Order, Suborder, Great Group or Subgroup Level
#'
#' @param x A character vector containing subgroup-level taxonomic names
#' @param level one of `c("order","suborder","greatgroup","subgroup")`
#'
#' @return A list containing `$defs`: a `data.frame` containing taxonomic elements, derivations, connotations and links. And `$char.index`: a numeric denoting the position where the formative element occurs in the search text `x`
#' @export
#' @author D.E. Beaudette, A.G. Brown
#' @rdname FormativeElements
#' @examples
#' 
#' FormativeElements("acrudoxic plinthic kandiudults", level = "subgroup")
#' SubGroupFormativeElements("acrudoxic plinthic kandiudults")
#' 
#' FormativeElements("acrudoxic plinthic kandiudults", level = "greatgroup")
#' GreatGroupFormativeElements("acrudoxic plinthic kandiudults")
#' 
#' FormativeElements("acrudoxic plinthic kandiudults", level = "suborder")
#' SubOrderFormativeElements("acrudoxic plinthic kandiudults")
#' 
#' FormativeElements("acrudoxic plinthic kandiudults", level = "order")
#' OrderFormativeElements("acrudoxic plinthic kandiudults")
#' 
#' @importFrom stringr str_locate_all
FormativeElements <- function(x, level = c("order","suborder","greatgroup","subgroup")) {
  
  level = match.arg(level, choices = c("order","suborder","greatgroup","subgroup"))
  
  # for R CMD check
  ST_formative_elements <- NULL
  
  # load local copy of formative elements
  load(system.file("data/ST_formative_elements.rda", package="SoilTaxonomy")[1])
  
  # load dictionary
  lut <- ST_formative_elements[[level]]
  haystack <- lut$element
  pattern <- haystack
  
  if (level == "order") {
    # soil order is always encoded at the end
    pattern <- paste0(haystack, '$')
    tok <- strsplit(x, " ", fixed=TRUE)  
  } else if (level == "greatgroup") {
    # soil order is always encoded at the end
    pattern <- paste0("\\b",haystack)
    tok <- strsplit(x, " ", fixed=TRUE)
  } else {
     # split into tokens
    tok <- strsplit(getTaxonAtLevel(x, level = level), " ", fixed=TRUE)
  }
  
  tok.len <- sapply(tok, length)
  tok.long <- sapply(tok.len, function(x) x > 2)
  tok[tok.long] <- lapply(tok[tok.long], function(x) {
      c(paste0(x[1:(length(x) - 1)], collapse = " "), x[length(x)])
    })
  tok.len <- sapply(tok, length)
  
  if(level == "subgroup") {
    # subgroup level: combine all tokens before the last token
    needle <- sapply(seq_along(tok), function(y) tok[y][[1]][1])
  } else {
    # all other levels: extract the last token
    needle <- sapply(seq_along(tok), function(y) tok[y][[1]][tok.len[y]])  
  }
  
  # find the last occurrence of formative elements
  m <- sapply(seq_along(pattern), FUN = function(i) haystack[i][grep(pattern[i], needle, ignore.case = TRUE)[1]])
  m <- m[which(!is.na(m))]
  mord <- m[order(nchar(m))]
  test <- sapply(mord, function(mm) length(grep(mm, m, ignore.case = TRUE)))
  if(any(test > 1)) {
    m <- m[m %in% mord[test == 1]]
  }
  
  # index position within LUT
  idx <- sapply(m, function(y) { 
    if(length(y) == 0) 
      return(NA)
    grep(y, x = haystack)[1]
  })
  
  
  # keep corresponding definitions
  defs <- do.call('rbind', lapply(sprintf("^%s$", names(idx)), function(z) subset(lut, grepl(z, lut$element))))
  rownames(defs) <- NULL
  
  loc.start <- do.call('rbind', sapply(m, function(mm) stringr::str_locate_all(x, mm)))
  
  if(level != "subgroup") {
    cidx <- suppressWarnings(max(loc.start[, 1], na.rm = TRUE))
    
  } else {
    cidx <- loc.start[, 1]
  }
  
  # attempt sorting multiple matches
  cidx.order <- order(cidx)
  defs <- defs[cidx.order, ]
  cidx <- cidx[cidx.order]
  
  if(any(is.nan(cidx))) {
    cidx[is.nan(cidx)] <- NA
  }
  
  return(list(defs = defs, char.index = cidx))
}

#' @export
#' @rdname FormativeElements
OrderFormativeElements <- function(x) {
  FormativeElements(x, level = "order")
}

#' @export
#' @rdname FormativeElements
SubOrderFormativeElements <- function(x) {
  FormativeElements(x, level = "suborder")
}

#' @export
#' @rdname FormativeElements
GreatGroupFormativeElements <- function(x) {
  FormativeElements(x, level = "greatgroup")
}

#' @export
#' @rdname FormativeElements
SubGroupFormativeElements <- function(x) {
  FormativeElements(x, level = "subgroup")
}
