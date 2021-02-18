context("Parent-Child / Preceding Letter Code Lookup")

# Identifying parent codes from child codes
test_that("decompose_taxon_code works", {
  expect_equal(decompose_taxon_code(c("ABC","ABCDe","BCDEf")), list(ABC = list("A", "AB", "ABC"), 
                                                                    ABCDe = list("A", "AB", "ABC", "ABCDe"), 
                                                                    BCDEf = list("B", "BC", "BCD", "BCDEf")))
  d1 <- decompose_taxon_code(NA)
  d2 <- decompose_taxon_code(character(0))
  expect_true(is.na(d1[[1]]))
  expect_equal(d2, structure(list(), .Names = character(0)))
})

# Identifying logically preceding codes from codes
test_that("preceding_taxon_codes works", {
  
  expect_equal(preceding_taxon_codes("A"),
               list(A = character(0)))
  
  expect_equal(preceding_taxon_codes(c("ABCD","BCDEf")), list(ABCD = c("AA", "ABA", "ABB", "ABCA", "ABCB", "ABCC"), 
                                                               BCDEf = c("A", "BA", "BB", "BCA", "BCB", "BCC", 
                                                                 "BCDA", "BCDB", "BCDC", "BCDD", "BCDE",
                                                                 "BCDEa",  "BCDEb", "BCDEc", "BCDEd", 
                                                                 "BCDEe", "BCDEf")))
  
  p1 <- preceding_taxon_codes(NA)
  p2 <- preceding_taxon_codes(character(0))
  
  expect_true(is.na(p1[[1]]))
  expect_equal(p2, structure(list(), .Names = character(0)))
})

test_that("taxon_code_to_taxon & taxon_to_taxon_code works", {
# CODE -> TAXON
  res1 <- taxon_code_to_taxon(c("ABC","XYZ","DAB",NA))
  expect_equal(as.character(res1), c("Anhyturbels", NA, "Cryaquands", NA))
  expect_equal(names(res1), c("ABC","XYZ","DAB",NA))

# TAXON -> CODE
  res2 <- taxon_to_taxon_code(res1)
  expect_equal(as.character(res2), c("ABC", NA, "DAB", NA))
  expect_equal(names(res2), as.character(res1))

# EMPTY

  res3 <- taxon_code_to_taxon(character(0))
  res4 <- taxon_code_to_taxon(NA)
  res5 <- taxon_to_taxon_code(character(0))
  res6 <- taxon_to_taxon_code(NA)
  
  expect_true(length(res3) == length(res5) && length(res3) == 0)
  expect_true(is.na(res4[[1]]) == is.na(res6[[1]]) &&
                is.na(names(res4)[1]) && is.na(names(res6)[1]))
})

# RELATIVE POSITION OF CODES
test_that("relative_taxon_code_position works", {
  expect_equal(relative_taxon_code_position(c("ABCD", "WXYZa","BAD")), 
               c(ABCD = 7, WXYZa = NA, BAD = 5))
  
  res1 <- relative_taxon_code_position(NA)
  expect_true(is.na(res1[1]) && is.na(names(res1)[1]))
  
  res2 <- relative_taxon_code_position(character(0))
  expect_true(length(res2) == 0)
})
