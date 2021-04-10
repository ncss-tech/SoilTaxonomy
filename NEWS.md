# SoilTaxonomy 0.1.2 (2021-04-10)
 * Extend `explainST` to work on Order, Suborder and Great Group
 * Add methods `level_to_taxon` and `taxon_to_level` to determine where taxa occur in the hierarchy 
 * Add `get_ST_features` wrapper method for filtering `ST_features` data set 
   * Derived from 12th Edition Keys to Soil Taxonomy definitions and criteria, for now
   * Data sourced from https://github.com/ncss-tech/SoilKnowledgeBase/ KST parsing module output)

# SoilTaxonomy 0.1.1 (2021-03-15)
 * Refactored `taxon_code_to_taxon` & `taxon_to_taxon_code` to use LEFT JOIN
 * Added a `NEWS.md` file to track changes to the package.

# SoilTaxonomy 0.1 (2021-02-23)
 * Initial CRAN release
