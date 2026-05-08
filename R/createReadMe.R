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

  file_table <- create_file_table(path = in_path)
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

create_file_table <- function(path) {
  # list all files in a directory by going through subdirectories recursively
  out <- list()

  all_files <- list.files(path = path,
                          full.names = TRUE,
                          recursive = FALSE)
  all_files <- all_files[!dir.exists(all_files)] # remove folders to only have true files
  all_files <- basename(all_files)
  all_sub_dirs <- list.dirs(path = path,
                            full.names = TRUE,
                            recursive = FALSE)

  if (length(all_files) > 0) {
    this_dir <- basename(path)
    file_tab <- data.frame(file_name = all_files,
                           name_length = nchar(all_files),
                           extension = stri_extract_last(str = all_files,
                                                         regex = "\\..{2,4}$"))
    file_tab$extension <- sub(pattern = "\\.",
                              replacement = "",
                              x = file_tab$extension)
    file_tab$description <- paste(lapply(file_tab$extension, switch,
                                         sav = "Dataset",
                                         dta = "Dataset",
                                         csv = "Dataset",
                                         txt = "ReadMe",
                                         pdf = "Documentation",
                                         pdfa = "Documentation",
                                         xlsx = "Codebook",
                                         sha = "Checksum",
                                         "Unspecified file"),
                                  "in", this_dir)
    out[[1]] <- file_tab
    names(out)[1] <- "files"
  } else {
    if (length(all_sub_dirs) == 0) return()
  }

  if (length(all_sub_dirs) > 0) {
    for (subdir in all_sub_dirs) {
      pointer <- length(out) + 1
      sub_content <- create_file_table(subdir)
      if (is.null(sub_content)) next # Don't list empty subdirs
      out[[pointer]] <- sub_content
      names(out)[[pointer]] <- basename(subdir)
    }
  } else {
    return(out)
  }

  return(out)
}
}
