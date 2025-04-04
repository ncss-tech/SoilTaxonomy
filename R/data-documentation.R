#'
#' Soil Taxonomy Hierarchy
#'
#' The first 4 levels of the US Soil Taxonomy hierarchy (soil order, suborder, greatgroup, subgroup), presented as a \code{data.frame} (denormalized) and a \code{list} of unique taxa.
#' @details Ordered based on the unique letter codes denoting taxa from the 13th edition of the Keys to Soil Taxonomy.
#' @usage data(ST)
#'
#' @references
#'
#' Soil Survey Staff. 1999. Soil taxonomy: A basic system of soil classification for making and interpreting soil surveys. 2nd edition. Natural Resources Conservation Service. U.S. Department of Agriculture Handbook 436.
#' \url{https://www.nrcs.usda.gov/resources/guides-and-instructions/soil-taxonomy}
#'
#' Soil Survey Staff. 2014. Keys to Soil Taxonomy, 12th ed. USDA-Natural Resources Conservation Service, Washington, DC.
#' \url{https://www.nrcs.usda.gov/resources/guides-and-instructions/keys-to-soil-taxonomy}
#'
#'
#' @aliases ST_unique_list
#'
#' @keywords datasets
#'
"ST"

#' Family-level Classes for Soil Taxonomy
#'
#' A database of family-level class names for Soil Taxonomy.
#'
#' @references
#'  Soil Survey Staff. 2014. Keys to Soil Taxonomy, 12th ed. USDA-Natural Resources Conservation Service, Washington, DC.
#' \url{https://www.nrcs.usda.gov/resources/guides-and-instructions/keys-to-soil-taxonomy}
#'
#' @usage data(ST_family_classes)
#'
#' @keywords datasets
#'
"ST_family_classes"

#' Epipedons, Diagnostic Horizons, Characteristics and Features in Soil Taxonomy
#'
#' A `data.frame` with columns "group", "name", "chapter", "page", "description", "criteria". Currently page numbers and contents are referenced to 12th Edition Keys to Soil Taxonomy and derived from products in the ncss-tech SoilKnowledgeBase repository (https://github.com/ncss-tech/SoilKnowledgeBase).
#'
#' @references
#' Soil Survey Staff. 2014. Keys to Soil Taxonomy, 12th ed. USDA-Natural Resources Conservation Service, Washington, DC.
#' \url{https://www.nrcs.usda.gov/resources/guides-and-instructions/keys-to-soil-taxonomy}
#'
#' @usage data(ST_features)
#'
#' @keywords datasets
#'
"ST_features"

#' Formative Elements used by Soil Taxonomy
#'
#' A database of formative elements used by the first 4 levels of US Soil Taxonomy hierarchy (soil order, suborder, greatgroup, subgroup).
#'
#' @references
#' S. W. Buol and R. C. Graham and P. A. McDaniel and R. J. Southard. Soil Genesis and Classification, 5th edition. Iowa State Press, 2003.
#'
#' @usage data(ST_formative_elements)
#'
#' @keywords datasets
#'
"ST_formative_elements"

#' Letter Code Lookup Table for Position of Taxa within the Keys to Soil Taxonomy (12th Edition)
#'
#' A lookup table mapping unique taxonomic Order, Suborder, Great Group and Subgroups to letter codes that denote their logical position within the Keys.
#'
#' @details The lookup table has been corrected to reflect errata that were posted after the print publication of the 12th Edition Keys, as well as typos in the Spanish language edition.
#'
#' @references
#'
#' Soil Survey Staff. 2014. Keys to Soil Taxonomy, 12th ed. USDA-Natural Resources Conservation Service, Washington, DC.
#' \url{https://www.nrcs.usda.gov/resources/guides-and-instructions/keys-to-soil-taxonomy}
#'
#' Soil Survey Staff. 2014. Claves para la Taxonomía de Suelos, 12th ed. USDA-Natural Resources Conservation Service, Washington, DC.
#' \url{https://www.nrcs.usda.gov/resources/guides-and-instructions/keys-to-soil-taxonomy}
#'
#' @usage data(ST_higher_taxa_codes_12th)
#'
#' @keywords datasets
#'
"ST_higher_taxa_codes_12th"

