#' Check variable names.
#'
#' Check variable names of variables in a \code{GADSdat}.
#'
#' Checks in variable names include
#' \itemize{
#' \item special signs such as \code{Umlaute}
#' \item column names with a \code{"."} in it.
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
check_var_names <- function(GADSdat) {
  nam <- eatGADS::namesGADS(GADSdat)

  suppressMessages(fixed_nam_GADSdat <- eatGADS::checkVarNames(GADSdat, checkKeywords = FALSE, checkDots = TRUE))
  fixed_nam <- eatGADS::namesGADS(fixed_nam_GADSdat)
  fixed_nam <- eatGADS::fixEncoding(fixed_nam)

  bad_encoding_var_names_vec <- nam[nam != fixed_nam]
  data.frame(varName = bad_encoding_var_names_vec)
}
