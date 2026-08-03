#' Check for missing variable labels
#'
#' This function checks whether all variables in a \code{GADSdat} object have been assigned a variable label.
#' Missing variable labels can indicate poorly documented data and may lead to issues in data analysis or reporting.
#'
#' @param GADSdat A \code{GADSdat} object containing the data for which variable labels should be checked.
#'
#' @return A \code{data.frame} with the names of variables that lack variable labels:
#' \itemize{
#'   \item \code{varName}: The name of the variable without a label.
#' }
#' If all variables have labels, the function returns an empty \code{data.frame}.
#'
#' @examples
#' # Example usage
#'
#' # Load example GADSdat object
#' GADSdat <- eatGADS::import_spss(system.file("extdata", "example_data2.sav", package = "eatFDZ"))
#'
#' # Check for variables missing labels
#' missing_labels <- check_var_labels(GADSdat)
#'
#' # Print the result
#' print(missing_labels)
#'
#'@export
check_var_labels <- function(GADSdat) {
  all_meta <- eatGADS::extractMeta(GADSdat)
  varLabels <- unique(all_meta[, c("varName", "varLabel")])

  missing_varLabels_vec <- varLabels[is.na(varLabels$varLabel), "varName"]
  data.frame(varName = missing_varLabels_vec)
}


