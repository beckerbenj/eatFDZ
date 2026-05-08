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
  if (length(in_path) == 1) {
    content <- create_RM_from_dir(in_path = in_path,
                                  out_path = out_path,
                                  flat_depth = flat_depth)
  } else {
    content <- create_RM_from_tab(in_path = in_path,
                                  out_path = out_path)
  }


}

create_RM_from_dir <- function(in_path, out_path, create_table, flat_depth) {
  if (!dir.exists(in_path)) {
    stop("Directory '", in_path, "' does not exist.",
         call. = FALSE)
  }
  check_path_or_null(out_path)

  if (is.null(out_path)) {
    out_path <- in_path
  }
}
create_RM_from_tab <- function(in_path, out_path, create_table) {

}


#### auxiliary ####

check_path_or_null <- function(arg, argName) {
  if (missing(argName)) {
    argName <- deparse(substitute(arg))
  }
  if (is.null(arg) || (is.character(arg) && dir.exists(arg))) {
    return(NULL)
  } else {
    stop("'", argName, "' has to be either NULL, or an existing directory or file path.",
         call. = FALSE)
  }
}
}
