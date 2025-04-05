test_that("getTaxonSMR works", {
  x <- getTaxonSMR(c("aridisols", "haploxeralfs", NA, "abruptic durixeralfs", "ustic haplocryalfs"))
  expect_true(is.na(x[3]))
  expect_true(is.factor(x) && is.ordered(x))

  y <- getTaxonSMR(c("aridisols", "haploxeralfs", NA, "abruptic durixeralfs", "ustic haplocryalfs"), as.is = TRUE)
  expect_true(is.character(y))
})
