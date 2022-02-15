<!-- badges: start -->
[![R-CMD-check](https://github.com/ncss-tech/SoilTaxonomy/workflows/R-CMD-check/badge.svg)](https://github.com/ncss-tech/SoilTaxonomy/actions)
[![Codecov test coverage](https://codecov.io/gh/ncss-tech/SoilTaxonomy/branch/master/graph/badge.svg)](https://codecov.io/gh/ncss-tech/SoilTaxonomy?branch=master)
[![CRAN Status](https://www.r-pkg.org/badges/version-last-release/SoilTaxonomy)](https://cran.r-project.org/package=SoilTaxonomy)
[![runiverse-SoilTaxonomy](https://ncss-tech.r-universe.dev/badges/SoilTaxonomy)](https://github.com/ncss-tech/SoilTaxonomy)
[![SoilTaxonomy Manual](https://img.shields.io/badge/docs-HTML-informational)](https://ncss-tech.github.io/SoilTaxonomy/docs/)
<!-- badges: end -->

# SoilTaxonomy
Taxonomic dictionaries, formative element lists, and functions related to the maintenance, development and application of U.S. Soil Taxonomy. 

   Data and functionality are based on official U.S. Department of Agriculture sources including the latest edition of the Keys to Soil Taxonomy. Descriptions and metadata are obtained from the National Soil Information System or Soil Survey Geographic databases. Other sources are referenced in the data documentation. 
   
   Provides tools for understanding and interacting with concepts in the U.S. Soil Taxonomic System. Most of the current utilities are for working with taxonomic concepts at the "higher" taxonomic levels: **Order**, **Suborder**, **Great Group**, and **Subgroup**. 

## Installation

Get the stable version from CRAN. 

```r
install.packages("SoilTaxonomy")
```

Get the development version from GitHub. 

```r
remotes::install_github("ncss-tech/SoilTaxonomy")
```

``` r
library(SoilTaxonomy)
```

### Soil Taxonomy Dictionaries

``` r
# hierarchy: order to subgroup
data('ST', package = 'SoilTaxonomy')

# unique taxa: just the names
data('ST_unique_list', package = 'SoilTaxonomy')

# formative element dictionary
data('ST_formative_elements', package = 'SoilTaxonomy')

# codes denoting higher taxonomic parent-child relationships (12th Edition Keys to Soil Taxonomy)
data('ST_higher_taxa_codes_12th', package = 'SoilTaxonomy')
```

### Functions

#### `getTaxonAtLevel`: Get taxonomic levels within higher taxonomic groups

##### HHCH = _Acrudoxic Plinthic Kandiudults_

```r
getTaxonAtLevel('acrudoxic plinthic kandiudults') # level = "order" # default
#> acrudoxic plinthic kandiudults 
#>                     "ultisols"

getTaxonAtLevel('acrudoxic plinthic kandiudults', level = "suborder")
#> acrudoxic plinthic kandiudults 
#>                       "udults"

getTaxonAtLevel('acrudoxic plinthic kandiudults', level = "greatgroup")
#> acrudoxic plinthic kandiudults 
#>                  "kandiudults"

getTaxonAtLevel('acrudoxic plinthic kandiudults', level = "subgroup")
#>   acrudoxic plinthic kandiudults 
#> "acrudoxic plinthic kandiudults"
```

#### BA = _Folists_

```r
getTaxonAtLevel('folists')
#>     folists 
#> "histosols"

getTaxonAtLevel('folists', level = "suborder")
#>   folists 
#> "folists"

getTaxonAtLevel('folists', level = "greatgroup")
#> folists 
#>      NA 

getTaxonAtLevel('folists', level = "subgroup")
#> folists 
#>      NA 

```

#### `explainST`: Label formative elements with brief explanations

`explainST` provides simple narrative explanations of the formative elements of taxa at the Order, Suborder, Great Group or Subgroup levels.

``` r
cat(explainST('folistels'))
#> folistels
#> |  |  |                                                                                             
#> mass of leaves                                                                                      
#>    |  |                                                                                             
#>    presence of organic soil materials                                                               
#>       |                                                                                             
#>       soils with permafrost or gelic material within 100cm  

cat(explainST('typic endoaqualfs'))
#> typic endoaqualfs
#> |     |   |  |                                                                                      
#> central theme of subgroup concept                                                                   
#>       |   |  |                                                                                      
#>       ground water table                                                                            
#>           |  |                                                                                      
#>           characteristics associated with wetness                                                   
#>              |                                                                                      
#>              soils with an argillic, kandic, or natric horizon

cat(explainST('abruptic haplic durixeralfs'))
#> abruptic haplic durixeralfs
#> |        |      |   |  |                                                                            
#> abrupt textural change                                                                              
#>          |      |   |  |                                                                            
#>          central theme of subgroup concept                                                          
#>                 |   |  |                                                                            
#>                 presence of a duripan                                                               
#>                     |  |                                                                            
#>                     xeric SMR                                                                       
#>                        |                                                                            
#>                        soils with an argillic, kandic, or natric horizon    

# convert "taxon code" to taxon name (subgroup)
cat(explainST(taxon_code_to_taxon("ABCD"))) # ABCD = gypsic anhyturbels
#> gypsic anhyturbels
#> |      |   |   |                                                                                    
#> presence of gypsic horizon                                                                          
#>        |   |   |                                                                                    
#>        very dry                                                                                     
#>            |   |                                                                                    
#>            presence of cryoturbation                                                                
#>                |                                                                                    
#>                soils with permafrost or gelic material within 100cm

# all soil orders (LETTERS[1:12]; taxon codes A through L)
res <- lapply(LETTERS[1:12], function(l) cat(explainST(taxon_code_to_taxon(l)), "\n\n"))
#> gelisols
#>  |                                                                                                  
#>  soils with permafrost or gelic material within 100cm                                                
#> 
#> histosols
#>  |                                                                                                  
#>  soils with more than 30% organic matter content to a depth of 40cm or more                          
#> 
#> spodosols
#>   |                                                                                                 
#>   soils with a spodic horizon within a depth of 200cm                                                
#> 
#> andisols
#> |                                                                                                   
#> soils with andic soils properties in 1/2 or more of the upper 60cm                                   
#> 
#> oxisols
#> |                                                                                                   
#> soils with an oxic horizon, or >40% clay in the surface 18cm and a kandic horizon with < 10%  weatherable minerals 
#> 
#> vertisols
#>  |                                                                                                  
#>  soils containing >30% clay in all horizons and cracks that open and close periodically              
#> 
#> aridisols
#>   |                                                                                                 
#>   soils with some diagnostic horizons and an aridic SMR                                              
#> 
#> ultisols
#> |                                                                                                   
#> soils with an argillic or kandic horizon and a base saturation at pH 8.2 <35% at a depth of 180cm    
#> 
#> mollisols
#>  |                                                                                                  
#>  soils with a mollic epipedon and base saturation at pH 7 >=50% in all depths above 180cm            
#> 
#> alfisols
#> |                                                                                                   
#> soils with an argillic, kandic, or natric horizon                                                    
#> 
#> inceptisols
#>    |                                                                                                
#>    soils with an umbric, mollic, or plaggen epipedon, or cambic horizon                              
#> 
#> entisols
#> |                                                                                                   
#> other soils
```

## Static Databases

The `./inst/extdata` folder (formerly `./databases`) of the GitHub repository formerly contained data tables related to taxonomic and map unit concepts within the U.S. Soil Survey Geographic Database (SSURGO).

Including: 
 - Statistics on taxonomic subgroups, family-level components, and soil series. 
 - MLRA Overlap tables for series, national map unit symbols and map unit keys. 
 - Summaries of KSSL records per series as well as geomorphic position, parent material origin and kind.
 
These tables have been moved to a dedicated repository called [SoilWeb-data](https://github.com/ncss-tech/SoilWeb-data).

## Visualize and Extend with `data.tree`

Static data sets in this R package can be readily visualized with the `data.tree` package.

### Example: show "parent" taxa (Subgroup -> Great Group -> Suborder -> Order)

``` r
library(SoilTaxonomy)
library(data.tree)

# load the full hierarchy at the subgroup level
data("ST", package = 'SoilTaxonomy')

# pick 10 taxa
x <- ST[sample(1:nrow(ST), size = 10),]

# construct path
# note: must include a top-level ("ST") in the hierarchy
path <- with(x, paste('ST', subgroup,
                      greatgroup,
                      suborder,
                      order,
                      sep = '/'
))

# convert to data.tree object
n <- as.Node(data.frame(pathString = path), pathDelimiter = '/')

# print
print(n, limit = NULL)
#>                       levelName
#> 1  ST                          
#> 2   ¦--dystric haplustands     
#> 3   ¦   °--haplustands         
#> 4   ¦       °--ustands         
#> 5   ¦           °--andisols    
#> 6   ¦--sodic haplogypsids      
#> 7   ¦   °--haplogypsids        
#> 8   ¦       °--gypsids         
#> 9   ¦           °--aridisols   
#> 10  ¦--lithic calcicryids      
#> 11  ¦   °--calcicryids         
#> 12  ¦       °--cryids          
#> 13  ¦           °--aridisols   
#> 14  ¦--xeric kandihumults      
#> 15  ¦   °--kandihumults        
#> 16  ¦       °--humults         
#> 17  ¦           °--ultisols    
#> 18  ¦--typic acraquox          
#> 19  ¦   °--acraquox            
#> 20  ¦       °--aquox           
#> 21  ¦           °--oxisols     
#> 22  ¦--petroferric haplustults 
#> 23  ¦   °--haplustults         
#> 24  ¦       °--ustults         
#> 25  ¦           °--ultisols    
#> 26  ¦--cumulic haploxerolls    
#> 27  ¦   °--haploxerolls        
#> 28  ¦       °--xerolls         
#> 29  ¦           °--mollisols   
#> 30  ¦--glossic ustic natrargids
#> 31  ¦   °--natrargids          
#> 32  ¦       °--argids          
#> 33  ¦           °--aridisols   
#> 34  ¦--xeric torriorthents     
#> 35  ¦   °--torriorthents       
#> 36  ¦       °--orthents        
#> 37  ¦           °--entisols    
#> 38  °--glacic haploturbels     
#> 39      °--haploturbels        
#> 40          °--turbels         
#> 41              °--gelisols
```

