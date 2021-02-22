context("Soil Taxonomy element validation")


test_that("isValidST functions as expected", {
  
  # soil order
  expect_true(isValidST('alfisols', 'order'))
  expect_false(isValidST('barfisols', 'order'))
  
  # suborder
  expect_true(isValidST('xeralfs', 'suborder'))
  expect_false(isValidST('xerbarfs', 'suborder'))
  
  # greatgroup
  expect_true(isValidST('durixeralfs', 'greatgroup'))
  expect_false(isValidST('crumicxerbarfs', 'greatgroup'))
  
  # subgroup
  expect_true(isValidST('abruptic durixeralfs', 'subgroup'))
  expect_false(isValidST('fartic crumicxerbarfs', 'subgroup'))
  
  # error condition
  expect_error(isValidST('alfisols', 'nothing'))
  
})
