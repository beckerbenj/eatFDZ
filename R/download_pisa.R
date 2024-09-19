#' Download and import an empty PISA public use file.
#'
#' Download and import an empty PISA public use file (containing only the first data row) from the
#' \href{https://www.oecd.org/en/about/programmes/pisa/pisa-data.html}{OECD homepage}.
#'
#' The function downloads a zip file from the OECD homepage into a temporary directory,
#' unzips it and imports the data with only a single data row via \code{\link[haven]{read_sav}}.
#' For downloading full PISA data sets see the \href{https://cran.r-project.org/package=EdSurvey}{EdSurvey} package.
#' The data is imported as a \code{GADSdat} object.
#'
#'@param year Year of the PISA cycle which the data is part of.
#'@param data_type Type of the PISA data. Currently supported is student background data (\code{"stud_quest"}).
#'
#'@examples
#' \dontrun{
#' pisa <- download_pisa(year = "2015", data_type = "stud_quest")
#' }
#'@export
download_pisa <- function(year = c("2018", "2015", "2012", "2009", "2006", "2003", "2000"),
                          data_type = c("stud_quest")) {
  ## input validation
  year <- match.arg(year)
  data_type <- match.arg(data_type)

  ## choose path
  if(year == "2018" && data_type == "stud_quest") {
    zip_path <- "https://webfs.oecd.org/pisa2018/SPSS_STU_QQQ.zip"
    data_subdir <- "STU/CY07_MSU_STU_QQQ.sav"
  } else if(year == "2015" && data_type == "stud_quest") {
    zip_path <- "https://webfs.oecd.org/pisa/PUF_SPSS_COMBINED_CMB_STU_QQQ.zip"
    data_subdir <- "CY6_MS_CMB_STU_QQQ.sav"
  } else {
    stop("The corresponding download has not been implemented yet.")
  }

  ## download zip file
  temp_folder <- tempdir()

  old_timeout <- getOption("timeout")
  options(timeout = max(300, old_timeout))
  on.exit(options(timeout = old_timeout))

  ### download data to a folder with writing permissions
  download.file(url = zip_path,
                destfile = file.path(temp_folder, "pisa.zip"))

  ### unzip data to temporary folder
  zip::unzip(zipfile = file.path(temp_folder, "pisa.zip"), files= data_subdir, exdir = temp_folder)

  ### read data
  haven_dat <- haven::read_sav(file.path (temp_folder, data_subdir), n_max = 1, user_na = TRUE)
  GADS <- eatGADS:::new_savDat(haven_dat)
  eatGADS:::prepare_labels(GADS, checkVarNames = FALSE, labeledStrings = "drop")
}
