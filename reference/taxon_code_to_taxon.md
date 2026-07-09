# Convert taxon code to taxon name

Convert taxon code to taxon name

## Usage

``` r
taxon_code_to_taxon(code)
```

## Arguments

- code:

  A character vector of Taxon Codes

## Value

A character vector of matching Taxon Names

## See also

[`decompose_taxon_code`](http://ncss-tech.github.io/SoilTaxonomy/reference/decompose_taxon_code.md),
[`preceding_taxon_codes`](http://ncss-tech.github.io/SoilTaxonomy/reference/preceding_taxon_codes.md),
[`taxon_to_taxon_code`](http://ncss-tech.github.io/SoilTaxonomy/reference/taxon_to_taxon_code.md)

## Examples

``` r

taxon_code_to_taxon(c("ABC", "XYZ", "DAB", NA))
#>           ABC           XYZ           DAB          <NA> 
#> "Anhyturbels"            NA  "Cryaquands"            NA 
```
