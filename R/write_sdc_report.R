#' Write formatted disclosure control reports
#'
#' Writes disclosure control results to the Excel template included in
#' `eatFDZ`. A separate worksheet is created for each dataset.
#'
#' @param x A named list of data frames returned by [sdc_check()].
#' @param file_path Path of the Excel file to be created.
#' @param overwrite Logical. Should an existing file be overwritten?
#'
#' @return The output file path, returned invisibly.
#'
#' @export
write_sdc_report <- function(x, file_path, overwrite = FALSE) {

  template_path <- system.file(
    "templates", "Datenschutzpruefung.xlsx", package = "eatFDZ"
  )

  if (!nzchar(template_path)) {
    stop("The Excel template is missing from 'eatFDZ'.", call. = FALSE)
  }

  dataset_names <- names(x)

  if (is.null(dataset_names) ||
      any(is.na(dataset_names) | dataset_names == "")) {
    stop("'x' must be a named list.", call. = FALSE)
  }

  wb <- openxlsx2::wb_load(template_path)

  for (i in seq_along(x)) {
    dat <- x[[i]]

    sheet <- paste0(i, "_", basename(dataset_names[[i]]))
    sheet <- openxlsx2::clean_worksheet_name(sheet, replacement = "_")
    sheet <- substr(sheet, 1, 31)

    wb <- openxlsx2::wb_clone_worksheet(
      wb, old = "Template", new = sheet
    )

    table_name <- openxlsx2::wb_get_tables(
      wb, sheet = sheet
    )$tab_name[[1]]

    wb <- openxlsx2::wb_add_data(
      wb,
      sheet = sheet,
      x = dat,
      start_row = 3,
      start_col = 1,
      col_names = FALSE,
      na = "_openxlsx_NULL"
    )

    wb <- openxlsx2::wb_update_table(
      wb,
      sheet = sheet,
      dims = paste0("A2:N", nrow(dat) + 2),
      tabname = table_name
    )
  }

  wb <- openxlsx2::wb_remove_worksheet(wb, sheet = "Template")
  openxlsx2::wb_save(wb, file = file_path, overwrite = overwrite)

  invisible(file_path)
}
