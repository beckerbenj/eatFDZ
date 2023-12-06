#' Check an identifier variable.
#'
#' Check the uniqueness and non-missingness of a variable in a \code{GADSdat}.
#'
#' Checks include
#' \itemize{
#' \item Is the identifier variable unique (i.e., no duplicates)?
#' \item Are there any missing values in the identifier variable?
#' }
#'
#'@param GADSdat \code{GADSdat} object.
#'@param idVar Name(s) of the identifier variable in the \code{GADSdat} object. If \code{NULL}, the first variable in
#'the data set is taken as the \code{idVar}.
#'
#'@return Returns the test report.
#'
#'@examples
#'# tbd
#'
#'@export
check_id <- function(GADSdat, idVar = NULL) {
  if(is.null(idVar)) {
    idVar <- eatGADS::namesGADS(GADSdat)[1]
  }
  suppressMessages(id_gads <- eatGADS::extractVars(GADSdat, vars = idVar))
  id_df <- eatGADS::extractData2(id_gads, convertMiss = TRUE)

  missing_ids_vec <- apply(id_df, 1, function(id_df_row) {
    any(is.na(id_df_row))
  }, simplify = TRUE)
  #missing_ids_vec <- which(is.na(id_vec))
  missing_ids <- data.frame(Rows = which(missing_ids_vec))

  #browser()
  id_df_no_na <- id_df[!missing_ids_vec, , drop = FALSE]
  duplicate_ids_df <- id_df_no_na[duplicated(id_df_no_na), , drop = FALSE]

  list(missing_ids = missing_ids, duplicate_ids = duplicate_ids_df)
}


## tbd: Extend to a combination of variables (e.g., IDSTUD and imp)
