# Determine taxonomic level of specified taxa

Taxa that resolve to a subgroup level taxon and contain a comma `","`
are assumed to be `"family"`-level.

## Usage

``` r
taxon_to_level(taxon)
```

## Arguments

- taxon:

  character vector of taxon names at Order, Suborder, Great Group or
  Subgroup level.

## Value

character of taxonomic hierarchy levels (such as "order", "suborder",
"greatgroup", "subgroup", "family") for each element of input vector.

## Examples

``` r

# get the taxonomic levels for various taxa

taxon_to_level(c("gelisols", NA, "foo", "typic folistels", "folistels"))
#> [1] "order"      NA           NA           "subgroup"   "greatgroup"
```
