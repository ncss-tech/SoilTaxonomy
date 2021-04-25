#' Parse components of a family-level taxon name
#'
#' @param family a character vector containing taxonomic families, e.g. `"fine-loamy, mixed, semiactive, mesic ultic haploxeralfs"`
#'
#' @return a `data.frame` containing column names: `"family"` (input), `"subgroup"` (parsed taxonomic subgroup), `"subgroup_code"` (letter code for subgroup), `"class_string"` (comma-separated family classes), `"classes_split"` (split class_string vector stored as `list` column)
#' 
#' @export
#'
#' @examples
#' 
#' families <- c("fine, kaolinitic, thermic typic kanhapludults",
#'               "fine-loamy, mixed, semiactive, mesic ultic haploxeralfs",
#'               "euic, thermic typic haplosaprists",
#'               "coarse-loamy, mixed, active, mesic aquic dystrudepts",
#'               "fine, kaolinitic, thermic typic kanhapludults",
#'               "fine-loamy, mixed, semiactive, mesic ultic haploxeralfs",
#'               "euic, thermic typic haplosaprists",
#'               "coarse-loamy, mixed, active, mesic aquic dystrudepts")
#'  
#' # inspect parsed list result             
#' str(parse_family(families))     
#' 
#' @importFrom stringr str_locate
parse_family <- function(family) {
  
  # for R CMD check
  ST_unique_list <- NULL
  
  # load local copy of taxon code lookup table
  load(system.file("data/ST_unique_list.rda", package = "SoilTaxonomy")[1])
  
  lut <- ST_unique_list[["subgroup"]]
  
  # lookup table sorted from largest to smallest (most specific to least)
  lut <- lut[order(nchar(lut), decreasing = TRUE)]
  res <- lapply(tolower(family), function(x) stringr::str_locate(string = x, pattern = lut))
  
  # take the first match (in SORTED lut)
  subgroup.idx <- sapply(res, function(x) which(!is.na(x[,1]))[1])
  subgroup.pos <- sapply(seq_along(subgroup.idx), function(i) res[[i]][subgroup.idx[i], 'start'])
  
  subgroups <- lut[subgroup.idx]
  family_classes <- trimws(substr(family, 0, subgroup.pos - 1))
  
  data.frame(row.names = NULL,
    family = family,
    subgroup = subgroups,
    subgroup_code = taxon_to_taxon_code(subgroups),
    class_string = family_classes,
    classes_split = I(lapply(strsplit(family_classes, ","), trimws)))
  
}
