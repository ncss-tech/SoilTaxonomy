context("Soil Taxonomy formative element parsing")


test_that("isValidST functions as expected", {
  
  expect_true(isValidST('alfisols', 'tax_order'))
  expect_false(isValidST('barfisols', 'tax_order'))
  
})
