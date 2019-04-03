# SoilTaxonomy

## Installation

Install dependencies from CRAN
`install.packages(c('stringdist', 'purrr', 'stringi', 'data.tree'), dep=TRUE)`

Get the development version from Github. The latest this will require the latest version of `remotes`.

`remotes::install_github("ncss-tech/SoilTaxonomy/R_pkg", dependencies=FALSE, upgrade=FALSE, build=FALSE)`


```r
library(SoilTaxonomy)
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

