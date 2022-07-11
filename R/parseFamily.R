#' Parse Components of a "Family-level" Taxon Name
#'
#' @param family a character vector containing taxonomic families, e.g. `"fine-loamy, mixed, semiactive, mesic ultic haploxeralfs"`
#' @param column_metadata include parsed NASIS physical column names and values from family taxon components? Default: `TRUE` requires soilDB package.
#'
#' @return a `data.frame` containing column names: `"family"` (input), `"subgroup"` (parsed taxonomic subgroup), `"subgroup_code"` (letter code for subgroup), `"class_string"` (comma-separated family classes), `"classes_split"` (split class_string vector stored as `list` column).
#'
#' In addition, the following column names are identified and returned based on NASIS (National Soil Information System) metadata (via soilDB package):
#'  - `"taxpartsize"`, `"taxpartsizemod"`, `"taxminalogy"`, `"taxceactcl"`, `"taxreaction"`, `"taxtempcl"`, `"taxsubgrp"`, `"taxgreatgroup"`, `"taxsuborder"`, `"taxorder"`
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
parse_family <- function(family, column_metadata = TRUE) {

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
  cbind(res, .get_family_differentia(res))
}

#' @import data.table
.get_family_differentia <- function(res) {

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

    # omitting the "duplicate" "osdtax..." columns within single domain
    # also taxtempcl used over taxtempregime (which has identical levels)
    md <- md[!grepl("^osdtax|taxtempregime", md$ColumnPhysicalName),]

    res5 <- unique(data.frame(
      classname = x$classname,
      ColumnPhysicalName = md$ColumnPhysicalName[match(x$classname, md$ChoiceName)],
      stringsAsFactors = FALSE
    ))
    cbind(`colnames<-`(as.data.frame(t(res5[[1]]), stringsAsFactors = FALSE), res5[[2]]), taxsub[i, ])
  })

  basetbl <- as.data.frame(`names<-`(rep(list(numeric(0)), 10), c("taxpartsize", "taxpartsizemod",
                                                                  "taxminalogy", "taxceactcl",
                                                                  "taxreaction", "taxtempcl",
                                                                  "taxsubgrp", "taxgrtgroup",
                                                                  "taxsuborder", "taxorder")),
                           stringsAsFactors = FALSE)
  as.data.frame(data.table::rbindlist(c(list(basetbl), res4), fill = TRUE),
                stringsAsFactors = FALSE)
}


