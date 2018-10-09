## Export soil series databases from SoilWeb
## D.E. Beaudette
## 2018-10-09
##
## notes:
##    - SC database is re-made elsewhere (dump-NASIS-SC-data.R)
##    - 
##



## cleanup old versions

# geomorph / parent material
rm geomcomp_wide.csv.gz hillpos_wide.csv.gz mountainpos_wide.csv.gz

# series / other taxa stats
rm series_stats.csv.gz taxsubgrp-stats.txt

# parent material
rm pmkind.csv.gz pmorigin.csv.gz 

# MLRA membership
rm series-mlra-overlap.csv.gz


## manually export latest versions
# db
# user
sh export-tables.sh

## compute subgroup stats ~ 1 hour
bash soilweb-acreage-by-subgroup.sh

## gzip for github
gzip *.csv


