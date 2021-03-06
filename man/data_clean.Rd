% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_clean.R
\name{data_clean}
\alias{data_clean}
\title{FDZ Data cleaning}
\usage{
data_clean(
  fileName,
  boundary = 5,
  saveFolder = NA,
  nameListe = NULL,
  nameSyntax = NULL,
  exclude = NULL
)
}
\arguments{
\item{fileName}{Character string of the SPSS file}

\item{boundary}{Integer number: categories with less observations than [boundary] will be summarized to guarantee anonymity}

\item{saveFolder}{Character string of the target folder for SPSS syntax output. Target folder must have writing permission.}

\item{nameListe}{File name of the csv-type variable information file}

\item{nameSyntax}{File name of the SPSS syntax file}

\item{exclude}{Optional: character vector of variable which should be excluded from summarizing and transformation}
}
\value{
SPSS syntax snippet
}
\description{
Generate SPSS syntax to make individual data anonymous
}
\details{
Data from large-scale assessments often have to be non-identifiable on individual level. Function summarizes low-sized categories of polytomous variables to more general categories. Additionally, character variables are transformed into numeric factors, providing factor levels as value labels.
}
\examples{
sav_path <- system.file("extdata", "LV_2011_CF.sav", package = "eatFDZ")

## if ID variable is a labeled variable, protect it from anonymization (here not necessary)
exclude<- c("idstud_FDZ", "idsch_FDZ")

##
out_folder <- tempdir()
syntax <- data_clean(fileName = sav_path,
            saveFolder = tempdir(), nameListe = "liste2.csv",
            nameSyntax = "syntax2.txt", exclude=exclude)



}
