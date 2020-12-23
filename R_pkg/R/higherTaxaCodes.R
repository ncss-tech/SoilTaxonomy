#' Decompose Soil Taxonomy Taxon Letter Codes to Parent Codes
#' 
#' @description Find all codes that logically comprise the specified codes. For instance, code "ABC" ("Anhyturbels") returns "A" ("Gelisols"), "AB" ("Turbels"), "ABC" ("Anhyturbels"). Use in conjunction with a lookup table that maps Order, Suborder, Great Group and Subgroup taxa to their codes (see \code{\link{taxon_code_to_taxon}} and \code{\link{taxon_to_taxon_code}}). This is the "logic" that underlies the \href{https://brownag.shinyapps.io/kstlookup/}{KSTLookup} app.
#' 
#' @details Accounts for Keys that run out of capital letters (more than 26 subgroups) and use lowercase letters for a unique subdivision within the "fourth character position." 
#' 
#' @param codes A character vector of taxon codes to "decompose"
#'
#' @return A list with equal length to input vector; one character vector per element
#' 
#' @seealso \code{\link{preceding_taxon_codes}}, \code{\link{taxon_code_to_taxon}}, \code{\link{taxon_to_taxon_code}}
#'
#' @export
#'
#' @examples
#' 
#' decompose_taxon_code(c("ABC", "ABCDe", "BCDEf"))
#' 
decompose_taxon_code <- function(codes) {
  clevels <- sapply(codes, function(cr) strsplit(cr, character(0)))
  clevel.sub <- lapply(clevels, function(cl) grepl("[a-z]", cl[length(cl)]))
  inter <- lapply(clevels, function(l) {
    res <- vector("list", length(l))
    for (i in 1:length(l)) {
      res[i] <- paste0(l[1:i], collapse = "")
    }
    return(res)
  })
  out <- lapply(1:length(inter), function(j) {
    res <- inter[j][[1]]
    if (clevel.sub[[names(inter[j])]]) {
      res[length(res) - 1] <- NULL
    }
    return(res)
  })
  names(out) <- codes
  return(out)
}

#' Identify Taxon Codes of Logically Preceding Taxa
#'
#' @description Find all codes that logically precede the specified codes. For instance, code "ABC" ("Anhyturbels") returns "AA"  ("Histels") "ABA" ("Histoturbels") and "ABB" ("Aquiturbels"). Use in conjunction with a lookup table that maps Order, Suborder, Great Group and Subgroup taxa to their codes (see \code{\link{taxon_code_to_taxon}} and \code{\link{taxon_to_taxon_code}}). This is the logic that underlies the \href{https://brownag.shinyapps.io/kstpreceding/}{KSTPreceding} app.
#' 
#' @details  Accounts for Keys that run out of capital letters (more than 26 subgroups) and use lowercase letters for a unique subdivision within the "fourth character position."
#' 
#' @param codes A character vector of codes to calculate preceding codes for
#'
#' @return A list with equal length to input vector; one character vector per element
#' @export
#' 
#' @seealso \code{\link{decompose_taxon_code}}, \code{\link{taxon_code_to_taxon}}, \code{\link{taxon_to_taxon_code}}
#'
#' @examples
#' 
#' preceding_taxon_codes(c("ABCDe", "BCDEf"))
#' 
preceding_taxon_codes <- function(codes) {
  lapply(codes, function(i) {
    out <- vector(mode = 'list',
                  length = nchar(i))
    parenttaxon <- character(0)
    for (j in 1:nchar(i)) {
      idx <- which(LETTERS == substr(i, j, j))
      idx.ex <- which(letters == substr(i, j, j))
      if (length(idx)) {
        previoustaxa <- LETTERS[1:idx[1] - 1]
        out[[j]] <- previoustaxa
        if (length(parenttaxon) > 0) {
          if (length(previoustaxa)) {
            out[[j]] <- paste0(parenttaxon, previoustaxa)
          }
          newparent <- LETTERS[idx[1]]
          if (length(newparent)) {
            parenttaxon <- paste0(parenttaxon, newparent)
          }
        } else {
          parenttaxon <- LETTERS[idx[1]]
        }
      } else if (length(idx.ex)) {
        previoustaxa <- c("", letters[1:idx.ex[1]])
        out[[j]] <- previoustaxa
        if (length(parenttaxon) > 0) {
          out[[j]] <- paste0(parenttaxon, previoustaxa)
          parenttaxon <- paste0(parenttaxon, letters[idx.ex[1]])
        } else {
          parenttaxon <- letters[idx.ex[1]]
        }
      } else {
        out[[j]] <- NA
      }
    }
    
    return(do.call('c', out))
  })
}

