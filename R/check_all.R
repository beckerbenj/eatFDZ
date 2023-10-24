#' Run all FDZ checks.
#'
#' Run all FDZ checks.
#'
#'
#'@param sav_path Character string of the SPSS file
#'@param encoding Optional: The character encoding used for reading the \code{.sav} file. The default, \code{NULL}, uses the encoding specified in the file, but sometimes this value is incorrect and it is useful to be able to override it.
#'@param missingRange Numerical range for missing tags.
#'@param missingRegex Regular expression for value labels for missing tags.
#'@param idVar Unique identifier variable in the data set.
#'@param sdcVars Variable names of variables with potential statistical disclosure control issues.
#'
#'@return A \code{data.frame}.
#'
#'
#'
#'@export
check_all <- function (sav_path, pdf_path = NULL, encoding = NULL,
                       missingRange = -50:-99,
                       missingRegex = "missing|omitted|not reached|nicht beantwortet|ausgelassen",
                       idVar = NULL,
                       sdcVars = NULL) {

  # encoding checks
  # ----------------------------------------------------------
  check_file_name(sav_path)
  gads <- eatGADS::import_spss(sav_path, checkVarNames = FALSE)

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
  empty_valLabels <- eatGADS::checkEmptyValLabels(gads, output = "data.frame")

  # missing tags
  # ----------------------------------------------------------
  missing_range_tags <- check_missing_range(gads, missingRange = missingRange)
  missing_regex_tags <- check_missing_regex(gads, missingRegex = missingRegex)

  # check data disclosure control
  # ----------------------------------------------------------
  exclude_vars <- setdiff(eatGADS::namesGADS(gads), sdcVars)
  if(is.null(sdcVars)) {
    exclude_vars <- character()
  }
  out <- eatFDZ::sdc_check(sav_path, exclude = exclude_vars)
  sdc_check_out <- out[out$exclude == FALSE, c("variable", "nKatOhneMissings", "nValid", "nKl5")]


  # check codebook
  # ----------------------------------------------------------
  docu_check <- data.frame()
  if(!is.null(pdf_path)) {
    docu_check <- check_docu(sav_path = sav_path, pdf_path = pdf_path, post_words = 2,
                             case_sensitive = FALSE, encoding = encoding)
  }


  # overview
  # ----------------------------------------------------------
  individual_result_list <- list(bad_encoding_var_names, bad_encoding_meta_data,
                                 missing_ids, duplicate_ids,
                                 missing_varLabels,
                                 missing_valLables, empty_valLabels,
                                 missing_range_tags, missing_regex_tags,
                                 sdc_check_out,
                                 docu_check)
  individual_result_list2 <- lapply(individual_result_list, make_df_with_comment)
  names(individual_result_list2) <- c("special_signs_variable_names", "special_signs_meta_data",
                   "missing_IDs", "duplicate_IDs",
                   "missing_variable_labels",
                   "missing_value_labels", "unused_value_labels",
                   "missing_range_tags", "missing_regex_tags",
                   "statistical_disclosure_control",
                   "docu_check")

  test_overview_logical <- c(nrow(bad_encoding_var_names) > 0,
                             nrow(bad_encoding_meta_data) > 0,
                             nrow(missing_ids) > 0,
                             nrow(duplicate_ids) > 0,
                             nrow(missing_varLabels) > 0,
                             nrow(missing_valLables) > 0,
                             nrow(empty_valLabels) > 0,
                             nrow(missing_range_tags) > 0,
                             nrow(missing_regex_tags) > 0,
                             nrow(sdc_check_out) > 0,
                             nrow(docu_check) > 0)

  test_overview_vec <- ifelse(test_overview_logical, yes = "Issues detected", no = "passing")
  if(is.null(pdf_path)) {
    test_overview_vec[11] <- "Not tested"
  }

  test_output <- data.frame(Test = test_names, Result = test_overview_vec)

  # output
  # ----------------------------------------------------------
  individual_result_list <- list(bad_encoding_var_names, bad_encoding_meta_data,
                missing_ids, duplicate_ids,
                missing_varLabels,
                missing_valLables, empty_valLabels,
                missing_range_tags, missing_regex_tags,
                sdc_check_out,
                docu_check)
  individual_result_list2 <- lapply(individual_result_list, make_df_with_comment)
  names(individual_result_list2) <- test_names

  # combine
  # ----------------------------------------------------------
  print(test_output)
  #browser()
  out <- append(list(test_output), individual_result_list2)
  names(out) <- c("Overview", test_names)
  out
}


make_df_with_comment <- function(x) {
  if(is.vector(x) && length(x) == 0 ||
     is.data.frame(x) && nrow(x) == 0) {
    return(data.frame(x, comment = character()))
  }
  data.frame(x, comment = NA)
}


### questions regarding further checks
# length variable names?
# variables with no missing tags at all? -> or unlabeled values within range?
# character variables?

# extend fixEncoding (further special signs?)
# check variable names => "."?

