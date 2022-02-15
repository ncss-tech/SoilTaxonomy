context("Taxon / Hierarchy Convenience Methods")

test_that("taxon_to_level works", {
  expect_equal(taxon_to_level(c("gelisols", NA, "foo", "typic folistels", "folistels")), 
               c("order", NA, NA, "subgroup", "greatgroup"))
})

test_that("taxon_to_level works (family-level taxa)", {
  expect_equal(taxon_to_level(
    c(
      "Fine-loamy, mixed, active, thermic Ultic Haploxeralfs",
      "Histosols",
      NA,
      "Thermic Typic Quartzipsamments"
    )
  ), c('family', 'order', NA, 'family'))
})

test_that("level_to_taxon works", {
  expect_equal(length(level_to_taxon(level = c("order","suborder"))), 80)
})

