####
#############################################################################
#' Check documentation of a data set.
#'
#' Check if all variables of a data set saved as \code{.sav} are included in the \code{.pdf} documentation.
#'
#' tbd
#'
#'@param sav_path Path to the \code{.sav} file.
#'@param pdf_path Path to the \code{.pdf} file.
#'@param post_words Number of words after the variable names that should be extracted from the PDF.
#'
#'@return A \code{data.frame} with the variable names, count of mentions in the PDF and words after the variable names.
#'
#'@examples
#' # tbd
#'
#'@export
check_docu <- function(sav_path, pdf_path, post_words = 2) {
  if(!is.character(sav_path) || length(sav_path) != 1) stop("sav_path needs to be a single path to a .sav file.")
  if(!is.character(pdf_path) || length(pdf_path) != 1) stop("pdf_path needs to be a single path to a .pdf file.")

  gads <- suppressWarnings(eatGADS::import_spss(sav_path, checkVarNames = FALSE))
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
    out <- quanteda::kwic(tok_docu, pattern = nam, window = post_words)
    post <- out$post
    if(nrow(out) == 0) post <- NA
    data.frame(variable = nam,
               count = nrow(out),
               post = post, stringsAsFactors = FALSE)
  })
  do.call(rbind, test)
}






