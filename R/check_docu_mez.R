####
#############################################################################
#' Check documentation of data sets.
#'
#' This is a specific version of \code{\link{check_docu}} written for the \code{MEZ} study. If a variable name can not be found in the
#' documentation, the variable name is split at the first numeral and \code{*} is added to the stem.
#'
#'@param sav_path Character vector with paths to the \code{.sav} files.
#'@param pdf_path Character vector with paths to the \code{.pdf} files.
#'@param post_words Number of words after the variable names that should be extracted from the PDF.
#'@param case_sensitive If \code{TRUE}, upper and lower case are differentiated for variable name matching. If \code{FALSE}, case is ignored.
#'@param encoding Optional: The character encoding used for reading the \code{.sav} file. The default, \code{NULL}, uses the encoding specified in the file, but sometimes this value is incorrect and it is useful to be able to override it.
#'
#'@return A \code{data.frame} with the variable names, count of mentions in the \code{pdf} (\code{count}), words after the variable names (\code{post}) and the name of the data set in which the variable occurs (\code{data_set}).
#'
#'@export
check_docu_mez <- function(sav_path, pdf_path, post_words = 2, case_sensitive = FALSE, encoding = NULL) {
  if(!is.character(sav_path) || length(sav_path) < 1) stop("sav_path needs to be at least one path to a .sav file.")
  if(!is.character(pdf_path) || length(pdf_path) < 1) stop("pdf_path needs to be at least one path to a .pdf file.")

  docu <- readtext::readtext(pdf_path)
  # to corpus
  corp_docu <- quanteda::corpus(docu)
  summary(corp_docu)
  # to token
  tok_docu <- quanteda::tokens(corp_docu)
  tok_docu_longer <- quanteda::tokens(corp_docu, what = "fasterword")

  out_list <- lapply(sav_path, function(single_sav_path) {
    gads <- suppressWarnings(eatGADS::import_spss(single_sav_path, checkVarNames = FALSE, encoding = encoding))
    nams <- eatGADS::namesGADS(gads)
    names(nams) <- nams

    # test
    test <- lapply(nams, function(nam) {
      print(nam)
      #if(nam == "msta1_e") browser()
      out <- quanteda::kwic(tok_docu, pattern = nam, window = post_words, case_insensitive = !case_sensitive)
      #browser()
      if(nrow(out) == 0) {
        nam_stem <- strsplit(nam, split = "(?<=[a-zA-Z])\\s*(?=[0-9])", perl = TRUE)[[1]][1]
        nam_new <- paste0(nam_stem, "*")

        out <- quanteda::kwic(tok_docu_longer, pattern = nam_new, window = post_words, case_insensitive = !case_sensitive, valuetype = "fixed")
        }

      data.frame(variable = nam,
                 count = nrow(out), stringsAsFactors = FALSE)
    })
    do.call(rbind, test)
  })
  #if(length(sav_path) > 1) browser()
  out_df <- eatTools::do_call_rbind_withName(out_list, name = basename(sav_path), colName = "data_set")
  out_df[, c("variable", "count", "data_set")]
}
