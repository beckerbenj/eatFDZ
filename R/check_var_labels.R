#' Check existence of variable labels.
#'
#' Check the existence of variable labels for all variables in a \code{GADSdat}.
#'
#' Checks include
#' \itemize{
#' \item Have variable labels been assigned?
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
check_var_labels <- function(GADSdat) {
  all_meta <- eatGADS::extractMeta(GADSdat)
  varLabels <- unique(all_meta[, c("varName", "varLabel")])

  missing_varLabels_vec <- varLabels[is.na(varLabels$varLabel), "varName"]
  data.frame(varName = missing_varLabels_vec)
}


