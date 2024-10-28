#' Download and import an empty FDZ file.
#'
#' Download and import an empty data set from the \href{https://www.iqb.hu-berlin.de/fdz/studies/}{FDZ homepage}.
#'
#' The function downloads and imports an empty data set (\code{Leerdatensatz}) from the FDZ homepage.
#' These data sets contain zero rows.
#' The data is imported via \code{\link[eatGADS]{import_spss}} as a \code{GADSdat} object.
#'
#'@param study Name of the study
#'@param year Year of the assessment (only needed for longitudinal assessments).
#'@param data_type Type of the data.
#'
#'@examples
#' fdz_pisa <- download_fdz(study = "PISA", year = "2015",
#'                         data_type = "stud_quest")
#'@export
download_fdz <- function(study = c("PISA"),
                          year = c("2018", "2015", "2012", "2009", "2006", "2003", "2000"),
                          data_type = c("stud_quest_15y", "stud_quest_9cl", "school_quest", "teach_quest", "timing")) {
  ## input validation
  study <- match.arg(study)
  year <- match.arg(year)
  data_type <- match.arg(data_type)

  ## choose path
  if(year == "2018") {
    if(data_type == "stud_quest_15y") {
      download_path <- "https://www.iqb.hu-berlin.de/fdz/studies/PISA_2018/PISA2018_Datensa_2.sav"
    } else if(data_type == "stud_quest_9cl") {
      download_path <- "https://www.iqb.hu-berlin.de/fdz/studies/PISA_2018/PISA2018_Datensa_1.sav"
    } else if(data_type == "school_quest") {
      download_path <- "https://www.iqb.hu-berlin.de/fdz/studies/PISA_2018/PISA2018_Datensa_4.sav"
    } else if(data_type == "teach_quest") {
      download_path <- "https://www.iqb.hu-berlin.de/fdz/studies/PISA_2018/PISA2018_Datensa.sav"
    } else if(data_type == "timing") {
      download_path <- "https://www.iqb.hu-berlin.de/fdz/studies/PISA_2018/PISA2018_Datensa_3.sav"
    }
  } else if(year == "2015") {
    if(data_type == "stud_quest") {
      download_path <- "https://www.iqb.hu-berlin.de/fdz/studies/PISA_2015/PISA2015_Schuele_1.sav"
    }
  } else {
    stop("The corresponding download has not been implemented yet.")
  }

  ### read data
  eatGADS::import_spss(download_path, checkVarNames = FALSE)
  #haven::read_sav(download_path, n_max = 1, user_na = TRUE)
}
