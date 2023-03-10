test_that("taxonTree works", {

  tf <- tempfile()
  sink(file = tf)
  x <- taxonTree(c("hapludults", "hapludalfs"))
  expect_true(inherits(x, 'SoilTaxonNode'))

  x <- taxonTree(
    "alfisols",
    root = "Alfisols",
    level = c("suborder", "greatgroup"),
    verbose = FALSE
  )
  expect_true(inherits(x, 'SoilTaxonNode'))

  x <- taxonTree("durixeralfs",
                 special.chars = c("\u251c",
                                   "\u2514",
                                   "\u2500 "))
  sink()
  expect_true(inherits(x, 'SoilTaxonNode'))
  unlink(tf)
})
