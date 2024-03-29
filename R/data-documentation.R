#'
#' @title Soil Taxonomy Hierarchy
#'
#' @description The first 4 levels of the US Soil Taxonomy hierarchy (soil order, suborder, greatgroup, subgroup), presented as a \code{data.frame} (denormalized) and a \code{list} of unique taxa.
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

#' @title Family-level Classes for Soil Taxonomy
#'
#' @description A database of family-level class names for Soil Taxonomy.
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

#' @title Epipedons, Diagnostic Horizons, Characteristics and Features in Soil Taxonomy
#'
#' @description A `data.frame` with columns "group", "name", "chapter", "page", "description", "criteria". Currently page numbers and contents are referenced to 12th Edition Keys to Soil Taxonomy and derived from products in the ncss-tech SoilKnowledgeBase repository (https://github.com/ncss-tech/SoilKnowledgeBase).
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

#' @title Formative Elements used by Soil Taxonomy
#'
#' @description A database of formative elements used by the first 4 levels of US Soil Taxonomy hierarchy (soil order, suborder, greatgroup, subgroup).
#'
#' @references
#' S. W. Buol and R. C. Graham and P. A. McDaniel and R. J. Southard. Soil Genesis and Classification, 5th edition. Iowa State Press, 2003.
#'
#' @usage data(ST_formative_elements)
#'
#' @keywords datasets
#'
"ST_formative_elements"

#' @title Letter Code Lookup Table for Position of Taxa within the Keys to Soil Taxonomy (12th Edition)
#'
#' @description A lookup table mapping unique taxonomic Order, Suborder, Great Group and Subgroups to letter codes that denote their logical position within the Keys.
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

#' @title Letter Code Lookup Table for Position of Taxa within the Keys to Soil Taxonomy (13th Edition)
#'
#' @description A lookup table mapping unique taxonomic Order, Suborder, Great Group and Subgroups to letter codes that denote their logical position within the Keys.
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
