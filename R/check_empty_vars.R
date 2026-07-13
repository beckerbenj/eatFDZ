#' Check for empty variables
#'
#' Identifies variables that contain only missing values. Values tagged as
#' missing in the metadata are treated as missing.
#'
#' @param GADSdat A \code{GADSdat} object.
#'
#' @return A \code{data.frame} with the variable name and variable label.
#' If no empty variables are found, an empty \code{data.frame} is returned.
#'
#' @export
check_empty_vars <- function(GADSdat) {

  dat <- eatGADS::extractData2(GADSdat, convertMiss = TRUE)

  empty_vars <- names(dat)[
    vapply(dat, function(x) all(is.na(x)), logical(1))
  ]

  meta <- unique(
    eatGADS::extractMeta(GADSdat)[, c("varName", "varLabel")]
  )

  data.frame(
    varName = empty_vars,
    varLabel = meta$varLabel[match(empty_vars, meta$varName)],
    row.names = NULL
  )
}
