.SoilTaxonomy_dir <- function(which = "data") {
  # persistent cache not supported on R<4
  if (R.version$major >= 4) {
    tools::R_user_dir("SoilTaxonomy", which = "data")
  } else {
    file.path(find.package("SoilTaxonomy"), "inst", "extdata")
  }
}

.cache_soilDB_series_classification_db <- function() { 
  
  if (!requireNamespace("soilDB")) {
    stop("package soilDB is required to download the Series Classification (SC) database", call. = FALSE)
  }
  
  dst <- .SoilTaxonomy_dir()
  
  if (!dir.exists(dst)) 
    dir.create(dst)
  
  fst <- file.path(dst, "scdb.rds")
  
  if (!file.exists(fst)) {
    x <- soilDB::get_soilseries_from_NASISWebReport("%")
    attr(x, "creation_time") <- Sys.time()
    saveRDS(x, file = fst)
  } else {
    x <- readRDS(fst)
  }
  
  x
}