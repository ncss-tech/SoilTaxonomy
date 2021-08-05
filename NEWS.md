# SoilTaxonomy 0.1.4 (2021-08-05)
 * Update `ST_formative_elements` / `explainST()` with subgroup-level descriptions for missing taxa

# SoilTaxonomy 0.1.3 (2021-05-02)
 * Add `code_to_level` to abstract core from `taxon_to_level` for higher taxa with letter codes
 * Add `getChildTaxa` counterpart to `getParentTaxa`; `getParentTaxa` can now be filtered with `level` argument
 * Fixes for `stringsAsFactors` defaulting to `TRUE` on R <4.0

# SoilTaxonomy 0.1.2 (2021-04-29)
 * Extend `explainST` to work on Order, Suborder and Great Group taxonomic names
 * Add methods `level_to_taxon` and `taxon_to_level` to determine where taxa occur in the hierarchy 
 * New data sets: `ST_features`, `ST_family_classes` for diagnostic horizons/features/properties and family-level class names and related content
   * Derived from 12th Edition Keys to Soil Taxonomy definitions and criteria until official release of 13th Edition 
   * Data sourced from https://github.com/ncss-tech/SoilKnowledgeBase/ `create_KST` module JSON output
 * Add `parse_family` method for separating family-level classes from higher taxonomic names 
 * Add `get_ST_features` wrapper method for filtering `ST_features` data set 
 * Add `getLastChildTaxon` method to determine last in Keys at specified `level` (Order, Suborder, or Great Group)
 
# SoilTaxonomy 0.1.1 (2021-03-15)
 * Re-factored `taxon_code_to_taxon` & `taxon_to_taxon_code` to use LEFT JOIN
 * Added a `NEWS.md` file to track changes to the package

# SoilTaxonomy 0.1 (2021-02-23)
 * Initial CRAN release
