#'
#' @title Soil Taxonomy Hierarchy
#' 
#' @description The first 4 levels of the US Soil Taxonomy hierarchy (soil order, suborder, greatgroup, subgroup), presented as a \code{data.frame} (de-normalized) and a \code{list} of unique taxa.
#' 
#' @usage data(ST)
#' 
#' @references 
#' 
#' Soil Survey Staff. 1999. Soil taxonomy: A basic system of soil classification for making and interpreting soil surveys. 2nd edition. Natural Resources Conservation Service. U.S. Department of Agriculture Handbook 436.
#' \url{https://www.nrcs.usda.gov/wps/portal/nrcs/main/soils/survey/class/taxonomy/}
#' 
#' Soil Survey Staff. 2014. Keys to Soil Taxonomy, 12th ed. USDA-Natural Resources Conservation Service, Washington, DC.
#' \url{https://www.nrcs.usda.gov/wps/portal/nrcs/detail/soils/survey/class/taxonomy/?cid=nrcs142p2_053580}
#' 
#' 
#' @aliases ST_unique_list
#'
#' @keywords datasets
#'
"ST"


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
#' @description A lookup table mapping unique taxonomic Order, Suborder, Great Group and Subgroups to letter codes that denote their logical position within the Keys. This is the lookup table used for the \href{https://brownag.shinyapps.io/kstlookup/}{KSTLookup} and \href{https://brownag.shinyapps.io/kstpreceding/}{KSTPreceding} apps. 
#' 
#' @details The lookup table has been corrected to reflect errata that were posted after the print publication of the 12th Edition Keys, as well as typos in the Spanish language edition. 
#' 
#' @references
#' 
#' Soil Survey Staff. 2014. Keys to Soil Taxonomy, 12th ed. USDA-Natural Resources Conservation Service, Washington, DC.
#' \url{https://www.nrcs.usda.gov/wps/portal/nrcs/detail/soils/survey/class/taxonomy/?cid=nrcs142p2_053580}
#' 
#' Soil Survey Staff. 2014. Claves para la Taxonomía de Suelos, 12th ed. USDA-Natural Resources Conservation Service, Washington, DC.
#' \url{https://www.nrcs.usda.gov/Internet/FSE_DOCUMENTS/nrcs142p2_051546.pdf}
#' 
#' @usage data(ST_higher_taxa_codes_12th)
#' 
#' @keywords datasets
#'
"ST_higher_taxa_codes_12th"

