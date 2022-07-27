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

  combined_varNames <- combine_mez_stem_suffix(tok_docu_longer)

  out_list <- lapply(sav_path, function(single_sav_path) {
    gads <- suppressWarnings(eatGADS::import_spss(single_sav_path, checkVarNames = FALSE, encoding = encoding))
    nams <- eatGADS::namesGADS(gads)
    names(nams) <- nams

    # test
    test <- lapply(nams, function(nam) {
      print(nam)

      out <- quanteda::kwic(tok_docu, pattern = nam, window = post_words, case_insensitive = !case_sensitive)

      if(nrow(out) == 0) {
        #if(nam == "msta1_e") browser()
        #browser()
        out_list <- lapply(combined_varNames, function(varNames_vec) nam %in% varNames_vec)
        count <- sum(unlist(out_list))
        out <- data.frame(variable = nam,
                   count = count,
                   how_found = ifelse(count > 0, yes = "name_pasting", no = NA),
                   stringsAsFactors = FALSE)
        return(out)
        }

      data.frame(variable = nam,
                 count = nrow(out),
                 how_found = ifelse(nrow(out) > 0, yes = "normal", no = NA),
                 stringsAsFactors = FALSE)
    })
    do.call(rbind, test)
  })
  #if(length(sav_path) > 1) browser()
  out_df <- eatTools::do_call_rbind_withName(out_list, name = basename(sav_path), colName = "data_set")
  out_df[, c("variable", "count", "how_found", "data_set")]
}


combine_mez_stem_suffix <- function(tok_docu_longer) {
  out <- lapply(tok_docu_longer, function(single_cb) {
    #browser()
    #star_vec <- grep("\\*$|^\\*", single_cb, value = TRUE)
    #star_vec <- grep("\\*", single_cb, value = TRUE)
    star_vec <- grep("\\*$|^\\*|^\\(\\*|^\\_\\(\\*", single_cb, value = TRUE)
    star_vec <- gsub("\\(|\\)|\\_\\(", "", star_vec)

    where_star <- stringi::stri_locate_first(star_vec, regex = "\\*")
    is_stem <- where_star[, "start"] > 1
    is_suffix <- where_star[, "start"] == 1

    i <- 1
    #out_list <- list()
    out_list <- c()

    while(i < length(star_vec)) {
      is_stem_single <- is_stem[i]
      stem_set <- c()

      while(is_stem_single) {
        stem_set <- c(stem_set, star_vec[i])
        i <- i + 1
        is_stem_single <- is_stem[i]
      }

      is_suffix_single <- is_suffix[i]
      suffix_set <- c()

      while(i < length(star_vec) && is_suffix_single) {
        suffix_set <- c(suffix_set, star_vec[i])
        i <- i + 1
        is_suffix_single <- is_suffix[i]
      }
      #list_element <- gsub("\\*", "", unlist(lapply(stem_set, function(x) paste0(x, suffix_set))))
      #for_list_append <- list()
      #for_list_append[[1]] <- list_element
      #out_list <- append(out_list, for_list_append)
      out_list <- c(out_list, gsub("\\*", "", unlist(lapply(stem_set, function(x) paste0(x, suffix_set)))))
    }

    out_list
  })
  out
}
