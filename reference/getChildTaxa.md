# Get the lower (child) taxa for a taxon name or code

Get the lower (child) taxa for a taxon name or code

## Usage

``` r
getChildTaxa(
  taxon = NULL,
  code = NULL,
  convert = TRUE,
  level = c("order", "suborder", "greatgroup", "subgroup")
)
```

## Arguments

- taxon:

  A character vector of taxa (case-insensitive)

- code:

  A character vector of taxon codes (case sensitive)

- convert:

  Convert results from taxon codes to taxon names? Default: TRUE

- level:

  Filter results to specific level? Default:
  `"order"`,`"suborder"`,`"greatgroup"`,`"subgroup"`

## Value

A named list, where names are taxon codes and values are character
vectors representing parent taxa

## Examples

``` r

# suborder children of "Mollisols"
getChildTaxa("Mollisols", level = "suborder")
#> $Mollisols
#>         IA         IB         IC         ID         IE         IF         IG 
#>  "Albolls"  "Aquolls" "Rendolls"  "Gelolls"  "Cryolls"  "Xerolls"  "Ustolls" 
#>         IH 
#>   "Udolls" 
#> 

# get all children within a great group, given a subgroup
getChildTaxa(getTaxonAtLevel("Ultic Haploxeralfs", "greatgroup"))
#> $haploxeralfs
#>                                  JDGA                                  JDGB 
#>          "Lithic Mollic Haploxeralfs" "Lithic Ruptic-Inceptic Haploxeralfs" 
#>                                  JDGC                                  JDGD 
#>                 "Lithic Haploxeralfs"                 "Vertic Haploxeralfs" 
#>                                  JDGE                                  JDGF 
#>               "Aquandic Haploxeralfs"                  "Andic Haploxeralfs" 
#>                                  JDGG                                  JDGH 
#>              "Vitrandic Haploxeralfs"             "Fragiaquic Haploxeralfs" 
#>                                  JDGI                                  JDGJ 
#>               "Aquultic Haploxeralfs"                  "Aquic Haploxeralfs" 
#>                                  JDGK                                  JDGL 
#>                 "Natric Haploxeralfs"                 "Fragic Haploxeralfs" 
#>                                  JDGM                                  JDGN 
#>               "Lamellic Haploxeralfs"             "Psammentic Haploxeralfs" 
#>                                  JDGO                                  JDGP 
#>               "Plinthic Haploxeralfs"                 "Calcic Haploxeralfs" 
#>                                  JDGQ                                  JDGR 
#>               "Inceptic Haploxeralfs"                  "Ultic Haploxeralfs" 
#>                                  JDGS                                  JDGT 
#>                 "Mollic Haploxeralfs"                  "Typic Haploxeralfs" 
#> 
```
