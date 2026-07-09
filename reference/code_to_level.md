# Determine taxonomic level of a taxonomic letter code

Determine taxonomic level of a taxonomic letter code

## Usage

``` r
code_to_level(code)
```

## Arguments

- code:

  A character vector of taxon codes (case sensitive)

## Value

A character vector containing `"order"`, `"suborder"`, `"greatgroup"` or
`"subgroup"`

## Examples

``` r

# order level code (1 character)
code_to_level("B")
#> [1] "order"

# subgroup level code (4 characters)
code_to_level("ABCD")
#> [1] "subgroup"

# subgroup level code (5 characters, 4 uppercase + 1 lowercase)
code_to_level("IFFZh")
#> [1] "subgroup"
```
