# Get last child taxon in Keys at specified taxonomic level

Get last child taxon in Keys at specified taxonomic level

## Usage

``` r
getLastChildTaxon(level = c("order", "suborder", "greatgroup"))
```

## Arguments

- level:

  Get child taxa from keys at specified level. One of: `"order"`,
  `"suborder"`, `"greatgroup"`

## Value

A `data.frame` containing `key` (parent key), `taxon` (last taxon name),
`code` (letter code), `position` (relative taxon position)

## Examples

``` r

# get last taxa in suborder-level keys
x <- getLastChildTaxon(level = "suborder")

# proportion of keys where last taxon has "Hap" formative element
prop.table(table(grepl("^Hap", x$taxon)))
#> 
#> FALSE  TRUE 
#>  0.25  0.75 
```
