# =============================================================================
# Taxonomic distance functions for USDA Soil Taxonomy
#
# Computes distances between soil taxa based on the depth of their most recent
# common ancestor in the hierarchy. Mirrors the interface from taxodist but
# uses your taxonomy data as the source.
# =============================================================================

#' Get the full taxonomic lineage of a soil taxon
#'
#' Returns an ordered character vector from the root ("Soil") down to the
#' specified taxon, including all intermediate levels (Order through Subgroup).
#' Mirrors the lineage concept used in biological taxonomy packages such as
#' \pkg{taxodist}, but uses USDA Soil Taxonomy hierarchy.
#'
#' @param taxon A character vector of taxon names or codes (case-insensitive for
#'   names, case-sensitive for codes)
#' @param level Character: which level to resolve to. Default is `"subgroup"`
#'   (the deepest level in the higher taxonomy). Use `"greatgroup"`, `"suborder"`,
#'   or `"order"` for shallower lineages.
#'
#' @return A named character vector, e.g.:
#'   \code{c("Soil" = "Soils", "Order" = "Alfisols", "Suborder" = "Xeralfs",
#'           "Great Group" = "Haploxeralfs")}
#'
#' @details The lineage is constructed by decomposing the taxon's letter code
#'   into its constituent prefix codes (e.g., \code{"JDG"} \eqn{\rightarrow}
#'   \code{c("J", "JD", "JDG")}) and looking up each in the taxonomy lookup table.
#'
#' @examples
#' taxon_lineage("Haploxeralfs")
#' #>       Soil        Order      Suborder   Great Group
#' #>    "Soils"    "Alfisols"     "Xeralfs" "Haploxeralfs"
#'
#' taxon_lineage("JDG")  # by code
#' @export
taxon_lineage <- function(taxon, level = "subgroup") {

  level <- match.arg(level, c("order", "suborder", "greatgroup", "subgroup"))

  if (is.null(taxon) || length(taxon) == 0) stop("taxon must be provided")
  code <- taxon_to_taxon_code(taxon)

  decomposed <- decompose_taxon_code(code)

  res <- lapply(seq_along(decomposed), function(i) {
    d <- decomposed[[i]]
    if (is.null(d) || all(is.na(d))) return(NA_character_)

    names_vec <- taxon_code_to_taxon(d)
    levels_vec <- code_to_level(d)

    level_order <- c("order", "suborder", "greatgroup", "subgroup")
    level_idx <- match(levels_vec, level_order)
    target_idx <- match(level, level_order)
    keep <- !is.na(level_idx) & level_idx <= target_idx

    names_vec <- names_vec[keep]
    levels_vec <- levels_vec[keep]

    if (length(names_vec) == 0) return(NA_character_)

    result <- c("Soils", names_vec[-1])
    level_names <- c("Soil", levels_vec)
    names(result) <- level_names
    return(result)
  })

  names(res) <- taxon
  res
}


#' Find the depth of shared taxonomy between two taxa
#'
#' Computes how many levels of the USDA Soil Taxonomy hierarchy two taxa share
#' in common, from the root down to their deepest shared node (most recent
#' common ancestor). This is the core quantity used by distance metrics.
#'
#' @param taxon_a,taxon_b Character vectors of taxon names or codes. Vectors are
#'   recycled to equal length for pairwise comparison.
#' @param level Character: maximum hierarchical level to consider (default
#'   `"subgroup"`).
#'
#' @return Integer vector giving shared depth for each pair. Depth 0 means no
#'   shared root (should not occur within Soil Taxonomy, which is a single tree).
#'   Higher values indicate more closely related taxa.
#'
#' @details The depth counts from the root ("Soil" = 1) through the hierarchy.
#'   Two taxa at the same subgroup have depth 4; two taxa sharing only their
#'   order have depth 2.
#'
#' @examples
#' shared_taxon_depth("Haploxeralfs", "Lithic Mollic Haploxeralfs")
#' #> [1] 4  (shared: Soils, Alfisols, Xeralfs, Haploxeralfs)
#'
#' shared_taxon_depth("Haploxeralfs", "Argiustoll")
#' #> [1] 2  (shared only at order level: Soils vs Mollisols diverge)
#' @export
shared_taxon_depth <- function(taxon_a, taxon_b, level = "subgroup") {

  if (missing(taxon_a) || missing(taxon_b)) stop("Both taxon_a and taxon_b must be provided")

  n <- max(length(taxon_a), length(taxon_b))
  taxon_a <- rep(taxon_a, length.out = n)
  taxon_b <- rep(taxon_b, length.out = n)

  lineages_a <- taxon_lineage(taxon_a, level = level)
  lineages_b <- taxon_lineage(taxon_b, level = level)

  depths <- mapply(function(a, b) {
    if (is.na(a) || is.na(b)) return(NA_integer_)
    if (!is.character(a) || !is.character(b)) return(NA_integer_)

    h <- 0L
    for (i in seq_along(a)) {
      if (i <= length(b) && a[i] == b[i]) {
        h <- i
      } else {
        break
      }
    }
    as.integer(h)
  }, lineages_a, lineages_b)

  depths
}


