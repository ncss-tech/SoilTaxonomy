#' Parse components of a "family-level" taxon name
#'
#' @param family character. vector of taxonomic families, e.g. `"fine-loamy, mixed, semiactive, mesic ultic haploxeralfs"`
#' @param column_metadata logical. include parsed NASIS physical column names and values from family taxon components? Default: `TRUE` requires soilDB package.
#' @param flat logical Default: `TRUE` to return concatenated family-level classes for `"taxminalogy"` and `"taxfamother"`? Alternately, if `FALSE`, list columns are returned.
#'
#' @return a `data.frame` containing column names: `"family"` (input), `"subgroup"` (parsed taxonomic subgroup), `"subgroup_code"` (letter code for subgroup), `"class_string"` (comma-separated family classes), `"classes_split"` (split `class_string` vector stored as `list` column).
#'
#' In addition, the following column names are identified and returned based on NASIS (National Soil Information System) metadata (via soilDB package):
#'  - `"taxpartsize"`, `"taxpartsizemod"`, `"taxminalogy"`, `"taxceactcl"`, `"taxreaction"`, `"taxtempcl"`, `"taxfamhahatmatcl"`, `"taxfamother"`, `"taxsubgrp"`, `"taxgreatgroup"`, `"taxsuborder"`, `"taxorder"`
#'
#' @export
#'
#' @examples
#' if (requireNamespace('soilDB')) {
#'   families <- c("fine, kaolinitic, thermic typic kanhapludults",
#'                 "fine-loamy, mixed, semiactive, mesic ultic haploxeralfs",
#'                 "euic, thermic typic haplosaprists",
#'                 "coarse-loamy, mixed, active, mesic aquic dystrudepts")
#'
#'   # inspect parsed list result
#'   str(parse_family(families))
#' }
#' @importFrom stringr str_locate fixed
parse_family <- function(family, column_metadata = TRUE, flat = TRUE) {

  # for R CMD check
  ST_unique_list <- NULL

  # load local copy of taxon code lookup table
  load(system.file("data", "ST_unique_list.rda", package = "SoilTaxonomy")[1])

  lut <- do.call('c', ST_unique_list)

  # lookup table sorted from largest to smallest (most specific to least)
  lut <- lut[order(nchar(lut), decreasing = TRUE)]
  res <- lapply(tolower(family), function(x) stringr::str_locate(string = x, pattern = stringr::fixed(lut)))

  # take the first match (in SORTED lut)
  subgroup.idx <- sapply(res, function(x) which(!is.na(x[,1]))[1])
  subgroup.pos <- sapply(seq_along(subgroup.idx), function(i) res[[i]][subgroup.idx[i], 'start'])

  taxname <- lut[subgroup.idx]
  lowest_level <- taxon_to_level(taxname)
  family_classes <- trimws(substr(family, 0, subgroup.pos - 1))
  taxon_codes <- taxon_to_taxon_code(taxname)
  res <- data.frame(row.names = NULL, stringsAsFactors = FALSE,
    family = ifelse(nchar(family_classes) > 0, family, NA_character_),
    taxclname = family,
    taxonname = taxname,
    subgroup_code = ifelse(lowest_level == "subgroup", taxon_codes, NA_character_),
    code = taxon_codes,
    class_string = family_classes,
    classes_split = I(lapply(strsplit(family_classes, ","), trimws)))

  if (!column_metadata)
    return(res)
  cbind(res, .get_family_differentiae(res, flat = flat))
}

