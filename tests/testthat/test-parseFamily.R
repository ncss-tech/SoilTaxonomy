test_that("parse_family works", {
  
  families <- c("fine, kaolinitic, thermic typic kanhapludults",
      "fine-loamy, mixed, semiactive, mesic ultic haploxeralfs",
      "euic, thermic typic haplosaprists",
      "coarse-loamy, mixed, active, mesic aquic dystrudepts",
      "fine, kaolinitic, thermic typic kanhapludults",
      "fine-loamy, mixed, semiactive, mesic ultic haploxeralfs",
      "euic, thermic typic haplosaprists",
      "coarse-loamy, mixed, active, mesic aquic dystrudepts")
  
  res <- parse_family(families)
  
  expect_equal(res$subgroup_code, 
               c("HCDN", "JDGR", "BDDH", "KFFK", 
                 "HCDN", "JDGR", "BDDH", "KFFK"))
})
