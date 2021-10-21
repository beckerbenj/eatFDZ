####
#############################################################################
#' Check documentation of data sets.
#'
#' Check if all variables of one or multiple data sets saved as \code{sav} are included in the \code{pdf} documentation.
#'
#'A common requirement for data documentation is a complete codebook. The \code{check_docu} function can be used to check, whether all variables (column names) in one or multiple \code{sav} data sets are mentioned in the documentation, provided as \code{pdf} files. Multiple \code{pdf} files are treated as one single \code{pdf} file. For multiple data sets the output is sorted by data set and the \code{data_set} column indicates to which data set the variable name belongs.
#'
#'For easier reading of the output, the output can be written to an excel file, for example using the \code{\link[openxlsx]{write.xlsx}} function from the \code{openxlsx} package or the \code{\link[eatAnalysis]{write_xlsx}} function from the \code{eatAnalysis} package.
#'
#'@param sav_path Character vector with paths to the \code{.sav} files.
#'@param pdf_path Character vector with paths to the \code{.pdf} files.
#'@param post_words Number of words after the variable names that should be extracted from the PDF.
#'@param case_sensitive If \code{TRUE}, upper and lower case are differentiated for variable name matching. If \code{FALSE}, case is ignored.
#'@param encoding Optional: The character encoding used for reading the \code{.sav} file. The default, \code{NULL}, uses the encoding specified in the file, but sometimes this value is incorrect and it is useful to be able to override it.
#'
#'@return A \code{data.frame} with the variable names, count of mentions in the \code{pdf} (\code{count}), words after the variable names (\code{post}) and the name of the data set in which the variable occurs (\code{data_set}).
#'
#'@examples
#' # File pathes
#' sav_path1 <- system.file("extdata", "helper_spss_p1.sav", package = "eatFDZ")
#' sav_path2 <- system.file("extdata", "helper_spss_p2.sav", package = "eatFDZ")
#' pdf_path1 <- system.file("extdata", "helper_codebook_p1.pdf", package = "eatFDZ")
#' pdf_path2 <- system.file("extdata", "helper_codebook_p2.pdf", package = "eatFDZ")
#'
#' check_df <- check_docu(sav_path = c(sav_path1, sav_path2),
#'                        pdf_path = c(pdf_path1, pdf_path2), post_words = 2)
#'
#'@export
check_docu <- function(sav_path, pdf_path, post_words = 2, case_sensitive = FALSE, encoding = NULL) {
  if(!is.character(sav_path) || length(sav_path) < 1) stop("sav_path needs to be at least one path to a .sav file.")
  if(!is.character(pdf_path) || length(pdf_path) < 1) stop("pdf_path needs to be at least one path to a .pdf file.")

  out_list <- lapply(sav_path, function(single_sav_path) {
    gads <- suppressWarnings(eatGADS::import_spss(single_sav_path, checkVarNames = FALSE, encoding = encoding))
    nams <- eatGADS::namesGADS(gads)
    names(nams) <- nams

    docu <- readtext::readtext(pdf_path)
    # to corpus
    corp_docu <- quanteda::corpus(docu)
    summary(corp_docu)
    # to token
    tok_docu <- quanteda::tokens(corp_docu)
    # test
    test <- lapply(nams, function(nam) {
      out <- quanteda::kwic(tok_docu, pattern = nam, window = post_words, case_insensitive = !case_sensitive)
      post <- out$post
      if(nrow(out) == 0) post <- NA
      data.frame(variable = nam,
                 count = nrow(out),
                 post = post, stringsAsFactors = FALSE)
    })
    do.call(rbind, test)
  })
  #if(length(sav_path) > 1) browser()
  out_df <- eatTools::do_call_rbind_withName(out_list, name = basename(sav_path), colName = "data_set")
  out_df[, c("variable", "count", "post", "data_set")]
}





