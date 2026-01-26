#' Check if labeled values fall within the specified missing value range
#'
#' This function checks whether all labeled values in the meta data of a \code{GADSdat} object fall within the specified range for missing values.
#' It identifies values that are labeled as valid but should be declared as missing based on the defined \code{missingRange}.
#'
#' @param GADSdat A \code{GADSdat} object containing the data to be checked.
#' @param missingRange A numeric vector specifying the range of values that should be treated as missing.
#' The default is \code{-50:-99}, but this can be customized.
#'
#' @return A \code{data.frame} listing labeled values that are within the specified \code{missingRange} but marked as valid in the meta data.
#' The output includes the following columns:
#' \itemize{
#'   \item \code{varName}: The name of the variable containing the value.
#'   \item \code{value}: The value itself that falls within the \code{missingRange}.
#'   \item \code{valLabel}: The label associated with the value.
#'   \item \code{missings}: The current missing status in the meta data (should be \code{"valid"} if reported here).
#' }
#' If all values within the \code{missingRange} are already declared as missing, the function returns an empty \code{data.frame}.
#'
#' @examples
#' # Example usage:
#'
#' # Load example GADSdat object
#' GADSdat <- eatGADS::import_spss(system.file("extdata", "example_data2.sav", package = "eatFDZ"))
#'
#' # Check if labeled values are within the missing value range (-50 to -99 by default)
#' missing_range_report <- check_missing_range(GADSdat)
#'
#' # Print the report
#' print(missing_range_report)
#'
#' @export
#'
#'@export
check_missing_range <- function(GADSdat, missingRange = -50:-99) {
  suppressMessages(checked_dat <- eatGADS::checkMissingsByValues(GADSdat, missingValues = missingRange))

  changed_vars <- eatGADS::equalGADS(GADSdat, checked_dat)$meta_data_differences
  changed_meta <- eatGADS::extractMeta(GADSdat, changed_vars)

  out <- changed_meta[changed_meta$value %in% missingRange & changed_meta$missings == "valid",
                      c("varName", "value", "valLabel", "missings")]
  row.names(out) <- NULL
  out
}


