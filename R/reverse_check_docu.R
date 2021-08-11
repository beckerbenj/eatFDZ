####
#############################################################################
#' Reverse check documentation of data sets.
#'
#' Diese Funktion nimmt das Skalenhandbuch, extrahiert alle Wörter, sortiert die aus, die als Variablennamen in einem oder mehreren Datensätzen vorkommen und diejenigen, die auf einer "whitelist" stehen. Dann gibt sie eine Liste derjenigen Begriffe aus, bei denen es sich möglicherweise um Variablennamen handelt, die nicht im Datensatz auffindbar sind.
#'
#' Die Formel benötigt folgenden Input:
#'
#'@param corpuspath Pfad, unter dem der externe Korpus (die "whitelist") als \code{.rdata} file abgelegt ist. (Die Funktion zieht sich automatisch den aktuellsten Korpus, der in dem Ordner liegt.)
#'@param pdf_path Character vector with paths to the \code{.pdf} files.
#'@param sav_path_list Liste der Datensatznamen inklusive ihrer Speicherpfade.
#'
#'@return Die Funktion gibt eine Liste mit den Objekten \code{venn_docu}, \code{unique_tokens} und \code{ext_corpus} aus.
#'\code{venn_docu} ist ein Objekt der Klasse "venn"; der Output von gplots::venn.
#' \code{unique_tokens} ist ein String-Vektor, der die Wörter enthält, die im Skalenhandbuch, aber weder im Datensatz, noch im externen Korpus enthalten sind.
#' \code{ext_corpus} ist der externe Korpus, der im ersten Schritt eingelesen wurde und die bisherige "whitelist" umfasst.
#' \code{variables} ist eine Liste der Variablen, die aus den Datensätzen extrahiert wurden.
#'
#'@examples
#'
#'studie <- "" # Hier den Ordnernamen der Studie in 01_Studien angeben (FDZ-intern)
#'studienpath <- "" # Hier den output-Pfad angeben
#'setwd(studienpath)
#'
#' out <- reverse_check_docu(corpuspath = corpuspath, sav_path_list = sav_path_list, pdf_path = pdf_path)
#'
#' plot(out$venn_docu)
#' corpus_alt <- out$ext_corpus
#
#' # 3. Ergebnis rausschreiben
#' write.csv(docu_unique, file=paste0(studienpath, "/", studie, "Skalenhandbuch_unique_words.csv"))
#'
#' ### # Dieses csv muss haendisch durchgegangen werden und verbliebene Variablennamen muessen identifiziert werden. Dies sind Variablen, die vermutlich in der Doku, aber nicht im Datensatz vorkommen und nochmals detailliert geprueft werden muessen. Diese werden in ein anderes Dokument kopiert und im Original geloescht. Das Original wird im nächsten Schritt wieder hier eingelesen, um den externen Korpus zu updaten
#'
#' ## 4.  externen Korpus aktualisieren fuer spaetere Verwendung, Namen der Quelle einfuegen
#' add_corp <- read.csv(paste0(studie, "Skalenhandbuch_unique_words.csv"), header=F, sep=";")
#' add_corp <- paste(add_corp$V2, collapse = " ")
#' names(add_corp) <- paste("Skalendokumentation", studie, sep=" ")
#' add_corp <- quanteda::corpus(add_corp)
#'
#' corpus <- corpus_alt + add_corp
#' save(corpus, file=paste0("corpus", Sys.Date(), ".rdata"))
#'
#'@export

reverse_check_docu <- function (corpuspath, sav_path_list, pdf_path ) {
  current_path <- getwd()
  on.exit(setwd(current_path))

  setwd(corpuspath)
  corpfiles <- list.files(getwd(), recursive = T, pattern="corpus*", full.names = T)
  filedates <- gsubfn::strapplyc(corpfiles, "[0-9-]{8,}", simplify = TRUE)
  corpus <- ifelse(length(corpfiles), load(paste0("corpus", max(unlist(filedates)), ".rdata")),  quanteda::corpus(""))

  summary(corpus)
  tok_ext <- quanteda::tokens(corpus, remove_punct = T, remove_numbers=T, remove_url=TRUE)
  tok_ext <- unlist(tok_ext)

  # Variablennamen aus Datensatz extrahieren
  nams <- lapply(sav_path_list, function(sav_path) {
    gads <- suppressWarnings(eatGADS::import_spss(sav_path, checkVarNames = FALSE))
    nams <- eatGADS::namesGADS(gads)
    #names(nams) <- nams
    nams})
  names(nams)<- unlist(lapply(sav_path_list, basename))
  #nams <- unlist(nams)

  # Skalendoku einlesen, in Korpus umwandeln und Text in Token umwandeln
  corp_docu <- quanteda::corpus(readtext::readtext(pdf_path))
  summary(corp_docu)

  tok_docu <- quanteda::tokens(corp_docu, remove_punct = T, remove_numbers=T, remove_url=TRUE, remove_symbols=T)

  ## Alle Woerter, die keine Variablen im Datensatz sind extrahieren
  inv_docu <- setdiff(tok_docu[[1]], unlist(nams))


  ## Schnittmenge aus externem Korpus und Skalenhandbuch darstellen
  venn_docu <-gplots::venn(list("Skalenhandbuch" = inv_docu, "externer Korpus" = tok_ext))
  docu_unique <- setdiff(inv_docu, tok_ext)

  res <- list ("venn_docu" = venn_docu, "unique_tokens" = docu_unique, "ext_corpus" = corpus, "variables" = nams)
  res
}
