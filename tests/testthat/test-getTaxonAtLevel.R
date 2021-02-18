test_that("getTaxonAtLevel works", {

  # specify alternate levels
  expect_equal(getTaxonAtLevel("humic haploxerands", level = "greatgroup"), 
               c(DECH = "haploxerands"))

  # can't get subgroup (child) from suborder (parent), can get suborder from suborder
  expect_equal(getTaxonAtLevel(c('folists','plinthic kandiudults'), level = "subgroup"),
               c(BA = NA, HCCN = "plinthic kandiudults"))

  # but can do parents of children
  expect_equal(getTaxonAtLevel("udifolists", level = "suborder"), 
               c(BAD = "folists"))
  
  # default is level="soilorder"
  expect_equal(getTaxonAtLevel("udolls"), 
               c(IH = "mollisols"))
  
  # garbage and 0-character input
  g1 <- getTaxonAtLevel("foo") 
  g2 <- getTaxonAtLevel("") # 
  expect_true(is.na(g1[[1]]) && is.na(g2[[1]]) && 
                is.na(names(g1)[1]) && is.na(names(g2)[1]))
  
  # empty (length 0) and missing (NA) input
  expect_true(is.na(getTaxonAtLevel(character(0))) && is.na(getTaxonAtLevel(NA)))
})
