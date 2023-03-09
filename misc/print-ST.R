library(fs)
library(SoilTaxonomy)
library(soilDB)
library(data.tree)


## 2023-03-08: new take on ST-tree.R code from many years ago

## TODO:
# * add subgroup acreage
# * 13th ed.
# * add series count to subgroups

# 12th ed.
data("ST")

# latest SC DB
sc <- get_soilseries_from_NASIS()

# susbet / rename columns for simpler joining
sc <- sc[, c('soilseriesname', 'taxclname', 'taxsubgrp')]
names(sc) <- c('series', 'family', 'subgroup')

# combine ST hierarchy + series by subgroup
# this will introduct family details
z <- merge(ST, sc, by.x = 'subgroup', all.x = TRUE, sort = FALSE)
head(z)

# normalization via lower case
z$family <- tolower(z$family)
z$series <- tolower(z$series)

# remove subgroup component of family spec
z$f <- NA_character_
for(i in 1:nrow(z)) {
  z$f[i] <- gsub(pattern = z$subgroup[i], replacement = '', z$family[i], fixed = TRUE)
}

# remove white space
z$f <- trimws(z$f, which = 'both')

# ok
head(z)


# ordering used by 'Keys
z <- z[order(z$code, method = 'radix'), ]

## hack #1: use directory listing for a compact representation
# note: order isn't correct
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


# dump output file text file
setwd(td)

sink('e:/temp/st12.txt')
dir_tree(file.path('ST'))
sink()

# cleanup
unlink(file.path(td, 'ST'), recursive = TRUE)


## hack #2: use directory listing for a compact representation
##          prefix with taxon codes for correct ordering
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

# save output to text file
setwd(td)

sink('e:/temp/st12-codes.txt')
dir_tree(file.path('ST'))
sink()

# cleanup
unlink(file.path(td, 'ST'), recursive = TRUE)



## correct ordering via data.tree, as long as order of `z` is correct
# less compact, but doesn't require crazy file system manipulation

# required columns only, smaller data.tree
v <- c('order', 'suborder', 'greatgroup', 'subgroup', 'f', 'series', 'path')

# init data.tree object
z$path <- sprintf("ST/%s/%s/%s/%s/%s/%s", z$order, z$suborder, z$greatgroup, z$subgroup, z$f, z$series)
n <- as.Node(z[, v], pathName = 'path')

## missing family / series result in an ugly tree, prune accordingly

# prune missing family / series
pf <- function(i) {
  
  # NA due to left join
  # note odd approach required, matching to 'NA' vs. is.na()
  if(GetAttribute(i, 'name') == 'NA') {
    return(FALSE)
  } else {
    return(TRUE)
  }
  
}

# dump to text file
options('max.print' = 1e7)
sink('e:/temp/st12-DT.txt')
print(n, limit = NULL, pruneFun = pf)
sink()

options('max.print' = 1000)



