#' Check for uniqueness and non-missingness in an identifier variable
#'
#' This function checks whether an identifier variable in a \code{GADSdat} object meets key requirements for data quality:
#' \itemize{
#'   \item The identifier variable must be unique (i.e., no duplicate values).
#'   \item The identifier variable must not contain any missing values (\code{NA}).
#' }
#' These checks help ensure that the identifier variable can uniquely and reliably index rows within the data.
#'
#' @param GADSdat A \code{GADSdat} object containing the data to be checked.
#' @param idVar A character string specifying the name of the identifier variable in the \code{GADSdat} object.
#' If \code{NULL}, the first variable in the dataset will be used as the identifier variable.
#'
#' @return A \code{list} with two components summarizing the issues found:
#' \itemize{
#'   \item \code{missing_ids}: A \code{data.frame} with the row indices of observations where the identifier variable has missing values.
#'   \item \code{duplicate_ids}: A \code{data.frame} with the values of duplicate identifiers (if any).
#' }
#' If there are no missing or duplicate identifiers, the respective \code{data.frame} will be empty.
#'
#' @examples
#' # Example usage
#'
#' # Load example GADSdat object
#' GADSdat <- eatGADS::import_spss(system.file("extdata", "example_data2.sav", package = "eatFDZ"))
#'
#' # Check identifier variable for uniqueness and non-missingness
#' id_check <- check_id(GADSdat, idVar = "ID")
#'
#' # View rows with missing identifier values
#' print(id_check$missing_ids)
#'
#' # View duplicate identifier values
#' print(id_check$duplicate_ids)
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
