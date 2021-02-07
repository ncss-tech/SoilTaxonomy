context("Parent-Child / Preceding Letter Code Lookup")

# Identifying parent codes from child codes
test_that("decompose_taxon_code works", {
  expect_equal(decompose_taxon_code(c("ABC","ABCDe","BCDEf")), list(ABC = list("A", "AB", "ABC"), 
                                                                    ABCDe = list("A", "AB", "ABC", "ABCDe"), 
                                                                    BCDEf = list("B", "BC", "BCD", "BCDEf")))
})

# Identifying logically preceding codes from codes
test_that("preceding_taxon_codes works", {
  expect_equal(preceding_taxon_codes(c("ABCDe","BCDEf")), list(c("AA", "ABA", "ABB", "ABCA", "ABCB", 
                                                                 "ABCC", "ABCD", "ABCDa", "ABCDb", 
                                                                 "ABCDc", "ABCDd", "ABCDe"), 
                                                               c("A", "BA", "BB", "BCA", "BCB", "BCC", 
                                                                 "BCDA", "BCDB", "BCDC", "BCDD", "BCDE",
                                                                 "BCDEa",  "BCDEb", "BCDEc", "BCDEd", 
                                                                 "BCDEe", "BCDEf")))
})

# CODE -> TAXON
test_that("taxon_code_to_taxon & taxon_to_taxon_code works", {
  res1 <- taxon_code_to_taxon(c("ABC","XYZ","DAB",NA))
  expect_equal(res1, c("Anhyturbels", NA, "Cryaquands", NA))

# TAXON -> CODE
  expect_equal(taxon_to_taxon_code(res1), c("ABC", NA, "DAB", NA))
})

# RELATIVE POSITION OF CODES
test_that("relative_taxon_code_position works", {
  expect_equal(relative_taxon_code_position(c("ABCD", "WXYZa","BAD")), c(7, NA, 5))
})
