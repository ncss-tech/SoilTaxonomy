## 2019-04-02
## D.E. Beaudette
##
## Rough draft of steps used to rebuild local databases
##


## periodically refresh the local SC copy
## consider making this a scheduled task
# source('prepare-SC-from-NASIS.R')

## this must be done after a change to the 'Keys
# source('prepare-ST-from-NASIS-domains.R')

## remake .rda versions
## this must be done after a change to the 'Keys, or changes to formative element dictionaries
source('rebuild-R-package-data-objects.R')

