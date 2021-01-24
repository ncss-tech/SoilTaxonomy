<!-- badges: start -->
[![R-CMD-check](https://github.com/ncss-tech/SoilTaxonomy/workflows/R-CMD-check/badge.svg)](https://github.com/ncss-tech/SoilTaxonomy/actions)
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
#> $BA
#> NULL

getTaxonAtLevel('folists', level = "subgroup")
#> $BA
#> NULL

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
#>          |      |   |  |                                                                            
#>          abrupt textural change                                                                     
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
path <- with(x, paste('ST', tax_subgroup,
                      tax_greatgroup,
                      tax_suborder,
                      tax_order,
                      sep = '/'
))

# convert to data.tree object
n <- as.Node(data.frame(pathString = path), pathDelimiter = '/')

# print
print(n, limit = NULL)
```

``` r
#>                      levelName
#> 1  ST                         
#> 2   ¦--andic haplocryods      
#> 3   ¦   °--haplocryods        
#> 4   ¦       °--cryods         
#> 5   ¦           °--spodosols  
#> 6   ¦--xeric vitricryands     
#> 7   ¦   °--vitricryands       
#> 8   ¦       °--cryands        
#> 9   ¦           °--andisols   
#> 10  ¦--lithic natrargids      
#> 11  ¦   °--natrargids         
#> 12  ¦       °--argids         
#> 13  ¦           °--aridisols  
#> 14  ¦--vertic haplocambids    
#> 15  ¦   °--haplocambids       
#> 16  ¦       °--cambids        
#> 17  ¦           °--aridisols  
#> 18  ¦--natric vermaqualfs     
#> 19  ¦   °--vermaqualfs        
#> 20  ¦       °--aqualfs        
#> 21  ¦           °--alfisols   
#> 22  ¦--entic calcitorrerts    
#> 23  ¦   °--calcitorrerts      
#> 24  ¦       °--torrerts       
#> 25  ¦           °--vertisols  
#> 26  ¦--petrogypsic anhyorthels
#> 27  ¦   °--anhyorthels        
#> 28  ¦       °--orthels        
#> 29  ¦           °--gelisols   
#> 30  ¦--typic anhyorthels      
#> 31  ¦   °--anhyorthels        
#> 32  ¦       °--orthels        
#> 33  ¦           °--gelisols   
#> 34  ¦--aeric haplowassents    
#> 35  ¦   °--haplowassents      
#> 36  ¦       °--wassents       
#> 37  ¦           °--entisols   
#> 38  °--humaqueptic epiaquents 
#> 39      °--epiaquents         
#> 40          °--aquents        
#> 41              °--entisols
```

### More examples coming soon!

<!--

### Example: Acres by Suborder, Great Group and Subgroup
```
                                  levelName       ac
1  xeralfs                                     16554816
2   ¦--durixeralfs                              1704451
3   ¦   ¦--abruptic durixeralfs                  923662
4   ¦   ¦--abruptic haplic durixeralfs            30118
5   ¦   ¦--aquic durixeralfs                       7267
6   ¦   ¦--haplic durixeralfs                     49027
7   ¦   ¦--natric durixeralfs                    158112
8   ¦   ¦--typic durixeralfs                     536265
9   ¦   °--vertic durixeralfs                         0
10  ¦--fragixeralfs                              141400
11  ¦   ¦--andic fragixeralfs                         0
12  ¦   ¦--aquic fragixeralfs                       924
13  ¦   ¦--inceptic fragixeralfs                      0
14  ¦   ¦--mollic fragixeralfs                    31906
15  ¦   ¦--typic fragixeralfs                         0
16  ¦   °--vitrandic fragixeralfs                108570
17  ¦--haploxeralfs                            11721233
18  ¦   ¦--andic haploxeralfs                    316458
19  ¦   ¦--aquandic haploxeralfs                  27437
20  ¦   ¦--aquic haploxeralfs                     88948
21  ¦   ¦--aquultic haploxeralfs                 160574
22  ¦   ¦--calcic haploxeralfs                   131105
23  ¦   ¦--fragiaquic haploxeralfs                 1350
24  ¦   ¦--fragic haploxeralfs                     1431
25  ¦   ¦--inceptic haploxeralfs                   1392
26  ¦   ¦--lamellic haploxeralfs                  15241
27  ¦   ¦--lithic haploxeralfs                   236502
28  ¦   ¦--lithic mollic haploxeralfs            597510
29  ¦   ¦--lithic ruptic-inceptic haploxeralfs   190796
30  ¦   ¦--mollic haploxeralfs                  2339766
31  ¦   ¦--natric haploxeralfs                    96027
32  ¦   ¦--plinthic haploxeralfs                      0
33  ¦   ¦--psammentic haploxeralfs                16987
34  ¦   ¦--typic haploxeralfs                   2033127
35  ¦   ¦--ultic haploxeralfs                   4827155
36  ¦   ¦--vertic haploxeralfs                     9889
37  ¦   °--vitrandic haploxeralfs                629538
38  ¦--palexeralfs                              2393894
39  ¦   ¦--andic palexeralfs                      43332
40  ¦   ¦--aquandic palexeralfs                   21924
41  ¦   ¦--aquic palexeralfs                     201617
42  ¦   ¦--arenic palexeralfs                         0
43  ¦   ¦--calcic palexeralfs                        41
44  ¦   ¦--fragiaquic palexeralfs                     0
45  ¦   ¦--fragic palexeralfs                         0
46  ¦   ¦--haplic palexeralfs                     28882
47  ¦   ¦--lamellic palexeralfs                       0
48  ¦   ¦--mollic palexeralfs                    549189
49  ¦   ¦--natric palexeralfs                     33585
50  ¦   ¦--petrocalcic palexeralfs                 3221
51  ¦   ¦--plinthic palexeralfs                       0
52  ¦   ¦--psammentic palexeralfs                     0
53  ¦   ¦--typic palexeralfs                     491630
54  ¦   ¦--ultic palexeralfs                     812194
55  ¦   ¦--vertic palexeralfs                     11073
56  ¦   °--vitrandic palexeralfs                 197206
57  ¦--natrixeralfs                              418472
58  ¦   ¦--aquic natrixeralfs                     53619
59  ¦   ¦--typic natrixeralfs                    358187
60  ¦   °--vertic natrixeralfs                     6666
61  ¦--rhodoxeralfs                              175366
62  ¦   ¦--calcic rhodoxeralfs                        0
63  ¦   ¦--inceptic rhodoxeralfs                      0
64  ¦   ¦--lithic rhodoxeralfs                        0
65  ¦   ¦--petrocalcic rhodoxeralfs                   0
66  ¦   ¦--typic rhodoxeralfs                    172935
67  ¦   °--vertic rhodoxeralfs                     2431
68  °--plinthoxeralfs                                 0
69      °--typic plinthoxeralfs                       0
```
-->
