#' Create a ReadMe file documenting directory contents
#'
#' List and describe the contents of a directory including all its subdirectories,
#'  reflecting the directory structure. Use this function to... \itemize{
#'   \item create an overview (and, optionally, a control table for future ReadMe construction)
#'    for an existing directory, or
#'   \item combine and apply control tables to describe a newly created directory.
#'  }
#'
#' This function serves the general purpose of creating a ReadMe that describes the contents of a
#'  folder/directory. While it can simply be used on an existing directory, its main purpose is in
#'  creating ReadMes for data packages delivered to the Research Data Centre's data users.
#'  The function has to modes which are selected based on the content of \code{in_path}:
#'  \enumerate{
#'  \item \strong{Directory mode}: If \code{in_path} is a single \code{file.path} that does not
#'   lead to a (table) file, this function runs in directory mode. It will list all files in the
#'   supplied directory as well as in all its subdirectories. While this can be used to create a
#'   simple ReadMe to give an overview of this directory, its main purpose is in creating control
#'   tables (see the \code{create_table} argument), which may then be enhanced with more specific
#'   file descriptions and reused by this function in table mode.
#'  \item \strong{Table mode}: If \code{in_path} is a vector of at least one \code{file.path} that
#'   leads to a control table file, this function runs in table mode. It will load each control
#'   table, paste together all tables' contents, and apply formatting to reflect the described
#'   directory structure. This mode may be used to describe data packages that are themselves
#'   created from a fixed inventory of data products described in the control tables.
#'  }
#'
#' @section Formatting: The look of the ReadMe file can be adjusted by a number of arguments.
#'  File names and file descriptions are set in a two-column table with a minimum \code{margin}
#'  between them and with the right column starting no more to the left than at \code{col_width}.
#'  File names are indented by x = \code{indent_per_level} spaces/blanks under the (sub)headline of
#'  their respective folder names, which may themselves be indented under their higher-level
#'  folder's names by the same number of spaces per level, but no more then \code{max_indent}.
#'
#'  Additional text sections may be added. For table mode, it is recommended to have one control
#'  table per section, with each table having a column named, e.g., "header_de" for a German header,
#'  that can be supplied to the function. Currently, the following sections are supported: \itemize{
#'  \item \code{header} - A centrally aligned header to the whole file, for example stating the name
#'   of the institution sending out the data package. It is added to the very top of the file.
#'   Aesthetic lines will be added above and below the header. The line styles are not yet
#'   customisable, but this functionality may be added on request.
#'  \item \code{content_box} - A higher-level table of content, further abstracting from the
#'   detailed file table below. It is added between the header and the main body/file table.
#'   Aesthetic lines will be added above and below. It may be used to list the "intermediate"
#'   data product packages/"studies" of the overall data package.
#'  \item \code{remarks} - A section of additional remarks about using the data. It is added below
#'   the main body/file table with a simple header above it. The header is not yet customisable,
#'   but this functionality may be added.
#'  \item \code{footer} - A footer section added to the very end of the file with decorative lines
#'   above and below. Use this to present, e.g., contact information.
#'  }
#'
#'
#' @param in_path Either a single directory path,
#'  or a character vector of at least one control table path.
#' @param out_path Optional \code{\link{file.path}} (incl. file name) for the ReadMe to be created in.
#'  \link{writeLines} needs to be able to write a plain text ReadMe here.
#'  If \code{NULL} (the defaul), no file is created.
#' @param lang Which language(s) should the ReadMe be created in? Per default, German (\code{"de"})
#'  and English (\code{"en"}) are supported, esp. for directory mode (see details). In table mode,
#'  any language acronym that matches a description column in the control tables can be selected.
#'  If more than one language is specified and an \code{out_path} is provided, one ReadMe will be
#'  created for each language, using \code{lang} as the file name suffix.
#' @param margin Formatting option: Numeric value of the minimum number of spaces that should
#'  separate file names and file descriptions.
#'  All formatting options only apply if a ReadMe is written to \code{out_path}.
#' @param col_width Formatting option: Numeric value of the default width at which the
#'  file descriptions should start. If \code{max(nchar(file names))} > \code{col_width},
#'  width will be set to \code{max(nchar(file names))} and \code{margin} will be applied on that.
#' @param indent_per_level Formatting option: Numeric value of the number of spaces used to
#'  indent a line to indicate its contents are one level lower than another line.
#' @param max_indent Formatting option: Numeric value of the maximum number
#'  of indentation spaces to use from \code{indent_per_level}.
#' @param create_table Control the return value of the function (see below).
#' @param sep Which column separator is used in the control tables?
#' @param flat_depth Directory mode only: At which depth should the function start pretending that
#'  all files and folders are on the same level. Using this may prevent file tables from blowing up
#'  but one may also consider not using the function on very deep directory structures.
#' @param skip_empty_base Directory mode only: Should the first level be ignored, if it contains no
#'  direct files? This is useful in creating control tables over many folders at once.
#' @param header,content_box,remarks,footer,replace_id For each of these optional file sections,
#'  either a \code{character vector} of the specific text to be added in the corresponding place
#'  of the ReadMe file, a single valid \code{\link{file.path}} to a control table with the text(s)
#'  in columns named "[irrelevant]_[\code{lang}]" (i.e., "language-coded"), or a list with
#'  "language-coded" names that would result from importing the control table file(s).
#' @param replace_id Optional \code{character vector} of length 2 to replace an ID placeholder
#'  (in the FDZ context usually: "_Antrag") with the specific ID (e.g., "2601-01a").
#'  The first element is a \link{regex} expression to be used as \code{pattern}, and replaced by
#'  the simple string in the second element of the vector.
#'
#' @returns Depending on \code{create_table}, this function may return...\itemize{
#'  \item \code{"control"} - A \code{list} of \code{data.frame}s, one for each subdirectory.
#'  These \code{data.frame}s may be saved as individual control table files that could be used
#'  as input for this function's table mode. Each \code{data.frame} consists of at least three
#'  columns:
#'  \code{file_name} (names of individual files and lower subdirectories),
#'  \code{description} (default descriptions of each file; one column per \code{lang}), and
#'  \code{flag} (formatting flags to mirror the directory structure if reused in table mode).
#'  \item \code{"overview"} - A flat \code{data.frame} with at least four columns:
#'  \code{file_name}, \code{description}, and \code{flag} as described for \code{"control"},
#'  as well each file's \code{depth} and \code{group} (i.e. first level directory).
#'  \item \code{"text"} - The \code{character vector} constituting the ReadMe text written to
#'  \code{out_path} if requested. If more than one \code{lang} is specified, this returns a list
#'  of each language's ReadMe text.
#' }
#'
#' @examples
#' # Create dummy directory
#' somedir <- tempfile("example")
#' dir.create(somedir)
#' dir.create(file.path(somedir, "literature"))
#' dir.create(file.path(somedir, "data"))
#' file.create(file.path(somedir, "data", c("a_text.txt", "my_data.csv")))
#' file.create(file.path(somedir, "literature", "Rucker_Weigt_Burblies_2026.pdf"))
#'
#' # Direcory mode
#' createReadMe(somedir, lang = "en", create_table = "overview")
#'
#' control_table <- createReadMe(somedir, lang = "en", create_table = "control")
#' control_table
#' write.table(control_table, file.path(somedir, "ReadMeControl.csv"), sep = ",",
#'             row.names = FALSE, col.names = c("file_name", "description_en", "flag"))
#'
#' # Table mode
#' read.csv(file.path(somedir, "ReadMeControl.csv"))
#' createReadMe(file.path(somedir, "ReadMeControl.csv"), lang = "en", create_table = "text",
#'              sep = ",", header = c("This", "is a", "HUGE HEADER"))
#'
#' # Clean-up
#' unlink(somedir, recursive = TRUE)
#'
#'
#' @export
createReadMe <- function(in_path, out_path = NULL, lang = c("de", "en"),
                         margin = 4, col_width = 90, indent_per_level = 2, max_indent = 10,
                         create_table = c("none", "control", "overview", "text"),
                         sep = c(";", ","),
                         flat_depth = NULL, skip_empty_base = FALSE,
                         header = NULL, content_box = NULL, remarks = NULL, footer = NULL,
                         replace_id = NULL) {
  if (!is.character(in_path) || length(in_path) == 0) {
    stop("'in_path' needs to be a character vector of length > 0.",
         call. = FALSE)
  }
  check_path_or_null(out_path)
  # lang <- match.arg(lang, several.ok = TRUE)
  create_table <- match.arg(create_table)
  sep <- match.arg(sep)
  lapply(c("margin", "col_width", "indent_per_level", "max_indent"),
         function(x) check_whole_positive(get(x), x))
  if (!is.null(flat_depth)) check_whole_positive(flat_depth)
  eatGADS:::check_logicalArgument(skip_empty_base)

  for (this_arg in c("header", "content_box", "remarks", "footer")) {
    if (is.null(get(this_arg))) next
    if (length(get(this_arg)) == 1 && file.exists(get(this_arg))) {
      file_ext <- stringi::stri_extract_last_regex(str = get(this_arg),
                                                   pattern = "\\..{2,4}$")
      if (!file_ext %in% c(".csv", "xlsx")) {
        stop("Unsupported file format in file: '", get(this_arg), "'",
             call. = FALSE)
      }
      if (file_ext == ".csv") {
        assign(this_arg, utils::read.csv(file = get(this_arg), sep = sep, blank.lines.skip = FALSE))
      } else {
        assign(this_arg, openxlsx::read.xlsx(xlsxFile = get(this_arg), sheet = 1, skipEmptyRows = FALSE))
      }

      sapply(lang, function(this_lang) {
        matching <- grepl(x = names(get(this_arg)),
                          pattern = paste0("_", this_lang, "$"))
        if (!any(matching)) {
          stop("No matching column name in ", this_arg,
               ' for language "', this_lang, '"')
        }
      })
    }
  }

  if (!is.null(replace_id) && (!is.character(replace_id) || length(replace_id) != 2)) {
    stop('"replace_id" needs to be a character vector of length 2.',
         call. = FALSE)
  }

  # Input = singular directory path     -> ReadMe = file list
  # Input = list of > 0 control file(s) -> ReadMe = list from control file(s)
  # BUT: length 1 could be either mode  -> decide by path ending:
  #  (A) no file extension of 2-4 characters = directory mode
  #  (B) file extension = table mode
  func_mode <- "table"
  if (length(in_path) == 1) {
    file_ext <- stringi::stri_extract_last_regex(str = in_path, pattern = "\\..{2,4}$")
    if (is.na(file_ext)) {
      if (!dir.exists(in_path)) {
        stop("Directory '", in_path, "' does not exist.",
             call. = FALSE)
      }
      func_mode <- "directory"
    } else {
      if (!all(file.exists(in_path))) {
        stop("Could not find file(s): '",
             paste0(in_path[!file.exists(in_path)], collapse = "', '"),
             "'",
             call. = FALSE)
      }
      func_mode <- "table"
    }
  }

  # call respective sub-function; returned content may be NULL or a table, depending on create_table
  if (func_mode == "table") {
    content <- create_RM_from_tab(in_path = in_path,
                                  out_path = out_path,
                                  lang = lang,
                                  margin = margin,
                                  col_width = col_width,
                                  indent_per_level = indent_per_level,
                                  max_indent = max_indent,
                                  create_table = create_table,
                                  sep = sep,
                                  header = header,
                                  content_box = content_box,
                                  remarks = remarks,
                                  footer = footer,
                                  replace_id = replace_id)
  } else {
    content <- create_RM_from_dir(in_path = in_path,
                                  out_path = out_path,
                                  lang = lang,
                                  margin = margin,
                                  col_width = col_width,
                                  indent_per_level = indent_per_level,
                                  max_indent = max_indent,
                                  create_table = create_table,
                                  flat_depth = flat_depth,
                                  skip_empty_base = skip_empty_base,
                                  header = header,
                                  remarks = remarks,
                                  footer = footer)
  }

  ## return file table as requested ##
  if (create_table == "none") return(NULL)

  if (create_table == "overview") return(content$files)

  if (create_table == "text") return(content$text)

  if (create_table == "control") {
    readme_filetab <- content$files
    readme_filetab$n_in_group <- sapply(seq_along(readme_filetab$group), function(x) {
      sum(grepl(pattern = paste0("^", readme_filetab$group[[x]], "$"),
                x = readme_filetab$group))
    })

    # identify "super-groups"; directories that only contain directories but no direct files
    super_groups <- readme_filetab$group[readme_filetab$n_in_group == 1]
    readme_filetab$super_group <- NA
    for (this_super_group in super_groups) {
      group_in_super_group <- grepl(pattern = this_super_group, x = readme_filetab$group)
      readme_filetab$super_group[group_in_super_group] <- this_super_group
    }

    # apply super-group if possible, revert to normal group if necessary
    readme_filetab$apply_group <- readme_filetab$super_group
    no_super_group <- is.na(readme_filetab$apply_group)
    readme_filetab$apply_group[no_super_group] <- readme_filetab$group[no_super_group]
    applied_group_names <- unique(readme_filetab$apply_group)

    control_table <- lapply(applied_group_names, function(grup) {
      this_group <- subset(x = readme_filetab,
                           subset = readme_filetab$apply_group == grup,
                           select = c("file_name",
                                      paste("description", lang, sep = "_"),
                                      "depth"))
      this_group$flag <- ""
      subhead_rows <- this_group[, paste("description", lang, sep = "_")[[1]]] == ""
      this_group$flag[subhead_rows] <- paste0("subheader/", this_group$depth[subhead_rows])
      this_group$flag[1] <- "header"
      this_group <- this_group[, names(this_group) != "depth"]
      return(this_group)
    })
    names(control_table) <- applied_group_names
    return(control_table)
  }
}

