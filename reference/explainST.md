# Explain a taxon name using formative elements

Explain a taxon name using formative elements

## Usage

``` r
explainST(x, format = c("text", "html"), viewer = TRUE)
```

## Arguments

- x:

  a Subgroup, Great Group, Suborder or Order-level taxonomic name;
  matching is exact and case-insensitive

- format:

  output format: 'text' \| 'html'

- viewer:

  show `format = 'html'` output in browser? default: `TRUE`

## Value

a block of text, suitable for display in fixed-width font

## Examples

``` r

cat(explainST("ids"), "\n\n")              #  -ids (order suffix) 
#> ids
#> |                                                                                                   
#> soils with some diagnostic horizons and an aridic soil moisture regime                               
#> 
cat(explainST("aridisols"), "\n\n")        # Aridisols (order name)
#> aridisols
#>   |                                                                                                 
#>   soils with some diagnostic horizons and an aridic soil moisture regime                             
#> 
cat(explainST("argids"), "\n\n")           # Arg- (suborder) 
#> argids
#> |  |                                                                                                
#> presence of an argillic horizon                                                                     
#>    |                                                                                                
#>    soils with some diagnostic horizons and an aridic soil moisture regime                            
#> 
cat(explainST("haplargids"), "\n\n")       # Hap- (great group)
#> haplargids
#> |   |  |                                                                                            
#> minimum horizon development                                                                         
#>     |  |                                                                                            
#>     presence of an argillic horizon                                                                 
#>        |                                                                                            
#>        soils with some diagnostic horizons and an aridic soil moisture regime                        
#> 
cat(explainST("typic haplargids"), "\n\n") # Typic (subgroup)
#> typic haplargids
#> |     |   |  |                                                                                      
#> central theme of subgroup concept                                                                   
#>       |   |  |                                                                                      
#>       minimum horizon development                                                                   
#>           |  |                                                                                      
#>           presence of an argillic horizon                                                           
#>              |                                                                                      
#>              soils with some diagnostic horizons and an aridic soil moisture regime                  
#> 
```
