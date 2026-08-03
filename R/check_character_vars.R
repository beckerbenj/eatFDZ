#' Check for the existence of character variables
#'
#' This function identifies all character variables in a \code{GADSdat} object and counts the number of unique values in each of those variables.
#' Character variables are often of particular interest as they may contain free text or other non-standardized inputs
#' that require additional review or processing.
#'
#' @param GADSdat A \code{GADSdat} object containing the data to be checked.
#'
#' @return A \code{data.frame} with the following columns:
#' \itemize{
#'   \item \code{varName}: The name of the character variable.
#'   \item \code{nUniqueValues}: The number of unique values in the character variable.
#' }
#' If no character variables exist, the function returns an empty \code{data.frame}.
#'
#' @examples
#' # Example usage:
#'
#' # Load example GADSdat object
#' GADSdat <- eatGADS::import_spss(system.file("extdata", "example_data2.sav", package = "eatFDZ"))
#'
#' # Check for character variables and count unique values
#' character_vars_report <- check_character_vars(GADSdat)
#'
#' # Print the report
#' print(character_vars_report)
#'
#'@export
check_character_vars <- function(GADSdat) {
  dat <- GADSdat$dat
  is_char <- sapply(dat, is.character)
  char_variables <- names(dat)[is_char]

  nUniqueValues <- integer()

  if(length(char_variables) > 0) {
    nUniqueValues <- sapply(char_variables, function(char_variable) {
      length(unique(dat[[char_variable]]))
    }, USE.NAMES = FALSE)
  }

  data.frame(varName = char_variables, nUniqueValues = nUniqueValues)
}


