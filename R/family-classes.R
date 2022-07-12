#' Parse Components of a "Family-level" Taxon Name
#'
#' @param family character. vector of taxonomic families, e.g. `"fine-loamy, mixed, semiactive, mesic ultic haploxeralfs"`
#' @param column_metadata logical. include parsed NASIS physical column names and values from family taxon components? Default: `TRUE` requires soilDB package.
#' @param flat logical Default: `TRUE` to return concatenated family-level classes for `"taxminalogy"` and `"taxfamother"`? Alternately, if `FALSE`, list columns are returned.
#'
#' @return a `data.frame` containing column names: `"family"` (input), `"subgroup"` (parsed taxonomic subgroup), `"subgroup_code"` (letter code for subgroup), `"class_string"` (comma-separated family classes), `"classes_split"` (split class_string vector stored as `list` column).
#'
#' In addition, the following column names are identified and returned based on NASIS (National Soil Information System) metadata (via soilDB package):
#'  - `"taxpartsize"`, `"taxpartsizemod"`, `"taxminalogy"`, `"taxceactcl"`, `"taxreaction"`, `"taxtempcl"`, `"taxfamhahatmatcl"`, `"taxfamother"`, `"taxsubgrp"`, `"taxgreatgroup"`, `"taxsuborder"`, `"taxorder"`
#'
#' @export
#'
#' @examples
#' if (!requireNamespace('soilDB')) {
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
  load(system.file("data/ST_unique_list.rda", package = "SoilTaxonomy")[1])

  lut <- ST_unique_list[["subgroup"]]

  # lookup table sorted from largest to smallest (most specific to least)
  lut <- lut[order(nchar(lut), decreasing = TRUE)]
  res <- lapply(tolower(family), function(x) stringr::str_locate(string = x, pattern = stringr::fixed(lut)))

  # take the first match (in SORTED lut)
  subgroup.idx <- sapply(res, function(x) which(!is.na(x[,1]))[1])
  subgroup.pos <- sapply(seq_along(subgroup.idx), function(i) res[[i]][subgroup.idx[i], 'start'])

  subgroups <- lut[subgroup.idx]
  family_classes <- trimws(substr(family, 0, subgroup.pos - 1))

  res <- data.frame(row.names = NULL, stringsAsFactors = FALSE,
    family = family,
    subgroup = subgroups,
    subgroup_code = taxon_to_taxon_code(subgroups),
    class_string = family_classes,
    classes_split = I(lapply(strsplit(family_classes, ","), trimws)))

  if (!column_metadata)
    return(res)
  cbind(res, .get_family_differentiae(res))
}

#' @import data.table
#' @importFrom utils type.convert
.get_family_differentiae <- function(res, flat = TRUE) {

  metadata <- NULL
  if (!requireNamespace("soilDB")) {
    message("package `soilDB` is required to lookup NASIS column metadata correponding to taxonomic classes", call. = FALSE)
    return(res[, 0, drop = FALSE])
  } else {
    # soilDB::get_NASIS_metadata() # 2.7.3+
    load(system.file("data/metadata.rda", package = "soilDB")[1])
  }

  ST_family_classes <- NULL
  load(system.file("data/ST_family_classes.rda", package = "SoilTaxonomy")[1])

  # lookup classes in KST definitions
  kst_lookup <- lapply(res$classes_split, function(x) {
    ST_family_classes[match(tolower(x), tolower(ST_family_classes$classname)), c("classname", "group", "name")]
  })

  # lookup classname -> (possible) NASIS domain ID
  nasis_family_classes <- metadata[c("ChoiceName", "DomainID")]
  colnames(nasis_family_classes) <- c("classname", "DomainID")

  # combine KST and NASIS LUT
  res2 <- lapply(kst_lookup, function(x) {

    ###; CHOICE LIST PATCHES
    # mapping of "diatomaceous" mineralogy class -> "diatomaceous earth" choicename for taxminalogy
    x$classname[x$classname == "diatomaceous"] <- "diatomaceous earth"
    ###

    res3 <- merge(x, nasis_family_classes[nasis_family_classes$classname %in% x$classname, ],
          by = "classname", all.x = TRUE, all.y = TRUE, sort = FALSE)
    res3
  })

  taxsub <- as.data.frame(do.call('rbind', lapply(decompose_taxon_code(res$subgroup_code), function(x) taxon_code_to_taxon(as.character(rev(x))))),
                          stringsAsFactors = FALSE)
  colnames(taxsub) <- rev(c("taxorder", "taxsuborder", "taxgrtgroup", "taxsubgrp"))
  rownames(taxsub) <- NULL

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
    cbind(`colnames<-`(as.data.frame(t(res5[[1]]), stringsAsFactors = FALSE), res5[[2]]), taxsub[i, ])
  })

  allowed.names <- c("taxpartsize", "taxpartsizemod",
                     "taxminalogy", "taxceactcl",
                     "taxreaction", "taxtempcl",
                     "taxfamhahatmatcl", "taxfamother",
                     "taxsubgrp", "taxgrtgroup",
                     "taxsuborder", "taxorder")
  basetbl <- as.data.frame(`names<-`(rep(list(numeric(0)), length(allowed.names)), allowed.names), stringsAsFactors = FALSE)
  res5 <- as.data.frame(data.table::rbindlist(c(list(basetbl), res4), fill = TRUE), stringsAsFactors = FALSE)

  #  many:1, since we know these were previously comma-separated we re-concatenate with comma
  #  TODO: the algorithm does not currently try to separate and re-parse " over " type logic
  multi.names <- c("taxminalogy", "taxfamother")
  .FUN <- function(x) strsplit(x, " over ", fixed = TRUE)
  .flat_FUN <- function(x) paste0(x, collapse = ", ")
  if (flat) {
    .FUN <- .flat_FUN
  }
  res5[multi.names] <- lapply(multi.names, function(n) {
    apply(res5[colnames(res5) %in% n], 1, .FUN)
  })
  res5 <- type.convert(res5[allowed.names], as.is = TRUE)
  res5
}

