#' Explain a taxon from Soil Taxonomy using formative elements
#'
#' @param x a Subgroup, Great Group, Suborder or Order-level taxonomic name; matching is exact and case-insensitive
#' @param format output format: 'text' | 'html'
#' @param viewer show `format = 'html'` output in browser? default: `TRUE`
#' @return a block of text, suitable for display in fixed-width font
#' 
#' @export
#' @importFrom utils browseURL
#' @examples 
#' 
#' cat(explainST("ids"), "\n\n")              #  -ids (order suffix) 
#' cat(explainST("aridisols"), "\n\n")        # Aridisols (order name)
#' cat(explainST("argids"), "\n\n")           # Arg- (suborder) 
#' cat(explainST("haplargids"), "\n\n")       # Hap- (great group)
#' cat(explainST("typic haplargids"), "\n\n") # Typic (subgroup)
#' 
explainST <- function(x, format = c('text', 'html'), viewer = TRUE) {
  
  # safely match argument choices
  format <- match.arg(format, choices = c('text', 'html'))
  
  # matching is done in lower case
  x <- tolower(x)
  
  # get taxonomic level of x
  x.lvl <- taxon_to_level(x)
  
  # no-match NULL data object
  empty <- list(defs = data.frame(element = "", derivation = "", 
                                  connotation = "", simplified = NA, link = NA), 
                char.index = 0)
  
  if (!is.na(x.lvl) && x.lvl == "order") {
    # handle input of full order name e.g. "aridisols"
    ST_formative_elements <- NULL
    load(system.file("data/ST_formative_elements.rda", package="SoilTaxonomy")[1])
    
    y <- ST_formative_elements[["order"]]
    idx <- which(x == y$order)
    x.o <- OrderFormativeElements(y$element[idx])
    
    # order LUT now contains the positions of each element within full taxon (order) name
    x.o$char.index <- y$element_start[idx]
    x.so <- empty
    
  } else {
    # normal handling of orders as suffixes e.g. "-ids"
    x.o <- OrderFormativeElements(x)
    x.so <- SubOrderFormativeElements(x)
  }
  
  # only match great group and subgroup if needed
  # for example: prevent matching "argi-" at GG level and "arg-" at SO level in "argids" 
  if (!x.lvl %in% c("order","suborder")) {
    x.gg <- GreatGroupFormativeElements(x)
  }  else {
    x.gg <- empty
  }
  
  if (!x.lvl %in% c("order","suborder","greatgroup")) {
    x.sg <- SubGroupFormativeElements(x)
  } else {
    x.sg <- empty
  }
   
  # TODO: family classes
  
  newline <- switch(format, text='\n', html='<br>')
  whitespace <- switch(format, text=' ', html='&nbsp;')
  
  main.style <- 'font-size: 85%; font-weight: bold;'
  sub.style <- 'font-size: 85%; font-style: italic;'
  
  sg.l <- .subGroupLines(x.o, x.so, x.gg, x.sg, ws = whitespace)
  gg.l <- .greatGroupLines(x.o, x.so, x.gg, ws = whitespace)
  so.l <- .subOrderLines(x.o, x.so, ws = whitespace)
  o.l <- .soilOrderLines(x.o, ws = whitespace)
  
  # create / mark-up lines
  if(format == 'html') {
    #
    x.txt <- paste0('<html><div style="padding: 5px; font-family: monospace; border: 1px solid grey; border-radius: 5px;">',
                   '<span style="', main.style, '">',
                   x,
                   '</span>'
                   )
    
    sg.txt <- paste0('<span style="', sub.style, '">', sg.l, '</span>')
    gg.txt <-  paste0('<span style="', sub.style, '">', gg.l, '</span>')
    so.txt <- paste0('<span style="', sub.style, '">', so.l, '</span>')
    o.txt <- paste0('<span style="', sub.style, '">', o.l, '</span>')
    
  } else {
    x.txt <- x
    sg.txt <- sg.l
    gg.txt <- gg.l
    so.txt <- so.l
    o.txt <- o.l
  }
  
  # container for lines of text
  ex <- list()
  
  # the taxon to explain, usually a subgroup
  ex <- append(ex, x.txt) 
  
  if (grepl("[A-Za-z?]", gsub("&nbsp;"," ",sg.l[[2]])))
    ex <- append(ex, sg.txt)
  
  if (grepl("[A-Za-z?]", gsub("&nbsp;"," ",gg.l[[2]])))
    ex <- append(ex, gg.txt)
  
  if (grepl("[A-Za-z?]", gsub("&nbsp;"," ",so.l[[2]])))
    ex <- append(ex, so.txt)
  
  if (grepl("[A-Za-z?]", gsub("&nbsp;"," ",o.l[[2]])))
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
