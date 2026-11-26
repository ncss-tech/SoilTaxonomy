# =============================================================================
# Tests for taxonomic distance functions (taxon_lineage, shared_taxon_depth,
# taxon_distance, taxon_distance_matrix, taxon_tree)
# =============================================================================

test_that("taxon_lineage returns correct lineage vectors", {
  # Haploxeralfs (JDG) → Soil → Alfisols → Xeralfs → Haploxeralfs
  l <- taxon_lineage("Haploxeralfs")
  expect_true(is.list(l))
  expect_equal(length(l), 1L)
  expect_true(!is.na(l[[1]]))

  # Check the lineage has correct structure: Soil, Order, Suborder, Great Group
  expect_equal(names(l[[1]]), c("Soil", "Order", "Suborder", "Great Group"))
  expect_equal(l[[1]][["Order"]], "Alfisols")
  expect_equal(l[[1]][["Suborder"]], "Xeralfs")
  expect_equal(l[[1]][["Great Group"]], "Haploxeralfs")

  # By code
  l2 <- taxon_lineage("JDG")
  expect_equal(l2[["JDG"]], l[["Haploxeralfs"]])

  # Gelisols example: A → AB → ABC (Anhyturbels)
  l3 <- taxon_lineage("Anhyturbels")
  expect_equal(l3[["Anhyturbels"]][["Order"]], "Gelisols")
})


test_that("taxon_lineage handles invalid taxa gracefully", {
  l <- taxon_lineage("nonexistent_taxon_xyz")
  expect_true(is.na(l[[1]]))

  l2 <- taxon_lineage(c("Haploxeralfs", "invalid"))
  expect_false(is.na(l2[["Haploxeralfs"]]))
  expect_true(is.na(l2[["invalid"]]))
})


test_that("taxon_lineage respects level parameter", {
  l_full <- taxon_lineage("Haploxeralfs", level = "subgroup")
  l_gg <- taxon_lineage("Haploxeralfs", level = "greatgroup")

  expect_equal(length(l_full[[1]]), 4L)   # Soil + Order + Suborder + Great Group
  expect_equal(length(l_gg[[1]]), 3L)     # Soil + Order + Great Group (skip suborder)
})


test_that("shared_taxon_depth returns correct depths", {
  # Same great group: Haploxeralfs and Lithic Mollic Haploxeralfs share to depth 4
  d1 <- shared_taxon_depth("Haploxeralfs", "Lithic Mollic Haploxeralfs")
  expect_equal(d1, 4L)

  # Different orders: Alfisols vs Mollisols → depth 1 (Soils root only)
  d2 <- shared_taxon_depth("Haploxeralfs", "Argiustoll")
  expect_true(is.numeric(d2) && d2 >= 0L)

  # Identical taxa: depth should be full lineage length
  d3 <- shared_taxon_depth("Haploxeralfs", "Haploxeralfs")
  expect_equal(d3, 4L)
})


test_that("shared_taxon_depth recycles vectors", {
  d <- shared_taxon_depth(
    c("Haploxeralfs", "Argiustoll"),
    c("Lithic Mollic Haploxeralfs", "Typic Hapludult")
  )
  expect_equal(length(d), 2L)
})


test_that("shared_taxon_depth handles invalid taxa", {
  d <- shared_taxon_depth("Haploxeralfs", "nonexistent_xyz")
  expect_true(is.na(d))
})


test_that("taxon_distance reciprocal metric works correctly", {
  # Same great group → depth 4 → distance = 1/4 = 0.25
  d1 <- taxon_distance("Haploxeralfs", "Lithic Mollic Haploxeralfs")
  expect_equal(d1, 0.25)

  # Identical taxa → distance = 0
  d2 <- taxon_distance("Haploxeralfs", "Haploxeralfs")
  expect_equal(d2, 0)

  # Different orders → larger distance (smaller shared depth)
  d3 <- taxon_distance("Haploxeralfs", "Argiustoll")
  expect_true(d3 > d1)  # Alfisols vs Mollisols should be more distant
})


test_that("taxon_distance outer product works", {
  taxa <- c("Haploxeralfs", "Argiustoll")
  d <- taxon_distance(taxa, taxa)

  expect_equal(dim(d), c(2L, 2L))
  expect_equal(d[1, 1], 0)   # Haploxeralfs vs itself
  expect_equal(d[2, 2], 0)   # Argiustoll vs itself
  expect_equal(d[1, 2], d[2, 1])  # symmetric
})


test_that("taxon_distance path metric works", {
  taxa <- c("Haploxeralfs", "Lithic Mollic Haploxeralfs")
  d <- taxon_distance(taxa[1], taxa[2], metric = "path")

  # Path = depth(A) + depth(B) - 2*depth(MRCA)
  # For Haploxeralfs (depth 4) and Lithic Mollic Haploxeralfs (depth 5):
  # path = 4 + 5 - 2*4 = 1
  expect_equal(d, 1)
})


test_that("taxon_distance wu_palmer metric works", {
  taxa <- c("Haploxeralfs", "Lithic Mollic Haploxeralfs")
  d <- taxon_distance(taxa[1], taxa[2], metric = "wu_palmer")

  # wu_palmer = 1 - 2*h/(d_A + d_B) = 1 - 2*4/(4+5) = 1 - 8/9 = 1/9
  expected <- 1 - 2 * 4 / (4 + 5)
  expect_equal(d, expected, tolerance = 1e-10)
})


test_that("taxon_distance_matrix returns dist object", {
  taxa <- c("Haploxeralfs", "Lithic Mollic Haploxeralfs", "Argiustoll")
  d <- taxon_distance_matrix(taxa)

  expect_s3_class(d, "dist")
  expect_equal(attr(d, "Size"), 3L)
  expect_equal(dimnames(d)[[1]], taxa)
  expect_equal(dimnames(d)[[2]], taxa)
})


test_that("taxon_distance_matrix diagonal is zero", {
  taxa <- c("Haploxeralfs", "Argiustoll", "Typic Hapludult")
  d_full <- taxon_distance(taxa, taxa)

  for (i in seq_along(taxa)) {
    expect_equal(d_full[i, i], 0)
  }
})


test_that("taxon_tree returns ape phylo object", {
  skip_if_not(requireNamespace("ape", quietly = TRUE))

  taxa <- c("Haploxeralfs", "Lithic Mollic Haploxeralfs")
  tree <- taxon_tree(taxa)

  expect_s3_class(tree, "phylo")
  expect_true(length(tree$tip.label) >= length(taxa))
})


test_that("taxon_distance handles single taxa", {
  d <- taxon_distance("Haploxeralfs", "Lithic Mollic Haploxeralfs")
  expect_equal(length(d), 1L)
  expect_true(is.numeric(d))
})