#' Letter Code Lookup Table for Position of Taxa within the Keys to Soil Taxonomy (13th Edition)
#'
#' A lookup table mapping unique taxonomic Order, Suborder, Great Group and Subgroups to letter codes that denote their logical position within the Keys.
#'
#' @references
#'
#' Soil Survey Staff. 2022. Keys to Soil Taxonomy, 13th ed. USDA-Natural Resources Conservation Service.
#' \url{https://www.nrcs.usda.gov/resources/guides-and-instructions/keys-to-soil-taxonomy}
#'
#' @usage data(ST_higher_taxa_codes_13th)
#'
#' @keywords datasets
#'
"ST_higher_taxa_codes_13th"


#' Keys to Soil Taxonomy Criteria (13th Edition)
#'
#' A lookup table relating taxon codes to specific criteria from the Keys to
#' Soil Taxonomy (13th Edition)
#'
#' @details
#'
#' A `list` containing one element per taxon code at order to subgroup level.
#' Each element contains a `data.frame` with 1 row per criterion, and 8 columns:
#'
#' Each `data.frame` contains the following columns:
#'  - `content` (text content of criterion)
#'  - `chapter` (chapter number)
#'  - `page` (page number)
#'  - `key` (key name or level)
#'  - `taxon` (taxon name)
#'  - `code` (taxon code)
#'  - `clause` (sequence number of criterion within taxon)
#'  - `logic` (logical meaning of criterion)
#'    - One of:
#'      - `FIRST` (first)
#'      - `OR` (either this criterion OR the next criterion at same level)
#'      - `END` (end of hierarchical key)
#'      - `NEW` (go to new page/taxon specified)
#'      - `AND` (this criterion AND the next criterion at same level)
#'      - `HAVE` (criteria that must be met)
#'      - `LAST` (end of subgroup key)
#'
#' @references
#'
#' Soil Survey Staff. 2022. Keys to Soil Taxonomy, 13th ed. USDA-Natural
#' Resources Conservation Service.
#' \url{https://www.nrcs.usda.gov/resources/guides-and-instructions/keys-to-soil-taxonomy}
#'
#' @usage data(ST_criteria_13th)
#'
#' @keywords datasets
#'
"ST_criteria_13th"

#' World Reference Base for Soil Resources (4th Edition, 2022)
#'
#' @details
#'
#' A _list_ containing three _data.frame_ elements `"rsg"`, `"pq"`, and `"sq"`
#' providing information on the 'Representative Soil Groups', 'Principal
#' Qualifiers,' and 'Supplementary Qualifiers,' respectively.
#'
#' Each element has the column `"code"` which is a number (1-32) referring to
#' the position in the Reference Soil Groups, and the column
#' `"reference_soil_group"` which is the corresponding group name. The `"pq"`
#' and `"sq"` qualifier name columns (`primary_qualifier` and
#' `supplementary_qualifier`) contain individual qualifier terms. Related
#' qualifiers are identified using `qualifier_group` column derived from
#' qualifier names separated with a forward slash `" / "`
#'
#'  - The _data.frame_ `"rsg"` has column `"criteria"`, describing the logical criteria for each Reference Soil Group.
#'  - The _data.frame_ `"pq"` has qualifier names in column `"principal_qualifier"`
#'  - The _data.frame_ `"sq"` has column `"supplementary_qualifier"`.
#'
#' @references
#'
#' IUSS Working Group WRB. 2022. World Reference Base for Soil Resources.
#' International soil classification system for naming soils and creating
#' legends for soil maps. 4th edition. International Union of Soil Sciences
#' (IUSS), Vienna, Austria.
#'
#' @usage data(WRB_4th_2022)
#'
#' @keywords datasets
#'
"WRB_4th_2022"
