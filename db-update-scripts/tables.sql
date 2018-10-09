
-- geomorph
\copy soilweb.geomcomp_wide to 'geomcomp_wide.csv' CSV HEADER
\copy soilweb.hillpos_wide to 'hillpos_wide.csv' CSV HEADER
\copy soilweb.mountainpos_wide to 'mountainpos_wide.csv' CSV HEADER

-- series stats
\copy soilweb.series_stats to 'series_stats.csv' CSV HEADER

-- parent material
\copy soilweb.pmkind to 'pmkind.csv' CSV HEADER
\copy soilweb.pmorigin to 'pmorigin.csv' CSV HEADER

-- MLRA membership
\copy soilweb.mlra_overlap to 'series-mlra-overlap.csv' CSV HEADER

