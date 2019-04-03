context("Soil Taxonomy element validation")


test_that("isValidST functions as expected", {
  
  # soil order
  expect_true(isValidST('alfisols', 'tax_order'))
  expect_false(isValidST('barfisols', 'tax_order'))
  
  # suborder
  expect_true(isValidST('xeralfs', 'tax_suborder'))
  expect_false(isValidST('xerbarfs', 'tax_suborder'))
  
  # greatgroup
  expect_true(isValidST('durixeralfs', 'tax_greatgroup'))
  expect_false(isValidST('crumicxerbarfs', 'tax_greatgroup'))
  
  # subgroup
  expect_true(isValidST('abruptic durixeralfs', 'tax_subgroup'))
  expect_false(isValidST('fartic crumicxerbarfs', 'tax_subgroup'))
  
  # error condition
  expect_error(isValidST('alfisols', 'nothing'))
  
})
