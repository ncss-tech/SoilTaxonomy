test_that("getParentTaxa works", {
  
  convert1 <- getParentTaxa(c("abruptic durixeralfs","asdgasdg","gypsic anhyturbels"))
  convert2 <- getParentTaxa(code = c("JDAE", "asdgasdg", "ABCD"))
  expect_equal(names(convert1)[2], names(convert2)[2])
  expect_equal(convert1[[1]], convert2[[1]])
  expect_equal(convert1[[2]], convert2[[2]])
  
  code1 <- getParentTaxa(c("abruptic durixeralfs","asdgasdg","gypsic anhyturbels"), convert = FALSE)
  code2 <- getParentTaxa(code = c("JDAE", "asdgasdg", "ABCD"), convert = FALSE)
  expect_equal(names(code1)[2], names(code2)[2])
  expect_equal(code1[[1]], code2[[1]])
  expect_equal(code1[[2]], code2[[2]])
 
  expect_equal(getParentTaxa("abruptic durixeralfs", level=c("suborder", "greatgroup")),
               list(`abruptic durixeralfs` = c(JD = "Xeralfs", JDA = "Durixeralfs"
               )))
})
