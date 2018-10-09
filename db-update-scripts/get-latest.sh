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
rm -f ../databases/geomcomp_wide.csv.gz ../databases/hillpos_wide.csv.gz ../databases/mountainpos_wide.csv.gz

# series / other taxa stats
rm -f ../databases/series_stats.csv.gz ../databases/taxsubgrp-stats.txt.gz

# parent material
rm -f ../databases/pmkind.csv.gz ../databases/pmorigin.csv.gz 

# MLRA membership
rm -f ../databases/series-mlra-overlap.csv.gz


## manually export latest versions
# db
# user
bash export-tables.sh

## gzip for github
gzip ../databases/*.csv

## compute subgroup stats ~ 1 hour
bash soilweb-acreage-by-subgroup.sh




