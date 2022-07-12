# data filters
.data_filter <- function(.data, filtargs = NULL, ..., multiline_sep = "\n", multiline_col = "criteria") {

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
                        tolower(eval(parse(text = x), envir = list(...))))

  # reduce if needed
  if (ncol(filtres) > 1) {
    filtres <- (rowSums(filtres) == ncol(filtres))
  }

  # subset
  .data[which(filtres),]
}
