# Identify formative elements in taxon names at Soil Order, Suborder, Great Group or Subgroup level

Identify formative elements in taxon names at Soil Order, Suborder,
Great Group or Subgroup level

## Usage

``` r
FormativeElements(x, level = c("order", "suborder", "greatgroup", "subgroup"))

OrderFormativeElements(x)

SubOrderFormativeElements(x)

GreatGroupFormativeElements(x)

SubGroupFormativeElements(x)

get_ST_formative_elements(
  level = c("order", "suborder", "greatgroup", "subgroup")
)
```

## Arguments

- x:

  A character vector containing subgroup-level taxonomic names

- level:

  one of `c("order","suborder","greatgroup","subgroup")`

## Value

A list containing `$defs`: a `data.frame` containing taxonomic elements,
derivations, connotations and links. And `$char.index`: a numeric
denoting the position where the formative element occurs in the search
text `x`

`get_ST_formative_elements()`: a data.frame containing descriptors of
formative elements used at the specified `level`

## Author

D.E. Beaudette, A.G. Brown

## Examples

``` r

FormativeElements("acrudoxic plinthic kandiudults", level = "subgroup")
#> $defs
#>     element central intergrade extragrade intragrade derivation
#> 1 acrudoxic   FALSE         NA         NA       TRUE    acrudox
#> 2  plinthic   FALSE         NA         NA      FALSE      brick
#>                                            connotation simplified link    level
#> 1 low apparent cation exchange capacity (like acrudox)              NA subgroup
#> 2                                presence of plinthite              NA subgroup
#> 
#> $char.index
#> [1]  1 11
#> 
SubGroupFormativeElements("acrudoxic plinthic kandiudults")
#> $defs
#>     element central intergrade extragrade intragrade derivation
#> 1 acrudoxic   FALSE         NA         NA       TRUE    acrudox
#> 2  plinthic   FALSE         NA         NA      FALSE      brick
#>                                            connotation simplified link    level
#> 1 low apparent cation exchange capacity (like acrudox)              NA subgroup
#> 2                                presence of plinthite              NA subgroup
#> 
#> $char.index
#> [1]  1 11
#> 

FormativeElements("acrudoxic plinthic kandiudults", level = "greatgroup")
#> $defs
#>   element            derivation                  connotation simplified link
#> 1   kandi modified from kandite presence of a kandic horizon         NA   NA
#>        level
#> 1 greatgroup
#> 
#> $char.index
#> [1] 20
#> 
GreatGroupFormativeElements("acrudoxic plinthic kandiudults")
#> $defs
#>   element            derivation                  connotation simplified link
#> 1   kandi modified from kandite presence of a kandic horizon         NA   NA
#>        level
#> 1 greatgroup
#> 
#> $char.index
#> [1] 20
#> 

FormativeElements("acrudoxic plinthic kandiudults", level = "suborder")
#> $defs
#>   element derivation               connotation simplified link    level
#> 1      ud      humid udic soil moisture regime         NA   NA suborder
#> 
#> $char.index
#> [1] 25
#> 
SubOrderFormativeElements("acrudoxic plinthic kandiudults")
#> $defs
#>   element derivation               connotation simplified link    level
#> 1      ud      humid udic soil moisture regime         NA   NA suborder
#> 
#> $char.index
#> [1] 25
#> 

FormativeElements("acrudoxic plinthic kandiudults", level = "order")
#> $defs
#>      order element derivation
#> 1 ultisols    ults       last
#>                                                                                         connotation
#> 1 soils with an argillic or kandic horizon and a base saturation at pH 8.2 <35% at a depth of 180cm
#>   simplified link element_start element_end level
#> 1         NA   NA             1           3 order
#> 
#> $char.index
#> [1] 27
#> 
OrderFormativeElements("acrudoxic plinthic kandiudults")
#> $defs
#>      order element derivation
#> 1 ultisols    ults       last
#>                                                                                         connotation
#> 1 soils with an argillic or kandic horizon and a base saturation at pH 8.2 <35% at a depth of 180cm
#>   simplified link element_start element_end level
#> 1         NA   NA             1           3 order
#> 
#> $char.index
#> [1] 27
#> 
```
