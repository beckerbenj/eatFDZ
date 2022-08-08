####
#############################################################################
#' Check documentation of data sets.
#'
#' Check if all variables of one or multiple data sets saved as \code{sav} are included in the \code{excel} documentation.
#'
#'A common requirement for data documentation is a complete codebook. The \code{check_docu_excel} function can be used to check, whether all variables (column names) in one or multiple \code{sav} data sets are mentioned in the documentation, provided as \code{excel} files. Multiple \code{pdf} files are treated as one single \code{pdf} file. For multiple data sets the output is sorted by data set and the \code{data_set} column indicates to which data set the variable name belongs.
#'
#'For easier reading of the output, the output can be written to an \code{excel} file, for example using the \code{write.xlsx} function from the \code{openxlsx} package or the \code{write_xlsx} function from the \code{eatAnalysis} package.
#'
#'@param sav_path Character vector with paths to the \code{.sav} files.
#'@param excel_path Character vector with paths to the \code{.xlsx} files.
#'@param case_sensitive If \code{TRUE}, upper and lower case are differentiated for variable name matching. If \code{FALSE}, case is ignored.
#'@param encoding Optional: The character encoding used for reading the \code{.sav} file. The default, \code{NULL}, uses the encoding specified in the file, but sometimes this value is incorrect and it is useful to be able to override it.
#'
#'@return A \code{data.frame} with the variable names, count of mentions in the \code{pdf} (\code{count}), and the name of the data set in which the variable occurs (\code{data_set}).
#'
#'@examples
#' # File pathes
#' sav_path1 <- system.file("extdata", "helper_spss_p1.sav", package = "eatFDZ")
#' sav_path2 <- system.file("extdata", "helper_spss_p2.sav", package = "eatFDZ")
#' excel_path1 <- system.file("extdata", "helper_codebook_p1.xlsx", package = "eatFDZ")
#'
#' check_df <- check_docu_excel(sav_path = c(sav_path1, sav_path2),
#'                        excel_path = c(excel_path1))
#'
#'@export
check_docu_excel <- function(sav_path, excel_path, case_sensitive = FALSE, encoding = NULL) {
  if(!is.character(sav_path) || length(sav_path) < 1) stop("sav_path needs to be at least one path to a .sav file.")
  if(!is.character(excel_path) || length(excel_path) < 1) stop("pdf_path needs to be at least one path to a .pdf file.")


  all_excel_codebooks <- lapply(excel_path, function(single_excel_path) {
    sheet_names <- readxl::excel_sheets(single_excel_path)
    lapply(sheet_names, function(sheet_name) {
      suppressMessages(codebook_df <- as.data.frame(readxl::read_excel(single_excel_path, sheet = sheet_name)))
      as.character(codebook_df)
  })})

  out_list <- lapply(sav_path, function(single_sav_path) {
    gads <- suppressWarnings(eatGADS::import_spss(single_sav_path, checkVarNames = FALSE, encoding = encoding))
    nams <- eatGADS::namesGADS(gads)
    names(nams) <- nams

    # test
    test <- lapply(nams, function(nam) {

      count_vec <- c()
      for(excel_file in all_excel_codebooks) {
        for(excel_sheet in excel_file) {
          count_vec <- c(count_vec, grep(nam, excel_sheet, ignore.case = !case_sensitive))
        }
      }

      data.frame(variable = nam,
                 count = length(count_vec),
                 stringsAsFactors = FALSE)
    })
    do.call(rbind, test)
  })
  #if(length(sav_path) > 1) browser()
  out_df <- eatTools::do_call_rbind_withName(out_list, name = basename(sav_path), colName = "data_set")
  out_df[, c("variable", "count", "data_set")]
}





