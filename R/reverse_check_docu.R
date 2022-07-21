####
#############################################################################
#' Reverse check documentation of data sets.
#'
#' This function extracts all words from the \code{pdf} file and discards all words which are variables in the data set and all words
#' which are white listed. Based on this a list of words is returned, which might be listed as variables in the documentation but not
#' in the data set.
#'
#'@param white_list A character vector containing all words which should not be flagged. Defaults to a combination of a German and English corpus.
#'@param pdf_path Character vector with paths to the \code{.pdf} files.
#'@param sav_path Character vector with paths to the \code{.sav} files.
#'@param encoding The character encoding used for the file. The default, \code{NULL}, use the encoding specified in the file, but sometimes this value is incorrect and it is useful to be able to override it.
#'
#'@return A \code{data.frame} with the columns \code{suspicious_words}, \code{missing_documentation} and \code{comment}.
#'
#'@examples
#' # File pathes
#' sav_path1 <- system.file("extdata", "helper_spss_p1.sav", package = "eatFDZ")
#' sav_path2 <- system.file("extdata", "helper_spss_p2.sav", package = "eatFDZ")
#' pdf_path1 <- system.file("extdata", "helper_codebook_p1.pdf", package = "eatFDZ")
#' pdf_path2 <- system.file("extdata", "helper_codebook_p2.pdf", package = "eatFDZ")
#' pdf_path3 <- system.file("extdata", "helper_codebook_p3.pdf", package = "eatFDZ")
#'
#' check_df <- reverse_check_docu(sav_path = c(sav_path1, sav_path2),
#'                        pdf_path = c(pdf_path1, pdf_path2, pdf_path3))
#'
#'@export
reverse_check_docu <- function(white_list = c(english_words, german_words), pdf_path, sav_path, encoding = NULL) {
  if(!is.character(white_list)) stop("'white_list' must be a character vector.")
  if(!is.character(sav_path) || length(sav_path) == 0) stop("'sav_path' must be a character vector of at least length 1.")
  if(!is.character(pdf_path) || length(pdf_path) == 0) stop("'pdf_path' must be a character vector of at least length 1.")

  data("english_words")
  data("german_words")
  all_words <- white_list

  ## extract variable names from data sets
  nams <- lapply(sav_path, function(single_sav_path) {
    gads <- suppressWarnings(eatGADS::import_spss(single_sav_path, checkVarNames = FALSE, encoding = encoding))
    eatGADS::namesGADS(gads)
  })
  #names(nams)<- unlist(lapply(sav_path_list, basename))

  ## read in codebook
  #cat("reading ", pdf_path)
  corp_docu <- quanteda::corpus(readtext::readtext(pdf_path))
  #summary(corp_docu)
  tok_docu <- quanteda::tokens(corp_docu, remove_punct = TRUE, remove_numbers = TRUE,
                               remove_url = TRUE, remove_symbols = TRUE)

  #cat("comparing ", pdf_path)
  ## word set comparisons
  words_not_in_data <- setdiff(tok_docu[[1]], unlist(nams)) ## which words in the documentation are in the data
  words_not_in_data_or_whitelist <- setdiff(words_not_in_data, all_words) ## which words in the documentation are in the white-lists
  # check if case was messing things up
  words_not_in_data_or_whitelist_lc <- tolower(words_not_in_data_or_whitelist)
  all_words_lc <- tolower(all_words)
  words_not_in_data_or_whitelist_case_independent <-  words_not_in_data_or_whitelist[!words_not_in_data_or_whitelist_lc %in% all_words_lc]

  #browser()
  ## separated words?
  sep_words <- words_not_in_data_or_whitelist_case_independent[grepl("-$", words_not_in_data_or_whitelist_case_independent, ignore.case = TRUE)]
  #if(length(sep_words) > 0) browser()
  for(sep_word in sep_words) {
   sep_word_part <- sub("-$", "", sep_word)
   out <- grep(sep_word_part, all_words, fixed = TRUE)
   if(length(out) > 0) words_not_in_data_or_whitelist_case_independent <- setdiff(words_not_in_data_or_whitelist_case_independent, sep_word)
  }

  #print(nams)

  data.frame(suspicious_words = words_not_in_data_or_whitelist_case_independent, missing_documention = "", comment = "")
}


# separate Tabellenlbaetter fuer Uebereinstimmungen mit a) Datensatz-Variablennamen und b) Korpus

