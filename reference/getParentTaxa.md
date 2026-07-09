# Get the higher (parent) taxa for a taxon name or code

Must specify either `taxon` or `code`. `taxon` is used if both are
specified.

## Usage

``` r
getParentTaxa(
  taxon = NULL,
  code = NULL,
  convert = TRUE,
  level = c("order", "suborder", "greatgroup", "subgroup")
)
```

## Arguments

- taxon:

  A character vector of taxa (case-insensitive)

- code:

  A character vector of taxon codes (case sensitive)

- convert:

  Convert results from taxon codes to taxon names? Default: `TRUE`

- level:

  level Filter results to specific level? Default:
  `"order"`,`"suborder"`,`"greatgroup"`,`"subgroup"`

## Value

A named list, where names are taxon codes and values are character
vectors representing parent taxa

## Examples

``` r

getParentTaxa("ultic haploxeralfs")
#> $`ultic haploxeralfs`
#>              J             JD            JDG 
#>     "Alfisols"      "Xeralfs" "Haploxeralfs" 
#> 

getParentTaxa(code = c("ABCD", "DABC"))
#> $ABCD
#>             A            AB           ABC 
#>    "Gelisols"     "Turbels" "Anhyturbels" 
#> 
#> $DABC
#>            D           DA          DAB 
#>   "Andisols"    "Aquands" "Cryaquands" 
#> 

getParentTaxa("folists", convert = FALSE)
#> $folists
#> [1] "B"
#> 
```
