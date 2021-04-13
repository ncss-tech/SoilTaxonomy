context("Diagnostic Features")

test_that("get_ST_features works", {
  
  # runs without error
  res <- get_ST_features()
  
  # colnames in result match the SoilKnowledgeBase JSON def 
  expect_equal(colnames(res),
               c("group", "name", "chapter",
                 "page", "description", "criteria"))
  
  # basic test of contents, mollic epipedon is in there
  expect_true("Mollic Epipedon" %in% res$name)
  
})
