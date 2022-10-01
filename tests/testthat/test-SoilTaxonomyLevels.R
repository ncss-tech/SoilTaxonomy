test_that("SoilTaxonomyLevels works", {

  x <- SoilTaxonomyLevels("suborder")
  expect_equal(class(x), c("ordered", "factor"))
  expect_equal(order(taxon_to_taxon_code(x)), as.numeric(x))

  x <- SoilTaxonomyLevels("order", as.is = TRUE)
  expect_equal(x, c("gelisols", "histosols", "spodosols", "andisols", "oxisols",
                    "vertisols", "aridisols", "ultisols", "mollisols", "alfisols",
                    "inceptisols", "entisols"))
})
