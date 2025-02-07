% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/write_check_report.R
\name{write_check_report}
\alias{write_check_report}
\title{Write a check report.}
\usage{
write_check_report(check_report, file_path, language = c("German", "English"))
}
\arguments{
\item{check_report}{The check report as created by \code{\link{check_all}}.}

\item{file_path}{File destination.}

\item{language}{In which language should the output be written? Currently only German is supported.}
}
\description{
Write a check report as created by \code{\link{check_all}} to excel.
}
\details{
The function writes a check report provided by \code{\link{check_all}} via \code{openxlsx} to excel.
Formating and additional explanations are added to increase readability and usability.
}
\examples{
dataset <- system.file("extdata", "example_data2.sav", package = "eatFDZ")
out <- check_all(dataset)
write_check_report(out, file_path = tempfile())
}
