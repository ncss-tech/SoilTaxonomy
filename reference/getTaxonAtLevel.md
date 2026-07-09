# Get the taxon name at the Soil Order, Suborder, Great Group or Subgroup level

Get the taxon name at the Soil Order, Suborder, Great Group or Subgroup
level

## Usage

``` r
getTaxonAtLevel(x, level = "order", simplify = TRUE)
```

## Arguments

- x:

  A character vector containing subgroup-level taxonomic names

- level:

  one of `c("order","suborder","greatgroup","subgroup")`

- simplify:

  Return a vector when `level` has length `1`? Default: `TRUE`.
  Otherwise, a data.frame is returned.

## Value

A named character vector of taxa at specified level, where names are the
internal Soil Taxonomy letter codes. When `length(level) > 1`? a
data.frame is returned with column names for each `level`.

## Examples

``` r

# default gets the soil order
getTaxonAtLevel(c("typic haplargids", "typic glacistels")) #, level = "order")
#> typic haplargids typic glacistels 
#>      "aridisols"       "gelisols" 

# specify alternate levels
getTaxonAtLevel("humic haploxerands", level = "greatgroup")
#> humic haploxerands 
#>     "haploxerands" 

# can't get subgroup (child) from great group (parent)
getTaxonAtLevel("udifolists", level = "subgroup")
#> udifolists 
#>         NA 

# but can do parents of children
getTaxonAtLevel("udifolists", level = "suborder")
#> udifolists 
#>  "folists" 

# specify multiple levels (returns a list element for each level)
getTaxonAtLevel("hapludolls", c("order", "suborder", "greatgroup", "subgroup"))
#>                order suborder greatgroup subgroup
#> hapludolls mollisols   udolls hapludolls     <NA>
```
