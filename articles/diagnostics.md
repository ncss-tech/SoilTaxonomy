# Soil Diagnostic Features & Characteristics

``` r

library(SoilTaxonomy)
```

Data from the latest version of the Keys to Soil Taxonomy related to
diagnostic features and characteristics are stored in the package
dataset `ST_features`.

You can load the full supporting data directly with:

``` r

data(ST_features, package = "SoilTaxonomy")
```

A wrapper function,
[`get_ST_features()`](http://ncss-tech.github.io/SoilTaxonomy/reference/get_ST_features.md),
is provided to help with obtaining information of interest to specific
features or groups of features.

We will inspect the “Mollic Epipedon” information to see the structure
of the `ST_features` *data.frame*.

We can use `get_ST_features(name=...)` to get features by name
(case-insensitive)

``` r

str(get_ST_features(name = "mollic epipedon"))
#> 'data.frame':    1 obs. of  6 variables:
#>  $ group      : chr "Surface"
#>  $ name       : chr "Mollic Epipedon"
#>  $ chapter    : int 3
#>  $ page       : int 9
#>  $ description: chr ""
#>  $ criteria   : chr "Required Characteristics The mollic epipedon consists of mineral soil material and, after mixing of the upper 1"| __truncated__
```

Columns included in the `ST_features`, and usable for filtering as
arguments to
[`get_ST_features()`](http://ncss-tech.github.io/SoilTaxonomy/reference/get_ST_features.md)
include:

- `group` - Diagnostic feature or characteristic group name
- `name` - Diagnostic feature or characteristic name
- `chapter` - Chapter number in Keys to Soil Taxonomy (latest edition)
- `page` - Page number in Keys to Soil Taxonomy (latest edition)
- `description` - Narrative description (may not be present for all
  features)
- `criteria` - “Key” to identifying the feature; logical criteria
  separated by AND/Or

Say we are interested in finding criteria to distinguish the epipedons
(surface diagnostic horizons).

We can use the `group=...` argument to get all of the “surface” features
as a *data.frame*.

``` r

epipedons <- get_ST_features(group = "surface")
```

There are 8 features in this result set.

``` r

str(epipedons)
#> 'data.frame':    8 obs. of  6 variables:
#>  $ group      : chr  "Surface" "Surface" "Surface" "Surface" ...
#>  $ name       : chr  "Anthropic Epipedon" "Folistic Epipedon" "Histic Epipedon" "Melanic Epipedon" ...
#>  $ chapter    : int  3 3 3 3 3 3 3 3
#>  $ page       : int  7 8 8 8 9 9 10 10
#>  $ description: chr  "The anthropic epipedon forms in human-altered or human- transported material (defined below). These epipedons f"| __truncated__ "" "" "" ...
#>  $ criteria   : chr  "Required Characteristics The anthropic epipedon consists of mineral soil material that shows evidence of the pu"| __truncated__ "Required Characteristics The folistic epipedon is a layer (one or more horizons) that is saturated for less tha"| __truncated__ "Required Characteristics The histic epipedon is a layer (one or more horizons) that is characterized by saturat"| __truncated__ "Required Characteristics The melanic epipedon has both of the following:\n1. An upper boundary at, or within 30"| __truncated__ ...
```

We can then select specific items by name, such as the `"description"`
and `"criteria"`:

``` r

subset(epipedons, name == "Anthropic Epipedon")$description
#> [1] "The anthropic epipedon forms in human-altered or human- transported material (defined below). These epipedons form in soils which occur on anthropogenic landforms and microfeatures or which are higher than the adjacent soils by as much as or more than the thickness of the anthropic epipedon. They may also occur in excavated areas. Most anthropic epipedons contain artifacts other than those associated with agricultural practices (e.g., quicklime) and litter discarded by humans (e.g., aluminum cans). Anthropic epipedons may have an elevated phosphorus content from human additions of food debris (e.g., bones), compost, or manure, although a precise value is not required. Although anthropic epipedons formed at the soil surface, they may now be buried. Most anthropic epipedons occur in soils of gardens, middens (Hester et al., 1975), and urban areas, and most also meet the definition of another diagnostic mineral epipedon or subsurface horizon."
```

``` r

subset(epipedons, name == "Anthropic Epipedon")$criteria
#> [1] "Required Characteristics The anthropic epipedon consists of mineral soil material that shows evidence of the purposeful alteration of soil properties or of earth-surface features by human activity. The field evidence of alteration is significant and excludes agricultural practices such as shallow plowing or addition of amendments, such as lime or fertilizer.\nThe anthropic epipedon includes eluvial horizons that are at or near the soil surface, and it extends to the base of horizons that meet all the criteria shown below or it extends to the top of the first underlying diagnostic illuvial horizon (defined below as an argillic, kandic, natric, or spodic horizon). The anthropic epipedon meets all of the following:\n1. When dry, has structural units with a diameter of 30 cm or less; and\n2. Has rock structure, including fine stratifications (5 mm or less thick), in less than one-half of the volume of all parts; and\n3. Formed in human-altered or human-transported material (defined below) on an anthropogenic landform or microfeature (defined below); and either:\na. Directly overlies mine or dredged spoil material which has rock structure, a root-limiting layer, or a lithologic discontinuity with horizons that are not derived from human- altered or human-transported material (defined below); or\nb. Has one or more of the following throughout:\n(1) Artifacts, other than agricultural amendments (e.g., quicklime) and litter discarded by humans (e.g., aluminum cans); or\n(2) Midden material (i.e., eating and cooking waste and associated charred products); or\n(3) Anthraquic conditions; and\n4. Has a minimum thickness that is either:\na. The entire thickness of the soil above a root-limiting layer (defined in chapter 17) if one occurs within 25 cm of the soil surface; or\nb. 25 cm; and\n5. Has an n value (defined below) of less than 0.7."
```

If we want to compare the basic definitions in Chapter 2 with the
features in Chapter 3, we can subset `ST_features` using the `chapter`
or `page` number (or range).

``` r

get_ST_features(chapter = 2)$name
#> [1] "Mineral Soil Material"                        
#> [2] "Organic Soil Material"                        
#> [3] "Distinction Between Mineral Soils and Organic"
#> [4] "Soil Surface"                                 
#> [5] "Mineral Soil Surface"                         
#> [6] "Definition of Mineral Soils"                  
#> [7] "Definition of Organic Soils"
```

``` r

get_ST_features(chapter = 3)$name
#>  [1] "Anthropic Epipedon"                        
#>  [2] "Folistic Epipedon"                         
#>  [3] "Histic Epipedon"                           
#>  [4] "Melanic Epipedon"                          
#>  [5] "Mollic Epipedon"                           
#>  [6] "Ochric Epipedon"                           
#>  [7] "Plaggen Epipedon"                          
#>  [8] "Umbric Epipedon"                           
#>  [9] "Agric Horizon"                             
#> [10] "Albic Horizon"                             
#> [11] "Anhydritic Horizon"                        
#> [12] "Argillic Horizon"                          
#> [13] "Calcic Horizon"                            
#> [14] "Cambic Horizon"                            
#> [15] "Duripan"                                   
#> [16] "Fragipan"                                  
#> [17] "Glossic Horizon"                           
#> [18] "Gypsic Horizon"                            
#> [19] "Kandic Horizon"                            
#> [20] "Natric Horizon"                            
#> [21] "Ortstein"                                  
#> [22] "Oxic Horizon"                              
#> [23] "Petrocalcic Horizon"                       
#> [24] "Petrogypsic Horizon"                       
#> [25] "Placic Horizon"                            
#> [26] "Salic Horizon"                             
#> [27] "Sombric Horizon"                           
#> [28] "Spodic Horizon"                            
#> [29] "Abrupt Textural Change"                    
#> [30] "Albic Materials"                           
#> [31] "Andic Soil Properties"                     
#> [32] "Anhydrous Conditions"                      
#> [33] "Coefficient of Linear Extensibility (COLE)"
#> [34] "Fragic Soil Properties"                    
#> [35] "Free Carbonates"                           
#> [36] "Identifiable Secondary Carbonates"         
#> [37] "Interfingering of Albic Materials"         
#> [38] "Lamellae"                                  
#> [39] "Kinds of Organic Soil Materials"           
#> [40] "Fibers"                                    
#> [41] "Fibric Soil Materials"                     
#> [42] "Hemic Soil Materials"                      
#> [43] "Sapric Soil Materials"                     
#> [44] "Humilluvic Material"                       
#> [45] "Kinds of Limnic Materials"                 
#> [46] "Coprogenous Earth"                         
#> [47] "Diatomaceous Earth"                        
#> [48] "Marl"                                      
#> [49] "Thickness of Organic Soil Materials"       
#> [50] "Surface Tier"                              
#> [51] "Subsurface Tier"                           
#> [52] "Bottom Tier"                               
#> [53] "Aquic Conditions"                          
#> [54] "Cryoturbation"                             
#> [55] "Densic Contact"                            
#> [56] "Densic Materials"                          
#> [57] "Gelic Materials"                           
#> [58] "Glacic Layer"                              
#> [59] "Lithic Contact"                            
#> [60] "Paralithic Contact"                        
#> [61] "Paralithic Materials"                      
#> [62] "Permafrost"                                
#> [63] "Soil Moisture Regimes"                     
#> [64] "Soil Moisture Control Section"             
#> [65] "Classes of Soil Moisture Regimes"          
#> [66] "Sulfidic Materials"                        
#> [67] "Sulfuric Horizon"                          
#> [68] "Anthropogenic Landforms"                   
#> [69] "Constructional Anthropogenic Landforms"    
#> [70] "Destructional Anthropogenic Landforms"     
#> [71] "Anthropogenic Microfeatures"               
#> [72] "Constructional Anthropogenic Microfeatures"
#> [73] "Destructional Anthropogenic Microfeatures" 
#> [74] "Artifacts"                                 
#> [75] "Human-Altered Material"                    
#> [76] "Human-Transported Material"                
#> [77] "Manufactured Layer"
```

If we want to get the definitions found on pages 18 to 20 (latest Keys
to Soil Taxonomy), we can specify a vector containing desired levels of
`page`:

``` r

get_ST_features(page = 18:20)$name
#> [1] "Anhydrous Conditions"                      
#> [2] "Coefficient of Linear Extensibility (COLE)"
#> [3] "Fragic Soil Properties"                    
#> [4] "Free Carbonates"                           
#> [5] "Identifiable Secondary Carbonates"         
#> [6] "Interfingering of Albic Materials"         
#> [7] "Lamellae"
```
