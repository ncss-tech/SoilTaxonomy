<!-- badges: start -->
[![R-CMD-check](https://github.com/ncss-tech/SoilTaxonomy/workflows/R-CMD-check/badge.svg)](https://github.com/ncss-tech/SoilTaxonomy/actions)
[![Codecov test coverage](https://codecov.io/gh/ncss-tech/SoilTaxonomy/branch/master/graph/badge.svg)](https://codecov.io/gh/ncss-tech/SoilTaxonomy?branch=master)
[![CRAN Status](https://www.r-pkg.org/badges/version-last-release/SoilTaxonomy)](https://cran.r-project.org/package=SoilTaxonomy)
<!-- badges: end -->

# SoilTaxonomy

Tools for understanding and interacting with concepts in the U.S. Soil Taxonomic System. Most of the current utilities are for working with taxonomic concepts at the "higher" taxonomic levels: **Order**, **Suborder**, **Great Group**, and **Subgroup**. 

The **R** package is still in early stages of development, but is entering an "active testing" phase as the scope and application of these tools has become refined over time.

The `./inst/extdata` folder (formerly `./databases`) of this repository contains a variety of assets related to taxonomic and map unit concepts within the U.S. Soil Survey Geographic Database (SSURGO). See "_Static Databases_" below for more.

## Installation

Get the development version from Github. 

```r
remotes::install_github("ncss-tech/SoilTaxonomy")
```

``` r
library(SoilTaxonomy)
```

### Soil Taxonomy "Data Dictionaries" 

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

``` r
getTaxonAtLevel('acrudoxic plinthic kandiudults') # level = "order" # default
#>       HCCH 
#> "ultisols"

getTaxonAtLevel('acrudoxic plinthic kandiudults', level = "suborder")
#>     HCCH 
#> "udults"

getTaxonAtLevel('acrudoxic plinthic kandiudults', level = "greatgroup")
#>          HCCH 
#> "kandiudults"

getTaxonAtLevel('acrudoxic plinthic kandiudults', level = "subgroup")
#>                             HCCH 
#> "acrudoxic plinthic kandiudults"
```

#### BA = _Folists_

```r
getTaxonAtLevel('folists')
#>          BA 
#> "histosols"

getTaxonAtLevel('folists', level = "suborder")
#>        BA 
#> "folists"

getTaxonAtLevel('folists', level = "greatgroup")
#> BA 
#> NA 

getTaxonAtLevel('folists', level = "subgroup")
#> BA 
#> NA 

```

#### `explainST`: Label formative elements with brief explanations

``` r
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
```

## Static Databases

The static data products in this repository include: 

 - Statistics on: taxonomic subgroups, family-level components, and soil series. 
 - MLRA Overlap tables: for series, national map unit symbols and map unit keys. 
 - Summaries of: KSSL records per series as well as geomorphic position, parent material origin and kind.
 
**NOTICE:** In the near future, these products may (depending on their data requirements) be:

 1. Converted to internal (R package) data sets in `SoilTaxonomy`, or possibly a new "data" package
 2. Routinely generated and provided via [SoilKnowledgeBase](https://github.com/ncss-tech/SoilKnowledgeBase) 
 3. Provided via a new API (from SoilWeb or ?)

They will after that point be removed from this repository.

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

