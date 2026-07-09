# Determine relative position of taxon within Keys to Soil Taxonomy (Order to Subgroup)

The relative position of a taxon is
`[number of preceding Key steps] + 1`, or `NA` if it does not exist in
the lookup table.

## Usage

``` r
relative_taxon_code_position(code)
```

## Arguments

- code:

  A character vector of taxon codes to determine the relative position
  of.

## Value

A numeric vector with the relative position of each code with respect to
their individual Keys.

## Examples

``` r

# "ABCD" -> "Gypsic Anhyturbels", relative position 7
# "WXYZa" does not exist, theoretical position is 97
# "BAD" -> "Udifolists", relative position is 5

relative_taxon_code_position(c("ABCD", "WXYZa", "BAD"))
#>  ABCD WXYZa   BAD 
#>     7    NA     5 

# [1]  7 NA  5
```
