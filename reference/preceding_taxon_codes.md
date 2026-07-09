# Get taxon codes of preceding taxa

Find all codes that logically precede the specified codes. For instance,
code "ABC" ("Anhyturbels") returns "AA" ("Histels") "ABA"
("Histoturbels") and "ABB" ("Aquiturbels"). Use in conjunction with a
lookup table that maps Order, Suborder, Great Group and Subgroup taxa to
their codes (see
[`taxon_code_to_taxon`](http://ncss-tech.github.io/SoilTaxonomy/reference/taxon_code_to_taxon.md)
and
[`taxon_to_taxon_code`](http://ncss-tech.github.io/SoilTaxonomy/reference/taxon_to_taxon_code.md)).

## Usage

``` r
preceding_taxon_codes(codes)
```

## Arguments

- codes:

  A character vector of codes to calculate preceding codes for

## Value

A list with equal length to input vector; one character vector per
element

## Details

Accounts for Keys that run out of capital letters (more than 26
subgroups) and use lowercase letters for a unique subdivision within the
"fourth character position."

## See also

[`decompose_taxon_code`](http://ncss-tech.github.io/SoilTaxonomy/reference/decompose_taxon_code.md),
[`taxon_code_to_taxon`](http://ncss-tech.github.io/SoilTaxonomy/reference/taxon_code_to_taxon.md),
[`taxon_to_taxon_code`](http://ncss-tech.github.io/SoilTaxonomy/reference/taxon_to_taxon_code.md)

## Examples

``` r

preceding_taxon_codes(c("ABCDe", "BCDEf"))
#> $ABCDe
#>  [1] "AA"    "ABA"   "ABB"   "ABCA"  "ABCB"  "ABCC"  "ABCD"  "ABCDa" "ABCDb"
#> [10] "ABCDc" "ABCDd" "ABCDe"
#> 
#> $BCDEf
#>  [1] "A"     "BA"    "BB"    "BCA"   "BCB"   "BCC"   "BCDA"  "BCDB"  "BCDC" 
#> [10] "BCDD"  "BCDE"  "BCDEa" "BCDEb" "BCDEc" "BCDEd" "BCDEe" "BCDEf"
#> 
```
