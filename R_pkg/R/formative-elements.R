# split into tokens by spaces
#' @importFrom stringi stri_split_fixed
.tokenizeST <- function(i) {
  tok <- stringi::stri_split_fixed(i, pattern=' ')
  return(tok)
}

# safely extract elements from a list, filling with NA when list element is empty
.safelyPickNotNA <- function(i) {
  
  if(all(is.na(i))) {
    return(NA)
  } else {
    res <- as.vector(na.omit(i))
    return(res)
  }
}

#' Check for valid order | suborder | greatgroup | subgroup.
#' 
#' This function can be used to quickly test for valid levels within the 
#' Soil Taxonomy hierarchy, a defined within the 13th edition of The Keys to Soil Taxonomy.
#' Matches are case insensitive.
#' 
#' @param needle vector of taxa
#' @param level single level of Soil Taxonomy hierarchy: order, suborder, greatgroup, subgroup
#' 
#' @return logical vector, same lenght as needle
isValidST <- function(needle, level) {
  # TODO this is currently an object in the parent environment
  #      should be stored in the package somewhere
  haystack <- unique(ST[[level]])
  # matching is done in lower case
  needle <- tolower(needle)
  res <- match(needle, haystack)
  res <- ! sapply(res, is.na)
  return(res)
}

# determine soil order and index to character position
# relies on ST.formative_elements
#' @importFrom purrr map2_chr map_int map
#' @importFrom stringi stri_match_last_regex stri_locate_last_regex
OrderFormativeElements <- function(x) {
  # load dictionary
  lut <- ST.formative_elements$soilorder
  haystack <- lut$element
  
  # soil order is always encoded at the end
  pattern <- paste0(haystack, '$')
  
  # split into tokens
  tok <- .tokenizeST(x)
  
  # the last token contains soil order formative element
  tok.len <- sapply(tok, length)
  
  # extract the last token
  # these will be searched
  needle <- purrr::map2_chr(tok, tok.len, pluck)
  
  # find the last occurence of formative elements
  # rows: possible matches in formative elements
  # columns: taxa to search
  m <- lapply(needle, FUN = stringi::stri_match_last_regex, pattern=pattern, opts_regex=list(case_insensitive=TRUE))
  
  # index position within LUT
  idx <- lapply(m, match, table=haystack, nomatch=NA)
  
  # remove all non-matching, retain single NA if no matching
  # result is a vector
  idx <- purrr::map_int(idx, .safelyPickNotNA)
  
  # keep corrosponding definitions
  defs <- lut[idx, ]
  
  # identify character index of formative elements
  # this is based on the entire taxa
  # TODO: is this robust?
  loc <- lapply(x, FUN = stringi::stri_locate_last_regex, pattern=pattern, opts_regex=list(case_insensitive=TRUE))
  
  # get the starting character position
  loc.start <- purrr::map(loc, function(i) {i[, 1]})
  loc.start <- purrr::map_int(loc.start, .safelyPickNotNA)
  
  return(list(defs=defs, char.index=loc.start))
}


# note: there is overlap in suborder | greatgroup formative elements
#' @importFrom purrr map2_chr map_int map
#' @importFrom stringi stri_match_last_regex stri_locate_last_regex
SubOrderFormativeElements <- function(x) {
  # load dictionary
  lut <- ST.formative_elements$suborder
  haystack <- lut$element
  
  # suborder is within the greatgroup
  pattern <- haystack
  
  # split into tokens
  tok <- .tokenizeST(x)
  
  # the last token contains soil order formative element
  tok.len <- sapply(tok, length)
  
  # extract the last token
  # these will be searched
  needle <- purrr::map2_chr(tok, tok.len, pluck)
  
  # remove any that aren't valid great groups
  needle.check <- isValidST(needle, level='tax_greatgroup')
  invalid.idx <- which(!needle.check)
  if(length(invalid.idx) > 0) {
    needle[invalid.idx] <- NA
  }
  
  # convert greatgroup to suborder
  needle.suborder <- sapply(needle, matchParentTaxa, unique(ST$tax_suborder), USE.NAMES=FALSE)
  
  # find the last occurence of formative elements
  # rows: possible matches in formative elements
  # columns: taxa to search
  m <- lapply(needle.suborder, FUN = stringi::stri_match_last_regex, pattern=pattern, opts_regex=list(case_insensitive=TRUE))
  
  # index position within LUT
  idx <- lapply(m, match, table=haystack, nomatch=NA)
  
  # remove all non-matching, retain single NA if no matching
  # result is a vector
  idx <- purrr::map_int(idx, .safelyPickNotNA)
  
  # keep corrosponding definitions
  defs <- lut[idx, ]
  
  
  # search for suborder starting character within original search
  # there is only a single formative element for the suborder
  # TODO: is this robust?
  loc <- lapply(x, FUN = stringi::stri_locate_last_regex, pattern=unique(ST$tax_suborder), opts_regex=list(case_insensitive=TRUE))
  
  # get the starting character position
  loc.start <- map(loc, function(i) {i[, 1]})
  loc.start <- map_int(loc.start, .safelyPickNotNA)
  
  # propagate NA based on invalid taxa
  if(length(invalid.idx) > 0) {
    loc.start[invalid.idx] <- NA
  }
  
  return(list(defs=defs, char.index=loc.start))
}


