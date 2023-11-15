#' Check for lengthy variable names.
#'
#' Check for lengthy variable names of variables in a \code{GADSdat}.
#'
#'
#'@param GADSdat \code{GADSdat} object.
#'@param boundary Numeric vector of lenght 1. Boundary: Number of characters variables names are allowed
#'to have.
#'
#'@return Returns the test report.
#'
#'@examples
#'# tbd
#'
#'@export
check_var_names_length <- function(GADSdat, boundary = 30) {
  nam <- eatGADS::namesGADS(GADSdat)
  nchar_nam <- nchar(nam)

  out_frame <- data.frame(varName = nam,
                          nChars = nchar_nam)

  out_frame[out_frame$nChars > boundary, ]
}
