library(fs)
library(SoilTaxonomy)
library(soilDB)
library(data.tree)


## 2023-03-08: new take on ST-tree.R code from many years ago

## TODO:
# * add subgroup acreage
# * 13th ed.
# * compact style of dir_tree(), but in proper order
# * add series count to subgroups

data("ST")

sc <- get_soilseries_from_NASIS()

sc <- sc[, c('soilseriesname', 'taxclname', 'taxsubgrp')]
names(sc) <- c('series', 'family', 'subgroup')

z <- merge(ST, sc, by.x = 'subgroup', all.x = TRUE, sort = FALSE)
head(z)

z$family <- tolower(z$family)
z$series <- tolower(z$series)

z$f <- NA_character_
for(i in 1:nrow(z)) {
  z$f[i] <- gsub(pattern = z$subgroup[i], replacement = '', z$family[i], fixed = TRUE)
}

z$f <- trimws(z$f, which = 'both')

head(z)


# ordering used by 'Keys
z <- z[order(z$code, method = 'radix'), ]


td <- tempdir()
unlink(file.path(td, 'ST'), recursive = TRUE)

for(i in 1:nrow(z)) {
  
  # account for subgroups without series
  if(is.na(z$series[i])) {
    fp <- file.path(
      td, 
      'ST', 
      z$order[i], 
      z$suborder[i], 
      z$greatgroup[i], 
      z$subgroup[i]
    )
  } else {
    fp <- file.path(
      td, 
      'ST', 
      z$order[i], 
      z$suborder[i], 
      z$greatgroup[i], 
      z$subgroup[i], 
      z$f[i], 
      z$series[i]
    ) 
  }
  
  dir.create(path = fp, recursive = TRUE)
}

setwd(td)

sink('e:/temp/st12.txt')
dir_tree(file.path('ST'))
sink()

unlink(file.path(td, 'ST'), recursive = TRUE)



for(i in 1:nrow(z)) {
  
  # account for subgroups without series
  if(is.na(z$series[i])) {
    fp <- file.path(
      td, 
      'ST', 
      sprintf("%s-%s", z$order_code[i], z$order[i]), 
      sprintf("%s-%s", z$suborder_code[i], z$suborder[i]), 
      sprintf("%s-%s", z$greatgroup_code[i], z$greatgroup[i]), 
      sprintf("%s-%s", z$subgroup_code[i], z$subgroup[i])
    )
    
  } else {
    fp <- file.path(
      td, 
      'ST', 
      sprintf("%s-%s", z$order_code[i], z$order[i]), 
      sprintf("%s-%s", z$suborder_code[i], z$suborder[i]), 
      sprintf("%s-%s", z$greatgroup_code[i], z$greatgroup[i]), 
      sprintf("%s-%s", z$subgroup_code[i], z$subgroup[i]), 
      z$f[i], 
      z$series[i]
    )
  }
  
  
  dir.create(path = fp, recursive = TRUE)
}

setwd(td)

sink('e:/temp/st12-codes.txt')
dir_tree(file.path('ST'))
sink()

unlink(file.path(td, 'ST'), recursive = TRUE)




v <- c('order', 'suborder', 'greatgroup', 'subgroup', 'f', 'series', 'path')
z$path <- sprintf("ST/%s/%s/%s/%s/%s/%s", z$order, z$suborder, z$greatgroup, z$subgroup, z$f, z$series)
n <- as.Node(z[, v], pathName = 'path')


# prune missing family / series
pf <- function(i) {
  
  if(GetAttribute(i, 'name') == 'NA') {
    return(FALSE)
  } else {
    return(TRUE)
  }
  
}

options('max.print' = 1e7)
sink('e:/temp/st12-DT.txt')
print(n, limit = NULL, pruneFun = pf)
sink()

options('max.print' = 1000)