#' @import data.table
#' @importFrom utils type.convert tail
#' @importFrom stats setNames na.omit
.get_family_differentiae <- function(res, flat = TRUE) {

  .DOMAINS <- c(
    `126` = "mineralogy class",
    `127` = "particle-size class",
    `128` = "reaction class",
    `131` = "soil moisture subclass",
    `184` = "other family class",
    `185` = "temperature class",
    `186` = "moisture regime",
    `188` = "temperature regime",
    `520` = "activity class",
    `521` = "particle-size modifier",
    `5247` = "human-altered and human transported class"
  )

  metadata <- NULL
  if (!requireNamespace("soilDB")) {
    message("package `soilDB` is required to lookup NASIS column metadata correponding to taxonomic classes", call. = FALSE)
    return(res[, 0, drop = FALSE])
  } else {
    # soilDB::get_NASIS_metadata() # 2.7.3+
    load(system.file("data", "metadata.rda", package = "soilDB")[1])
  }

  ST_family_classes <- NULL
  load(system.file("data", "ST_family_classes.rda", package = "SoilTaxonomy")[1])

  # lookup classes in KST definitions
  kst_lookup <- lapply(res$classes_split, function(x) {
      x <- tolower(x)
      y <- tolower(ST_family_classes$classname)
      ldx <- grepl(' over ', x, fixed = TRUE) & !(x %in% y)
      if (sum(ldx) > 0) {
        idx <- which(!ldx)
        xold <- as.list(x[idx])
        xnew <- strsplit(x[ldx], ' over ', fixed = TRUE)
        names(xnew) <- as.character(which(ldx))
        names(xold) <- as.character(idx)
        x <- c(xnew, xold)
        x <- do.call('c', x[order(as.integer(names(x)))])
      }
      ST_family_classes[match(x, y), c("classname", "group", "name", "DomainID")]
    })

  # lookup classname -> (possible) NASIS domain ID
  nasis_family_classes <- metadata[c("ChoiceName", "DomainID", "ColumnPhysicalName")]
  colnames(nasis_family_classes) <- c("classname", "DomainID", "ColumnPhysicalName")
  nasis_family_classes <- nasis_family_classes[(nasis_family_classes$DomainID %in% names(.DOMAINS)) &
                                                 (grepl("^tax", nasis_family_classes$ColumnPhysicalName)),]

  # combine KST and NASIS LUT
  res2 <- lapply(kst_lookup, function(x) {
    merge(
      x,
      nasis_family_classes[nasis_family_classes$classname %in% x$classname, ],
      by = c("classname", "DomainID"),
      sort = FALSE
    )
  })

  taxsub <- as.data.frame(data.table::rbindlist(lapply(decompose_taxon_code(res$code), function(x) {
    y <- taxon_code_to_taxon(as.character(rev(x)))
    z <- data.frame(taxsubgrp = NA_character_, taxgrtgroup = NA_character_,
                    taxsuborder = NA_character_, taxorder = NA_character_,
                    stringsAsFactors = FALSE)
    z[1, ] <- tail(c(rep(NA_character_, 4), y), 4)
    z
  })), stringsAsFactors = FALSE)

  res4 <- lapply(seq_along(res2), function(i) {
      x <- res2[[i]]
      # md <- soilDB::get_NASIS_column_metadata(x$DomainID, "DomainID")
      md <- metadata[metadata$DomainID %in% x$DomainID, ]

      # omitting the "duplicate" "osdtax..." columns within single domain, featkind, reskind
      # also taxtempcl is used over taxtempregime (which has identical levels)
      md <- md[grepl("^tax", md$ColumnPhysicalName) & !(md$ColumnPhysicalName == "taxtempregime"),]

      res5 <- unique(data.frame(
        classname = x$classname,
        ColumnPhysicalName = md$ColumnPhysicalName[match(x$classname, md$ChoiceName)],
        stringsAsFactors = FALSE
      ))
      cbind(stats::setNames(as.data.frame(t(res5[[1]]), stringsAsFactors = FALSE), res5[[2]]), taxsub[i, ])
    })

  allowed.names <- c("taxpartsize", "taxpartsizemod",
                     "taxminalogy", "taxceactcl",
                     "taxreaction", "taxtempcl",
                     "taxfamhahatmatcl", "taxfamother",
                     "taxsubgrp", "taxgrtgroup",
                     "taxsuborder", "taxorder")
  basetbl <- as.data.frame(stats::setNames(rep(list(numeric(0)), length(allowed.names)), allowed.names), stringsAsFactors = FALSE)

  #  many:1, since we know these were previously comma-separated we re-concatenate with comma
  #  TODO: the algorithm does not currently try to separate and re-parse " over " type logic

  res5 <- as.list(data.table::rbindlist(c(list(basetbl), res4), fill = TRUE))
  multi.names <- c("taxminalogy", "taxfamother")
  .FUN <- function(x, sep = NULL) list(x)
  .flat_FUN <- function(x, sep = ", ") {
    y <- paste0(na.omit(x), collapse = sep)
    if (nchar(y) == 0) return(NA_character_)
    y
  }
  if (flat) {
    .FUN <- .flat_FUN
  }

  res5[multi.names] <- lapply(multi.names, function(n) {
      res6 <- apply(data.frame(res5[names(res5) %in% n]), 1, .FUN,
                    sep = ifelse(n == "taxminalogy", " over ", ", "))
      res6 <- lapply(res6, function(nn) {
        nnn <- nn[[1]]
        lr6 <- length(nnn)
        stats::setNames(nnn, paste0(rep(n, lr6), seq_len(lr6)))
      })
      if (flat) return(as.character(res6))
      res6
    })
  out <- res5[allowed.names]
  out <- utils::type.convert(out[allowed.names], as.is = TRUE)

  # TODO: generalize if needed
  if (!flat) {
    out$taxminalogy <- I(res5$taxminalogy)
    out$taxfamother <- I(res5$taxfamother)
  } else {
    out$taxminalogy <- as.character(res5$taxminalogy)
    out$taxfamother <- as.character(res5$taxfamother)
  }
  data.frame(out, stringsAsFactors = FALSE)
}

