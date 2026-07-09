# Get all taxa at specified level

Convenience method for getting taxa from `ST_unique_list`

## Usage

``` r
level_to_taxon(level = c("order", "suborder", "greatgroup", "subgroup"))
```

## Arguments

- level:

  character. One or more of "order", "suborder", "greatgroup",
  "subgroup"

## Value

A character vector of taxa at the specified level

## Examples

``` r

# get all order and suborder level taxa

level_to_taxon(level = c("order","suborder"))
#>  [1] "gelisols"    "histosols"   "spodosols"   "andisols"    "oxisols"    
#>  [6] "vertisols"   "aridisols"   "ultisols"    "mollisols"   "alfisols"   
#> [11] "inceptisols" "entisols"    "histels"     "turbels"     "orthels"    
#> [16] "folists"     "wassists"    "fibrists"    "saprists"    "hemists"    
#> [21] "aquods"      "gelods"      "cryods"      "humods"      "orthods"    
#> [26] "aquands"     "gelands"     "cryands"     "torrands"    "xerands"    
#> [31] "vitrands"    "ustands"     "udands"      "aquox"       "torrox"     
#> [36] "ustox"       "perox"       "udox"        "aquerts"     "cryerts"    
#> [41] "xererts"     "torrerts"    "usterts"     "uderts"      "cryids"     
#> [46] "salids"      "durids"      "gypsids"     "argids"      "calcids"    
#> [51] "cambids"     "aquults"     "humults"     "udults"      "ustults"    
#> [56] "xerults"     "albolls"     "aquolls"     "rendolls"    "gelolls"    
#> [61] "cryolls"     "xerolls"     "ustolls"     "udolls"      "aqualfs"    
#> [66] "cryalfs"     "ustalfs"     "xeralfs"     "udalfs"      "aquepts"    
#> [71] "gelepts"     "cryepts"     "ustepts"     "xerepts"     "udepts"     
#> [76] "wassents"    "aquents"     "psamments"   "fluvents"    "orthents"   
```
