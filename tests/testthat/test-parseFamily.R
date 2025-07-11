test_that("parse_family(..., column_metadata = FALSE) works", {

  families <- c("fine, kaolinitic, thermic typic kanhapludults",
      "fine-loamy, mixed, semiactive, mesic ultic haploxeralfs",
      "euic, thermic typic haplosaprists",
      "coarse-loamy, mixed, active, mesic aquic dystrudepts",
      "fine, kaolinitic, thermic typic kanhapludults",
      "fine-loamy, mixed, semiactive, mesic ultic haploxeralfs",
      "euic, thermic typic haplosaprists",
      "coarse-loamy, mixed, active, mesic aquic dystrudepts")

  res <- parse_family(families, column_metadata = FALSE)

  expect_equal(res$code,
               c("HCDN", "JDGR", "BDDH", "KFFK",
                 "HCDN", "JDGR", "BDDH", "KFFK"))
})

test_that("parse_family(..., column_metadata = TRUE) works", {

  families <- c("fine, kaolinitic, thermic typic kanhapludults",
                "fine-loamy, mixed, semiactive, mesic ultic haploxeralfs",
                "euic, thermic typic haplosaprists",
                "coarse-loamy, mixed, active, mesic aquic dystrudepts",
                "fine, kaolinitic, thermic typic kanhapludults",
                "fine-loamy, mixed, semiactive, mesic ultic haploxeralfs",
                "euic, thermic typic haplosaprists",
                "coarse-loamy, mixed, active, mesic aquic dystrudepts")

  res <- parse_family(families, column_metadata = TRUE)

  expect_equal(res$code,
               c("HCDN", "JDGR", "BDDH", "KFFK",
                 "HCDN", "JDGR", "BDDH", "KFFK"))
})

test_that("complex or uncommon family classes", {

  skip_if_not_installed("soilDB")

  if (packageVersion("soilDB") >= "2.8.11") {
    # mapping of "diatomaceous" mineralogy class -> "diatomaceous earth" choicename for taxminalogy
    x <- parse_family("DIATOMACEOUS, EUIC, FRIGID LIMNIC HAPLOHEMISTS")
    expect_true(x$taxminalogy == "diatomaceous" && x$taxreaction == "euic")
  }

  # in domain order ortstein is a featkind and reskind (and several other things) before it is taxfamother
  x <- parse_family("MEDIAL-SKELETAL, AMORPHIC, FRIGID, ORTSTEIN ANDIC DURIHUMODS")
  expect_true(x$taxminalogy == "amorphic" && x$taxfamother == "ortstein")

  # compound family classes such as "amorphic over isotic" for strongly contrasting control section
  x <- parse_family("MEDIAL-SKELETAL OVER LOAMY-SKELETAL, AMORPHIC OVER ISOTIC, FRIGID ANDIC HAPLORTHODS")
  expect_true(x$taxminalogy == "amorphic over isotic" &&
                x$taxpartsize == "medial-skeletal over loamy-skeletal",
                x$classes_split[[1]][2] == "AMORPHIC OVER ISOTIC")

  # test flat=FALSE (returns list columns)
  x <- parse_family("MEDIAL-SKELETAL OVER LOAMY-SKELETAL, AMORPHIC OVER ISOTIC, FRIGID ANDIC HAPLORTHODS", flat = FALSE)
  expect_equal(x$taxminalogy, I(list(c(taxminalogy1="amorphic", taxminalogy2="isotic"))))


  # however, cases where more than one class return comma separated
  x <- parse_family("SANDY, ISOTIC, FRIGID, SHALLOW, ORTSTEIN TYPIC DURORTHODS")
  expect_equal(x$taxfamother, "shallow, ortstein")

  x <- parse_family(c("FINE-SILTY, ISOTIC, ISOMESIC AQUANDIC DYSTRUDEPTS",
                      "FINE, SMECTITIC, FRIGID LEPTIC UDIC HAPLUSTERTS",
                      "SANDY, ISOTIC, FRIGID, SHALLOW, ORTSTEIN TYPIC DURORTHODS",
                      "FINE, MIXED, ACTIVE, MESIC OXYAQUIC HAPLUDALFS",
                      "MEDIAL-SKELETAL OVER LOAMY-SKELETAL, AMORPHIC OVER ISOTIC, FRIGID ANDIC HAPLORTHODS"),
                    flat = TRUE)
  expect_equal(x$taxminalogy, c("isotic", "smectitic", "isotic", "mixed", "amorphic over isotic"))
  expect_equal(x$taxfamother, c(NA, NA, "shallow, ortstein", NA, NA))

  # test flat=FALSE (many taxa)
  x <- parse_family(c("FINE-SILTY, ISOTIC, ISOMESIC AQUANDIC DYSTRUDEPTS",
                      "FINE, SMECTITIC, FRIGID LEPTIC UDIC HAPLUSTERTS",
                      "SANDY, ISOTIC, FRIGID, SHALLOW, ORTSTEIN TYPIC DURORTHODS",
                      "FINE, MIXED, ACTIVE, MESIC OXYAQUIC HAPLUDALFS",
                      "MEDIAL-SKELETAL OVER LOAMY-SKELETAL, AMORPHIC OVER ISOTIC, FRIGID ANDIC HAPLORTHODS"),
                    flat = FALSE)
  expect_equal(x$taxminalogy, I(list(c(taxminalogy1 = "isotic", taxminalogy2 = NA),
                                     c(taxminalogy1 = "smectitic", taxminalogy2 = NA),
                                     c(taxminalogy1 = "isotic", taxminalogy2 = NA),
                                     c(taxminalogy1 = "mixed", taxminalogy2 = NA),
                                     c(taxminalogy1 = "amorphic", taxminalogy2 = "isotic"))))
})

test_that("taxa above family and incomplete family names", {

  skip_if_not_installed("soilDB")

  x <- data.frame(
    taxonname = c("Alberti", "Aquents", "Lithic Xeric Torriorthents", "Stagy Family", "Haplodurids"),
    taxonkind = c("series", "taxon above family", "taxon above family", "family", "taxon above family"),
    taxclname = c(
      "Clayey, smectitic, thermic, shallow Vertic Rhodoxeralfs", # Full family name
      "Aquents",                                              # Taxon above subgroup
      "Lithic Xeric Torriorthents",                           # Subgroup
      "Coarse-loamy, mixed, mesic Duric Haploxerolls",        # Family name missing activity class
      "Mixed, superactive, thermic Haplodurids"               # Taxon above family (family classes + great group)
    ))
  res <- parse_family(x$taxclname)
  expect_equal(res$taxsuborder, c("Xeralfs", "Aquents", "Orthents", "Xerolls", "Durids"))
  expect_equal(res$taxgrtgroup, c("Rhodoxeralfs", NA_character_, "Torriorthents", "Haploxerolls", "Haplodurids"))
})
