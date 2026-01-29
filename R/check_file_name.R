#' Check and validate a file name
#'
#' This function checks the validity of a file name, ensuring that it does not contain special characters (e.g., \code{Umlaute})
#' or spaces. File names with problematic encoding or formatting are flagged, as these issues may cause errors when processing
#' files in different systems or environments.
#'
#' @param path A character string specifying the file path to be checked.
#'
#' @return This function returns an error if any issues are detected with the file name (e.g., special characters or spaces).
#' If the file name is valid, no output is returned.
#'
#' @examples
#' # Example of a valid file name
#' valid_path <- system.file("extdata", "example_data2.sav", package = "eatFDZ")
#' check_file_name(valid_path)
#'
#' # Example of an invalid file name (this will throw an error)
#' invalid_path <- "invalid file name.sav"
#' check_file_name(invalid_path)
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
