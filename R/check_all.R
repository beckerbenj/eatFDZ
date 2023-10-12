#' Run all FDZ checks.
#'
#' Run all FDZ checks.
#'
#'
#'@param fileName Character string of the SPSS file
#'@param boundary Integer number: categories with less than or equal to \code{boundary} observations will be flagged
#'@param exclude Optional: character vector of variable names which should be excluded from the report
#'@param encoding Optional: The character encoding used for reading the \code{.sav} file. The default, \code{NULL}, uses the encoding specified in the file, but sometimes this value is incorrect and it is useful to be able to override it.
#'
#'@return A \code{data.frame}.
#'
#'
#'
#'@export
sdc_check <- function (sav_path, pdf_path, post_words = 2, case_sensitive = FALSE, encoding = NULL,
                       ) {
  # check codebook

  # check data disclosure control

  # id variable

  # data cleaning
}
