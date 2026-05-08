#' Create the ReadMe file for a data user archive
#'
#' @param
#'
#' @returns
#'
#' @examples
#'
#' @export
createReadMe <- function(in_path, out_path = NULL,
                         create_table = c("none", "control", "overview"), flat_depth = NULL) {
  if (!is.character(in_path) || length(in_path) == 0) {
    stop("'in_path' needs to be a character vector of length > 0.",
         call. = FALSE)
  }
  create_table <- match.arg(create_table)
  if (!is.null(flat_depth)) eatGADS:::check_numericArgument(flat_depth)

  # Input = singular directory path     -> ReadMe = file list
  # Input = list of > 0 control file(s) -> ReadMe = list from control file(s)
}
