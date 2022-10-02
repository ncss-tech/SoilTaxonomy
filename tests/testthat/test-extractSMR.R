test_that("extractSMR works", {
  expect_equal(extractSMR(c("aquic haploxeralfs",
                            "typic epiaqualfs",
                            "humic inceptic eutroperox")),
               factor(
                 c(`aquic haploxeralfs` = "xeric",
                   `typic epiaqualfs` = "aquic",
                   `humic inceptic eutroperox` = "perudic"
                 ),
                 levels = c(
                   "aridic (torric)",
                   "ustic",
                   "xeric",
                   "udic",
                   "perudic",
                   "aquic",
                   "peraquic"
                 ),
                 ordered = TRUE)
              )
})
