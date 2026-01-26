##' Run all data checks for a GADSdat object
#'
#' This function performs a series of comprehensive data quality checks on a \code{GADSdat} object.
#' It aggregates the functionality of multiple individual checks, validating the structure, consistency, and documentation
#' of the dataset. The checks include:
#' \itemize{
#'   \item \code{\link{check_file_name}}: Verifies the validity of the file name.
#'   \item \code{\link{check_var_names}}: Checks variable names for e.g. special characters.
#'   \item \code{\link{check_meta_encoding}}: Ensures proper encoding in metadata.
#'   \item \code{\link{check_id}}: Validates the uniqueness and non-missingness of identifier variables.
#'   \item \code{\link{check_var_labels}}: Checks for the existence of variable labels.
#'   \item \code{\link[eatGADS]{checkMissingValLabels}}: Ensures missing value labels are correctly defined.
#'   \item \code{\link{check_missing_range}}: Validates whether values fall within a defined missing value range.
#'   \item \code{\link{check_missing_regex}}: Identifies missing value labels based on a regular expression.
#'   \item \code{\link{sdc_check}}: Performs a statistical disclosure control check for variables with low category frequencies.
#'   \item \code{\link{check_docu}}: Verifies that all variables are referenced in external documentation (e.g., codebooks in \code{.pdf} format).
#' }
#'
#' This function provides a comprehensive overview of potential issues, helping to ensure data set quality and consistency.
#' It outputs a summary of detected issues as well as detailed reports for each individual check.
#'
#' @param sav_path Character string specifying the path to the SPSS file (\code{.sav}).
#' @param pdf_path Optional. A character string specifying the path to the \code{.pdf} file containing the codebook or documentation.
#' If not provided, checks related to documentation are skipped.
#' @param encoding Optional. A character string specifying the encoding used for reading the \code{.sav} file.
#' If \code{NULL} (default), the encoding defined in the file is used.
#' @param missingRange Numeric. A range of values that should be declared as missing. Defaults to \code{-50:-99}.
#' @param missingRegex Character. A regular expression pattern used to identify labels that should be treated as missing.
#' Defaults to \code{"missing|omitted|not reached|nicht beantwortet|ausgelassen"}.
#' @param idVar Optional. A character vector specifying the name(s) of identifier variables in the \code{GADSdat} object.
#' If \code{NULL} (default), the first variable in the data set is used as the identifier variable.
#' @param sdcVars Optional. A character vector of variable names to be checked for statistical disclosure control risks.
#' If \code{NULL}, all variables are checked.
#'
#' @return A \code{list} containing:
#' \itemize{
#'   \item \code{Overview}: A \code{data.frame} summarizing which checks passed or detected issues.
#'   \item Detailed reports for each check: A series of \code{data.frame}s generated during the checks, each labeled
#'         with the respective check name (e.g., \code{"lengthy_variable_names"}, \code{"missing_IDs"}).
#' }
#'
#' @examples
#' # Specify the path to an SPSS file
#' sav_path <- system.file("extdata", "example_data2.sav", package = "eatFDZ")
#'
#' # Run all checks with default parameters
#' check_results <- check_all(sav_path = sav_path)
#'
#' # View summary of results
#' print(check_results$Overview)
#'
#' # Access detailed results for specific checks
#' print(check_results$`missing_IDs`)
#'
#'@examples
#' dataset <- system.file("extdata", "example_data2.sav", package = "eatFDZ")
#' out <- check_all(dataset)
#'@export
check_all <- function (sav_path, pdf_path = NULL, encoding = NULL,
                       missingRange = -50:-99,
                       missingRegex = "missing|omitted|not reached|nicht beantwortet|ausgelassen",
                       idVar = NULL,
                       sdcVars = NULL) {

  ### further checks (tbd)?
  # lengthy variable names?
  # variables with no missing tags at all? -> or unlabeled values within range?
  # character variables?
  # extended fixEncoding (further special signs?)

  # check file
  # ----------------------------------------------------------
  check_file_name(sav_path)
  gads <- eatGADS::import_spss(sav_path, checkVarNames = FALSE)

  # lengthy variable names
  # ----------------------------------------------------------
  lengthy_var_names <- check_var_names_length(gads, boundary = 30)

  # encoding checks
  # ----------------------------------------------------------
  bad_encoding_var_names <- check_var_names(gads)
  bad_encoding_meta_data <- check_meta_encoding(gads)

  # id variable
  # ----------------------------------------------------------
  id_check <- check_id(gads, idVar = idVar)
  missing_ids <- id_check[["missing_ids"]]
  duplicate_ids <- id_check[["duplicate_ids"]]

  # variable labels
  # ----------------------------------------------------------
  missing_varLabels <- check_var_labels(gads)

  # value labels
  # ----------------------------------------------------------
  missing_valLables <- eatGADS::checkMissingValLabels(gads, output = "data.frame")

  # missing tags
  # ----------------------------------------------------------
  missing_range_tags <- check_missing_range(gads, missingRange = missingRange)
  missing_regex_tags <- check_missing_regex(gads, missingRegex = missingRegex)

  # check data disclosure control
  # ----------------------------------------------------------
  if(is.null(sdcVars)) sdcVars <- eatGADS::namesGADS(gads)
  sdc_check_out <- check_sdc(gads, vars = sdcVars)

  # check for character variables
  # ----------------------------------------------------------
  character_vars <- check_character_vars(gads)

  # check codebook
  # ----------------------------------------------------------
  docu_check <- data.frame()
  if(!is.null(pdf_path)) {
    docu_check <- check_docu(sav_path = sav_path, pdf_path = pdf_path, post_words = 2,
                             case_sensitive = FALSE, encoding = encoding)
  }


  # overview
  # ----------------------------------------------------------
  individual_result_list <- list(lengthy_var_names,
                                 bad_encoding_var_names, bad_encoding_meta_data,
                                 missing_ids, duplicate_ids,
                                 missing_varLabels,
                                 missing_valLables,
                                 missing_range_tags, missing_regex_tags,
                                 sdc_check_out,
                                 character_vars,
                                 docu_check)
  names(individual_result_list) <- c(
    "lengthy_variable_names",
    "special_signs_variable_names", "special_signs_meta_data",
    "missing_IDs", "duplicate_IDs",
    "missing_variable_labels",
    "missing_value_labels",
    "missing_range_tags", "missing_regex_tags",
    "statistical_disclosure_control",
    "character_variables",
    "docu_check")

  individual_result_list2 <- lapply(individual_result_list, make_df_with_comment)

  test_overview_vec <- sapply(individual_result_list2, function(x){
    ifelse(nrow(x) > 0, yes = "Issues detected", no = "passing")
  })
  if(is.null(pdf_path)) {
    test_overview_vec[length(test_overview_vec)] <- "Not tested"
  }

  test_output <- data.frame(Test = names(test_overview_vec), Result = test_overview_vec, row.names = NULL)
  print(test_output)

  # combine
  # ----------------------------------------------------------
  out <- append(list(test_output), individual_result_list2)
  names(out) <- c("Overview", test_output$Test)
  out
}


make_df_with_comment <- function(x) {
  if(is.vector(x) && length(x) == 0 ||
     is.data.frame(x) && nrow(x) == 0) {
    return(data.frame(x, comment = character()))
  }
  data.frame(x, comment = NA)
}



