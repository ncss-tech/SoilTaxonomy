# Get Taxon Criteria from the Keys to Soil Taxonomy

Get Taxon Criteria from the Keys to Soil Taxonomy

## Usage

``` r
getTaxonCriteria(
  taxon = NULL,
  code = NULL,
  level = c("order", "suborder", "greatgroup", "subgroup")
)
```

## Arguments

- taxon:

  *character*. Vector of taxon names (order to subgroup level). These
  values are converted to taxon "codes"

- code:

  *character*. Vector of taxon codes.

- level:

  *character*. One or more of: "order", "suborder", "greatgroup",
  "subgroup"

## Value

A named list. Each list element is named based on the input value
(either `taxon` or `code`) and contains a data.frame derived from
dataset ST_criteria_13th.

## See also

[`taxon_to_taxon_code()`](http://ncss-tech.github.io/SoilTaxonomy/reference/taxon_to_taxon_code.md),
[ST_criteria_13th](http://ncss-tech.github.io/SoilTaxonomy/reference/ST_criteria_13th.md)

## Examples

``` r
getTaxonCriteria(c("mollic haplocryalfs", "abruptic durixeralfs"))
#> $`mollic haplocryalfs`
#>                                                                                                                                                                                                                                                content
#> 1                                                                                                                                                                             J. Other soils that do not have a plaggen epipedon and that have either:
#> 2                                                                                                                                                                                                        1. An argillic, kandic, or natric horizon; or
#> 3                                                                                                                                                                                   2. A fragipan that has clay films 1 mm or more thick in some part.
#> 4                                                                                                                                                                                                                                      Alfisols, p. 73
#> 5                                                                                                                                                                           JB. Other Alfisols that have a cryic or isofrigid soil temperature regime.
#> 6                                                                                                                                                                                                                                       Cryalfs, p. 82
#> 7                                                                                                                                                                                                                                  JBC. Other Cryalfs.
#> 8                                                                                                                                                                                                                                  Haplocryalfs, p. 83
#> 9                                                                                                                                                                                                             JBCO. Other Haplocryalfs that have both:
#> 10 1. A color value, moist, of 3 or less and a color value, dry, of 5 or less (crushed and smoothed sample) either throughout the upper 18 cm of the mineral soil (unmixed) or between the mineral soil surface and a depth of 18 cm after mixing; and
#> 11                                                       2. A base saturation (by NH4 OAc) of 50 percent ormore in all parts from the mineral soil surface to a depth of 180 cm or to a densic, lithic, or paralithic contact, whichever is shallower.
#> 12                                                                                                                                                                                                                                 Mollic Haplocryalfs
#>    chapter page                 key        taxon code clause logic
#> 1        4   70  Key to Soil Orders            *    J      1    OR
#> 2        4   70  Key to Soil Orders            *    J      2    OR
#> 3        4   70  Key to Soil Orders            *    J      3   END
#> 4        4   70  Key to Soil Orders            *    J      4   NEW
#> 5        5   73    Key to Suborders     Alfisols   JB      1 FIRST
#> 6        5   73    Key to Suborders     Alfisols   JB      2  LAST
#> 7        5   82 Key to Great Groups      Cryalfs  JBC      1 FIRST
#> 8        5   82 Key to Great Groups      Cryalfs  JBC      2  LAST
#> 9        5   85    Key to Subgroups Haplocryalfs JBCO      1   AND
#> 10       5   85    Key to Subgroups Haplocryalfs JBCO      2   AND
#> 11       5   85    Key to Subgroups Haplocryalfs JBCO      3   END
#> 12       5   85    Key to Subgroups Haplocryalfs JBCO      4  LAST
#> 
#> $`abruptic durixeralfs`
#>                                                                                                                                                                                                                                                                                       content
#> 1                                                                                                                                                                                                                    J. Other soils that do not have a plaggen epipedon and that have either:
#> 2                                                                                                                                                                                                                                               1. An argillic, kandic, or natric horizon; or
#> 3                                                                                                                                                                                                                          2. A fragipan that has clay films 1 mm or more thick in some part.
#> 4                                                                                                                                                                                                                                                                             Alfisols, p. 73
#> 5                                                                                                                                                                                                                                  JD. Other Alfisols that have a xeric soil moisture regime.
#> 6                                                                                                                                                                                                                                                                             Xeralfs, p. 109
#> 7                                                                                                                                                                                                                 JDA. Xeralfs that have a duripan within 100 cm of the mineral soil surface.
#> 8                                                                                                                                                                                                                                                                         Durixeralfs, p. 110
#> 9                                                                              JDAE. Other Durixeralfs that have an argillic horizon that has 35 percent or more noncarbonate clay throughout one or more subhorizons totaling 7.5 cm or more in thickness, and one or both of the following:
#> 10 1. A clay increase of 20 percent or more (absolute, in the fine-earth fraction) within a vertical distance of 7.5 cm or of 15 percent or more (absolute, in the fine-earth fraction) within a vertical distance of 2.5 cm, either within the argillic horizon or at its upper boundary; or
#> 11                                                                                                                                                                                   2. An abrupt textural change between the eluvial horizon and the upper boundary of the argillic horizon.
#> 12                                                                                                                                                                                                                                                                       Abruptic Durixeralfs
#>    chapter page                 key       taxon code clause logic
#> 1        4   70  Key to Soil Orders           *    J      1    OR
#> 2        4   70  Key to Soil Orders           *    J      2    OR
#> 3        4   70  Key to Soil Orders           *    J      3   END
#> 4        4   70  Key to Soil Orders           *    J      4   NEW
#> 5        5   73    Key to Suborders    Alfisols   JD      1 FIRST
#> 6        5   73    Key to Suborders    Alfisols   JD      2  LAST
#> 7        5  109 Key to Great Groups     Xeralfs  JDA      1 FIRST
#> 8        5  109 Key to Great Groups     Xeralfs  JDA      2  LAST
#> 9        5  110    Key to Subgroups Durixeralfs JDAE      1   AND
#> 10       5  110    Key to Subgroups Durixeralfs JDAE      2    OR
#> 11       5  110    Key to Subgroups Durixeralfs JDAE      3   END
#> 12       5  110    Key to Subgroups Durixeralfs JDAE      4  LAST
#> 

getTaxonCriteria(code = "ABC", level = c("greatgroup"))
#> $ABC
#>                                              content chapter page
#> 1 ABC. Other Turbels that have anhydrous conditions.       9  195
#> 2                                Anhyturbels, p. 196       9  195
#>                   key   taxon code clause logic
#> 1 Key to Great Groups Turbels  ABC      1 FIRST
#> 2 Key to Great Groups Turbels  ABC      2  LAST
#> 
```
