#' Write a check report.
#'
#' Write a check report as created by \code{\link{check_all}} to excel.
#'
#' The function writes a check report provided by \code{\link{check_all}} via \code{openxlsx} to excel.
#' Formating and additional explanations are added to increase readability and usability.
#'
#'@param check_report The check report as created by \code{\link{check_all}}.
#'@param file_path File destination.
#'@param language In which language should the output be written? Currently only German is supported.
#'
#'@examples
#' dataset <- system.file("extdata", "example_data2", package = "eatFDZ")
#' out <- check_all(dataset)
#' write_check_report(out, file_path = tempfile())
#'@export
write_check_report <- function (check_report, file_path, language = c("German", "English")) {
  # input validation
  # tbd
  language <- match.arg(language)

  if (file.exists(file_path)) {
    file.remove(file_path)
  }

  #openxlsx::write.xlsx(check_report, file = filePath, sheetName = names(df_list), colNames = TRUE, rowNames = FALSE)

  if(identical(language, "German")) {
    template_file <- system.file("extdata", "check_report_template_german.xlsx", package = "eatFDZ")
  }

  # copy and open workbook
  file.copy(from = template_file, to = file_path)
  template <- openxlsx::loadWorkbook(file_path)

  # insert information into workbook
  implications <- ifelse(check_report$Overview$Result == "passing",
                         yes = "Keine weitere Bearbeitung noetig.",
                         no = ifelse(check_report$Overview$Result == "Not tested",
                                     yes = "",
                                     no = "Details siehe entsprechender Reiter"))
  commented_results <- data.frame(Result = check_report$Overview$Result,
                                  Handungsbedarf = implications)

  openxlsx::writeData(wb = template, sheet = "Overview", startCol = 3, startRow = 2,
                                  x = commented_results,
                                  colNames = FALSE, rowNames = FALSE)

  for(nam in names(check_report)[-1]) {
    if(nrow(check_report[[nam]]) == 0) {
      openxlsx::removeWorksheet(wb = template, sheet = nam)
    } else {
      openxlsx::writeData(wb = template, sheet = nam, startCol = 1, startRow = 2,
                          x = check_report[[nam]],
                          colNames = FALSE, rowNames = FALSE)
    }
  }

  # add formating to workbook
  passing <- openxlsx::createStyle(fontColour = "darkgreen")
  issues_detected <- openxlsx::createStyle(fontColour = "darkred")

  #browser()
  openxlsx::addStyle(template, sheet = "Overview", cols = 3, style = passing, stack = TRUE,
                     rows = which(check_report$Overview$Result == "passing") + 1)
  openxlsx::addStyle(template, sheet = "Overview", cols = 3, style = issues_detected, stack = TRUE,
                     rows = which(check_report$Overview$Result == "Issues detected") + 1)
  # save workbook
  openxlsx::saveWorkbook(wb = template, file = file_path, overwrite = TRUE)

}