#' Get soil family / series differentiae and class names
#'
#' All parameters to this function are optional (default `NULL`). If specified, they are used as filters.
#'
#' This is a wrapper method around the package data set `ST_family_classes`.
#'
#' @param classname optional filtering vector; levels of `ChoiceName` column from NASIS metadata
#' @param group optional filtering vector; one or more of: `"Mineral Family"`, `"Organic Family"`, `"Mineral or Organic"`
#' @param chapter optional filtering vector for chapter number
#' @param name optional filtering vector; one or more of: `"Mineralogy Classes"`, `"Mineralogy Classes Applied Only to Limnic Subgroups"`, `"Mineralogy Classes Applied Only to Terric Subgroups"`, `"Key to the Particle-Size and Substitute Classes of Mineral Soils"`, `"Calcareous and Reaction Classes of Mineral Soils"`, `"Reaction Classes for Organic Soils"`, `"Soil Moisture Subclasses"`, `"Other Family Classes"`, `"Soil Temperature Classes"`, `"Soil Moisture Regimes"`, `"Cation-Exchange Activity Classes"`, `"Use of Human-Altered and Human-Transported Material Classes"`
#' @param page optional filtering vector; page number (12th Edition Keys to Soil Taxonomy)
#' @param multiline_sep default `"\n"` returns `multiline_col` column as a character vector concatenated with `"\n"`. Use `NULL` for list
#' @param multiline_col character. vector of "multi-line" column names to concatenate. Default: `"criteria"`; use `NULL` for no concatenation.
#' @return a _data.frame_
#' @export
#' @seealso `ST_family_classes` `ST_features` `get_ST_features()`
#'
#' @return a subset of `ST_family_classes` _data.frame_
#' @export
#'
#' @examples
#'
#' # get classes in chapter 17
#' str(get_ST_family_classes(chapter = 17))
#'
#' # get classes on page 323
#' get_ST_family_classes(page = 323)
#'
#' # get the description for the mesic temperature class from list column
#' str(get_ST_family_classes(classname = "mesic")$description)
#'
get_ST_family_classes <- function(classname = NULL,
                                group = NULL,
                                name = NULL,
                                chapter = NULL,
                                page = NULL,
                                multiline_sep = "\n",
                                multiline_col = "criteria") {

  ST_family_classes <- NULL
  load(system.file("data", "ST_family_classes.rda", package = "SoilTaxonomy")[1])

  .data_filter(
    .data = ST_family_classes,
    classname = classname,
    group = group,
    chapter = chapter,
    name = name,
    page = page,
    multiline_sep = multiline_sep,
    multiline_col = multiline_col
  )
}
