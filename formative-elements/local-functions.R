# split into tokens by spaces
tokenizeST <- function(i) {
  tok <- stri_split_fixed(i, pattern=' ')
  return(tok)
}

safelyPickNotNA <- function(i) {
  
  if(all(is.na(i))) {
    return(NA)
  } else {
    res <- as.vector(na.omit(i))
    return(res)
  }
}


# determine soil order and index to character position
# relies on ST.formative_elements
parseOrder <- function(x) {
  # load dictionary
  lut <- ST.formative_elements$soilorder
  haystack <- lut$element
  
  # soil order is always encoded at the end
  pattern <- paste0(haystack, '$')
  
  # split into tokens
  tok <- tokenizeST(x)
  
  # the last token contains soil order formative element
  tok.len <- sapply(tok, length)
  
  # extract the last token
  # these will be searched
  needle <- map2_chr(tok, tok.len, pluck)
  
  # find the last occurence of formative elements
  # rows: possible matches in formative elements
  # columns: taxa to search
  m <- lapply(needle, FUN = stri_match_last_regex, pattern=pattern, opts_regex=list(case_insensitive=TRUE))
  
  # index position within LUT
  idx <- lapply(m, match, table=haystack, nomatch=NA)
  
  # remove all non-matching, retain single NA if no matching
  # result is a vector
  idx <- map_int(idx, safelyPickNotNA)
  
  # keep corrosponding definitions
  defs <- lut[idx, ]
  
  # identify character index of formative elements
  # this is based on the entire taxa
  # TODO: is this robust?
  loc <- lapply(x, FUN = stri_locate_last_regex, pattern=pattern, opts_regex=list(case_insensitive=TRUE))
  
  # get the starting character position
  loc.start <- map(loc, function(i) {i[, 1]})
  loc.start <- map_int(loc.start, safelyPickNotNA)
  
  return(list(defs=defs, char.index=loc.start))
}


# note: there is overlap in suborder | greatgroup formative elements
parseSubOrder <- function(x) {
  # load dictionary
  lut <- ST.formative_elements$suborder
  haystack <- lut$element
  
  # suborder is within the greatgroup
  pattern <- haystack
  
  # split into tokens
  tok <- tokenizeST(x)
  
  # the last token contains soil order formative element
  tok.len <- sapply(tok, length)
  
  # extract the last token
  # these will be searched
  needle <- map2_chr(tok, tok.len, pluck)
  
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
  m <- lapply(needle.suborder, FUN = stri_match_last_regex, pattern=pattern, opts_regex=list(case_insensitive=TRUE))
  
  # index position within LUT
  idx <- lapply(m, match, table=haystack, nomatch=NA)
  
  # remove all non-matching, retain single NA if no matching
  # result is a vector
  idx <- map_int(idx, safelyPickNotNA)
  
  # keep corrosponding definitions
  defs <- lut[idx, ]
  
  
  # search for suborder starting character within original search
  # there is only a single formative element for the suborder
  # TODO: is this robust?
  loc <- lapply(x, FUN = stri_locate_last_regex, pattern=unique(ST$tax_suborder), opts_regex=list(case_insensitive=TRUE))
  
  # get the starting character position
  loc.start <- map(loc, function(i) {i[, 1]})
  loc.start <- map_int(loc.start, safelyPickNotNA)
  
  # propagate NA based on invalid taxa
  if(length(invalid.idx) > 0) {
    loc.start[invalid.idx] <- NA
  }
  
  return(list(defs=defs, char.index=loc.start))
}


parseGreatGroup <- function(x) {
  # load dictionary
  lut <- ST.formative_elements$greatgroup
  haystack <- lut$element
  
  # suborder is within the greatgroup
  pattern <- haystack
  
  # split into tokens
  tok <- tokenizeST(x)
  
  # the last token contains soil order formative element
  tok.len <- sapply(tok, length)
  
  # extract the last token
  # these will be searched
  needle <- map2_chr(tok, tok.len, pluck)
  
  # remove any that aren't valid great groups
  needle.check <- isValidST(needle, level='tax_greatgroup')
  invalid.idx <- which(!needle.check)
  if(length(invalid.idx) > 0) {
    needle[invalid.idx] <- NA
  }
  
  # lookup suborder
  needle.suborder <- sapply(needle, matchParentTaxa, unique(ST$tax_suborder), USE.NAMES=FALSE)
  
  # remove suborder
  needle.ggpart <- stri_replace_last_fixed(needle, replacement = '', pattern=needle.suborder)
  
  ## TODO: is this correct?
  # the great group "part" can be directly found in the haystack
  idx <- match(needle.ggpart, pattern)
  
  # keep corrosponding definitions
  defs <- lut[idx, ]
  
  # search for greatgroup starting character within original search
  # there is only a single formative element for the greatgroup
  # TODO: is this robust?
  loc <- lapply(x, FUN = stri_locate_last_regex, pattern=unique(ST$tax_greatgroup), opts_regex=list(case_insensitive=TRUE))
  
  # get the starting character position
  loc.start <- map(loc, function(i) {i[, 1]})
  loc.start <- map_int(loc.start, safelyPickNotNA)
  
  # propagate NA based on invalid taxa
  if(length(invalid.idx) > 0) {
    loc.start[invalid.idx] <- NA
  }
  
  return(list(defs=defs, char.index=loc.start))
}


