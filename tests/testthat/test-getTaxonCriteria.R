test_that("getTaxonCriteria works", {
  i1 <- c("mollic haplocryalfs", "abruptic durixeralfs")

  x1 <- getTaxonCriteria(i1)
  expect_equal(names(x1), i1)
  expect_equal(length(x1), 2)
  expect_equal(nrow(x1[[1]]), 12)

  x2 <- getTaxonCriteria(code = "ABC", level = c("greatgroup"))
  expect_true(is.list(x2))
  expect_equal(names(x2), "ABC")
  expect_equal(nrow(x2[[1]]), 2)
})
