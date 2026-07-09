# Lookup Pre-calculated Soil Moisture Regimes by Taxon

Helper function for using latest version of the Keys to Soil Taxonomy
standard lookup table for soil moisture information.

## Usage

``` r
getTaxonSMR(
  taxon = NULL,
  code = NULL,
  as.is = FALSE,
  droplevels = FALSE,
  ordered = TRUE
)
```

## Arguments

- taxon:

  *character*. Vector of taxon names (order to subgroup level). These
  values are converted to taxon "codes"

- code:

  *character*. Vector of taxon codes.

- as.is:

  *logical*. Return character labels rather than an (ordered) factor?
  Default: `FALSE`

- droplevels:

  *logical*. Drop unused levels? Default: `FALSE`

- ordered:

  *logical*. Create an ordinal factor? Default: `TRUE`

## Value

*character* or *factor* (when as.is=FALSE) containing soil moisture
regime labels extracted from 13th edition Keys to Soil Taxonomy taxa
using
[`extractSMR()`](http://ncss-tech.github.io/SoilTaxonomy/reference/extractSMR.md)

## See also

[`extractSMR()`](http://ncss-tech.github.io/SoilTaxonomy/reference/extractSMR.md)
[ST_SMR_13th](http://ncss-tech.github.io/SoilTaxonomy/reference/ST_SMR_13th.md)

## Examples

``` r
getTaxonSMR(c("aridisols", "haploxeralfs", NA, "abruptic durixeralfs", "ustic haplocryalfs"))
#>            aridisols         haploxeralfs                 <NA> 
#>      aridic (torric)                xeric                 <NA> 
#> abruptic durixeralfs   ustic haplocryalfs 
#>                xeric                ustic 
#> 7 Levels: aridic (torric) < ustic < xeric < udic < perudic < ... < peraquic
```
