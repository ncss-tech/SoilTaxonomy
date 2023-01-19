test_that("extractSMR works", {
  # test below subgroup level/case insensitivity/no factor
  expect_equal(extractSMR("Aquolls", as.is = TRUE), c(Aquolls = "aquic"))

  # test with multiple subgroup level taxa,
  # including one w/ more formative elements than usual (humic inceptic eutroperox)
  expect_equal(extractSMR(c("aquic haploxeralfs",
                            "typic epiaqualfs",
                            "humic inceptic eutroperox",
                            "aquisalids",
                            "aquiturbels")),
               factor(
                 c(`aquic haploxeralfs` = "xeric",
                   `typic epiaqualfs` = "aquic",
                   `humic inceptic eutroperox` = "perudic",
                   `aquisalids` = "aridic (torric)",
                   `aquiturbels` = "aquic"
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
