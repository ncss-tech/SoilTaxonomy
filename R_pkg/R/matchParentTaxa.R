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
  d <- stringdist::stringdist(needle, haystack, method='qgram', q=qgram.size)
  
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

