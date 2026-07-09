# Convert taxon name to taxon code

Convert taxon name to taxon code

## Usage

``` r
taxon_to_taxon_code(taxon)
```

## Arguments

- taxon:

  A character vector of taxon names, case insensitive

## Value

A character vector of matching taxon codes

## See also

[`decompose_taxon_code`](http://ncss-tech.github.io/SoilTaxonomy/reference/decompose_taxon_code.md),
[`preceding_taxon_codes`](http://ncss-tech.github.io/SoilTaxonomy/reference/preceding_taxon_codes.md),
[`taxon_code_to_taxon`](http://ncss-tech.github.io/SoilTaxonomy/reference/taxon_code_to_taxon.md)

## Examples

``` r

taxon_to_taxon_code(c("Anhyturbels", "foo", "Cryaquands", NA))
#> Anhyturbels         foo  Cryaquands        <NA> 
#>       "ABC"          NA       "DAB"          NA 
```
