# Create a `data.tree` Object from Taxon Names

This function takes one or more taxon names and taxonomic levels as
input.

## Usage

``` r
taxonTree(
  taxon,
  level = c("order", "suborder", "greatgroup", "subgroup"),
  root = "Soil Taxonomy",
  verbose = TRUE,
  special.chars = c("|--", "|", "|", "-"),
  file = "",
  ...
)
```

## Arguments

- taxon:

  A vector of taxon names

- level:

  One or more of: `"order"`, `"suborder"`, `"greatgroup"`, `"subgroup"`.
  The lowest level is passed to `getChildLevel()` to generate the leaf
  nodes.

- root:

  Label for root node. Default: `"Soil Taxonomy"`; `NULL` for "unrooted"
  tree.

- verbose:

  Print tree output? Default: `TRUE`

- special.chars:

  Characters used to print the tree to console. Default:
  `c("|--", "|", "|", "-")`. For fancy markup try:
  `c("\u251c","\u2502", "\u2514", "\u2500 ")`

- file:

  Optional: path to output file. Default: `""` prints to standard output
  connection (unless redirected by
  [`sink()`](https://rdrr.io/r/base/sink.html))

- ...:

  Additional arguments to
  [`data.tree::as.Node.data.frame()`](https://rdrr.io/pkg/data.tree/man/as.Node.data.frame.html)

## Value

A `SoilTaxonNode` (subclass of `data.tree` `Node`) object (invisibly). A
text representation of the tree is printed to stdout when
`verbose=TRUE`.

## Details

A subclass of data.tree `Node` object is returned. This object has a
custom [`print()`](https://rdrr.io/r/base/print.html) method

## Examples

``` r

# hapludults and hapludalfs (to subgroup level)
taxonTree(c("hapludults", "hapludalfs"))
#> Soil Taxonomy                                 
#>  |-ultisols                                  
#>  |   |-udults                                
#>  |       |-hapludults                        
#>  |           |-lithic-ruptic-entic hapludults
#>  |           |-lithic hapludults             
#>  |           |-vertic hapludults             
#>  |           |-fragiaquic hapludults         
#>  |           |-aquic arenic hapludults       
#>  |           |-aquic hapludults              
#>  |           |-fragic hapludults             
#>  |           |-oxyaquic hapludults           
#>  |           |-lamellic hapludults           
#>  |           |-psammentic hapludults         
#>  |           |-arenic hapludults             
#>  |           |-grossarenic hapludults        
#>  |           |-inceptic hapludults           
#>  |           |-humic hapludults              
#>  |           |-typic hapludults              
#>  |-alfisols                                  
#>      |-udalfs                                
#>          |-hapludalfs                        
#>              |-lithic hapludalfs             
#>              |-aquertic chromic hapludalfs   
#>              |-aquertic hapludalfs           
#>              |-oxyaquic vertic hapludalfs    
#>              |-chromic vertic hapludalfs     
#>              |-vertic hapludalfs             
#>              |-andic hapludalfs              
#>              |-vitrandic hapludalfs          
#>              |-fragiaquic hapludalfs         
#>              |-fragic oxyaquic hapludalfs    
#>              |-aquic arenic hapludalfs       
#>              |-arenic oxyaquic hapludalfs    
#>              |-anthraquic hapludalfs         
#>              |-albaquultic hapludalfs        
#>              |-albaquic hapludalfs           
#>              |-glossaquic hapludalfs         
#>              |-aquultic hapludalfs           
#>              |-aquollic hapludalfs           
#>              |-aquic hapludalfs              
#>              |-mollic oxyaquic hapludalfs    
#>              |-oxyaquic hapludalfs           
#>              |-fragic hapludalfs             
#>              |-lamellic hapludalfs           
#>              |-psammentic hapludalfs         
#>              |-arenic hapludalfs             
#>              |-glossic hapludalfs            
#>              |-inceptic hapludalfs           
#>              |-ultic hapludalfs              
#>              |-mollic hapludalfs             
#>              |-typic hapludalfs              

# alfisols suborders and great groups
taxonTree("alfisols", root = "Alfisols", level = c("suborder", "greatgroup"))
#> Alfisols              
#>  |-aqualfs           
#>  |   |-cryaqualfs    
#>  |   |-plinthaqualfs 
#>  |   |-duraqualfs    
#>  |   |-natraqualfs   
#>  |   |-fragiaqualfs  
#>  |   |-kandiaqualfs  
#>  |   |-vermaqualfs   
#>  |   |-albaqualfs    
#>  |   |-glossaqualfs  
#>  |   |-epiaqualfs    
#>  |   |-endoaqualfs   
#>  |-cryalfs           
#>  |   |-palecryalfs   
#>  |   |-glossocryalfs 
#>  |   |-haplocryalfs  
#>  |-ustalfs           
#>  |   |-durustalfs    
#>  |   |-plinthustalfs 
#>  |   |-natrustalfs   
#>  |   |-kandiustalfs  
#>  |   |-kanhaplustalfs
#>  |   |-paleustalfs   
#>  |   |-rhodustalfs   
#>  |   |-haplustalfs   
#>  |-xeralfs           
#>  |   |-durixeralfs   
#>  |   |-natrixeralfs  
#>  |   |-fragixeralfs  
#>  |   |-plinthoxeralfs
#>  |   |-rhodoxeralfs  
#>  |   |-palexeralfs   
#>  |   |-haploxeralfs  
#>  |-udalfs            
#>      |-natrudalfs    
#>      |-ferrudalfs    
#>      |-fraglossudalfs
#>      |-fragiudalfs   
#>      |-kandiudalfs   
#>      |-kanhapludalfs 
#>      |-paleudalfs    
#>      |-rhodudalfs    
#>      |-glossudalfs   
#>      |-hapludalfs    
```
