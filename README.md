
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R-CMD-check](https://github.com/ncss-tech/SoilTaxonomy/workflows/R-CMD-check/badge.svg)](https://github.com/ncss-tech/SoilTaxonomy/actions/workflows/R-CMD-check.yml)
[![Codecov test
coverage](https://codecov.io/gh/ncss-tech/SoilTaxonomy/branch/master/graph/badge.svg)](https://app.codecov.io/gh/ncss-tech/SoilTaxonomy?branch=master)
[![CRAN
Status](https://www.r-pkg.org/badges/version-last-release/SoilTaxonomy)](https://cran.r-project.org/package=SoilTaxonomy)
[![runiverse-SoilTaxonomy](https://ncss-tech.r-universe.dev/badges/SoilTaxonomy)](https://github.com/ncss-tech/SoilTaxonomy)
[![SoilTaxonomy
Manual](https://img.shields.io/badge/docs-HTML-informational)](https://ncss-tech.github.io/SoilTaxonomy/)
<!-- badges: end -->

# {SoilTaxonomy}

Taxonomic dictionaries, formative element lists, and functions related
to the maintenance, development and application of U.S. Soil Taxonomy.

-   Data and functionality are based on official U.S. Department of
    Agriculture sources including the latest edition of the Keys to Soil
    Taxonomy. Descriptions and metadata are obtained from the National
    Soil Information System or Soil Survey Geographic databases. Other
    sources are referenced in the data documentation.

-   Provides tools for understanding and interacting with concepts in
    the U.S. Soil Taxonomic System. Most of the current utilities are
    for working with taxonomic concepts at the “higher” taxonomic
    levels: **Order**, **Suborder**, **Great Group**, and **Subgroup**.

## Installation

Get the stable version from CRAN.

``` r
install.packages("SoilTaxonomy")
```

Get the development version from GitHub.

``` r
remotes::install_github("ncss-tech/SoilTaxonomy")
```

``` r
library(SoilTaxonomy)
```

### Soil Taxonomy Dictionaries

``` r
# hierarchy: order to subgroup
# data('ST', package = 'SoilTaxonomy')
# 
# # unique taxa: just the taxon names (in order that they "key out" in the keys)
# data('ST_unique_list', package = 'SoilTaxonomy')
# 
# # formative element dictionary
# data('ST_formative_elements', package = 'SoilTaxonomy')
# 
# # codes denoting higher taxonomic parent-child relationships (12th Edition Keys to Soil Taxonomy)
data('ST_higher_taxa_codes_12th', package = 'SoilTaxonomy')
# 
# # definitions of diagnostic features and characteristics (12th Edition Keys to Soil Taxonomy)
# data('ST_features', package = 'SoilTaxonomy')
# 
# # definitions of family-level classes and differentiae (12th Edition Keys to Soil Taxonomy)
# data('ST_family_classes', package = 'SoilTaxonomy')
```

### Vignettes

Several vignettes are included with the package to demonstrate basic
functionality:

-   [Taxon Letter Codes in Soil
    Taxonomy](https://ncss-tech.github.io/SoilTaxonomy/articles/taxon-letter-codes.html)

-   [Diagnostic Features &
    Characteristics](https://ncss-tech.github.io/SoilTaxonomy/articles/diagnostics.html)

-   [Family-level Taxonomic
    Classes](https://ncss-tech.github.io/SoilTaxonomy/articles/family-level_taxonomy.html)

### Featured Functions

Two helpful functions that make use of the internal lookup tables are
`getTaxonAtLevel()`, `taxonTree()`, and `explainST()`

#### `getTaxonAtLevel()`: Get taxonomic levels within higher taxonomic groups

##### HHCH = *Acrudoxic Plinthic Kandiudults*

``` r
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

##### BA = *Folists*

``` r
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

#### `taxonTree()`: Create `data.tree` representation of Soil Taxonomy Hierarchy

``` r
# all hapludults and hapludalfs (to subgroup level)
taxonTree(c("hapludults", "hapludalfs"))
#> Loading required namespace: data.tree
#> Soil Taxonomy                                 
#>  |--ultisols                                  
#>  |   |--udults                                
#>  |       |--hapludults                        
#>  |           |--lithic-ruptic-entic hapludults
#>  |           |--lithic hapludults             
#>  |           |--vertic hapludults             
#>  |           |--fragiaquic hapludults         
#>  |           |--aquic arenic hapludults       
#>  |           |--aquic hapludults              
#>  |           |--fragic hapludults             
#>  |           |--oxyaquic hapludults           
#>  |           |--lamellic hapludults           
#>  |           |--psammentic hapludults         
#>  |           |--arenic hapludults             
#>  |           |--grossarenic hapludults        
#>  |           |--inceptic hapludults           
#>  |           |--humic hapludults              
#>  |           |--typic hapludults              
#>  |--alfisols                                  
#>      |--udalfs                                
#>          |--hapludalfs                        
#>              |--lithic hapludalfs             
#>              |--aquertic chromic hapludalfs   
#>              |--aquertic hapludalfs           
#>              |--oxyaquic vertic hapludalfs    
#>              |--chromic vertic hapludalfs     
#>              |--vertic hapludalfs             
#>              |--andic hapludalfs              
#>              |--vitrandic hapludalfs          
#>              |--fragiaquic hapludalfs         
#>              |--fragic oxyaquic hapludalfs    
#>              |--aquic arenic hapludalfs       
#>              |--arenic oxyaquic hapludalfs    
#>              |--anthraquic hapludalfs         
#>              |--albaquultic hapludalfs        
#>              |--albaquic hapludalfs           
#>              |--glossaquic hapludalfs         
#>              |--aquultic hapludalfs           
#>              |--aquollic hapludalfs           
#>              |--aquic hapludalfs              
#>              |--mollic oxyaquic hapludalfs    
#>              |--oxyaquic hapludalfs           
#>              |--fragic hapludalfs             
#>              |--lamellic hapludalfs           
#>              |--psammentic hapludalfs         
#>              |--arenic hapludalfs             
#>              |--glossic hapludalfs            
#>              |--inceptic hapludalfs           
#>              |--ultic hapludalfs              
#>              |--mollic hapludalfs             
#>              |--typic hapludalfs
```

``` r
# suborders and great groups of alfisols 
taxonTree("alfisols", root = "Alfisols", level = c("suborder", "greatgroup"))
#> Alfisols              
#>  |--aqualfs           
#>  |   |--cryaqualfs    
#>  |   |--plinthaqualfs 
#>  |   |--duraqualfs    
#>  |   |--natraqualfs   
#>  |   |--fragiaqualfs  
#>  |   |--kandiaqualfs  
#>  |   |--vermaqualfs   
#>  |   |--albaqualfs    
#>  |   |--glossaqualfs  
#>  |   |--epiaqualfs    
#>  |   |--endoaqualfs   
#>  |--cryalfs           
#>  |   |--palecryalfs   
#>  |   |--glossocryalfs 
#>  |   |--haplocryalfs  
#>  |--ustalfs           
#>  |   |--durustalfs    
#>  |   |--plinthustalfs 
#>  |   |--natrustalfs   
#>  |   |--kandiustalfs  
#>  |   |--kanhaplustalfs
#>  |   |--paleustalfs   
#>  |   |--rhodustalfs   
#>  |   |--haplustalfs   
#>  |--xeralfs           
#>  |   |--durixeralfs   
#>  |   |--natrixeralfs  
#>  |   |--fragixeralfs  
#>  |   |--plinthoxeralfs
#>  |   |--rhodoxeralfs  
#>  |   |--palexeralfs   
#>  |   |--haploxeralfs  
#>  |--udalfs            
#>      |--natrudalfs    
#>      |--ferrudalfs    
#>      |--fraglossudalfs
#>      |--fragiudalfs   
#>      |--kandiudalfs   
#>      |--kanhapludalfs 
#>      |--paleudalfs    
#>      |--rhodudalfs    
#>      |--glossudalfs   
#>      |--hapludalfs
```

#### `explainST()`: Label formative elements with brief explanations

`explainST()` provides simple narrative explanations of the formative
elements of taxa at the Order, Suborder, Great Group or Subgroup levels.

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

The `./inst/extdata` folder (formerly `./databases`) of the GitHub
repository formerly contained data tables related to taxonomic and map
unit concepts within the U.S. Soil Survey Geographic Database (SSURGO).

These databases included:

-   Statistics on taxonomic subgroups, family-level components, and soil
    series.

-   MLRA Overlap tables for series, national map unit symbols and map
    unit keys.

-   Summaries of KSSL records per series as well as geomorphic position,
    parent material origin and kind.

These tables have been moved to a dedicated repository called
[SoilWeb-data](https://github.com/ncss-tech/SoilWeb-data).