#' Compute taxonomic distances between soil taxa
#'
#' Calculates distances based on the depth of the most recent common ancestor in
#' the USDA Soil Taxonomy hierarchy. Provides multiple distance metrics for
#' different analytical needs.
#'
#' @param taxon_a,taxon_b Character vectors of taxon names or codes. If both are
#'   length > 1, computes all pairwise distances (outer product). Vectors are
#'   recycled to equal length if needed.
#' @param metric Character: distance metric to use. Default `"reciprocal"`.
#'   Options:
#'   \describe{
#'     \item{"reciprocal"}{d = 1 / depth(MRCA) — ultrametric, best tracks
#'       divergence within a clade}
#'     \item{"path"}{d = depth(A) + depth(B) - 2 * depth(MRCA) — number of edges
#'       between taxa through the hierarchy}
#'     \item{"wu_palmer"}{d = 1 - 2 * h / (depth(A)+depth(B)) — normalized to
#'       [0, 1], corrects for uneven resolution of the classification}
#'   }
#' @param level Character: maximum hierarchical level to consider. Default
#'   `"subgroup"`.
#' @param ... Additional arguments (ignored, provided for API compatibility).
#'
#' @return Numeric vector or matrix of distances. Distance 0 means identical taxa;
#'   larger values indicate more distantly related taxa. Returns \code{Inf} if no
#'   shared root is found.
#'
#' @details The reciprocal metric produces an ultrametric within the connected
#'   hierarchy: d(A,C) <= max(d(A,B), d(B,C)). This makes it suitable for
#'   hierarchical clustering and ordination of soil taxa.
#'
#'   Distance and membership answer different questions. For example, a subgroup
#'   has a positive distance from its parent great group because they are distinct
#'   hierarchy nodes, even though the subgroup is a member of the great group.
#'   Use \code{\link{getParentTaxa}} or \code{\link{getChildTaxa}} when the
#'   relationship of interest is containment or ancestry.
#'
#' @examples
#' # Single pair
#' taxon_distance("Haploxeralfs", "Lithic Mollic Haploxeralfs")
#' #> [1] 0.25  (1/4)
#'
#' # Multiple pairs (recycled)
#' taxon_distance(c("Haploxeralfs", "Argiustoll"),
#'                c("Lithic Mollic Haploxeralfs", "Typic Hapludult"))
#'
#' # All pairwise (outer product)
#' taxa <- c("Haploxeralfs", "Argiustoll", "Typic Hapludult")
#' taxon_distance(taxa, taxa)
#'
#' # Different metrics
#' taxon_distance("Haploxeralfs", "Argiustoll", metric = "wu_palmer")
#' @export
taxon_distance <- function(taxon_a, taxon_b, metric = "reciprocal",
                           level = "subgroup", ...) {

  metric <- match.arg(metric, c("reciprocal", "path", "wu_palmer"))

  na_len <- length(taxon_a)
  nb_len <- length(taxon_b)
  is_outer <- (na_len > 1 && nb_len > 1)

  if (is_outer) {
    depths_ab <- outer(taxon_a, taxon_b, Vectorize(function(a, b) {
      shared_taxon_depth(a, b, level = level)
    }))

    depths_a <- sapply(taxon_a, function(a) {
      l <- taxon_lineage(a, level = level)
      if (is.na(l)) return(NA_real_)
      sum(!is.na(l))
    })
    depths_b <- sapply(taxon_b, function(b) {
      l <- taxon_lineage(b, level = level)
      if (is.na(l)) return(NA_real_)
      sum(!is.na(l))
    })

  } else {
    depths_ab <- shared_taxon_depth(taxon_a, taxon_b, level = level)
    depths_a <- sapply(taxon_a, function(a) {
      l <- taxon_lineage(a, level = level)
      if (is.na(l)) return(NA_real_)
      sum(!is.na(l))
    })
    depths_b <- sapply(taxon_b, function(b) {
      l <- taxon_lineage(b, level = level)
      if (is.na(l)) return(NA_real_)
      sum(!is.na(l))
    })
  }

  switch(metric,
    reciprocal = {
      d <- ifelse(depths_ab == 0, Inf, 1 / depths_ab)
      diag_mask <- outer(taxon_a, taxon_b, `==`)
      d[diag_mask] <- 0
    },
    path = {
      d <- depths_a + depths_b - 2 * depths_ab
      d[is.na(depths_ab)] <- NA_real_
    },
    wu_palmer = {
      denom <- depths_a + depths_b
      d <- ifelse(denom == 0, NA_real_, 1 - 2 * depths_ab / denom)
    }
  )

  if (is_outer) {
    rownames(d) <- taxon_a
    colnames(d) <- taxon_b
  }

  d
}


