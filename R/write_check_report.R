#' Write a check report.
#'
#' Write a check report as created by \code{\link{check_all()}} to excel.
#'
#'
#'@param check_report The check report as created by \code{\link{check_all()}}.
#'@param file_path File destination
#'
#'@return NULL
#'
#'
#'@export
write_check_report <- function (check_report, file_path, language = c("German", "English")) {
  # input validation
  # tbd
  language <- match.arg(language)

  if (file.exists(file_path))
    file.remove(file_path)

  #openxlsx::write.xlsx(check_report, file = filePath, sheetName = names(df_list), colNames = TRUE, rowNames = FALSE)

  if(identical(language, "German")) {
    template_file <- system.file("extdata", "check_report_template_german.xlsx", package = "eatFDZ")
  }

  # copy workbook
  file.copy(from = template_file, to = file_path)

  # open workbook
  template <- openxlsx::loadWorkbook(file_path)

  # write to workbook
  #browser()
  openxlsx::writeData(wb = template, sheet = "Overview", startCol = 3, startRow = 2,
                                  x = check_report$Overview$Result,
                                  colNames = FALSE, rowNames = FALSE)

  openxlsx::writeData(wb = template, sheet = "special_signs_variable_names", startCol = 1, startRow = 2,
                      x = check_report$special_signs_variable_names,
                      colNames = FALSE, rowNames = FALSE)


  ## Handlungsbedarf
  # Keine weitere Bearbeitung noetig. vs. Details siehe entsprechender Reiter

  ## Sheets
  # Keine weitere Bearbeitung noetig

  #
  #openxlsx::addStyle() ## gruen/rot => Achtung: Zellenweise!
  # save workbook
  openxlsx::saveWorkbook(wb = template, file = file_path, overwrite = TRUE)

}


# vor-formatierte Excel nutzen!
# nachtraeglich eher nur triviales (zB Farben bei Problemen)