parseSubGroup <- function(x) {
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
  needle.sgpart <- stri_replace_last_fixed(needle, replacement = '', pattern=needle.greatgroup)
  
  # trim trailing whitespace
  needle.sgpart <- stri_trim_right(needle.sgpart)
  
  # split into tokens
  # there may be multiple subgroup formative elements
  tok <- tokenizeST(needle.sgpart)
  
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
    loc[[i]] <- stri_locate_last_regex(x[i], tok[[i]], opts_regex=list(case_insensitive=TRUE))
  }
  
  # get the starting character position
  # keep as a list
  loc.start <- map(loc, function(i) {i[, 1]})
  
  return(list(defs=defs, char.index=loc.start))
}



isValidST <- function(needle, level) {
  haystack <- unique(ST[[level]])
  res <- match(needle, haystack)
  res <- ! sapply(res, is.na)
  return(res)
}



# extract parent taxa from lower levels:
# sub group -> great group
# great group -> sub order
# TODO: not reliable for sub order -> order, use manual matching
# TODO: not robust to errors
matchParentTaxa <- function(needle, haystack, qgram.size=4) {
  # work with the unique set of things to find
  haystack <- unique(haystack)
  
  # when matching lower levels of ST, it is helpful to only use the last sub-string
  # after splitting on white-space
  needle.split <- strsplit(needle, ' ')[[1]]
  needle <- needle.split[length(needle.split)]
  
  # compute distance between current great group and all possible sub orders
  d <- stringdist(needle, haystack, method='qgram', q=qgram.size)
  
  # there may be ties in the distance vector, check
  tab <- table(d)
  min.d <- min(d)
  min.idx <- match(min.d, names(tab))
  matching <- haystack[which(d == min.d)]
  
  # pick the first match
  res <- matching[1]
  
  # generate a warning with ties flagged
  ## TODO attempt alternate matching strategy here
  if(length(matching) > 1) {
    message(paste0('ties in distance vector: ', needle, ' [', paste0(matching, collapse=','), ']'))
    # ties <- TRUE
  }
  ## TODO flag ties
  #   else
  #     ties <- FALSE
  
  return(res)
}


printExplanation <- function(width=100, pos, txt) {
  # split explanation into a vector
  txt <- strsplit(txt, split = '')[[1]]
  # placement of explanation
  idx <- seq(from=pos, to=pos + (length(txt) - 1))
  # init whitespace, making room for very long explanation
  ws <- rep(' ', times=pmax(width, max(idx)))
  # insert text
  ws[idx] <- txt
  
  # convert to character
  return(paste(ws, collapse=''))
}

makeBars <- function(width=100, pos) {
  # init whitespace
  ws <- rep(' ', times=width)
  # insert bars
  ws[pos] <- '|'
  
  # convert to character
  return(paste(ws, collapse=''))
}



.soilOrderLines <- function(o) {
  txt <- list()
  
  txt[[1]] <- makeBars(pos=o$char.index)
  txt[[2]] <- printExplanation(pos = o$char.index, txt = o$defs$connotation)
  
  return(txt)
}

.subOrderLines <- function(o, so) {
  txt <- list()
  
  txt[[1]] <- makeBars(pos=c(so$char.index, o$char.index))
  txt[[2]] <- printExplanation(pos = so$char.index, txt = so$defs$connotation)
  
  return(txt)
}

.greatGroupLines <- function(o, so, gg) {
  txt <- list()
  
  txt[[1]] <- makeBars(pos=c(gg$char.index, so$char.index, o$char.index))
  txt[[2]] <- printExplanation(pos = gg$char.index, txt = gg$defs$connotation)
  
  return(txt)
}

# 
# sg: list of lists
.subGroupLines <- function(o, so, gg, sg) {
  txt <- list()
  
  # extract parts
  sg.pos <- unlist(sg$char.index, unlist)
  sg.defs <- sg$defs[[1]]$connotation
  
  # counters
  i <- 1
  j <- 1
  # local copy of positions
  sg.pos.temp <- sg.pos
  
  # iterate over parts
  while(i < length(sg.pos)+1) {
    
    # add all bars
    txt[[j]] <- makeBars(pos=c(sg.pos.temp, gg$char.index, so$char.index, o$char.index))
    txt[[j+1]] <- printExplanation(pos = sg.pos.temp[1], txt = sg.defs[1])
    
    # nibble vectors
    sg.pos.temp <- sg.pos.temp[-1]
    sg.defs <- sg.defs[-1]
    
    # increment vars
    j <- j+2
    i <- i+1
  }
  
  return(txt)
}





prettyPrintST <- function(x) {
  
  x.o <- parseOrder(x)
  x.so <- parseSubOrder(x)
  x.gg <- parseGreatGroup(x)
  x.sg <- parseSubGroup(x)
  
  ex <- list()
  # the taxon to explain, usually a subgroup
  ex[[1]] <- x
  
  ex[[2]] <- .subGroupLines(x.o, x.so, x.gg, x.sg)
  
  ex[[3]] <- .greatGroupLines(x.o, x.so, x.gg)
  
  ex[[4]] <- .subOrderLines(x.o, x.so)
  
  ex[[5]] <- .soilOrderLines(x.o)
  
  res <- unlist(ex, recursive = TRUE)
  
  return(res)
}



