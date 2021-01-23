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
test_that("taxon_code_to_taxon works", {
  expect_equal(taxon_code_to_taxon(c("ABC","XYZ","DAB",NA)),c("Cryaquands", NA, "Anhyturbels", NA))
})

# TAXON -> CODE
test_that("taxon_to_taxon_code works", {
  expect_equal(taxon_to_taxon_code(c("Anhyturbels","foo","Cryaquands",NA)), c("DAB", NA, "ABC", NA))
})

# RELATIVE POSITION OF CODES
test_that("relative_taxon_code_position works", {
  expect_equal(relative_taxon_code_position(c("ABCD", "WXYZa","BAD")), c(7, NA, 5))
})
