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
#'@param idVar Name of the identifier variable in the \code{GADSdat} object.
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
  id_vec <- eatGADS::extractData2(id_gads, convertMiss = TRUE)[[1]]

  missing_ids_vec <- which(is.na(id_vec))
  missing_ids <- data.frame(Rows = missing_ids_vec)

  id_vec_no_na <- id_vec[!is.na(id_vec)]
  duplicate_ids_vec <- id_vec_no_na[duplicated(id_vec_no_na)]
  duplicate_ids <- data.frame(IDs = duplicate_ids_vec)

  list(missing_ids = missing_ids, duplicate_ids = duplicate_ids)
}


## tbd: Extend to a combination of variables (e.g., IDSTUD and imp)
