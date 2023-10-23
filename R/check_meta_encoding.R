#' Check meta data encoding.
#'
#' Check the occurence of specials signs in the meta data of a \code{GADSdat}.
#'
#' Checks in the meta data include
#' \itemize{
#' \item special signs such as \code{Umlaute}
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
check_meta_encoding <- function(GADSdat) {
  #browser()
  clean_encoding_gads <- eatGADS::fixEncoding(GADSdat)

  all_differences <- eatGADS::equalGADS(GADSdat, clean_encoding_gads)
  bad_encoding_meta_data_vec <- all_differences$meta_data_differences
  data.frame(varName = bad_encoding_meta_data_vec)
}
