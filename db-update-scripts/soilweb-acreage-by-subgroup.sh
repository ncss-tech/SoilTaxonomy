## compute acreage according to subgroup for ST task force
## NOTE: there can be errors in component taxa population, therefore we are tabulating at the lowest level


## TODO: consider using a language with a proper DBI

# pre-filter component data, requires about 40 seconds
psql -U postgres ssurgo_combined <<EOF
SET work_mem to '512MB';
SET search_path to soilweb, public;

-- make a temp table with component information and indices
DROP TABLE IF EXISTS soilweb.comp_data_subgroup;
CREATE TABLE soilweb.comp_data_subgroup AS
SELECT mukey, 
taxsubgrp, 
sum(comppct_r/100.00) as pct
FROM ssurgo.component
WHERE compkind != 'Miscellaneous area'
GROUP BY mukey, taxsubgrp ;

CREATE INDEX comp_data_comp_data_subgroup_idx ON comp_data_subgroup (mukey);
VACUUM ANALYZE comp_data_subgroup;

-- remove rows with missing taxonomic data
DELETE FROM soilweb.comp_data_subgroup WHERE taxsubgrp IS NULL;
VACUUM ANALYZE comp_data_subgroup;
EOF

# move any previously computed stats to backup file
if [ -f taxsubgrp-stats.txt ]; then
	echo "saving existing stats file"
    mv taxsubgrp-stats.txt taxsubgrp-stats-old.txt
fi


# compute stats by order/suborder/great group/subgroup and save to text file
# parallel computation by great group
# ~1 hour run in parallel (8 cores)

# get a list of subgroups
# converting to lower case and replacing spaces with underscore
echo "select DISTINCT taxsubgrp from soilweb.comp_data_subgroup" | psql -U postgres ssurgo_combined -t -A > taxsubgrp-list-for-stats

# run in parallel: 2x CPUs, 4 cores each
# note special syntax for accommodating spaces in subgroup names
# http://www.gnu.org/software/parallel/man.html#QUOTING
cat taxsubgrp-list-for-stats | parallel --eta --progress -q bash -c "echo \"SELECT taxsubgrp, ROUND((SUM(pct * ST_Area(wkb_geometry::geography)) * 0.000247105)::numeric)::bigint AS ac, COUNT(wkb_geometry) as n_polygons FROM ssurgo.mapunit_poly JOIN soilweb.comp_data_subgroup USING (mukey) WHERE comp_data_subgroup.taxsubgrp = '{}' GROUP BY taxsubgrp\" | psql -U postgres ssurgo_combined -t -A >> taxsubgrp-stats.txt"

# compress and move
gzip taxsubgrp-stats.txt && mv taxsubgrp-stats.txt.gz ../databases/

# cleanup
echo "DROP TABLE IF EXISTS soilweb.comp_data_subgroup;" | psql -U postgres ssurgo_combined


