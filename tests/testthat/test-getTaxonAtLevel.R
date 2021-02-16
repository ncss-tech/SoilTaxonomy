test_that("getTaxonAtLevel works", {

  # specify alternate levels
  expect_equal(as.character(getTaxonAtLevel("humic haploxerands", level = "greatgroup")), "haploxerands")

  # can't get subgroup (child) from suborder (parent), can get suborder from suborder
  expect_equal(getTaxonAtLevel(c('folists','plinthic kandiudults'), level = "subgroup"),
               c(BA = NA, HCCN = "plinthic kandiudults"))

  # but can do parents of children
  expect_equal(as.character(getTaxonAtLevel("udifolists", level = "suborder")), "folists")
})
