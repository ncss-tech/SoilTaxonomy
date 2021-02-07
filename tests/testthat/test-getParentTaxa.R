test_that("getParentTaxa works", {
  
  expect_equal(getParentTaxa(c("abruptic durixeralfs","asdgasdg","gypsic anhyturbels")),
               getParentTaxa(code = c("JDAE", NA, "ABCD")))
  
  expect_equal(getParentTaxa(c("abruptic durixeralfs","asdgasdg","gypsic anhyturbels"), convert = FALSE),
               getParentTaxa(code = c("JDAE", NA, "ABCD"), convert = FALSE))
 
})
