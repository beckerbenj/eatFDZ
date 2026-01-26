#' Create a Statistical Disclosure Control Report
#'
#' This function generates a statistical disclosure control (SDC) report, identifying variables with categories
#' that have low absolute frequencies. Such low-frequency categories could potentially lead to statistical
#' data disclosure issues, particularly in data sets involving individual-level data from studies like
#' large-scale assessments. The function currently performs only a uni-variate check, flagging categories
#' with a frequency below a specified threshold.
#'
#' @param fileName A character string specifying the path to the SPSS file to import as a \code{GADSdat} object.
#' @param boundary An integer specifying the frequency threshold for identifying low-frequency categories.
#' Categories with less than or equal to this number of observations will be flagged. The default value is \code{5}.
#' @param exclude An optional character vector containing variable names that should be excluded from the report.
#' @param encoding An optional character string specifying the character encoding for importing the SPSS file.
#' If \code{NULL} (default), the encoding specified in the file is used.
#'
#' @return A \code{data.frame} summarizing categories with low frequencies, including the following columns:
#' \itemize{
#'   \item \code{variable}: The name of the variable with low-frequency categories.
#'   \item \code{varLab}: The label for the variable (if present).
#'   \item \code{existVarLab}: Whether a variable label exists (\code{TRUE} or \code{FALSE}).
#'   \item \code{existValLab}: Whether value labels exist for the variable (\code{TRUE} or \code{FALSE}).
#'   \item \code{skala}: Information on the variable type/classification.
#'   \item \code{nKatOhneMissings}: The total number of non-missing categories.
#'   \item \code{nValid}: The total number of valid observations for the variable.
#'   \item \code{nKl5}: Indicator for variables with categories flagged as low frequency (\code{TRUE} or \code{FALSE}).
#'   \item \code{exclude}: Whether the variable has been excluded based on the \code{exclude} argument.
#' }
#'
#' @examples
#' # Load an example SPSS file
#' sav_path <- system.file("extdata", "LV_2011_CF.sav", package = "eatFDZ")
#'
#' # Exclude unique identifier variables from the SDC check
#' exclude_vars <- c("idstud_FDZ", "idsch_FDZ")
#'
#' # Generate the SDC report
#' sdc_report <- sdc_check(fileName = sav_path, boundary = 5, exclude = exclude_vars)
#'
#' # Print the SDC report
#' print(sdc_report)
#'
#'@export
check_sdc <- function(GADSdat, vars = eatGADS::namesGADS(GADSdat), boundary = 5) {
  eatGADS:::check_vars_in_GADSdat(GADSdat, vars = vars)
  suppressMessages(GADSdat <- eatGADS::extractVars(GADSdat, vars = vars))

  datOM  <- eatGADS::extractData2(GADSdat, convertMiss = TRUE)
  names(vars) <- vars

  out_list <- lapply(vars, function(single_nam) {
    single_var <- datOM[[single_nam]]
    single_meta <- eatGADS::extractMeta(GADSdat, single_nam)

    skala <- class(single_var)
    tab <- table(as.character(single_var))
    nKat <- length(tab) # Anzahl Kategorien (ohne Missingkategorien)
    nValid <- sum(tab)

    freq5 <- any(tab <= boundary)
    values_freq5 <- names(tab)[tab <= boundary]
    if(length(values_freq5) > 10) values_freq5 <- c(values_freq5[1:10], ", ...")
    values_freq5_string <- paste(values_freq5, collapse = ", ")

    rows_with_valLabels <- single_meta[which(!is.na(single_meta$value) & single_meta$missings == "valid"), ]
    existValLab <- nrow(rows_with_valLabels) > 0

    data.frame(existValLab = existValLab, skala = skala, nKatOhneMissings = nKat, nValid = nValid,
               deanonymRisk = freq5, values = values_freq5_string,
               stringsAsFactors = FALSE)
  })

  #browser()
  out <- eatTools::do_call_rbind_withName(out_list, colName = "variable")
  out[out$deanonymRisk == TRUE, !names(out) %in% "deanonymRisk"]
}


