#' Check for lengthy variable names.
#'
#' This function checks whether variable names in a \code{GADSdat} object exceed the allowed number of characters.
#' This can help ensure that variable names adhere to naming conventions and avoid potential issues with downstream processing or compatibility.
#'
#'@param GADSdat \code{GADSdat} object.
#'@param boundary An integer specifying the maximum length (number of characters) a variable name is allowed to have. Default is 30.
#'
#'@return A \code{data.frame} containing the variable names that exceed the boundary, along with their respective character counts.
#' If all variable names are within the boundary, an empty \code{data.frame} is returned.
#'
#'@examples
#' # Example usage:
#' # Load example GADSdat object
#' GADSdat <- eatGADS::import_spss(system.file("extdata", "example_data2.sav", package = "eatFDZ"))
#'
#' # Check for variable names longer than 30 characters
#' lengthy_names <- check_var_names_length(GADSdat, boundary = 30)
#'
#' # Print the result
#' print(lengthy_names)
#'
#'@export
check_var_names_length <- function(GADSdat, boundary = 30) {
  nam <- eatGADS::namesGADS(GADSdat)
  nchar_nam <- nchar(nam)

  out_frame <- data.frame(varName = nam,
                          nChars = nchar_nam)

  out_frame[out_frame$nChars > boundary, ]
}
