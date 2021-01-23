test_that("getTaxonAtLevel works", {

  # specify alternate levels
  expect_equal(as.character(getTaxonAtLevel("humic haploxerands", level = "greatgroup")), "haploxerands")

  # can't get subgroup (child) from great group (parent)
  expect_null(getTaxonAtLevel("udifolists", level = "subgroup")[[1]])

  # but can do parents of children
  expect_equal(as.character(getTaxonAtLevel("udifolists", level = "suborder")), "folists")
})
