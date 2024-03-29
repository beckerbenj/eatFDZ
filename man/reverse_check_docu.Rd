% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reverse_check_docu.R
\name{reverse_check_docu}
\alias{reverse_check_docu}
\title{Reverse check documentation of data sets.}
\usage{
reverse_check_docu(
  white_list = c(english_words, german_words),
  pdf_path,
  sav_path,
  encoding = NULL
)
}
\arguments{
\item{white_list}{A character vector containing all words which should not be flagged. Defaults to a combination of a German and English corpus.}

\item{pdf_path}{Character vector with paths to the \code{.pdf} files.}

\item{sav_path}{Character vector with paths to the \code{.sav} files.}

\item{encoding}{The character encoding used for the file. The default, \code{NULL}, use the encoding specified in the file, but sometimes this value is incorrect and it is useful to be able to override it.}
}
\value{
A \code{data.frame} with the columns \code{suspicious_words}, \code{missing_documentation} and \code{comment}.
}
\description{
This function extracts all words from the \code{pdf} file and discards all words which are variables in the data set and all words
which are white listed. Based on this a list of words is returned, which might be listed as variables in the documentation but not
in the data set.
}
\examples{
# File pathes
sav_path1 <- system.file("extdata", "helper_spss_p1.sav", package = "eatFDZ")
sav_path2 <- system.file("extdata", "helper_spss_p2.sav", package = "eatFDZ")
pdf_path1 <- system.file("extdata", "helper_codebook_p1.pdf", package = "eatFDZ")
pdf_path2 <- system.file("extdata", "helper_codebook_p2.pdf", package = "eatFDZ")
pdf_path3 <- system.file("extdata", "helper_codebook_p3.pdf", package = "eatFDZ")

check_df <- reverse_check_docu(sav_path = c(sav_path1, sav_path2),
                       pdf_path = c(pdf_path1, pdf_path2, pdf_path3))

}
