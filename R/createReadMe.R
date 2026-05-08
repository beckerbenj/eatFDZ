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

  ## create ReadMe file ##
  positions_name_length <- grep(pattern = "name_length",
                                x = attributes(unlist(file_table))$names)
  max_name_length <- max(as.numeric(unlist(file_table)[positions_name_length]))
  file_list <- flatten_file_table(dirname = "",
                                  file_table = file_table,
                                  flat_depth = flat_depth)
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

flatten_file_table <- function(dirname, file_table, flat_depth, depth = 0, warning_issued = FALSE) {
  # name of folder
  out <- data.frame(file_name = dirname,
                    description = "",
                    depth = if (depth == 0) depth else depth - 1)

  # list direct files
  if (names(file_table)[[1]] == "files") {
    out <- rbind(out,
                 data.frame(file_name = file_table$files$file_name,
                            description = file_table$files$file_name,
                            depth = depth))
    if (length(file_table) == 1) return(out) # no further subdirectories
  }

  # go throught subdirectories recursively
  if (!is.null(flat_depth) && flat_depth == depth) {
    depth <- depth
  } else {
    depth <- depth + 1
    if (depth > 10 && !warning_issued && is.null(flat_depth)) {
      warning("This directory has an appending depth of more than 10 levels, i.e. there are at least",
              " 10 subdirectory levels between the top directory and its deepest subdirectory.",
              " Consider setting the 'flat_depth' argument to a reasonable value.",
              call. = FALSE)
      warning_issued <- TRUE
    }
  }
  for (i in 2:length(file_table)) {
    out <- rbind(out,
                 flatten_file_table(dirname = names(file_table)[[i]],
                                    file_table = file_table[[i]],
                                    flat_depth = flat_depth,
                                    depth = depth,
                                    warning_issued = warning_issued))
  }
  return(out)
}
