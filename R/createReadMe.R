#' Create the ReadMe file for a data user archive
#'
#' @param
#'
#' @returns
#'
#' @examples
#'
#' @export
createReadMe <- function(in_path, out_path = NULL, lang = c("de", "en"),
                         create_table = c("none", "control", "overview"), flat_depth = NULL) {
  if (!is.character(in_path) || length(in_path) == 0) {
    stop("'in_path' needs to be a character vector of length > 0.",
         call. = FALSE)
  }
  lang <- match.arg(lang, several.ok = TRUE)
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
  file_table_deep <- create_file_table(path = in_path)

  ## create ReadMe file ##
  file_table_flat <- flatten_file_table(dirname = basename(in_path),
                                        file_table = file_table_deep,
                                        flat_depth = flat_depth)
  names(file_table_flat) <- sub(x = names(file_table_flat),
                                pattern = "description",
                                replacement = "description_en")
  # translate descriptions if necessary
  if ("de" %in% lang) {
    # reassamble file_table_flat: cols up to English description, German description, other cols
    position_descr_col <- which(names(file_table_flat) == "description_en")
    first_cols <- file_table_flat[, 1:position_descr_col]
    last_cols <- file_table_flat[, (position_descr_col + 1):ncol(file_table_flat)]
    description_de <- stri_replace_all_fixed(str = file_table_flat$description_en,
                                             pattern = c("Dataset",
                                                         "Documentation",
                                                         "Checksum",
                                                         "Unspecified file"),
                                             replacement = c("Datensatz",
                                                             "Dokumentation",
                                                             "Checksumme",
                                                             "Unspezifizierte Datei"),
                                             vectorise_all = FALSE)
    file_table_flat <- cbind(first_cols, description_de, last_cols)
    rm(position_descr_col, first_cols, description_de, last_cols)
  }

  # select language specific descriptions based on user input
  cols_of_selected_lang <- grep(x = names(file_table_flat),
                                pattern = paste0("(_",
                                                 paste(lang, collapse = "$)|(_"),
                                                 "$)"))
  file_table2write <- file_table_flat[, -cols_of_selected_lang]
  rm(cols_of_selected_lang)
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

create_file_table <- function(path, prev_depth = 0) {
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
                           depth = prev_depth,
                           name_length = nchar(all_files),
                           extension = stri_extract_last(str = all_files,
                                                         regex = "\\..{2,4}$"))
    file_tab$extension <- sub(pattern = "\\.",
                              replacement = "",
                              x = file_tab$extension)
    file_tab$description_en <- paste(lapply(file_tab$extension, switch,
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
      sub_content <- create_file_table(subdir, prev_depth = prev_depth + 1)
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
                    depth = depth,
                    group = dirname)

  # list direct files
  if (names(file_table)[[1]] == "files") {
    out <- rbind(out,
                 data.frame(file_name = file_table$files$file_name,
                            description = file_table$files$description,
                            depth = depth,
                            group = dirname))
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
                 flatten_file_table(dirname = paste(dirname,
                                                    names(file_table)[[i]],
                                                    sep = "/"),
                                    file_table = file_table[[i]],
                                    flat_depth = flat_depth,
                                    depth = depth,
                                    warning_issued = warning_issued))
  }
  return(out)
}
