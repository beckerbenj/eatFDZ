#' Check existence of character variables.
#'
#' Check the existence of character variables in a \code{GADSdat}.
#'
#'
#'@param GADSdat \code{GADSdat} object.
#'
#'@return Returns the test report.
#'
#'@examples
#'# tbd
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


