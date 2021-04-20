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
  
  # filtering using chapter and page
  res <- get_ST_features(chapter = 2)
  expect_equal(nrow(res), 7)
  
  res <- get_ST_features(page = 18:19)
  expect_equal(nrow(res), 6)
  
  # filter on multiple [redundant] criteria
  expect_equal(
    get_ST_features(group = "Surface", name = "Mollic Epipedon"),
    get_ST_features(name = "Mollic Epipedon")
  )
  
})
