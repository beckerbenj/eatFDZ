#' Check encoding issues in meta data
#'
#' This function checks the meta data of a \code{GADSdat} object for encoding issues, such as the presence of special characters (e.g., \code{"Umlaute"} or other non-ASCII characters).
#' Encoding problems in meta data (e.g., variable labels, value labels) can lead to inconsistencies and issues when working with data across systems that expect clean encoding.
#'
#' Checks in the meta data include
#' \itemize{
#' \item special signs such as \code{Umlaute}
#' }
#'
#'@param GADSdat A \code{GADSdat} object containing the data to be checked for meta data encoding issues.
#'
#' @return A \code{data.frame} that reports the variables and labels with encoding issues:
#' \itemize{
#'   \item \code{"varName"}: The name of the variable with encoding issues (if applicable).
#'   \item \code{"value"}: The problematic value (if applicable).
#'   \item \code{"GADSdat_varLabel"}: The variable label with the detected encoding issue.
#'   \item \code{"GADSdat_valLabel"}: The value label with the detected encoding issue.
#' }
#' If no issues are found, the function returns an empty \code{data.frame}.
#'
#'@examples
#' # Example usage:
#' # Load example GADSdat object
#' GADSdat <- eatGADS::import_spss(system.file("extdata", "example_data2.sav", package = "eatFDZ"))
#'
#' # Check for encoding issues in meta data
#' meta_encoding_issues <- check_meta_encoding(GADSdat)
#'
#' # Print the result
#' print(meta_encoding_issues)
#'
#'@export
check_meta_encoding <- function(GADSdat) {
  clean_encoding_gads <- eatGADS::fixEncoding(GADSdat)


  all_differences <- eatGADS::equalGADS(GADSdat, clean_encoding_gads)
  bad_encoding_meta_data_vec <- all_differences$meta_data_differences

  if(length(bad_encoding_meta_data_vec) == 0) {
    return(data.frame(varName = character()))
  }

  out <- list()
  for(nam in bad_encoding_meta_data_vec) {
    single_out <- eatGADS::inspectMetaDifferences(varName = nam, GADSdat = GADSdat,
                                    other_GADSdat = clean_encoding_gads)

    if(!identical(single_out$varDiff, "all.equal")) {
      single_out$varDiff <- single_out$varDiff[, "GADSdat_varLabel", drop = FALSE]
    } else {
      single_out$varDiff <- data.frame(GADSdat_varLabel = character())
    }

    if(!identical(single_out$valDiff, "all.equal")) {
      single_out$valDiff <- single_out$valDiff[, c("value", "GADSdat_valLabel")]
    } else {
      single_out$valDiff <- data.frame(value = numeric(), GADSdat_valLabel = character())
    }

    single_out_df <- do.call(plyr::rbind.fill, single_out)
    out[[nam]] <- single_out_df
  }

  eatTools::do_call_rbind_withName(out, colName = "varName")
}
