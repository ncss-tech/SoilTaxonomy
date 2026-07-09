# Taxon Letter Codes in Soil Taxonomy

There are four different “levels” of the hierarchy in Soil Taxonomy that
are represented by letter codes:

- Soil Order
- Suborder
- Great Group
- Subgroup

In the *SoilTaxonomy* package the `level` argument is used by some
functions to specify output for a target level within the hierarchy.
Other functions determine `level` by comparison against known taxa or
codes. This vignette covers the basics of how taxon letter code
conversion to and from taxonomic names is implemented.

``` r

library(SoilTaxonomy)
```

## `taxon_to_taxon_code()`

[`taxon_to_taxon_code()`](http://ncss-tech.github.io/SoilTaxonomy/reference/taxon_to_taxon_code.md)
converts a taxon name (Soil Order, Suborder, Great Group, or Subgroup)
to a letter code that corresponds to the logical position of that taxon
in the Keys to Soil Taxonomy.

*Gelisols* are the first Soil Order to key out and are given letter code
“A”

``` r

taxon_to_taxon_code("gelisols")
#> gelisols 
#>      "A"
```

The number of letters in a taxon code corresponds to the `level` of that
taxon. *Histels* are the first Suborder to key out in the *Gelisols* key
(**A**), so they are given two letter code “AA”

``` r

taxon_to_taxon_code("histels")
#> histels 
#>    "AA"
```

For each “step” in each key, the letter codes are “incremented” by one.

*Glacistels* are the *second* Great Group in the *Histels* key (**AA**),
so they have the three letter code “AAB”.

``` r

taxon_to_taxon_code("glacistels")
#> glacistels 
#>      "AAB"
```

*Typic* subgroups, by convention, are the last subgroup to key out in a
Great Group.

``` r

taxon_to_taxon_code("typic glacistels")
#> typic glacistels 
#>           "AABC"
```

Since *Typic Glacistels* have code `"AABC"` we can infer that there are
three taxa in the *Glacistels* key with codes `"AABA"`, `"AABB"` and
`"AABC"`

This follows for Great Groups with many more subgroups. In case a Great
Group has more than 26 subgroups within it, a fifth lowercase letter
code is used to “extend” the ability to increment the code beyond 26.

An example of where this is needed is in the *Haploxerolls* key where
the *Typic* subgroup has code `"IFFZh"`.

``` r

taxon_to_taxon_code("typic haploxerolls")
#> typic haploxerolls 
#>            "IFFZh"
```

From this code we infer that the *Haploxerolls* key has $`26+8=34`$
subgroups corresponding to the range from `IFFA` to `IFFZ` *plus*
`IFFZa` to `IFFZh`.

## `taxon_code_to_taxon()`

We can use a vector of letter codes to do the inverse operation with
[`taxon_code_to_taxon()`](http://ncss-tech.github.io/SoilTaxonomy/reference/taxon_code_to_taxon.md).

Above we determined the *Glacistels* Key contains three taxa with codes
`"AABA"`, `"AABB"` and `"AABC"`. Let’s convert those codes to taxon
names.

``` r

taxon_code_to_taxon(c("AABA", "AABB", "AABC"))
#>                AABA                AABB                AABC 
#>  "Hemic Glacistels" "Sapric Glacistels"  "Typic Glacistels"
```

## `taxon_to_level()`

We can infer from the length of the four-letter codes that all of the
above are subgroup-level taxa.
[`taxon_to_level()`](http://ncss-tech.github.io/SoilTaxonomy/reference/taxon_to_level.md)
confirms this.

``` r

taxon_to_level(c("Hemic Glacistels","Sapric Glacistels","Typic Glacistels"))
#> [1] "subgroup" "subgroup" "subgroup"
```

[`taxon_to_level()`](http://ncss-tech.github.io/SoilTaxonomy/reference/taxon_to_level.md)
can also identify a fifth (lower-level) *family* tier
(`level="family"`). Soil family differentiae are not handled in the
Order to Subgroup keys. Family names are defined by concatenating
comma-separated class names on to the subgroup. Classes used in family
names are determined by specific keys and apply variably depending on
the subgroup-level taxonomy.

For instance, the soil family
`"Fine, mixed, semiactive, mesic Ultic Haploxeralfs"` includes a
particle-size class (`"fine"`), a mineralogy class (`"mixed"`), a cation
exchange capacity (CEC) activity class (`"semiactive"`) and a
temperature class (`"mesic"`)

``` r

taxon_to_level("Fine, mixed, semiactive, mesic Ultic Haploxeralfs")
#> [1] "family"
```

## `getTaxonAtLevel()`

A wrapper method around taxon letter code functionality is
[`getTaxonAtLevel()`](http://ncss-tech.github.io/SoilTaxonomy/reference/getTaxonAtLevel.md).

Say that you have family-level taxon above and you want to determine the
taxonomy at a higher (less detailed) level. You can determine what to
remove (family and subgroup-level modifiers) to get the Great Group
using `getTaxonAtLevel(level="greatgroup")`

``` r

getTaxonAtLevel("Fine, mixed, semiactive, mesic Ultic Haploxeralfs", level = "greatgroup")
#> Fine, mixed, semiactive, mesic Ultic Haploxeralfs 
#>                                    "haploxeralfs"
```

If you request a more-detailed taxonomic level than what you start with,
you will get an `NA` result.

For example, we request the subgroup from suborder (`"Folists"`) level
taxon name which is undefined.

``` r

getTaxonAtLevel("Folists", level = "subgroup")
#> Folists 
#>      NA
```

## `getParentTaxa()`

Another wrapper method around taxon letter code functionality is
[`getParentTaxa()`](http://ncss-tech.github.io/SoilTaxonomy/reference/getParentTaxa.md).
This function will enumerate the tiers above a particular taxon.

``` r

getParentTaxa("Fine, mixed, semiactive, mesic Ultic Haploxeralfs")
#> $`Fine, mixed, semiactive, mesic Ultic Haploxeralfs`
#>                    J                   JD                  JDG 
#>           "Alfisols"            "Xeralfs"       "Haploxeralfs" 
#>                 JDGR 
#> "Ultic Haploxeralfs"
```

You can alternately specify `code` argument instead of `taxon`.

``` r

getParentTaxa(code = "BAB")
#> $BAB
#>           B          BA 
#> "Histosols"   "Folists"
```

And converting the internally used taxon codes to taxon names can be
disabled with `convert = FALSE`. This may be useful for certain
applications.

``` r

getParentTaxa(code = c("BAA","BAB"), convert = FALSE)
#> $BAA
#> [1] "B"  "BA"
#> 
#> $BAB
#> [1] "B"  "BA"
```

## `decompose_taxon_code()`

For more general cases
[`decompose_taxon_code()`](http://ncss-tech.github.io/SoilTaxonomy/reference/decompose_taxon_code.md)
might be useful. This is a function used by many of the above methods
that returns a nested list result containing the letter code hierarchy.

``` r

decompose_taxon_code(c("BAA","BAB"))
#> $BAA
#> $BAA[[1]]
#> [1] "B"
#> 
#> $BAA[[2]]
#> [1] "BA"
#> 
#> $BAA[[3]]
#> [1] "BAA"
#> 
#> 
#> $BAB
#> $BAB[[1]]
#> [1] "B"
#> 
#> $BAB[[2]]
#> [1] "BA"
#> 
#> $BAB[[3]]
#> [1] "BAB"
```

## `preceding_taxon_codes()` and `relative_taxon_code_position()`

Other functions useful for comparing relative positions within Keys, or
the number of “steps” that it takes to reach a particular taxon, are
[`preceding_taxon_codes()`](http://ncss-tech.github.io/SoilTaxonomy/reference/preceding_taxon_codes.md)
and
[`relative_taxon_code_position()`](http://ncss-tech.github.io/SoilTaxonomy/reference/relative_taxon_code_position.md).

[`preceding_taxon_codes()`](http://ncss-tech.github.io/SoilTaxonomy/reference/preceding_taxon_codes.md)
returns a list of vectors containing all preceding codes.

For example, the `AA` suborder key precedes `AB`. And within the `AB`
key `ABA` and `ABB` precede `ABC`.

``` r

preceding_taxon_codes("ABC")
#> $ABC
#> [1] "AA"  "ABA" "ABB"
```

[`relative_taxon_code_position()`](http://ncss-tech.github.io/SoilTaxonomy/reference/relative_taxon_code_position.md)
counts how many taxa key out before a taxon plus $`1`$ (to get *the*
taxon position).

``` r

relative_taxon_code_position(c("A","AA","AAA","AAAA",
                               "AB","AAB","ABA","ABC",
                               "B","BA","BAA","BAB",
                               "BBA","BBB","BBC"))
#>    A   AA  AAA AAAA   AB  AAB  ABA  ABC    B   BA  BAA  BAB  BBA  BBB  BBC 
#>    1    1    1    1    2    2    2    4    2    2    2    3    3    4    5
```
