context("Soil Taxonomy formative element parsing")

# used to iterate over all taxa at a given level
data("ST_unique_list")

test_that("soil order formative elements", {
  
  # full subgroup
  x <- OrderFormativeElements('typic haploxerolls')
  expect_equal(x$defs$order, 'mollisols')
  expect_equal(x$char.index, 15L)
  
  # suborder
  x <- OrderFormativeElements('xererts')
  expect_equal(x$defs$order, 'vertisols')
  expect_equal(x$char.index, 4L)
  
  # another
  x <- OrderFormativeElements('hemists')
  expect_equal(x$defs$order, 'histosols')
  expect_equal(x$char.index, 4L)
  
  # apply to all suborders
  # NA = parsing failure
  x <- OrderFormativeElements(ST_unique_list$tax_suborder)
  expect_false(any(is.na(x$defs$order)))
  expect_false(any(is.na(x$char.index)))
  
  # apply to all greatgroups
  # NA = parsing failure
  x <- OrderFormativeElements(ST_unique_list$tax_greatgroup)
  expect_false(any(is.na(x$defs$order)))
  expect_false(any(is.na(x$char.index)))
  
  # apply to all subgroups
  # NA = parsing failure
  x <- OrderFormativeElements(ST_unique_list$tax_subgroup)
  expect_false(any(is.na(x$defs$order)))
  expect_false(any(is.na(x$char.index)))
  
})


test_that("suborder formative elements", {
  
  # full subgroup
  x <- SubOrderFormativeElements('typic haploxerolls')
  expect_equal(x$defs$element, 'xer')
  expect_equal(x$char.index, 12L)
  
  # greatgroup
  x <- SubOrderFormativeElements('haplocryolls')
  expect_equal(x$defs$element, 'cry')
  expect_equal(x$char.index, 6L)
  
  # aridisols were causing problems due to collision ar|arg
  x <- SubOrderFormativeElements('calciargids')
  expect_equal(x$defs$element, 'arg')
  expect_equal(x$char.index, 6L)
  
  ## TODO: https://github.com/ncss-tech/SoilTaxonomy/issues/6
  # # histosols are difficult because of truncation: ist | hist
  # x <- SubOrderFormativeElements('folistels')
  # expect_equal(x$defs$element, 'ist')
  # expect_equal(x$char.index, 6L)
  
  # multiple occurence of formative elements
  x <- SubOrderFormativeElements('acrustoxic kanhaplustults')
  expect_equal(x$defs$element, 'ust')
  expect_equal(x$char.index, 19L)
  
  # multiple subgroup elements
  x <- SubOrderFormativeElements('aridic lithic argixerolls')
  expect_equal(x$defs$element, 'xer')
  expect_equal(x$char.index, 19L)
  
})


test_that("greatgroup formative elements", {
  
  # full subgroup
  x <- GreatGroupFormativeElements('typic haploxerolls')
  expect_equal(x$defs$element, 'haplo')
  expect_equal(x$char.index, 7L)
  
  # more complex example
  x <- GreatGroupFormativeElements('aridic lithic argixerolls')
  expect_equal(x$defs$element, 'argi')
  expect_equal(x$char.index, 15)
  
  x <- GreatGroupFormativeElements('alfic humic vitrixerands')
  expect_equal(x$defs$element, 'vitri')
  expect_equal(x$char.index, 13)
  
  ## TODO: https://github.com/ncss-tech/SoilTaxonomy/issues/7  
  # # multiple occurence of formative elements
  # x <- GreatGroupFormativeElements('acrustoxic kanhaplustults')
  # expect_equal(x$defs$element, 'ust')
  # expect_equal(x$char.index, 19L)
  
})

test_that("explainST", {
  data("ST_higher_taxa_codes_12th")
  
  subgroups <- ST_higher_taxa_codes_12th[nchar(ST_higher_taxa_codes_12th$code) >= 4,]
  
  # res <- lapply(subgroups$taxon, function(x) try(explainST(x), silent = TRUE))
  
  # TODO: some sort of partial matching needs revision
  # ties in distance vector: hemistels [histels,hemists]
  
  # first iteration: 30% of subgroups produce errors
  # second iteration: 3% of subgroups produce errors
  # third iteration: no errors woo
  # lbad <- sapply(res, function(x) inherits(x, 'try-error'))
  # round(sum(lbad) / length(res) * 100, 5)
  # 
  # # take five bad ones at random, fix any errors, re-run
  # test.idx <- sample(which(lbad), 5)
  # 
  # subgroups[test.idx,]
  
  # first iteration: all these are broken
  # Error in ws[idx] <- txt : replacement has length zero
  
  expect_output(cat(explainST("ultic argixerolls")))
  expect_output(cat(explainST("folistic haplorthels")))
  expect_output(cat(explainST("psammentic paleudalfs")))
  expect_output(cat(explainST("vitrandic humustepts")))
  # now they work, but their subgroup modifier missing (not in LUT)
  
  # TODO: explanations for all of these
  # subset(ST_formative_elements[["subgroup"]], connotation == "")
  
  # second iteration: all these are broken; 2 different errors
  # 299  JCEC          Aridic Kanhaplustalfs
  # 1242 AACB              Terric Fibristels
  # 1248 AAAC                Typic Folistels
  # 2787 HCCH Acrudoxic Plinthic Kandiudults
  # 2867 HDCF           Andic Kanhaplustults
  
  # Error: Result 1 must be a single integer, not an integer vector of length 2
  expect_output(cat(explainST("aridic kanhaplustalfs")))
  expect_output(cat(explainST("acrudoxic plinthic kandiudults")))
  expect_output(cat(explainST("andic kanhaplustults")))
  # now they work, 
  # TODO: but the acrudoxic plinthic confuses things -- ? in slightly wrong position
  
  # Error in seq.default(from = pos, to = pos + (length(txt) - 1)) : 'from' must be a finite number 
  expect_output(cat(explainST("terric fibristels")))
  expect_output(cat(explainST("typic folistels")))
  # now they work,
})
