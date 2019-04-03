
#' Explain a subgroup level taxa from Soil Taxaonomy
#'
#' @param x a single subgroup, matching is exact and case insensitive
#' 
#' @return a block of text, suitable for display in fixed-width font
#' 
#' @note This function currently accepts only subgroup taxa. There are plans to extend to arbitrary levels of the heirarchy.
#' 
#' @export
explainST <- function(x) {
  
  # matching is done in lower case
  x <- tolower(x)
  
  x.o <- OrderFormativeElements(x)
  x.so <- SubOrderFormativeElements(x)
  x.gg <- GreatGroupFormativeElements(x)
  x.sg <- SubGroupFormativeElements(x)
  
  ex <- list()
  # the taxon to explain, usually a subgroup
  ex[[1]] <- x
  
  ex[[2]] <- .subGroupLines(x.o, x.so, x.gg, x.sg)
  
  ex[[3]] <- .greatGroupLines(x.o, x.so, x.gg)
  
  ex[[4]] <- .subOrderLines(x.o, x.so)
  
  ex[[5]] <- .soilOrderLines(x.o)
  
  res <- paste(unlist(ex, recursive = TRUE), collapse='\n')
  
  return(res)
}

## internally used functions

.printExplanation <- function(width=100, pos, txt) {
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

.makeBars <- function(width=100, pos) {
  # init whitespace
  ws <- rep(' ', times=width)
  # insert bars
  ws[pos] <- '|'
  
  # convert to character
  return(paste(ws, collapse=''))
}



.soilOrderLines <- function(o) {
  txt <- list()
  
  txt[[1]] <- .makeBars(pos=o$char.index)
  txt[[2]] <- .printExplanation(pos = o$char.index, txt = o$defs$connotation)
  
  return(txt)
}

.subOrderLines <- function(o, so) {
  txt <- list()
  
  txt[[1]] <- .makeBars(pos=c(so$char.index, o$char.index))
  txt[[2]] <- .printExplanation(pos = so$char.index, txt = so$defs$connotation)
  
  return(txt)
}

.greatGroupLines <- function(o, so, gg) {
  txt <- list()
  
  txt[[1]] <- .makeBars(pos=c(gg$char.index, so$char.index, o$char.index))
  txt[[2]] <- .printExplanation(pos = gg$char.index, txt = gg$defs$connotation)
  
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
    txt[[j]] <- .makeBars(pos=c(sg.pos.temp, gg$char.index, so$char.index, o$char.index))
    txt[[j+1]] <- .printExplanation(pos = sg.pos.temp[1], txt = sg.defs[1])
    
    # nibble vectors
    sg.pos.temp <- sg.pos.temp[-1]
    sg.defs <- sg.defs[-1]
    
    # increment vars
    j <- j+2
    i <- i+1
  }
  
  return(txt)
}
