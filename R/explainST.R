
#' Explain a subgroup level taxa from Soil Taxonomy
#'
#' @param x a single subgroup, matching is exact and case insensitive
#' @param format output format: 'text' | 'html'
#' @param viewer show `format = 'html'` output in browser? default: `TRUE`
#' @return a block of text, suitable for display in fixed-width font
#' 
#' @note This function currently accepts only subgroup taxa. There are plans to extend to arbitrary levels of the hierarchy.
#' 
#' @export
#' @importFrom utils browseURL
explainST <- function(x, format = c('text', 'html'), viewer = TRUE) {
  
  # safely match argument choices
  format <- match.arg(format)
  
  # matching is done in lower case
  x <- tolower(x)
  
  x.o <- OrderFormativeElements(x)
  x.so <- SubOrderFormativeElements(x)
  x.gg <- GreatGroupFormativeElements(x)
  x.sg <- SubGroupFormativeElements(x)
  
  newline <- switch(format, text='\n', html='<br>')
  whitespace <- switch(format, text=' ', html='&nbsp;')
  
  main.style <- 'font-size: 85%; font-weight: bold;'
  sub.style <- 'font-size: 85%; font-style: italic;'
  
  # create / mark-up lines
  if(format == 'html') {
    #
    x.txt <- paste0('<html><div style="padding: 5px; font-family: monospace; border: 1px solid grey; border-radius: 5px;">',
                   '<span style="', main.style, '">',
                   x,
                   '</span>'
                   )
    
    sg.txt <- paste0('<span style="', sub.style, '">', .subGroupLines(x.o, x.so, x.gg, x.sg, ws=whitespace), '</span>')
    gg.txt <-  paste0('<span style="', sub.style, '">', .greatGroupLines(x.o, x.so, x.gg, ws=whitespace), '</span>')
    so.txt <- paste0('<span style="', sub.style, '">', .subOrderLines(x.o, x.so, ws=whitespace), '</span>')
    o.txt <- paste0('<span style="', sub.style, '">', .soilOrderLines(x.o, ws=whitespace), '</span>')
    
  } else {
    x.txt <- x
    sg.txt <- .subGroupLines(x.o, x.so, x.gg, x.sg, ws = whitespace)
    gg.txt <- .greatGroupLines(x.o, x.so, x.gg, ws = whitespace)
    so.txt <- .subOrderLines(x.o, x.so, ws = whitespace)
    o.txt <- .soilOrderLines(x.o, ws = whitespace)
  }
  
  
  # container for lines of text
  ex <- list()
  
  # the taxon to explain, usually a subgroup
  ex <- append(ex, x.txt) 
  
  ex <- append(ex, sg.txt)
  
  ex <- append(ex, gg.txt)
  
  ex <- append(ex, so.txt)
  
  ex <- append(ex, o.txt)
  
  if(format == 'html') {
    ex <- append(ex, '</div></html>')
  }
  
  
  # flatten to char vector
  ex.char <- unlist(ex, recursive = TRUE)
  # collapse to single character
  res <- paste(ex.char, collapse=newline)
  
  # put HTML output into viewer
  if(format == 'html' && viewer) {
    viewer <- getOption("viewer", default = utils::browseURL)
    tf <- tempfile(fileext=".html")
    cat(res, file=tf)
    viewer(tf)
  }
  
  ## TODO: do we need to periodically remove temp files
  
  # return but silently, the results fill the console window if not careful
  invisible(res)
}


## internally used functions

## TODO: wrap-text with newline if > width

.printExplanation <- function(pos, txt, width=100, ws.char=' ') {
  if(nchar(txt) > 0 && is.finite(pos)) {
    # split explanation into a vector
    txt <- strsplit(txt, split = '')[[1]]
    # placement of explanation
    idx <- seq(from=pos, to=pos + (length(txt) - 1))
    # init whitespace, making room for very long explanation
    ws <- rep(ws.char, times=pmax(width, max(idx)))
    # insert text
    ws[idx] <- txt
  } else {
    return("")
  }
  # convert to character
  return(paste(ws, collapse=''))
}

.makeBars <- function(width=100, pos, ws.char=' ') {
  # init whitespace
  ws <- rep(ws.char, times=width)
  # insert bars
  ws[pos] <- '|'
  
  # convert to character
  return(paste(ws, collapse=''))
}



.soilOrderLines <- function(o, ws) {
  txt <- list()
  
  txt[[1]] <- .makeBars(pos=o$char.index, ws.char=ws)
  txt[[2]] <- .printExplanation(pos = o$char.index, txt = o$defs$connotation, ws.char=ws)
  
  return(txt)
}

.subOrderLines <- function(o, so, ws) {
  txt <- list()
  
  txt[[1]] <- .makeBars(pos=c(so$char.index, o$char.index), ws.char=ws)
  txt[[2]] <- .printExplanation(pos = so$char.index, txt = so$defs$connotation, ws.char=ws)
  
  return(txt)
}

.greatGroupLines <- function(o, so, gg, ws) {
  txt <- list()
  
  # short-circuit: no greatgroup formative element positions found
  if(is.na(gg$char.index)) {
    # start at the first character
    gg$char.index <- 1
  }
  
  # short-circuit: no subgroup formative elements found
  nacon <-is.na(gg$defs$connotation)
  if(any(nacon)) {
    # let user know we have no idea
    gg$defs$connotation[nacon] <- '?'
  }
  
  txt[[1]] <- .makeBars(pos=c(gg$char.index, so$char.index, o$char.index), ws.char=ws)
  txt[[2]] <- .printExplanation(pos = gg$char.index, txt = gg$defs$connotation, ws.char=ws)
  
  return(txt)
}

# 
# sg: list of lists
.subGroupLines <- function(o, so, gg, sg, ws) {
  txt <- list()
  
  # extract parts
  sg.pos <- unlist(sg$char.index)
  sg.defs <- sg$defs$connotation
  
  # short-circuit: no subgroup formative element positions found
  if(all(is.na(sg.pos))) {
    # start at the first character
    sg.pos <- 1
  }
  
  ## TODO: all levels should make the distinction: no entry vs. incomplete entries
  # element-wise flag for no-matching definition (element present in dictionary, but no definition)
  sg.defs <- ifelse(sg.defs == '', '?', sg.defs)
  
  # short-circuit: no subgroup formative elements found
  if(all(is.na(sg.defs)) | (length(sg.defs) == 1 & nchar(sg.defs[[1]]) == 0)) {
    # let user know we have no idea
    sg.defs <- '?'
  }
  
  # counters
  i <- 1
  j <- 1
  # local copy of positions
  sg.pos.temp <- sg.pos
  
  # iterate over parts
  while(i < length(sg.pos)+1) {
    
    # add all bars
    txt[[j]] <- .makeBars(pos=c(sg.pos.temp, gg$char.index, so$char.index, o$char.index), ws.char=ws)
    txt[[j+1]] <- .printExplanation(pos = sg.pos.temp[1], txt = sg.defs[1], ws.char=ws)
    
    # nibble vectors
    sg.pos.temp <- sg.pos.temp[-1]
    sg.defs <- sg.defs[-1]
    
    # increment vars
    j <- j+2
    i <- i+1
  }
  
  return(txt)
}
