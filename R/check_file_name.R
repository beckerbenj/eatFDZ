#' Check file name.
#'
#' Check and validate a file name.
#'
#' Checks in variable names include
#' \itemize{
#' \item special signs such as \code{Umlaute}
#' \item spaces
#' }
#'
#'@param path File path.
#'
#'@return Returns the test report.
#'
#'@examples
#'# tbd
#'
#'@export
check_file_name <- function(path) {
  file_name <- basename(path)

  # spaces
  clean_encoding_file_name <- eatGADS::fixEncoding(file_name)
  clean_encoding_file_name <- gsub(" ", "", clean_encoding_file_name)

  if(!identical(file_name, clean_encoding_file_name)) {
    stop("File name contains special characters or spaces.")
  }

  # special signs? see R.utils:::getFilename.Arguments
}
