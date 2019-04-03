context("Soil Taxonomy formative element parsing")


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
  
})