#' @importFrom purrr map2_chr map_int map
#' @importFrom stringi stri_replace_last_fixed stri_locate_last_regex
GreatGroupFormativeElements <- function(x) {
  # load dictionary
  lut <- ST.formative_elements$greatgroup
  haystack <- lut$element
  
  # suborder is within the greatgroup
  pattern <- haystack
  
  # split into tokens
  tok <- .tokenizeST(x)
  
  # the last token contains soil order formative element
  tok.len <- sapply(tok, length)
  
  # extract the last token
  # these will be searched
  needle <- purrr::map2_chr(tok, tok.len, pluck)
  
  # remove any that aren't valid great groups
  needle.check <- isValidST(needle, level='tax_greatgroup')
  invalid.idx <- which(!needle.check)
  if(length(invalid.idx) > 0) {
    needle[invalid.idx] <- NA
  }
  
  # lookup suborder
  needle.suborder <- sapply(needle, matchParentTaxa, unique(ST$tax_suborder), USE.NAMES=FALSE)
  
  # remove suborder
  needle.ggpart <- stringi::stri_replace_last_fixed(needle, replacement = '', pattern=needle.suborder)
  
  ## TODO: is this correct?
  # the great group "part" can be directly found in the haystack
  idx <- match(needle.ggpart, pattern)
  
  # keep corrosponding definitions
  defs <- lut[idx, ]
  
  # search for greatgroup starting character within original search
  # there is only a single formative element for the greatgroup
  # TODO: is this robust?
  loc <- lapply(x, FUN = stringi::stri_locate_last_regex, pattern=unique(ST$tax_greatgroup), opts_regex=list(case_insensitive=TRUE))
  
  # get the starting character position
  loc.start <- purrr::map(loc, function(i) {i[, 1]})
  loc.start <- purrr::map_int(loc.start, .safelyPickNotNA)
  
  # propagate NA based on invalid taxa
  if(length(invalid.idx) > 0) {
    loc.start[invalid.idx] <- NA
  }
  
  return(list(defs=defs, char.index=loc.start))
}


#' @importFrom purrr map
#' @importFrom stringi stri_replace_last_fixed stri_trim_right stri_locate_last_regex
SubGroupFormativeElements <- function(x) {
  # load dictionary
  lut <- ST.formative_elements$subgroup
  pattern <- lut$element
  
  # parity with other functions
  needle <- x
  
  # remove any that aren't valid subgroups
  needle.check <- isValidST(needle, level='tax_subgroup')
  invalid.idx <- which(!needle.check)
  if(length(invalid.idx) > 0) {
    needle[invalid.idx] <- NA
  }
  
  # lookup greatgroup
  needle.greatgroup <- sapply(needle, matchParentTaxa, unique(ST$tax_greatgroup), USE.NAMES=FALSE)
  
  # remove greatgoup
  needle.sgpart <- stringi::stri_replace_last_fixed(needle, replacement = '', pattern=needle.greatgroup)
  
  # trim trailing whitespace
  needle.sgpart <- stringi::stri_trim_right(needle.sgpart)
  
  # split into tokens
  # there may be multiple subgroup formative elements
  tok <- .tokenizeST(needle.sgpart)
  
  # match formative elements from subgroup dictionary
  idx <- lapply(tok, match, table=pattern)
  
  # extract corrosponding definitions
  # keep as a list
  defs <- lapply(idx, function(i) {
    lut[i, ]
  })
  
  # search for all formative elements within subgroup parts
  # TODO: is this robust
  # a for-loop is the safest here
  loc <- list()
  for(i in seq_along(x)) {
    loc[[i]] <- stringi::stri_locate_last_regex(x[i], tok[[i]], opts_regex=list(case_insensitive=TRUE))
  }
  
  # get the starting character position
  # keep as a list
  loc.start <- purrr::map(loc, function(i) {i[, 1]})
  
  return(list(defs=defs, char.index=loc.start))
}

















