test_that("parent/child_level() works", {
  expect_equal(child_level(parent_level("family")), "family")
  expect_equal(parent_level('subgroup'), "greatgroup")
  expect_equal(child_level('suborder', 3), "family")
  expect_equal(parent_level('family', 5), NA_character_)
})
