# Parent/Child Hierarchy

Parent/Child Hierarchy

## Usage

``` r
parent_level(level, n = 1)

child_level(level, n = 1)
```

## Arguments

- level:

  character. Initial level name of a taxon. Vectors include values that
  are one of: `"order"`, `"suborder"`, `"greatgroup"`, `"subgroup"`,
  `"family"`

- n:

  Number of levels above/below (parent/child). Default: `1`

## Value

character. Level name of parent or child at specified level above input
`level`.

## Examples

``` r
parent_level('subgroup')
#> [1] "greatgroup"

child_level('greatgroup')
#> [1] "subgroup"

parent_level('family', 3)
#> [1] "suborder"

# no level above order
parent_level('family', 5)
#> [1] NA
```
