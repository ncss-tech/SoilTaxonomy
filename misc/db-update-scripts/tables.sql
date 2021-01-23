
-- geomorph
\copy soilweb.geomcomp_wide to '../databases/geomcomp_wide.csv' CSV HEADER
\copy soilweb.hillpos_wide to '../databases/hillpos_wide.csv' CSV HEADER
\copy soilweb.mountainpos_wide to '../databases/mountainpos_wide.csv' CSV HEADER

-- series stats
\copy soilweb.series_stats to '../databases/series_stats.csv' CSV HEADER

-- parent material
\copy soilweb.pmkind to '../databases/pmkind.csv' CSV HEADER
\copy soilweb.pmorigin to '../databases/pmorigin.csv' CSV HEADER

-- MLRA membership
\copy soilweb.mlra_overlap to '../databases/series-mlra-overlap.csv' CSV HEADER

-- PRISM climate database: 16MB
\copy soilweb.series_climate_stats TO '../databases/series_climate_stats.csv' CSV HEADER

