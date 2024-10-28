#' Compare existing variables and meta data structure between two data sets.
#'
#' Compare existing variables and meta data structure between two data sets.
#'
#' The function performs a comparison between two \code{GADSdat} objects.
#' Variables included in each data set are compared and reported, as well as meta data differences
#' (variable labels, SPSS format, value labels, missing tags).
#'
#'@param data1 Data set one, provided as a \code{GADSdat} object.
#'@param data2 Data set two, provided as a \code{GADSdat} object.
#'@param name_data1 Character vector of length 1. Name of \code{data1}.
#'@param name_data2 Character vector of length 1. Name of \code{data2}.
#'@param ID_var Identifier variable in both data sets.
#'
#'@examples
#' # tbd
#'@export
compare_data <- function(data1, data2, name_data1 = "data1", name_data2 = "data2", ID_var) {
  ## input validation
  # ----------------------------------------------------------
  eatGADS:::check_GADSdat(data1)
  eatGADS:::check_GADSdat(data2)

  eatGADS:::check_characterArgument(ID_var, argName = "ID_var")
  eatGADS:::check_characterArgument(name_data1, argName = "name_data1")
  eatGADS:::check_characterArgument(name_data2, argName = "name_data2")

  eatGADS:::check_vars_in_GADSdat(data1, vars = ID_var, argName = "ID_var", GADSdatName = "data1")
  eatGADS:::check_vars_in_GADSdat(data2, vars = ID_var, argName = "ID_var", GADSdatName = "data2")

  ## initiate comparison
  # ----------------------------------------------------------
  eatGADS_comparison <- eatGADS::equalGADS(data1, data2, id = ID_var)
  ## equalGADS has some overhead, especially for larger data sets. Could be optimized in the future
  ## also: for compare_data ID_var should be omitted

  ## list missing variables in both data sets
  # ----------------------------------------------------------
  missing_data1 <- unique(data2$labels[data2$labels$varName %in% eatGADS_comparison$names_not_in_1,
                                      c("varName", "varLabel")])
  missing_data2 <- unique(data1$labels[data1$labels$varName %in% eatGADS_comparison$names_not_in_2,
                                      c("varName", "varLabel")])

  ## compare variable labels
  # ----------------------------------------------------------
  out_list_var <- lapply(eatGADS_comparison$meta_data_differences, function(nam) {
    out <- eatGADS::inspectMetaDifferences(data1, other_GADSdat = data2, varName = nam)
    out$varDiff
  })
  names(out_list_var) <- eatGADS_comparison$meta_data_differences

  #guarantee that output data.frame has always the same structure
  dummy_vec <- rep(NA_character_, length(out_list_var))
  complete_out_df_var <- data.frame(varName = dummy_vec,
                                    GADSdat_varLabel = dummy_vec,
                                    GADSdat_format = dummy_vec,
                                    other_GADSdat_varLabel = dummy_vec,
                                    other_GADSdat_format = dummy_vec)
  #browser()
  if(length(out_list_var) > 0) {
    out_list_var[sapply(out_list_var, identical, y = "all.equal")] <- NULL
    out_df_var <- eatTools::do_call_rbind_withName(out_list_var, colName = "varName")

    ## hotfix because of bug in insepctMetaDifferences (see also https://github.com/beckerbenj/eatGADS/issues/81)
    if("metaVar1.format" %in% names(out_df_var)) {
      recode_table <- data.frame(old = c("GADSdat_format", "other_GADSdat_format", "metaVar1.format", "metaVar2.format"),
                                 new = c("GADSdat_varLabel", "other_GADSdat_varLabel", "GADSdat_format", "other_GADSdat_format"))
      names(out_df_var) <- eatTools::recodeLookup(names(out_df_var), lookup = recode_table)
    }

    for(col_nam in names(out_df_var)) {
      complete_out_df_var[, col_nam] <- out_df_var[, col_nam]
    }
  }

    ## compare value labels
  # ----------------------------------------------------------
  out_list_val <- lapply(eatGADS_comparison$meta_data_differences, function(nam) {
    out <- eatGADS::inspectMetaDifferences(data1, other_GADSdat = data2, varName = nam)
    out$valDiff
  })
  names(out_list_val) <- eatGADS_comparison$meta_data_differences
  out_list_val[sapply(out_list_val, identical, y = "all.equal")] <- NULL

  #guarantee that output data.frame has always the same structure
  all_nrows <- sapply(out_list_val, nrow)
  row_sum <- ifelse(length(all_nrows > 0), yes = sum(all_nrows), no = 0)
  dummy_vec2 <- rep(NA_character_, row_sum)
  complete_out_df_val <- data.frame(varName = dummy_vec2,
                                    value = dummy_vec2,
                                    GADSdat_valLabel = dummy_vec2,
                                    GADSdat_missings = dummy_vec2,
                                    other_GADSdat_valLabel = dummy_vec2,
                                    other_GADSdat_missings = dummy_vec2)

  if(length(out_list_val) > 0) {
    out_df_val <- eatTools::do_call_rbind_withName(out_list_val, colName = "varName")

    for(col_nam in names(out_df_val)) {
      complete_out_df_val[, col_nam] <- out_df_val[, col_nam]
    }
  }

  ## modify column and list element names
  # ----------------------------------------------------------
  names(complete_out_df_var) <- c("varName",
                                  paste0(c("varLabel_", "SPSS_format_"), name_data1),
                                  paste0(c("varLabel_", "SPSS_format_"), name_data2))
  names(complete_out_df_val) <- c("varName", "value",
                         paste0(c("valLabel_", "missingTag_"), name_data1),
                         paste0(c("valLabel_", "missingTag_"), name_data2))

  out_list <- list(missing_data1, missing_data2,
                   complete_out_df_var, complete_out_df_val)
  names(out_list) <- c(paste0("not_in_", name_data1, "_data"),
                       paste0("not_in_", name_data2, "_data"),
                       "differences_variable_labels", "differences_value_labels")
  out_list
}