#' Compute pairwise distance matrix for multiple soil taxa
#'
#' Creates a symmetric distance matrix from a set of soil taxa, returning a base R
#' \code{dist} object suitable for hierarchical clustering (\code{hclust}),
#' ordination (\code{cmdscale}), and visualization.
#'
#' @param taxa Character vector of taxon names or codes
#' @param metric Character: distance metric (default `"reciprocal"`)
#' @param level Character: maximum hierarchical level (default `"subgroup"`)
#'
#' @return A \code{dist} object with taxon names as row/column labels. Same class
#'   as base R's \code{dist()}, so it works directly with clustering and ordination
#'   functions.
#'
#' @details The returned object uses the upper triangle of the distance matrix,
#'   stored in row-major order (as per the \code{dist} class convention). This
#'   makes it memory-efficient for large sets of taxa.
#'
#' @examples
#' taxa <- c("Haploxeralfs", "Lithic Mollic Haploxeralfs",
#'           "Argiustoll", "Typic Hapludult")
#' d <- taxon_distance_matrix(taxa)
#' hclust(d)  # hierarchical clustering of soil taxa
#'
#' cmdscale(d)  # principal coordinates analysis
#' @export
taxon_distance_matrix <- function(taxa, metric = "reciprocal", level = "subgroup") {

  if (length(taxa) < 2) stop("Need at least 2 taxa for a distance matrix")

  d_full <- taxon_distance(taxa, taxa, metric = metric, level = level)

  n <- length(taxa)
  d_vec <- as.vector(d_full)[upper.tri(d_full, diag = FALSE)]
  d_dist <- stats::as.dist(d_vec)
  dimnames(d_dist) <- list(taxa, taxa)

  d_dist
}


