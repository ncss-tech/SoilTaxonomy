# SoilTaxonomy

## Installation

Install dependencies from CRAN

```r
install.packages(c('stringdist', 'purrr', 'stringi', 'data.tree'), dep=TRUE)
```

Get the development version from Github. The latest this will require the latest version of `remotes`.

```r
remotes::install_github("ncss-tech/SoilTaxonomy/R_pkg", dependencies=FALSE, upgrade=FALSE, build=FALSE)
```

Give it a try.
```r
library(SoilTaxonomy)

# label formative elements in the hierarchy with brief explanations
cat(explainST('typic endoaqualfs'), sep = '\n')
```

```
typic endoaqualfs
|     |   |  |                                                                                      
central theme of subgroup concept                                                                   
      |   |  |                                                                                      
      ground water table                                                                            
          |  |                                                                                      
          characteristics associated with wetness                                                   
             |                                                                                      
             soils with an argillic, kandic, or natric horizon
```



