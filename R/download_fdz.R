#' Download an empty FDZ file.
#'
#' Download an empty data set from the FDZ homepage.
#'
#' The function downloads a \code{Leerdatensatz} from the FDZ homepage.
#'
#'@param study Name of the study
#'@param year Year of the assessment (only needed for longitudinal assessments).
#'@param data_type Type of the data.
#'
#'@examples
#' # tbd
#'@export
download_fdz <- function(study = c("PISA"),
                          year = c("2018", "2015", "2012", "2009", "2006", "2003", "2000"),
                          data_type = c("stud_quest")) {
  ## input validation
  study <- match.arg(study)
  year <- match.arg(year)
  data_type <- match.arg(data_type)

  ## choose path
  if(year == "2018" && data_type == "stud_quest") {
    download_path <- "https://www.iqb.hu-berlin.de/fdz/studies/PISA_2018/PISA2018_Datensa_2.sav"
  } else if(year == "2015" && data_type == "stud_quest") {
    download_path <- "https://www.iqb.hu-berlin.de/fdz/studies/PISA_2015/PISA2015_Schuele_1.sav"
  } else {
    stop("The corresponding download has not been implemented yet.")
  }

  ### read data
  eatGADS::import_spss(download_path, checkVarNames = FALSE)
  #haven::read_sav(download_path, n_max = 1, user_na = TRUE)
}
