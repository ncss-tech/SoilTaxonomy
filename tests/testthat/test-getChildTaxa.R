context("getChildTaxa")

test_that("getChildTaxa works", {
  expect_equal(getChildTaxa(code = taxon_to_taxon_code("Mollisols"), level = "suborder"), 
               list(I = c(IA = "Albolls", IB = "Aquolls", IC = "Rendolls", ID = "Gelolls", 
                          IE = "Cryolls", IF = "Xerolls", IG = "Ustolls", IH = "Udolls"
               )))
  expect_equal(getChildTaxa(taxon ="Alfisols", level = "order"), 
               list(Alfisols = structure(character(0), .Names = character(0))))
})