#' Create a classification tree from soil taxa
#'
#' Builds an \code{ape::phylo} object representing the minimal subtree connecting
#' all specified taxa, with internal nodes labeled by their most recent common
#' ancestor names. Useful for visualizing relationships among a set of soils.
#'
#' @param taxa Character vector of taxon names or codes
#' @param level Character: maximum hierarchical level (default `"subgroup"`)
#'
#' @return An \code{ape::phylo} object with named internal nodes. Requires the
#'   \pkg{ape} package (suggested dependency).
#'
#' @details The tree is constructed by finding all unique taxa in the lineages of
#'   the input taxa, then building a phylogenetic tree where tip labels are the
#'   original input taxa and internal node labels are their MRCA names. Branch
#'   lengths are set to 1 (equal spacing) since the distances represent hierarchy
#'   depth rather than evolutionary time.
#'
#' @note This function builds the minimal subtree by collecting all nodes from
#'   the input lineages and constructing edges between consecutive levels. For
#'   large taxon sets, consider using \code{taxon_distance_matrix()} with
#'   hierarchical clustering instead.
#'
#' @examples
#' \donttest{
#' if (requireNamespace("ape", quietly = TRUE)) {
#'   taxa <- c("Haploxeralfs", "Lithic Mollic Haploxeralfs",
#'             "Argiustoll", "Typic Hapludult")
#'   tree <- taxon_tree(taxa)
#'   plot(tree, show.node.label = TRUE)
#' }
#' }
#' @export
taxon_tree <- function(taxa, level = "subgroup") {

  if (!requireNamespace("ape", quietly = TRUE)) {
    stop("Package 'ape' is required for taxon_tree(). Install with install.packages('ape')")
  }

  all_lineages <- lapply(taxa, function(t) taxon_lineage(t, level = level))
  n <- length(taxa)

  if (n == 1) {
    return(ape::read.tree(text = paste0("(", taxa[1], "):")))
  }

  # Collect all unique node names from lineages
  all_nodes <- unique(unlist(lapply(all_lineages, function(l) {
    if (is.na(l)) return(NA_character_)
    l[!is.na(l)]
  })))
  all_nodes <- all_nodes[!is.na(all_nodes)]

  # Build edge list from lineage paths
  edges <- data.frame(parent = character(0), child = character(0), stringsAsFactors = FALSE)

  for (i in seq_along(taxa)) {
    l <- all_lineages[[i]]
    if (is.na(l) || length(l) < 2) next
    for (j in seq_len(length(l) - 1)) {
      edges <- rbind(edges, data.frame(
        parent = l[j], child = l[j + 1], stringsAsFactors = FALSE
      ))
    }
  }

  edges <- unique(edges)

  # Map node names to indices
  tip_set <- setNames(seq_along(taxa), taxa)
  internal_set <- setdiff(all_nodes, names(tip_set))
  all_labels <- c(names(tip_set), internal_set)
  all_labels <- all_labels[!is.na(all_labels)]

  if (length(all_labels) == 0) {
    stop("Could not construct tree from input taxa")
  }

  node_idx <- setNames(seq_along(all_labels), all_labels)

  edge_from <- sapply(edges$parent, function(p) as.integer(node_idx[p]))
  edge_to <- sapply(edges$child, function(c) as.integer(node_idx[c]))

  valid <- !is.na(edge_from) & !is.na(edge_to)
  edge_from <- edge_from[valid]
  edge_to <- edge_to[valid]

  if (length(edge_from) == 0) {
    stop("Could not build tree: no valid edges found")
  }

  n_internal <- max(node_idx) - length(taxa)

  tree <- list(
    edge = cbind(edge_from, edge_to),
    edge.length = rep(1, length(edge_from)),
    Nnode = as.integer(max(0, n_internal)),
    tip.label = taxa,
    label = all_labels
  )

  if (n_internal > 0 && length(internal_set) >= n_internal) {
    tree$node.label <- internal_set[seq_len(n_internal)]
  }

  class(tree) <- "phylo"
  ape::as.phylo(tree)
}


# =============================================================================
# Helper: compute shared depth for a single pair (used internally)
# =============================================================================
.shared_depth_single <- function(taxon_a, taxon_b, level) {
  la <- taxon_lineage(taxon_a, level = level)
  lb <- taxon_lineage(taxon_b, level = level)

  if (is.na(la) || is.na(lb)) return(NA_integer_)
  if (!is.character(la) || !is.character(lb)) return(NA_integer_)

  h <- 0L
  for (i in seq_along(la)) {
    if (i <= length(lb) && la[i] == lb[i]) {
      h <- i
    } else {
      break
    }
  }
  as.integer(h)
}
