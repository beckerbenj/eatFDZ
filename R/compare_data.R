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
#'@param metaExceptions Should certain meta data columns be excluded from the comparison?
#'
#'@examples
#' # tbd
#'@export
compare_data <- function(data1, data2, name_data1 = "data1", name_data2 = "data2",
                         metaExceptions = c("display_width", "labeled")) {
  ## input validation
  # ----------------------------------------------------------
  eatGADS:::check_GADSdat(data1)
  eatGADS:::check_GADSdat(data2)

  eatGADS:::check_characterArgument(name_data1, argName = "name_data1")
  eatGADS:::check_characterArgument(name_data2, argName = "name_data2")

  ## initiate comparison
  # ----------------------------------------------------------
  eatGADS_comparison <- eatGADS::equalMeta(data1, data2, metaExceptions = metaExceptions)
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

  if(length(out_list_var) > 0) {
    out_list_var[sapply(out_list_var, identical, y = "all.equal")] <- NULL
  }

  #guarantee that output data.frame has always the same structure
  dummy_vec <- rep(NA_character_, length(out_list_var))
  complete_out_df_var <- data.frame(varName = dummy_vec,
                                    GADSdat_varLabel = dummy_vec,
                                    GADSdat_format = dummy_vec,
                                    other_GADSdat_varLabel = dummy_vec,
                                    other_GADSdat_format = dummy_vec)
  #browser()
  if(length(out_list_var) > 0) {
    #browser()
    out_df_var <- eatTools::do_call_rbind_withName(out_list_var, colName = "varName")

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

  if(length(out_list_val) > 0) {
    out_list_val[sapply(out_list_val, identical, y = "all.equal")] <- NULL
  }

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
                       "differences_variable_level", "differences_value_level")
  out_list
}
