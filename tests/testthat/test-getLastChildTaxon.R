test_that("getLastChildTaxon works", {
  expect_equal(as.numeric(prop.table(table(grepl("^Hap", getLastChildTaxon("suborder")$taxon)))), c(0.25,0.75))
})
