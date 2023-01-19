#' Determine soilDB version with public-facing NASIS metadata methods is available
#'
#' Returns `TRUE` if soilDB package version is greater than or equal to "2.7.3"
#'
#' @param op operator e.g. `">="` or `">"`
#' @param min_version Default: `"2.7.3"` (version where `get_NASIS_metadata()` and related methods introduced)
#' @param strict Default: `TRUE` passed to `package_version()`
#' @param quietly Default: `TRUE` passed to `requireNamespace()`
#' @param ... additional arguments passed to `loadNamespace()`
#'
#' @return logical
#' @noRd
#' @keywords internal
.soilDB_metadata_available <- function(op = ">=", min_version = "2.7.3", strict = TRUE, quietly = TRUE, ...) {
  invisible(requireNamespace(
    package = 'soilDB',
    versionCheck = list(op = ">=", version = package_version(min_version, strict = strict)),
    quietly = quietly,
    ...
  ))
}
