# Parse components of a "family-level" taxon name

Parse components of a "family-level" taxon name

## Usage

``` r
parse_family(family, column_metadata = TRUE, flat = TRUE)
```

## Arguments

- family:

  character. vector of taxonomic families, e.g.
  `"fine-loamy, mixed, semiactive, mesic ultic haploxeralfs"`

- column_metadata:

  logical. include parsed NASIS physical column names and values from
  family taxon components? Default: `TRUE` requires soilDB package.

- flat:

  logical Default: `TRUE` to return concatenated family-level classes
  for `"taxminalogy"` and `"taxfamother"`? Alternately, if `FALSE`, list
  columns are returned.

## Value

a `data.frame` containing column names: `"family"` (input), `"subgroup"`
(parsed taxonomic subgroup), `"subgroup_code"` (letter code for
subgroup), `"class_string"` (comma-separated family classes),
`"classes_split"` (split `class_string` vector stored as `list` column).

In addition, the following column names are identified and returned
based on NASIS (National Soil Information System) metadata (via soilDB
package):

- `"taxpartsize"`, `"taxpartsizemod"`, `"taxminalogy"`, `"taxceactcl"`,
  `"taxreaction"`, `"taxtempcl"`, `"taxfamhahatmatcl"`, `"taxfamother"`,
  `"taxsubgrp"`, `"taxgreatgroup"`, `"taxsuborder"`, `"taxorder"`

## Examples

``` r
if (requireNamespace('soilDB')) {
  families <- c("fine, kaolinitic, thermic typic kanhapludults",
                "fine-loamy, mixed, semiactive, mesic ultic haploxeralfs",
                "euic, thermic typic haplosaprists",
                "coarse-loamy, mixed, active, mesic aquic dystrudepts")

  # inspect parsed list result
  str(parse_family(families))
}
#> Loading required namespace: soilDB
#> 'data.frame':    4 obs. of  19 variables:
#>  $ family          : chr  "fine, kaolinitic, thermic typic kanhapludults" "fine-loamy, mixed, semiactive, mesic ultic haploxeralfs" "euic, thermic typic haplosaprists" "coarse-loamy, mixed, active, mesic aquic dystrudepts"
#>  $ taxclname       : chr  "fine, kaolinitic, thermic typic kanhapludults" "fine-loamy, mixed, semiactive, mesic ultic haploxeralfs" "euic, thermic typic haplosaprists" "coarse-loamy, mixed, active, mesic aquic dystrudepts"
#>  $ taxonname       : chr  "typic kanhapludults" "ultic haploxeralfs" "typic haplosaprists" "aquic dystrudepts"
#>  $ subgroup_code   : chr  "HCDN" "JDGR" "BDDH" "KFFK"
#>  $ code            : chr  "HCDN" "JDGR" "BDDH" "KFFK"
#>  $ class_string    : chr  "fine, kaolinitic, thermic" "fine-loamy, mixed, semiactive, mesic" "euic, thermic" "coarse-loamy, mixed, active, mesic"
#>  $ classes_split   :List of 4
#>   ..$ : chr  "fine" "kaolinitic" "thermic"
#>   ..$ : chr  "fine-loamy" "mixed" "semiactive" "mesic"
#>   ..$ : chr  "euic" "thermic"
#>   ..$ : chr  "coarse-loamy" "mixed" "active" "mesic"
#>   ..- attr(*, "class")= chr "AsIs"
#>  $ taxpartsize     : chr  "fine" "fine-loamy" NA "coarse-loamy"
#>  $ taxpartsizemod  : logi  NA NA NA NA
#>  $ taxminalogy     : chr  "kaolinitic" "mixed" NA "mixed"
#>  $ taxceactcl      : chr  NA "semiactive" NA "active"
#>  $ taxreaction     : chr  NA NA "euic" NA
#>  $ taxtempcl       : chr  "thermic" "mesic" "thermic" "mesic"
#>  $ taxfamhahatmatcl: logi  NA NA NA NA
#>  $ taxfamother     : chr  NA NA NA NA
#>  $ taxsubgrp       : chr  "Typic Kanhapludults" "Ultic Haploxeralfs" "Typic Haplosaprists" "Aquic Dystrudepts"
#>  $ taxgrtgroup     : chr  "Kanhapludults" "Haploxeralfs" "Haplosaprists" "Dystrudepts"
#>  $ taxsuborder     : chr  "Udults" "Xeralfs" "Saprists" "Udepts"
#>  $ taxorder        : chr  "Ultisols" "Alfisols" "Histosols" "Inceptisols"
```
