####
#############################################################################
#' Reverse check documentation of data sets.
#'
#' This function extracts all words from the \code{pdf} file and discards all words which are variables in the data set and all words
#' which are white listed. Based on this a list of words is returned, which might be listed as variables in the documentation but not
#' in the data set.
#'
#'@param corpuspath Path to the folder, in which the external corups (the \code{white list}) is stored as \code{.rdata} file. The function extracts automatically the newest file available.
#'@param pdf_path Character vector with paths to the \code{.pdf} files.
#'@param sav_path_list Character vector of all data set paths.
#'@param encoding The character encoding used for the file. The default, \code{NULL}, use the encoding specified in the file, but sometimes this value is incorrect and it is useful to be able to override it.
#'
#'@return A list with the entries \code{venn_docu}, \code{unique_tokens} and \code{ext_corpus}:
#' \code{venn_docu}, an object of class \code{venn}; the output of \code{gplots::venn}.
#' \code{unique_tokens}, a character vector containing the words found in the codebook but neither in the data sets nor in the corpus
#' \code{ext_corpus}, the external corpus as imported containing all white listed words.
#' \code{variables}, a character vector including all variable names in the data sets
#'
#'@examples
#'\dontrun{
#'studie <- "" # Hier den Ordnernamen der Studie in 01_Studien angeben (FDZ-intern)
#'studienpath <- "" # Hier den output-Pfad angeben
#'setwd(studienpath)
#'
#' out <- reverse_check_docu(corpuspath = corpuspath, sav_path_list = sav_path_list,
#'                           pdf_path = pdf_path)
#'
#' plot(out$venn_docu)
#' corpus_alt <- out$ext_corpus
#
#' # 3. Ergebnis rausschreiben
#' write.csv(docu_unique,
#'           file=paste0(studienpath, "/", studie, "Skalenhandbuch_unique_words.csv"))
#'
#' ### # Dieses csv muss haendisch durchgegangen werden und verbliebene Variablennamen
#' # muessen identifiziert werden. Dies sind Variablen, die vermutlich in der Doku,
#' # aber nicht im Datensatz vorkommen und nochmals detailliert geprueft werden muessen.
#' # Diese werden in ein anderes Dokument kopiert und im Original geloescht.
#' # Das Original wird im nächsten Schritt wieder hier eingelesen,
#' # um den externen Korpus zu updaten
#'
#' ## 4.  externen Korpus aktualisieren fuer spaetere Verwendung, Namen der Quelle einfuegen
#' add_corp <- read.csv(paste0(studie, "Skalenhandbuch_unique_words.csv"), header=F, sep=";")
#' add_corp <- paste(add_corp$V2, collapse = " ")
#' names(add_corp) <- paste("Skalendokumentation", studie, sep=" ")
#' add_corp <- quanteda::corpus(add_corp)
#'
#' corpus <- corpus_alt + add_corp
#' save(corpus, file=paste0("corpus", Sys.Date(), ".rdata"))
#'}
#'
#'@export
reverse_check_docu <- function(white_list = c(english_words, german_words), sav_path_list, pdf_path, encoding = NULL) {
  all_words <- white_list

  ## extract variable names from data sets
  nams <- lapply(sav_path_list, function(sav_path) {
    gads <- suppressWarnings(eatGADS::import_spss(sav_path, checkVarNames = FALSE, encoding = encoding))
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




