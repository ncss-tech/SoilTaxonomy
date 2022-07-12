# data filters

#' `.data_filter()`
#'
#' Helper function for subset of _data.frame_ objects using arguments that match column names and values
#'
#' @param .data _data.frame_
#' @param filtargs logical. named vector of argument names to use
#' @param ... filter arguments; e.g. `name = c('foo', 'bar')` to return rows where name is `'foo'` or `'bar'`
#' @param multiline_sep multiline column separator
#' @param multiline_col multiline column name
#'
#' @details An attempt is made to match the first filter argument against the subset to order the rows in the result.
#'
#' If any matches fail (return `NA`) the default order (in order of increasing `DomainID`) is returned.
#'
#' @return _data.frame_ subset of `.data`
#' @noRd
#' @keywords internal
.data_filter <- function(.data, filtargs = NULL, ..., multiline_sep = "\n", multiline_col = "criteria") {

  args <- list(...)

  # default args assume most users don't want a list column in their data.frame
  if (!is.null(multiline_sep) && length(multiline_col) > 0 && any(multiline_col %in% colnames(.data))) {
    .data[multiline_col] <- lapply(multiline_col, function(n) sapply(.data[[n]], function(x) paste0(x, collapse = multiline_sep)))
  }

  if (all(!filtargs)) {
    return(.data)
  }

  # list of logical vector matching argument criteria
  filtres <- sapply(paste0(names(filtargs)[filtargs]),
                    function(x)
                      tolower(eval(parse(text = x), envir = .data)) %in%
                        tolower(eval(parse(text = x), envir = args)))

  # reduce if needed
  if (ncol(filtres) > 1) {
    filtres <- (rowSums(filtres) == ncol(filtres))
  }

  # order based on the first filter criterion
  idx <- which(filtres)
  fn <- names(filtargs[filtargs])[1]
  ord <- order(match(.data[idx,][[fn]], args[[fn]]))
  if (any(is.na(ord))) {
    ord <- seq_along(idx)
  }
  .data[idx[ord],]
}
