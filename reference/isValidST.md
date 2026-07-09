# Check for valid taxonomic level (Order, Suborder, Great Group, Subgroup)

Checks `needle` for matches against a single level of Soil Taxonomy
hierarchy: `order`, `suborder`, `greatgroup`, `subgroup`. Matches are
case-insensitive.

## Usage

``` r
isValidST(needle, level = c("order", "suborder", "greatgroup", "subgroup"))
```

## Arguments

- needle:

  vector of taxa

- level:

  single level of Soil Taxonomy hierarchy; one of: `"order"`,
  `"suborder"`, `"greatgroup"`, `"subgroup"`

## Value

`logical` vector, same length as needle

## Examples

``` r

isValidST('typic haploxeralfs', level = 'subgroup')
#> [1] TRUE
```
