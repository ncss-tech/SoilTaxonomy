# Get (Ordered) Factors based on Soil Taxonomy Key position

Get (Ordered) Factors based on Soil Taxonomy Key position

## Usage

``` r
SoilTaxonomyLevels(
  level = c("order", "suborder", "greatgroup", "subgroup"),
  as.is = FALSE,
  ordered = TRUE
)

SoilMoistureRegimeLevels(as.is = FALSE, ordered = TRUE)

SoilTemperatureRegimeLevels(as.is = FALSE, ordered = TRUE)
```

## Arguments

- level:

  One of: `"order"`, `"suborder"`, `"greatgroup"`, `"subgroup"`

- as.is:

  Return character labels rather than an (ordered) factor? Default:
  `FALSE`

- ordered:

  Create an ordinal factor? Default: `TRUE`

## Value

an (ordered) factor or character vector (when `as.is=TRUE`)

## Examples

``` r

SoilTaxonomyLevels("order")
#>  [1] gelisols    histosols   spodosols   andisols    oxisols     vertisols  
#>  [7] aridisols   ultisols    mollisols   alfisols    inceptisols entisols   
#> 12 Levels: gelisols < histosols < spodosols < andisols < ... < entisols

SoilTaxonomyLevels("order", ordered = FALSE)
#>  [1] gelisols    histosols   spodosols   andisols    oxisols     vertisols  
#>  [7] aridisols   ultisols    mollisols   alfisols    inceptisols entisols   
#> 12 Levels: gelisols histosols spodosols andisols oxisols ... entisols

SoilTaxonomyLevels("order", as.is = TRUE)
#>  [1] "gelisols"    "histosols"   "spodosols"   "andisols"    "oxisols"    
#>  [6] "vertisols"   "aridisols"   "ultisols"    "mollisols"   "alfisols"   
#> [11] "inceptisols" "entisols"   

SoilTaxonomyLevels("suborder")
#>  [1] histels   turbels   orthels   folists   wassists  fibrists  saprists 
#>  [8] hemists   aquods    gelods    cryods    humods    orthods   aquands  
#> [15] gelands   cryands   torrands  xerands   vitrands  ustands   udands   
#> [22] aquox     torrox    ustox     perox     udox      aquerts   cryerts  
#> [29] xererts   torrerts  usterts   uderts    cryids    salids    durids   
#> [36] gypsids   argids    calcids   cambids   aquults   humults   udults   
#> [43] ustults   xerults   albolls   aquolls   rendolls  gelolls   cryolls  
#> [50] xerolls   ustolls   udolls    aqualfs   cryalfs   ustalfs   xeralfs  
#> [57] udalfs    aquepts   gelepts   cryepts   ustepts   xerepts   udepts   
#> [64] wassents  aquents   psamments fluvents  orthents 
#> 68 Levels: histels < turbels < orthels < folists < wassists < ... < orthents
```
