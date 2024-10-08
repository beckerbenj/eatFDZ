#' Run all data checks.
#'
#' Run all data checks.
#'
#' This functions calls \code{\link{check_file_name}},
#' \code{\link{check_var_names}}, \code{\link{check_meta_encoding}},
#' \code{\link{check_id}}, \code{\link{check_var_labels}},
#' \code{\link[eatGADS]{checkMissingValLabels}},
#' \code{\link{check_missing_range}}, \code{\link{check_missing_regex}},
#' \code{\link{sdc_check}}, and \code{\link{check_docu}}.
#'
#'
#'@param sav_path Path to the SPSS file
#'@param pdf_path Path to the \code{.pdf} file
#'@param encoding Optional: The character encoding used for reading the \code{.sav} file.
#'The default, \code{NULL}, uses the encoding specified in the file,
#'but sometimes this value is incorrect and it is useful to be able to override it.
#'@param missingRange Numerical range for missing tags.
#'@param missingRegex Regular expression for value labels for missing tags.
#'@param idVar Name(s) of the identifier variable in the \code{GADSdat} object. If \code{NULL}, the first variable in
#'the data set is taken as the \code{idVar}.
#'@param sdcVars Variable names of variables with potential statistical disclosure control issues.
#'
#'@return A \code{data.frame}.
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



