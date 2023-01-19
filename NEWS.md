# SoilTaxonomy 0.2.3 (2023-01-18)
 - Fix unintended case-sensitivity of `FormativeElements()`; thanks to Shawn Salley (@swsalley)
 - Fix for `extractSMR()` via fix for `FormativeElements()` applied at multiple levels (affects taxa above subgroup level)
 - Add `level_hierarchy()` a helper function for creating ordered factors related to the levels: "order", "suborder", "greatgroup", "subgroup", "family".
 - Taxon code lookup tables are now cached in the package environment (`SoilTaxonomy.env`) after the first time they are used for a moderate boost in performance in scenarios calling `taxon_code_to_taxon()` or `taxon_to_taxon_code()` many times

# SoilTaxonomy 0.2.2 (2022-10-01)
 * The order of dataset `ST` is now based on the full subgroup level code (https://github.com/ncss-tech/SoilTaxonomy/issues/35). Partial codes corresponding to each level of the hierarchy are also included in columns: `order_code`, `suborder_code`, `greatgroup_code` and `subgroup_code`.
 * New function `SoilTaxonomyLevels()`: used for creating ordinal and nominal factors corresponding to taxonomic levels `"order"`, `"suborder"`, `"greatgroup"`, and `"subgroup"` (https://github.com/ncss-tech/SoilTaxonomy/issues/39).
 * New function `SoilMoistureRegimeLevels()` and `SoilTemperatureRegimeLevels()`: used for creating ordinal and nominal factors corresponding to Soil Moisture and Temperature Regimes (https://github.com/ncss-tech/SoilTaxonomy/issues/34).
 * `FormativeElements()` can now take multiple `level` values, returning the formative elements found at each level combined in a single data.frame.
 * New function `get_ST_formative_elements()` a helper function for getting a data.frame containing descriptors of formative elements used at the specified `level`(s)
 * New function `extractSMR()`: utilizes order to subgroup formative elements to identify Soil Moisture Regimes from taxon names

# SoilTaxonomy 0.2.1 (2022-07-21)
 * New function `newick_string()`: used for creating parenthetical "Newick" (or "New Hampshire") format tree string inputs to functions such as `ape::read.tree()`
 
# SoilTaxonomy 0.2.0 (2022-07-12)
 * New vignette related to soil diagnostic features and characteristics `get_ST_features()`
 * New function `get_ST_family_classes()` (the `ST_family_classes` analogue of `ST_features`/`get_ST_features()`)
 * `ST_family_classes` gains information on the `"aniso"` particle-size class modifier
 * `parse_family()` now returns additional columns reflecting NASIS physical column names corresponding to components of the family-level taxonomy
    * This routine uses the NASIS metadata that ares cached in the {soilDB} package, which has been added to Suggests
    * `parse_family()` gains `flat` argument (default `TRUE`) to toggle returning list columns for "child" table taxonomic family data such as mineralogy class and "other" taxonomic family class.

# SoilTaxonomy 0.1.5 (2022-02-15)
 * `taxon_code_to_taxon` and `taxon_to_level` now support family-level taxa with only one class e.g. "Thermic Typic Quartzipsamments"
 * included data `ST_unique_list` is now sorted according to the order of appearance in the Keys to Soil Taxonomy (12th edition)
 
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
