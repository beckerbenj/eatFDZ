#' Check if labeled values match a missing value regex pattern
#'
#' This function checks whether labeled values in the meta data of a \code{GADSdat} object match a specified regular expression (\code{missingRegex})
#' for missing value labels. It identifies values that are marked as valid but whose labels suggest they should be declared as missing,
#' based on the provided pattern.
#'
#' @param GADSdat A \code{GADSdat} object containing the data to be checked.
#' @param missingRegex A character string specifying the regular expression pattern used to identify value labels that should be treated as missing.
#' The default pattern is \code{"missing|omitted|not reached|nicht beantwortet|ausgelassen"}.
#'
#' @return A \code{data.frame} listing value labels that match the specified \code{missingRegex} pattern but are marked as valid in the meta data.
#' The output includes the following columns:
#' \itemize{
#'   \item \code{varName}: The name of the variable containing the value.
#'   \item \code{value}: The value itself that has a label matching the \code{missingRegex}.
#'   \item \code{valLabel}: The label associated with the value.
#'   \item \code{missings}: The current missing status in the meta data (should be \code{"valid"} if reported here).
#' }
#' If no issues are found, the function returns an empty \code{data.frame}.
#'
#' @examples
#' # Example usage:
#'
#' # Load example GADSdat object
#' GADSdat <- eatGADS::import_spss(system.file("extdata", "example_data2.sav", package = "eatFDZ"))
#'
#' # Check if labeled values match the missing value regex pattern
#' missing_regex_report <- check_missing_regex(GADSdat)
#'
#' # Print the report
#' print(missing_regex_report)
#'
#' # Using a custom regex pattern
#' custom_report <- check_missing_regex(GADSdat, missingRegex = "unanswered|unknown|keine Angabe")
#' print(custom_report)
#'
#'@export
check_missing_regex <- function(GADSdat, missingRegex = "missing|omitted|not reached|nicht beantwortet|ausgelassen") {
  suppressMessages(checked_dat <- eatGADS::checkMissings(GADSdat, missingLabel = missingRegex))

  changed_vars <- eatGADS::equalGADS(GADSdat, checked_dat)$meta_data_differences
  changed_meta <- eatGADS::extractMeta(GADSdat, changed_vars)

  out <- changed_meta[grepl(missingRegex, changed_meta$valLabel) & changed_meta$missings == "valid",
                      c("varName", "value", "valLabel", "missings")]
  row.names(out) <- NULL
  out
}


