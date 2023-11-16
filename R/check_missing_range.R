#' Check missing range.
#'
#' Check all labeled values if they fall in the range for missing values \code{GADSdat}.
#'
#' Checks include
#' \itemize{
#' \item ...
#' }
#'
#'@param GADSdat \code{GADSdat} object.
#'@param missingRange Values which should be declared as missings.
#'
#'@return Returns the test report.
#'
#'@examples
#'# tbd
#'
#'@export
check_missing_range <- function(GADSdat, missingRange = -50:-99) {
  suppressMessages(checked_dat <- eatGADS::checkMissingsByValues(GADSdat, missingValues = missingRange))

  changed_vars <- eatGADS::equalGADS(GADSdat, checked_dat)$meta_data_differences
  changed_meta <- eatGADS::extractMeta(GADSdat, changed_vars)

  out <- changed_meta[changed_meta$value %in% missingRange, c("varName", "value", "valLabel", "missings")]
  row.names(out) <- NULL
  out
}


