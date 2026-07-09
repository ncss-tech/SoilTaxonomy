# Order of Hierarchical Levels in Soil Taxonomy

Creates an ordered factor such that different levels (the values used in
`level` arguments to various SoilTaxonomy package functions) in the Soil
Taxonomy hierarchy can be distinguished or compared to one another.

## Usage

``` r
level_hierarchy(
  x = c("order", "suborder", "greatgroup", "subgroup", "family"),
  family = TRUE,
  as.is = FALSE
)
```

## Arguments

- x:

  Passed as input to [`factor()`](https://rdrr.io/r/base/factor.html);
  defaults to full set: `"order"`, `"suborder"`, `"greatgroup"`,
  `"subgroup"`, `"family"`,

- family:

  Allow `"family"` as input in `x`? Used for validating inputs that must
  be a "taxon above family".

- as.is:

  Return `x` "as is" (after validation)? Shorthand for
  `unclass(taxon_hierarchy())` to return simple character vector.

## Value

An ordered factor with the values "order", "suborder", "greatgroup",
"subgroup". or character when `as.is=TRUE`.

## Details

The levels of Soil Taxonomy hierarchy include: `"family"`, `"subgroup"`,
`"greatgroup"`, `"suborder"`, `"order"`. The `"order"` is a level above
`"suborder"`. `"subgroup"` and above are `"taxa above family"`. Note:
`"family"` is always included as the "lowest" level when the result is
an ordered factor, even when family-level input is disallowed by
`family=FALSE`.

## Examples

``` r

# is great group a taxon above family?

level_hierarchy("greatgroup") > "family"
#> [1] TRUE

# is order lower level than suborder?
level_hierarchy("order") < "suborder"
#> [1] FALSE

# what levels are above or equal to a particular taxon's level?
level_hierarchy(as.is = TRUE)[level_hierarchy() >= taxon_to_level("aquisalids")]
#> [1] "order"      "suborder"   "greatgroup"

## this produces an error (used for checking for taxa above family)
# level_hierarchy("family", family = FALSE)
```