#' Get Family and Series Differentiae and Names
#'
#' All parameters to this function are optional (default `NULL`). If specified, they are used as filters.
#'
#' This is a wrapper method around the package data set `ST_features`.
#'
#' @param classname optional filtering vector; levels of `ChoiceName` column from NASIS metadata
#' @param group optional filtering vector; one or more of: `"Mineral Family"`, `"Organic Family"`, `"Mineral or Organic"`
#' @param chapter optional filtering vector for chapter number
#' @param name optional filtering vector; one or more of: `"Mineralogy Classes"`, `"Mineralogy Classes Applied Only to Limnic Subgroups"`, `"Mineralogy Classes Applied Only to Terric Subgroups"`, `"Key to the Particle-Size and Substitute Classes of Mineral Soils"`, `"Calcareous and Reaction Classes of Mineral Soils"`, `"Reaction Classes for Organic Soils"`, `"Soil Moisture Subclasses"`, `"Other Family Classes"`, `"Soil Temperature Classes"`, `"Soil Moisture Regimes"`, `"Cation-Exchange Activity Classes"`, `"Use of Human-Altered and Human-Transported Material Classes"`
#' @param page optional filtering vector; page number (12th Edition Keys to Soil Taxonomy)
#' @param multiline_sep default `"\n"` returns `criteria` column as a character vector concatenated with `"\\n"`. Use `NULL` for list
#' @param multiline_col character. vector of "multiline" column names to concatenate. Default: `"criteria"`; use `NULL` for no concatenation.
#' @return a data.frame
#' @export
#' @seealso `ST_family_class`
#'
#' @return a subset of `ST_family_class` _data.frame_
#' @export
#'
#' @examples
#'
#' # get all features
#' str(get_ST_family_classes())
#'
#' # get features in chapter 17
#' str(get_ST_family_classes(chapter = 17))
#'
#' # get features on pages 322:323
#' get_ST_family_classes(page = 322:323)
#'
#' # get the required characteristics for the mollic epipedon from list column
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
  load(system.file("data/ST_family_classes.rda", package = "SoilTaxonomy")[1])

  # get full set of features
  res <- ST_family_classes

  filtargs <- c(
    "classname" = !is.null(classname),
    "group" = !is.null(group),
    "chapter" = !is.null(chapter),
    "name" = !is.null(name),
    "page" = !is.null(page)
  )

  .data_filter(
    .data = res,
    filtargs = filtargs,
    classname = classname,
    group = group,
    chapter = chapter,
    name = name,
    page = page,
    multiline_sep = multiline_sep,
    multiline_col = multiline_col
  )
}
