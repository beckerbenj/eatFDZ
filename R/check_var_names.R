#' Check variable names for encoding issues and dots
#'
#' This function checks whether variable names in a \code{GADSdat} object contain specific formatting issues,
#' focusing on:
#' \itemize{
#'   \item Encoding problems: Variables with non-ASCII characters, such as \code{"Umlaute"} or other special characters.
#'   \item The presence of dots (\code{"."}) in variable names.
#' }
#'
#' These checks help detect and report variable naming issues that may cause compatibility problems with certain tools or systems (e.g., Stata or databases with strict naming conventions).
#'
#'@param GADSdat A \code{GADSdat} object containing the data whose variable names are to be checked.
#'
#'@return A \code{data.frame} containing variable names that failed the checks.
#' If all variable names meet the requirements, the function returns an empty \code{data.frame}.
#'
#'@examples
#' # Example usage:
#' # Load example GADSdat object
#' GADSdat <- eatGADS::import_spss(system.file("extdata", "example_data2.sav", package = "eatFDZ"))
#'
#' # Check for problematic variable names
#' problematic_var_names <- check_var_names(GADSdat)
#'
#' # Print the result
#' print(problematic_var_names)#'
#'
#'@export
check_var_names <- function(GADSdat) {
  nam <- eatGADS::namesGADS(GADSdat)

  suppressMessages(fixed_nam_GADSdat <- eatGADS::checkVarNames(GADSdat, checkKeywords = FALSE, checkDots = TRUE))
  fixed_nam <- eatGADS::namesGADS(fixed_nam_GADSdat)
  fixed_nam <- eatGADS::fixEncoding(fixed_nam)

  bad_encoding_var_names_vec <- nam[nam != fixed_nam]
  data.frame(varName = bad_encoding_var_names_vec)
}
