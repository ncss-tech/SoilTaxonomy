% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hierarchy.R
\name{level_hierarchy}
\alias{level_hierarchy}
\title{Order of Hierarchical Levels in Soil Taxonomy}
\usage{
level_hierarchy(
  x = c("order", "suborder", "greatgroup", "subgroup", "family"),
  family = TRUE,
  as.is = FALSE
)
}
\arguments{
\item{x}{Passed as input to \code{factor()}; defaults to full set: \code{"order"}, \code{"suborder"},  \code{"greatgroup"}, \code{"subgroup"}, \code{"family"},}

\item{family}{Allow \code{"family"} as input in \code{x}? Used for validating inputs that must be a "taxon above family".}

\item{as.is}{Return \code{x} "as is" (after validation)? Shorthand for \code{unclass(taxon_hierarchy())} to return simple character vector.}
}
\value{
An ordered factor with the values "order", "suborder", "greatgroup", "subgroup". or character when \code{as.is=TRUE}.
}
\description{
Creates an ordered factor such that different levels (the values used in \code{level} arguments to various SoilTaxonomy package functions) in the Soil Taxonomy hierarchy can be distinguished or compared to one another.
}
\details{
The levels of Soil Taxonomy hierarchy include: \code{"family"}, \code{"subgroup"}, \code{"greatgroup"}, \code{"suborder"}, \code{"order"}. The \code{"order"} is a level above \code{"suborder"}. \code{"subgroup"} and above are \code{"taxa above family"}.  Note: \code{"family"} is always included as the "lowest" level when the result is an ordered factor, even when family-level input is disallowed by \code{family=FALSE}.
}
\examples{

# is great group a taxon above family?

level_hierarchy("greatgroup") > "family"

# is order lower level than suborder?
level_hierarchy("order") < "suborder"

# what levels are above or equal to a particular taxon's level?
level_hierarchy(as.is = TRUE)[level_hierarchy() >= taxon_to_level("aquisalids")]

## this produces an error (used for checking for taxa above family)
# level_hierarchy("family", family = FALSE)
}
