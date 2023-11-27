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
