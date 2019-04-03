context("Soil Taxonomy formative element parsing")

# used to iterate over all taxa at a given level
data("ST_unique_list")

test_that("soil order formative elements", {
  
  # full subgroup
  x <- OrderFormativeElements('typic haploxerolls')
  expect_equal(x$defs$order, 'mollisols')
  expect_equal(x$char.index, 15L)
  
  # suborder
  x <- OrderFormativeElements('xererts')
  expect_equal(x$defs$order, 'vertisols')
  expect_equal(x$char.index, 4L)
  
  # another
  x <- OrderFormativeElements('hemists')
  expect_equal(x$defs$order, 'histosols')
  expect_equal(x$char.index, 4L)
  
  # apply to all suborders
  # NA = parsing failure
  x <- OrderFormativeElements(ST_unique_list$tax_suborder)
  expect_false(any(is.na(x$defs$order)))
  expect_false(any(is.na(x$char.index)))
  
  # apply to all greatgroups
  # NA = parsing failure
  x <- OrderFormativeElements(ST_unique_list$tax_greatgroup)
  expect_false(any(is.na(x$defs$order)))
  expect_false(any(is.na(x$char.index)))
  
  # apply to all subgroups
  # NA = parsing failure
  x <- OrderFormativeElements(ST_unique_list$tax_subgroup)
  expect_false(any(is.na(x$defs$order)))
  expect_false(any(is.na(x$char.index)))
  
})


test_that("suborder formative elements", {
  
  # full subgroup
  x <- SubOrderFormativeElements('typic haploxerolls')
  expect_equal(x$defs$element, 'xer')
  expect_equal(x$char.index, 12L)
  
  # greatgroup
  x <- SubOrderFormativeElements('haplocryolls')
  expect_equal(x$defs$element, 'cry')
  expect_equal(x$char.index, 6L)
  
  # aridisols were causing problems due to collision ar|arg
  x <- SubOrderFormativeElements('calciargids')
  expect_equal(x$defs$element, 'arg')
  expect_equal(x$char.index, 6L)
  
  ## TODO: https://github.com/ncss-tech/SoilTaxonomy/issues/6
  # # histosols are difficult because of truncation: ist | hist
  # x <- SubOrderFormativeElements('folistels')
  # expect_equal(x$defs$element, 'ist')
  # expect_equal(x$char.index, 6L)
  
  # multiple occurence of formative elements
  x <- SubOrderFormativeElements('acrustoxic kanhaplustults')
  expect_equal(x$defs$element, 'ust')
  expect_equal(x$char.index, 19L)
  
})



