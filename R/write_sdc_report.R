#' Write formatted disclosure control reports
#'
#' Writes disclosure control results to the Excel template included in
#' `eatFDZ`. A separate worksheet is created for each dataset.
#'
#' @param x A named list of data frames returned by \link{sdc_check}.
#' @param file_path Path of the Excel file to be created.
#' @param overwrite Logical. Should an existing file be overwritten?
#'
#' @return The output file path, returned invisibly.
#'
#' @export
write_sdc_report <- function(x, file_path, overwrite = FALSE) {

  template_sheet <- "Vorlage"
  template_path <- system.file(
    "templates",
    "Datenschutzpruefung.xlsx",
    package = "eatFDZ")
  dataset_names <- names(x)

  if (is.null(dataset_names) ||
      anyNA(dataset_names) ||
      any(!nzchar(dataset_names))) {
    stop("'x' must be a named list.", call. = FALSE)
  }

  wb <- openxlsx2::wb_load(template_path)

  manual_cols <- unlist(
    openxlsx2::wb_to_df(
      wb,
      sheet = template_sheet,
      dims = "F2:N2",
      col_names = FALSE,
      check_names = FALSE), use.names = FALSE)

  sheet_names <- substr(gsub("[\\\\/:*?\\[\\]]", "_", basename(dataset_names)), 1L, 31L)

  if (anyDuplicated(tolower(sheet_names))) {
    stop(
      "Dataset names must result in unique worksheet names after shortening to 31 characters.",
      call. = FALSE
    )
  }

  for (i in seq_along(x)) {
    dat <- x[[i]]
    sheet <- sheet_names[[i]]

    # Remove columns that are not included in the Excel template
    dat[c(
      "existVarLab",
      "nKatOhneMissings",
      "nValid",
      "exclude")] <- NULL

    # Add empty columns for subsequent manual processing
    dat[manual_cols] <- NA_character_

    wb <- openxlsx2::wb_clone_worksheet(
      wb,
      old = template_sheet,
      new = sheet)

    table_name <- openxlsx2::wb_get_tables(
      wb,
      sheet = sheet)$tab_name[[1L]]

    wb <- openxlsx2::wb_remove_tables(
      wb,
      sheet = sheet,
      table = table_name,
      remove_data = FALSE)

    wb <- openxlsx2::wb_add_data_table(
      wb,
      sheet = sheet,
      x = dat,
      dims = "A2",
      table_style = "TableStyleLight1",
      table_name = paste0("SdcTable", i),
      na = "_openxlsx_NULL")
  }

  wb <- openxlsx2::wb_remove_worksheet(
    wb,
    sheet = template_sheet)

  openxlsx2::wb_save(
    wb,
    file = file_path,
    overwrite = overwrite)

  invisible(file_path)
}
