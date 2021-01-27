library(SoilTaxonomy)

data("ST_higher_taxa_codes_12th")

subgroups <- ST_higher_taxa_codes_12th[nchar(ST_higher_taxa_codes_12th$code) >= 4,]

res <- lapply(subgroups$taxon, function(x) try(explainST(x), silent = TRUE))

# TODO: some sort of partial matching needs revision
# ties in distance vector: hemistels [histels,hemists]

# first iteration: 30% of subgroups produce errors
# second iteration: 3% of subgroups produce errors
# third iteration: no errors woo
lbad <- sapply(res, function(x) inherits(x, 'try-error'))
round(sum(lbad) / length(res) * 100, 5)

# take five bad ones at random, fix any errors, re-run
test.idx <- sample(which(lbad), 5)

subgroups[test.idx,]

# first iteration: all these are broken
# Error in ws[idx] <- txt : replacement has length zero
cat(explainST("ultic argixerolls"))
cat(explainST("folistic haplorthels"))
cat(explainST("psammentic paleudalfs"))
cat(explainST("vitrandic humustepts"))
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
cat(explainST("aridic kanhaplustalfs"))
cat(explainST("acrudoxic plinthic kandiudults")) # TODO: concatenate acr/udoxic + plinthic
cat(explainST("andic kanhaplustults"))
# now they work, 

# Error in seq.default(from = pos, to = pos + (length(txt) - 1)) : 'from' must be a finite number 
cat(explainST("terric fibristels"))
cat(explainST("typic folistels"))
# now they work,
# TODO: but their great group missing definitions and no marker at all for subgroup??
