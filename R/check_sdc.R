#' Create a Statistical Disclosure Control Report.
#'
#' Create a statistical disclosure control report: Which variables have categories with low absolute frequencies,
#' which might lead to statistical data disclosure issues?
#'
#' Individual participants of studies such as educational large-scale assessments usually must remain non-identifiable on individual level.
#' This function checks all variables in a \code{GADSdat} object
#' for low frequency categories which might lead to statistical disclosure control issues.
#' Currently, only a uni-variate check is implemented.
#'
#'@param GADSdat tbd
#'@param vars tbd
#'@param boundary Integer number: categories with less than or equal to \code{boundary} observations will be flagged
#'
#'@return A \code{data.frame}.
#'
#'@examples
#'sav_path <- system.file("extdata", "LV_2011_CF.sav", package = "eatFDZ")
#'
#'## don't report low frequencies for unique id variables
#'exclude<- c("idstud_FDZ", "idsch_FDZ")
#'
#'##
#'sdc_report <- sdc_check(fileName = sav_path, exclude=exclude)
#'
#'
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

    existValLab <- nrow(single_meta[which(!is.na(single_meta$value) & single_meta$missings == "valid"), ] ) > 0

    data.frame(existValLab = existValLab, skala = skala, nKatOhneMissings = nKat, nValid = nValid,
               nKl5 = freq5, valuesNKl5 = values_freq5_string,
               stringsAsFactors = FALSE)
  })

  #browser()
  out <- eatTools::do_call_rbind_withName(out_list, colName = "variable")
  out[out$nKl5 == TRUE, !names(out) %in% "nKl5"]
}


