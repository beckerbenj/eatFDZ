#' Check for constant variables
#'
#' Identifies variables that contain exactly one distinct non-missing value.
#' Values defined as missing in the metadata are excluded from the check.
#'
#' @param GADSdat A \code{GADSdat} object.
#'
#' @return A \code{data.frame} with variable names, labels, and constant values.
#'
#' @export
check_constant_vars <- function(GADSdat) {

  dat <- eatGADS::extractData2(GADSdat, convertMiss = TRUE)

  valid_values <- lapply(dat, function(x) unique(x[!is.na(x)]))
  constant_vars <- names(valid_values)[lengths(valid_values) == 1L]

  meta <- unique(
    eatGADS::extractMeta(GADSdat)[, c("varName", "varLabel")]
  )

  data.frame(
    varName = constant_vars,
    varLabel = meta$varLabel[match(constant_vars, meta$varName)],
    value = vapply(
      valid_values[constant_vars],
      function(x) as.character(x[[1]]),
      character(1)
    ),
    row.names = NULL
  )
}
