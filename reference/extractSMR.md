# Extract Soil Moisture Regime from Subgroup or Higher Level Taxon

Extract Soil Moisture Regime from Subgroup or Higher Level Taxon

## Usage

``` r
extractSMR(taxon, as.is = FALSE, droplevels = FALSE, ordered = TRUE)
```

## Arguments

- taxon:

  character. Vector of taxon names.

- as.is:

  Return character labels rather than an (ordered) factor? Default:
  `FALSE`

- droplevels:

  Drop unused levels? Default: `FALSE`

- ordered:

  Create an ordinal factor? Default: `TRUE`

## Value

an (ordered) factor of Soil Moisture Regimes, or character vector when
`as.is=TRUE`

## Examples

``` r
extractSMR(c("aquic haploxeralfs", "typic epiaqualfs", "humic inceptic eutroperox"))
#>        aquic haploxeralfs          typic epiaqualfs humic inceptic eutroperox 
#>                     xeric                     aquic                   perudic 
#> 7 Levels: aridic (torric) < ustic < xeric < udic < perudic < ... < peraquic
```