#' Convert Taxon Code to Taxon
#'
#' @param code A character vector of Taxon Codes
#'
#' @return A character vector of matching Taxon Names
#' @export
#' 
#' @seealso \code{\link{decompose_taxon_code}}, \code{\link{preceding_taxon_codes}}, \code{\link{taxon_to_taxon_code}}
#'
#' @examples
#' 
#' taxon_code_to_taxon(c("ABC", "XYZ", "DAB", NA))
#' 
taxon_code_to_taxon <- function(code) {
  
  # for R CMD check
  ST_higher_taxa_codes_12th <- NULL
  
  # load local copy of taxon code lookup table
  load(system.file("data/ST_higher_taxa_codes_12th.rda", package = "SoilTaxonomy")[1])
  
  # return matches
  idx <- code %in% ST_higher_taxa_codes_12th$code 
  res <- vector("character", length(idx))
  res[!idx] <- NA
  res[idx] <- ST_higher_taxa_codes_12th[which(ST_higher_taxa_codes_12th$code %in% code), 'taxon']
  return(res)
}

#' Convert Taxon to Taxon Code
#'
#' @param taxon A character vector of Taxon Names
#'
#' @return A character vector of matching Taxon Codes
#' 
#' @export
#' 
#' @seealso \code{\link{decompose_taxon_code}}, \code{\link{preceding_taxon_codes}}, \code{\link{taxon_code_to_taxon}}
#'
#' @examples
#' 
#' taxon_to_taxon_code(c("Anhyturbels", "foo", "Cryaquands", NA))
#' 
taxon_to_taxon_code <- function(taxon) {
  
  # for R CMD check
  ST_higher_taxa_codes_12th <- NULL
  
  # load local copy of taxon code lookup table
  load(system.file("data/ST_higher_taxa_codes_12th.rda", package = "SoilTaxonomy")[1])
  
  # return matches
  idx <- taxon %in% ST_higher_taxa_codes_12th$taxon 
  res <- vector("character", length(idx))
  res[!idx] <- NA
  res[idx] <- ST_higher_taxa_codes_12th[which(ST_higher_taxa_codes_12th$taxon %in% taxon), 'code']
  return(res)
}

#' Determine Relative Position of Taxon within Existing Keys 
#'
#' @description The relative position of a taxon is `[number of preceding Key steps] + 1`, or `NA` if it does not exist in the lookup table.
#' 
#' @param code A character vector of taxon codes to determine the relative position of.
#'
#' @return A numeric vector with the relative position of each code with respect to their individual Keys.
#' 
#' @export
#'
#' @examples
#' 
#' # "ABCD" -> "Gypsic Anhyturbels", relative position 7
#' # "WXYZa" does not exist, theoretical position is 97
#' # "BAD" -> "Udifolists", relative position is 5
#' 
#' relative_taxon_code_position(c("ABCD", "WXYZa", "BAD"))
#' 
#' # [1]  7 NA  5
#' 
relative_taxon_code_position <- function(code) {
  
  # calculate theoretical positions for each code
  res <- sapply(preceding_taxon_codes(code), function(x) {
    return(length(x) + 1)
  })
  
  # non-existent codes return NA
  tst <- vapply(taxon_code_to_taxon(code), FUN.VALUE = logical(1), is.na)
  bad_idx <- which(tst)
  
  if (length(tst) == 0) { 
    return(NA)
  } else if (length(tst) > 0 & 
             length(bad_idx) == 0) {
    return(res)
  } 
  
  res[bad_idx] <- NA
  return(res)
}

