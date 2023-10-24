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
#'
#'@return Returns the test report.
#'
#'@examples
#'# tbd
#'
#'@export
check_missing_regex <- function(GADSdat, missingRegex = "missing|omitted|not reached|nicht beantwortet|ausgelassen") {
  suppressMessages(checked_dat <- eatGADS::checkMissings(GADSdat, missingLabel = missingRegex))

  changed_vars <- eatGADS::equalGADS(GADSdat, checked_dat)$meta_data_differences
  changed_meta <- eatGADS::extractMeta(GADSdat, changed_vars)

  out <- changed_meta[grepl(missingRegex, changed_meta$valLabel), c("varName", "value", "valLabel", "missings")]
  row.names(out) <- NULL
  out
}


