# Decompose taxon letter codes

Find all codes that logically comprise the specified codes. For
instance, code "ABC" ("Anhyturbels") returns "A" ("Gelisols"), "AB"
("Turbels"), "ABC" ("Anhyturbels"). Use in conjunction with a lookup
table that maps Order, Suborder, Great Group and Subgroup taxa to their
codes (see
[`taxon_code_to_taxon`](http://ncss-tech.github.io/SoilTaxonomy/reference/taxon_code_to_taxon.md)
and
[`taxon_to_taxon_code`](http://ncss-tech.github.io/SoilTaxonomy/reference/taxon_to_taxon_code.md)).

## Usage

``` r
decompose_taxon_code(codes)
```

## Arguments

- codes:

  A character vector of taxon codes to "decompose" – case sensitive

## Value

A list with equal length to input vector; one character vector per
element

## Details

Accounts for Keys that run out of capital letters (more than 26
subgroups) and use lowercase letters for a unique subdivision within the
"fourth character position."

## See also

[`preceding_taxon_codes`](http://ncss-tech.github.io/SoilTaxonomy/reference/preceding_taxon_codes.md),
[`taxon_code_to_taxon`](http://ncss-tech.github.io/SoilTaxonomy/reference/taxon_code_to_taxon.md),
[`taxon_to_taxon_code`](http://ncss-tech.github.io/SoilTaxonomy/reference/taxon_to_taxon_code.md)

## Examples

``` r

decompose_taxon_code(c("ABC", "ABCDe", "BCDEf"))
#> $ABC
#> $ABC[[1]]
#> [1] "A"
#> 
#> $ABC[[2]]
#> [1] "AB"
#> 
#> $ABC[[3]]
#> [1] "ABC"
#> 
#> 
#> $ABCDe
#> $ABCDe[[1]]
#> [1] "A"
#> 
#> $ABCDe[[2]]
#> [1] "AB"
#> 
#> $ABCDe[[3]]
#> [1] "ABC"
#> 
#> $ABCDe[[4]]
#> [1] "ABCDe"
#> 
#> 
#> $BCDEf
#> $BCDEf[[1]]
#> [1] "B"
#> 
#> $BCDEf[[2]]
#> [1] "BC"
#> 
#> $BCDEf[[3]]
#> [1] "BCD"
#> 
#> $BCDEf[[4]]
#> [1] "BCDEf"
#> 
#> 
```
