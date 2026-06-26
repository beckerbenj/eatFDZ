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
                         margin = 4, col_width = 90, max_width = 300,
                         indent_per_level = 2, max_indent = 10,
                         create_table = c("none", "control", "overview"), flat_depth = NULL) {
  if (!is.character(in_path) || length(in_path) == 0) {
    stop("'in_path' needs to be a character vector of length > 0.",
         call. = FALSE)
  }
  check_path_or_null(out_path)
  lang <- match.arg(lang, several.ok = TRUE)
  check_whole_number(margin)
  check_whole_number(col_width)
  check_whole_number(max_width)
  check_whole_number(indent_per_level)
  check_whole_number(max_indent)
  create_table <- match.arg(create_table)
  if (!is.null(flat_depth)) eatGADS:::check_numericArgument(flat_depth)

  # Input = singular directory path     -> ReadMe = file list
  # Input = list of > 0 control file(s) -> ReadMe = list from control file(s)
  if (length(in_path) == 1) {
    content <- create_RM_from_dir(in_path = in_path,
                                  out_path = out_path,
                                  lang = lang,
                                  margin = margin,
                                  col_width = col_width,
                                  max_width = max_width,
                                  indent_per_level = indent_per_level,
                                  max_indent = max_indent,
                                  create_table = create_table,
                                  flat_depth = flat_depth)
  } else {
    content <- create_RM_from_tab(in_path = in_path,
                                  out_path = out_path)
  }
  return(content)
}

create_RM_from_dir <- function(in_path, out_path, lang, margin, col_width, max_width,
                               indent_per_level, max_indent, create_table, flat_depth) {
  if (!dir.exists(in_path)) {
    stop("Directory '", in_path, "' does not exist.",
         call. = FALSE)
  }

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

  # paste together all alternative descriptions
  for (i in seq_along(lang)) {
    this_lang_col <- grep(x = names(file_table_flat),
                           pattern = paste0("_", lang[[i]], "$"))
    file_table2write$description <- file_table_flat[, this_lang_col]
    these_lines <- file_table_as_text(content = file_table2write,
                                      margin = margin,
                                      col_width = col_width,
                                      prefix = "- ",
                                      indent_per_level = indent_per_level,
                                      max_indent = max_indent,
                                      header = TRUE)
    if (i == 1) {
      lines2write <- list(these_lines)
      names(lines2write) <- lang[[i]]
    } else {
      lines2write[[lang[[i]]]] <-these_lines
    }
    rm(this_lang_col, these_lines)
  }


}

create_RM_from_tab <- function(in_path, out_path, create_table) {

}


#### auxiliary: checks ####

check_path_or_null <- function(arg, argName) {
  if (missing(argName)) {
    argName <- deparse(substitute(arg))
  }
  if (is.null(arg)) {
    return(NULL)
  }
  if (is.character(arg) && dir.exists(arg)) {
    return(NULL)
  }
  if (is.character(arg) && dir.exists(dirname(arg))) {
    return(NULL)
  } else {
    stop("'", argName, "' has to be either NULL, or an existing directory or file path.",
         call. = FALSE)
  }
}

check_whole_number <- function(arg, argName) {
  if (missing(argName)) {
    argName <- deparse(substitute(arg))
  }
  eatGADS:::check_numericArgument(arg = arg, argName = argName)
  if (arg == round(arg)) {
    return(NULL)
  } else {
    stop("'", argName, "' has to be a whole number.",
         call. = FALSE)
  }
}

#### auxiliary: substantive ####

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

file_table_as_text <- function(content, margin = 4, col_width = 90, prefix = "- ",
                               indent_per_level = 2, max_indent = 10, header = TRUE) {
  filenames <- content$file_name
  descriptions <- content$description
  depths <- content$depth

  lengths_name <- nchar(filenames, type = "char")
  lengths_indentation <- depths * indent_per_level
  lengths_indentation[lengths_indentation > max_indent] <- max_indent
  lengths_indented_name <- lengths_name + lengths_indentation
  col_width <- max(c(max(lengths_indented_name) + margin,
                     col_width))

  groups <- unique(content$group)
  full_lines <- sapply(seq_along(groups), function(group_index) {
    this_group <- subset(content,
                         subset = group == groups[[group_index]],
                         select = c(file_name, description, depth))

    this_depth <- this_group$depth[[1]]
    lines_above <- abs(this_depth[[1]] - max(depths)) + 1

    # no lines above if previous group had no direct files
    if (group_index == 1 || nrow(subset(content, group == groups[[group_index - 1]])) == 1) {
      lines_above <- 0
    }

    # reduce header indentation
    if (header) {
      this_depth <- c(this_depth, rep(this_depth + 1, nrow(this_group) - 1))
    }

    this_section <- these_filenames <- sapply(seq_along(this_group$file_name), function(x) {
      paste0(paste0(rep(" ",
                        indent_per_level * this_depth[[x]]),
                    collapse = ""),
             this_group$file_name[[x]])
    })

    # paste together lines and fill left column with blanks if necessary
    lines_with_description <- this_group$description != ""
    if (any(lines_with_description)) {
      these_descriptions <- paste0(prefix, this_group$description[lines_with_description])

      this_section[lines_with_description] <- fill_with_blanks(col1 = these_filenames[lines_with_description],
                                                               col2 = these_descriptions,
                                                               width = col_width)
    }

    # add blank lines above, depending on depth of group
    this_section <- c(rep("", lines_above),
                      this_section)
  })
  full_lines <- unlist(full_lines)
  return(full_lines)
}

fill_with_blanks <- function(col1, col2, width, use_tabs = TRUE) {
  if (length(col1) != length(col2)) {
    length_diff <- length(col1) - length(col2)
    if (length_diff > 0) {
      col2 <- c(col2, rep("", length_diff))
    } else {
      col1 <- c(col1, rep("", length_diff))
    }
  }

  length_col1 <- nchar(col1, type = "char")
  fill_blanks <- width - length_col1

  if (use_tabs) {
    fill_tabs <- floor(fill_blanks / 8)
    fill_blanks <- fill_blanks %% 8
    tabs <- sapply(fill_tabs, function(x) paste0(rep("\t", x), collapse = ""))
    blanks <- sapply(fill_blanks, function(x) paste0(rep(" ", x), collapse = ""))
    filler <- paste0(blanks, tabs)
  } else {
    filler <- sapply(fill_blanks, function(x) paste0(rep(" ", x), collapse = ""))
  }

  out <- paste0(col1, filler, col2)
  return(out)
}