create_RM_from_dir <- function(in_path, out_path, lang,
                               margin, col_width, indent_per_level, max_indent,
                               create_table, flat_depth, skip_empty_base,
                               header, remarks, footer) {
  file_table_deep <- create_file_table(path = in_path)

  ## create ReadMe file ##
  file_table_flat <- flatten_file_table(dirname = basename(in_path),
                                        file_table = file_table_deep,
                                        flat_depth = flat_depth,
                                        skip_empty_base = skip_empty_base)
  names(file_table_flat) <- sub(x = names(file_table_flat),
                                pattern = "description",
                                replacement = "description_en")
  # translate descriptions if necessary
  if ("de" %in% lang) {
    # reassamble file_table_flat: cols up to English description, German description, other cols
    position_descr_col <- which(names(file_table_flat) == "description_en")
    first_cols <- file_table_flat[, 1:position_descr_col]
    last_cols <- file_table_flat[, (position_descr_col + 1):ncol(file_table_flat)]
    description_de <- stringi::stri_replace_all_fixed(str = file_table_flat$description_en,
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
  for (this_lang in lang) {
    this_lang_col <- grep(x = names(file_table_flat),
                           pattern = paste0("_", this_lang, "$"))
    file_table2write$description <- file_table_flat[, this_lang_col]
    these_lines <- file_table_as_text(content = file_table2write,
                                      margin = margin,
                                      col_width = col_width,
                                      indent_per_level = indent_per_level,
                                      max_indent = max_indent)
    total_width <- attr(these_lines, "total_width")

    # content subheader
    these_lines <- add_spanning_border(text = these_lines,
                                       width = total_width,
                                       linetype = 3,
                                       where = "above")
    these_lines <- add_header(text = these_lines,
                              header = paste0("default///content_", this_lang),
                              width = total_width,
                              center = FALSE,
                              brace = TRUE)
    these_lines <- c("", "", these_lines)

    these_lines <- add_overall_head(text = these_lines,
                                    header = header,
                                    lang = this_lang,
                                    width = total_width)

    these_lines <- c(these_lines, "", "")
    these_lines <- add_remarks_section(text = these_lines,
                                       section = remarks,
                                       lang = this_lang,
                                       width = total_width)

    these_lines <- c(these_lines, "", "")
    these_lines <- add_footer(text = these_lines,
                              footer = footer,
                              lang = this_lang,
                              width = total_width)

    if (this_lang == lang[[1]]) {
      lines2write <- list(these_lines)
      names(lines2write) <- this_lang
    } else {
      lines2write[[this_lang]] <- these_lines
    }
    rm(this_lang_col, these_lines)
  }

  ## write ReadMe if requested via out_path ##
  if (!is.null(out_path)) {
    for (this_lang in lang) {
      if (length(lang) > 1) {
        out_ext <- stringi::stri_extract_last_regex(str = out_path, pattern = "\\.[[:alnum:]]{2,4}$")
        this_out_path <- sub(x = out_path,
                             pattern = "\\.[[:alnum:]]{2,4}$",
                             replacement = paste0("_", this_lang, out_ext))
      } else {
        this_out_path <- out_path
      }
      writeLines(text = lines2write[[this_lang]],
                 con = this_out_path)
    }
  }

  out_list <- list(text = lines2write,
                   files = file_table_flat)
  return(out_list)
}

create_RM_from_tab <- function(in_path, out_path, lang,
                               margin, col_width, indent_per_level, max_indent,
                               create_table, sep,
                               header, content_box, remarks, footer, replace_id) {
  file_ext <- stringi::stri_extract_last_regex(str = in_path, pattern = "\\..{2,4}$")
  if (any(!file_ext %in% c(".csv", "xlsx"))) {
    stop("Unsupported file format in file(s): '",
         paste0(in_path[!file_ext %in% c(".csv", "xlsx")], collapse = "', '"),
         "'",
         call. = FALSE)
  }

  content_list <- lapply(seq_along(in_path), function(path_index) {
    if (file_ext[[path_index]] == ".csv") {
      this_content <- utils::read.csv(file = in_path[[path_index]],
                                      sep = sep)
    } else {
      this_content <- openxlsx::read.xlsx(xlsxFile = in_path[[path_index]],
                                          sheet = 1)
    }

    subhead_lines <- which(grepl(x = this_content$flag,
                                 pattern = "subheader"))
    # define sections and set indentation levels
    this_content$depth <- 0 # header is always depth 0
    this_content$group <- this_content$file_name[[1]]
    for (i in seq_along(subhead_lines)) {
      section_start <- subhead_lines[[i]]
      if (i == length(subhead_lines)) {
        section_end <- nrow(this_content)
      } else {
        section_end <- subhead_lines[[i + 1]] - 1
      }
      section_depth <- as.numeric(sub(x = this_content$flag[[section_start]],
                                      pattern = "subheader/",
                                      replacement = ""))
      this_content$depth[section_start:section_end] <- section_depth
      this_content$group[section_start:section_end] <- this_content$file_name[[section_start]]
    }
    if (!is.null(replace_id)) {
      this_content$file_name <- gsub(x = this_content$file_name,
                                     pattern = replace_id[[1]],
                                     replacement = replace_id[[2]])
    }
    return(this_content)
  })

  # paste and save full texts per language
  lines2write <- list()
  for (this_lang in lang) {
    # paste together file tables of this language
    file_table2write <- do.call("rbind",
                                lapply(content_list, function(single_content) {
                                  subset(x = single_content,
                                         select = c("file_name",
                                                    paste0("description_", this_lang),
                                                    "depth",
                                                    "group",
                                                    "flag"))
                                }))
    names(file_table2write) <- sub(x = names(file_table2write),
                                   pattern = paste0("description_", this_lang),
                                   replacement = "description")

    # move description information to column file_name for printing
    header_lines <- which(grepl(x = file_table2write$flag,
                                pattern = "(header)|(subheader)"))
    file_table2write$file_name[header_lines] <- file_table2write$description[header_lines]
    file_table2write$description[header_lines] <- ""
    file_table2write <- file_table2write[, names(file_table2write) != "flag"]

    # create text table
    text_table_single_content <- file_table_as_text(content = file_table2write,
                                                    margin = margin,
                                                    col_width = col_width,
                                                    indent_per_level = indent_per_level,
                                                    max_indent = max_indent)
    total_width <- attr(text_table_single_content, "total_width")

    # content subheader
    text_table_single_content <- add_spanning_border(text = text_table_single_content,
                                                     width = total_width,
                                                     linetype = 3,
                                                     where = "above")
    text_table_single_content <- add_header(text = text_table_single_content,
                                            header = paste0("default///content_", this_lang),
                                            width = total_width,
                                            center = FALSE,
                                            brace = TRUE)
    text_table_single_content <- c("", "", text_table_single_content)

    text_table_single_content <- add_overall_head(text = text_table_single_content,
                                                  header = header,
                                                  lang = this_lang,
                                                  width = total_width)

    text_table_single_content <- c(text_table_single_content, "", "")
    text_table_single_content <- add_remarks_section(text = text_table_single_content,
                                                     section = remarks,
                                                     lang = this_lang,
                                                     width = total_width)

    text_table_single_content <- c(text_table_single_content, "", "")
    text_table_single_content <- add_footer(text = text_table_single_content,
                                            footer = footer,
                                            lang = this_lang,
                                            width = total_width)

    lines2write[[this_lang]] <- text_table_single_content

    ## write ReadMe if requested via out_path ##
    if (!is.null(out_path)) {
      if (length(lang) > 1) {
        out_ext <- stringi::stri_extract_last_regex(str = out_path, pattern = "\\.[[:alnum:]]{2,4}$")
        this_out_path <- sub(x = out_path,
                             pattern = "\\.[[:alnum:]]{2,4}$",
                             replacement = paste0("_", this_lang, out_ext))
      } else {
        this_out_path <- out_path
      }
      writeLines(text = lines2write[[this_lang]],
                 con = this_out_path)
    }
  }
  flat_file_table <- do.call("rbind", lapply(content_list, function(this_content) {
    this_content[, names(this_content) != "flag"]
  }))
  out_list <- list(text = lines2write,
                   files = flat_file_table)
  return(out_list)
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

check_whole_positive <- function(arg, argName) {
  if (missing(argName)) {
    argName <- deparse(substitute(arg))
  }
  eatGADS:::check_numericArgument(arg = arg, argName = argName)
  if (arg == round(arg) && arg > 0) {
    return(NULL)
  } else {
    stop("'", argName, "' has to be a whole number > 0.",
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
                           extension = stringi::stri_extract_last_regex(str = all_files,
                                                                        pattern = "\\..{2,4}$"))
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

flatten_file_table <- function(dirname, file_table, flat_depth, depth = 0, warning_issued = FALSE,
                               skip_empty_base = TRUE) {
  # ignore base of directory (first level) if it has no direct files and if the skip is requested
  # (relevant for template creation)
  if (isTRUE(skip_empty_base) && depth == 0 && names(file_table)[[1]] != "files") {
    empty_base <- TRUE
    start_col <- 1
    depth <- -1
  } else {
    empty_base <- FALSE
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
      if (length(file_table) == 1) {
        return(out) # no further subdirectories
      } else {
        start_col <- 2 # otherwise 2nd col will have the first subdir
      }
    } else {
      start_col <- 1
    }
  }

  # warn if directory is very deep
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

  # go throught subdirectories recursively
  for (i in start_col:length(file_table)) {
    if (isTRUE(empty_base)) {
      subdir <- names(file_table)[[i]]
    } else {
      subdir <- paste(dirname,
                      names(file_table)[[i]],
                      sep = "/")
    }
    new_row <- flatten_file_table(dirname = subdir,
                                  file_table = file_table[[i]],
                                  flat_depth = flat_depth,
                                  depth = depth,
                                  warning_issued = warning_issued,
                                  skip_empty_base = FALSE)
    if (!exists("out")) {
      out <- new_row
    } else {
      out <- rbind(out, new_row)
    }
  }
  return(out)
}

file_table_as_text <- function(content, margin, col_width, prefix = "- ",
                               indent_per_level, max_indent, header = TRUE) {
  filenames <- content$file_name
  descriptions <- content$description
  depths <- content$depth
  groups <- unique(content$group)

  lengths_name <- nchar(filenames, type = "char")
  lengths_indentation <- (depths + 1) * indent_per_level
  lengths_indentation[lengths_indentation > max_indent] <- max_indent
  lengths_indented_name <- lengths_name + lengths_indentation
  col_width <- max(c(max(lengths_indented_name) + margin,
                     col_width))

  full_lines <- sapply(seq_along(groups), function(group_index) {
    this_group <- subset(content,
                         subset = content$group == groups[[group_index]],
                         select = c("file_name", "description", "depth"))

    # indent lines
    these_indentations <- this_group$depth * indent_per_level
    if (header && length(these_indentations) > 1) { # increase body indentation against header if requested
      these_indentations[2:length(these_indentations)] <-
        (these_indentations[2:length(these_indentations)] + 1) * indent_per_level
    }
    this_section <- these_filenames <- sapply(seq_along(this_group$file_name), function(x) {
      paste0(paste0(rep(" ", these_indentations[[x]]), collapse = ""),
             this_group$file_name[[x]])
    })

    # construct and paste lines of file names and descriptions; fill left column with blanks if necessary
    lines_with_description <- this_group$description != ""
    if (any(lines_with_description)) {
      these_descriptions <- paste0(prefix, this_group$description[lines_with_description])

      this_section[lines_with_description] <- fill_with_blanks(col1 = these_filenames[lines_with_description],
                                                               col2 = these_descriptions,
                                                               width = col_width)
    }

    # add lines above as padding against previous group (add none if previous group has no direct files)
    lines_above <- abs(this_group$depth[[1]] - max(depths)) + 1
    if (group_index == 1 || nrow(subset(content, content$group == groups[[group_index - 1]])) == 1) {
      lines_above <- 0
    }
    this_section <- c(rep("", lines_above),
                      this_section)
    return(this_section)
  })
  full_lines <- unlist(full_lines)
  attr(full_lines, "total_width") <- col_width + nchar(prefix) +max(nchar(descriptions))
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

  length_col1 <- nchar(tabs_to_blanks(col1),
                       type = "char")
  fill_blanks <- width - length_col1
  filler <- sapply(fill_blanks, function(x) paste0(rep(" ", x), collapse = ""))

  if (use_tabs) filler <- sapply(filler, blanks_to_tabs)

  out <- paste0(col1, filler, col2)
  return(out)
}

tabs_to_blanks <- function(text) {
  gsub(x = text,
       pattern = "\t",
       replacement = "        ")
}
blanks_to_tabs <- function(text) {
  tabs_first <- gsub(x = text,
                     pattern = " {8}",
                     replacement = "\t")
  blank_first <- paste0(gsub(x = tabs_first, pattern = "\\t", replacement = ""),
                        gsub(x = tabs_first, pattern = " ", replacement = ""))
  return(blank_first)
}

add_header <- function(text, header, width,
                       center = TRUE, brace = FALSE, where = c("above", "below")) {
  if (length(header) == 1 && grepl(x = header, pattern = "^default///")) {
    default_headers <- list(content_de = " I N H A L T ",
                            content_en = " C O N T E N T S ",
                            remarks_de = " H I N W E I S E ",
                            remarks_en = " A D D I T I O N A L   R E M A R K S ")
    header <- sub(x = header, pattern = "^default///", replacement = "")
    header <- default_headers[[header]]
  }
  where <- match.arg(where)
  nline <- length(header)

  if (center) {
    header <- sapply(unlist(header), function(header_line) {
      width_header <- nchar(header_line)
      if (width_header >= width) return(header_line)

      padding_left <- floor((width - width_header) / 2)
      if (brace) marg_col <- " " else marg_col <- ""

      left_padded <- fill_with_blanks(marg_col, header_line, padding_left)
      new_header_line <- fill_with_blanks(left_padded, marg_col, width)
      return(new_header_line)
    })
  }

  if (brace) {
    if (center) header <- sapply(unlist(header), function(header_line) {
      substr(x = header_line, start = 1, stop = nchar(header) - 1)
    })
    nline <- length(header)
    if (nline == 1) {
      header <- paste0("[", header, "]")
    } else {
      header[[1]] <- paste0("\u250c", header[[1]], "\u2510")
      header[[length(header)]] <- paste0("\u2514", header[[1]], "\u2518")
      if (nline > 2) {
        header[2:(length(header) - 1)] <- paste0("\u2502", header[2:(length(header) - 1)], "\u2502")
      }
    }
  }

  if (where == "above") {
    new_text <- c(header, text)
  } else {
    new_text <- c(text, header)
  }
  return(new_text)
}

add_spanning_border <- function(text, linetype, width = NULL, where = c("above", "below")) {
  if (is.null(width)) width <- nchar(tabs_to_blanks(text), type = "char")
  # double full width lower: \u2017
  # single full width lower: \u005f
  # single full width upper: \u203e
  # single half width upper: \u00af
  # vertical: \u2502
  lineTypes <- data.frame(upper = c("\u005f", "\u005f", "\u00af"),
                          lower = c("", "\u00af", ""))
  this_line_upper <- paste0(rep(lineTypes$upper[[linetype]], width), collapse = "")
  this_line_lower <- paste0(rep(lineTypes$lower[[linetype]], width), collapse = "")
  this_line_combined <- c(this_line_upper, this_line_lower)
  this_line_combined <- this_line_combined[this_line_combined != ""]

  if ("above" %in% where) text <- c(this_line_combined, text)
  if ("below" %in% where) text <- c(text, this_line_combined)
  return(text)
}

add_overall_head <- function(text, header, lang, width) {
  if (is.null(header)) return(text)
  if (is.list(header) && length(header) > 1) {
    this_header <- header[grepl(x = names(header), pattern = paste0("_", lang, "$"))]
  } else {
    this_header <- unlist(header)
  }

  text <- add_spanning_border(text = text,
                              linetype = 2,
                              width = width,
                              where = "above")
  text <- add_header(text = text,
                     header = this_header,
                     width = width)
  text <- add_spanning_border(text = text,
                              linetype = 2,
                              width = width,
                              where = "above")
  return(text)
}

add_remarks_section <- function(text, section, lang, width) {
  if (is.null(section)) return(text)
  if (is.list(section) && length(section) > 1) {
    this_section <- section[grepl(x = names(section), pattern = paste0("_", lang, "$"))]
    this_section <- unlist(this_section)
  } else {
    this_section <- unlist(section)
  }

  text <- add_header(text = text,
                     header = paste0("default///remarks_", lang),
                     width = width,
                     center = FALSE,
                     brace = TRUE,
                     where = "below")
  text <- add_spanning_border(text = text,
                              width = width,
                              linetype = 3,
                              where = "below")
  text <- c(text, this_section)
  return(text)
}

add_footer <- function(text, footer, lang, width) {
  if (is.null(footer)) return(text)
  if (is.list(footer) && length(footer) > 1) {
    this_footer <- footer[grepl(x = names(footer), pattern = paste0("_", lang, "$"))]
    this_footer <- unlist(this_footer)
  } else {
    this_footer <- unlist(footer)
  }

  text <- add_spanning_border(text = text,
                              linetype = 2,
                              width = width,
                              where = "below")
  text <- c(text, this_footer)
  text <- add_spanning_border(text = text,
                              linetype = 2,
                              width = width,
                              where = "below")
  return(text)
}
