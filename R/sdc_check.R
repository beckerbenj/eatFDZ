
#   foo <- fdz(fileName = "n:/Dropbox/Projekte/2014/Aleks/StEG_Datensatz_Eltern_IZA.sav", saveFolder = "n:/Archiv/temp", nameListe = "liste1.csv", nameSyntax = "syntax1.txt")
#   foo <- fdz(fileName = "q:/BT2016/BT/50_Daten/03_Aufbereitet/06_Gesamtdatensatz/BS_LV_Primar_2016_Matchingvorlaeufig_09_erweiterteGadsversion.sav", saveFolder = "N:/archiv/temp", nameListe = "liste2.csv", nameSyntax = "syntax2.txt", exclude = exclude)

#### Perform FDZ Data Cleansing
#############################################################################
#' Create a Statistical Disclosure Control Report
#'
#' This function generates a statistical disclosure control (SDC) report, identifying variables with categories
#' that have low absolute frequencies. Such low-frequency categories could potentially lead to statistical
#' data disclosure issues, particularly in datasets involving individual-level data from studies like
#' large-scale assessments. The function currently performs only a uni-variate check, flagging categories
#' with a frequency below a specified threshold.
#'
#' @param fileName A character string specifying the path to the SPSS file to import as a \code{GADSdat} object.
#' @param boundary An integer specifying the frequency threshold for identifying low-frequency categories.
#' Categories with less than or equal to this number of observations will be flagged. The default value is \code{5}.
#' @param exclude An optional character vector containing variable names that should be excluded from the report.
#' @param encoding An optional character string specifying the character encoding for importing the SPSS file.
#' If \code{NULL} (default), the encoding specified in the file is used.
#'
#' @return A \code{data.frame} summarizing categories with low frequencies, including the following columns:
#' \itemize{
#'   \item \code{variable}: The name of the variable with low-frequency categories.
#'   \item \code{varLab}: The label for the variable (if present).
#'   \item \code{existVarLab}: Whether a variable label exists (\code{TRUE} or \code{FALSE}).
#'   \item \code{existValLab}: Whether value labels exist for the variable (\code{TRUE} or \code{FALSE}).
#'   \item \code{skala}: Information on the variable type/classification.
#'   \item \code{nKatOhneMissings}: The total number of non-missing categories.
#'   \item \code{nValid}: The total number of valid observations for the variable.
#'   \item \code{nKl5}: Indicator for variables with categories flagged as low frequency (\code{TRUE} or \code{FALSE}).
#'   \item \code{exclude}: Whether the variable has been excluded based on the \code{exclude} argument.
#' }
#'
#' @examples
#' # Load an example SPSS file
#' sav_path <- system.file("extdata", "LV_2011_CF.sav", package = "eatFDZ")
#'
#' # Exclude unique identifier variables from the SDC check
#' exclude_vars <- c("idstud_FDZ", "idsch_FDZ")
#'
#' # Generate the SDC report
#' sdc_report <- sdc_check(fileName = sav_path, boundary = 5, exclude = exclude_vars)
#'
#' # Print the SDC report
#' print(sdc_report)
#'
#'@export
sdc_check <- function ( fileName, boundary = 5, exclude = NULL, encoding = NULL) {
  GADSdat     <- eatGADS::import_spss(fileName, checkVarNames = FALSE, encoding = encoding)
  # load("t:/Sebastian/gd.rda")
  #GADSdat     <- eatGADS::checkMissings(GADSdat, missingLabel = "missing", addMissingCode = TRUE, addMissingLabel = TRUE)
  #datOM  <- eatGADS::miss2NA(GADSdat) ## alle was man braucht? oder extractData
  varLab <- unique(GADSdat[["labels"]][, c("varName", "varLabel")])
  liste <- create_overview(GADSdat, boundary = boundary)

  #browser()

  ## Fehler werfen statt warning und pruefen ob rausgenommen oder nur in Spalte geschrieben
  if (!is.null(exclude) ) {
    chk <- setdiff(exclude,liste[,"variable"])
    if ( length(chk)>0) {
      warning("Variables '",paste(chk, collapse="', '"), "' from the 'exclude' argument are not available in the data set and will be ignored.")
    }
    liste[stats::na.omit(match(exclude, liste[,"variable"])),"exclude"] <- TRUE
  }

  liste
}


create_overview <- function(GADSdat, boundary) {
  skala  <- sapply(GADSdat[["dat"]], class)
  datOM  <- eatGADS::miss2NA(GADSdat)
  # to do: Funktion schreiben, die in dem data.frame die missingwerte (z.B. -9994) auf basis der labels in NA umwandelt
  # folgende Zeilen braucht einen Datensatz mit NAs statt -9994                                                  # datensatz ohne missings
  tab    <- lapply(datOM, FUN = function (y ) { table(as.character(y)) } )
  nKatOM <- sapply(tab, FUN = function ( y ) { length(y)})                 ### Anzahl Kategorien (ohne Missingkategorien)
  nValid <- sapply(tab, FUN = function ( y ) { sum(y)})                    ### untere Zeile: Kategorien mit Haeufigkeit kleiner gleich 5, aber groesser als 0!
  freq5  <- sapply(tab, FUN = function ( y ) { length(which(y <= boundary & y > 0 ))>0 })
  varLab <- unique(GADSdat[["labels"]][, c("varName", "varLabel")])
  existVarLab <- nchar(varLab[,"varLabel"])>0 & !is.na(varLab[,"varLabel"])
  existValLab <- do.call(rbind, by(data = GADSdat[["labels"]], INDICES = GADSdat[["labels"]][,"varName"], FUN = function (x ) {
    data.frame(variable = unique(x[, "varName"]), existValLab = any(!is.na(x[,"valLabel"])), stringsAsFactors = FALSE)
    }))
  out1 <- data.frame ( variable = varLab[,"varName"], varLab = varLab[,"varLabel"], existVarLab = existVarLab,
                         skala = unlist(skala), nKatOhneMissings = nKatOM, nValid = nValid,
                         nKl5 = freq5, exclude = FALSE, stringsAsFactors = FALSE)
  out2 <- merge(out1, existValLab, all = TRUE, by = "variable", sort = FALSE)
  out2[, c("variable", "varLab", "existVarLab", "existValLab", "skala", "nKatOhneMissings", "nValid", "nKl5", "exclude")]
}


makeAnonymous <- function (x, liste, boundary, datOM, df, varLab) {
  message(length(x), " numeric variables with category size <= ", boundary," will be recoded anonymously.")
  liste[x, "makeAnonymous"] <- TRUE
  toRec <- liste[which(liste[,"makeAnonymous"]==TRUE),]
  snipp1<- unlist(by(toRec, INDICES = toRec[,"variable"], FUN = function ( tr ) {
    werte <- table(datOM[, as.character(tr[["variable"]]) ] )       ### hier: Variablenweise!
    werteM<- table(df[["dat"]][, as.character(tr[["variable"]]) ] )
    unter6<- werte[which(werte < (boundary + 1) )]
    if ( length(unter6) ==0) {cat("darf nicht passieren."); browser()}
    unter6<- data.frame ( Nummer = seq_along(unter6), kategorie = names(unter6), belegung = unter6)
    aufb  <- do.call("rbind", by(data = unter6, INDICES = unter6[,"Nummer"], FUN = function ( z ) {
      matchU <- match( as.character(z[["kategorie"]]), names(werte))
      matchW <- matchU                                  ### hier: werteweise (je Variable)
      toNA   <- FALSE
      while ( sum(werte[matchU:matchW])< (boundary + 1) & toNA == FALSE ) {
        if( (matchW+2)< length(werte))  {
          matchW <- matchW+1
        }  else {
          toNA <- TRUE
        }
      }
      inkl   <- names(werte[matchU:matchW])[-1]         ### wenn zwei Werte mit weniger als 5 Belegungen direkt benachbart sind, muss ggf. nicht
      if(length(inkl) == 0 ) { inkl <- NA}              ### zweimal recodiert werden, falls beide Kategorien zusammen mehr als 5 Belegungen haben
      z      <- data.frame ( Nummer = z[["Nummer"]], kategorie = z[["kategorie"]], inkludiert = inkl, toNA = toNA)
      return(z)}))
    weg   <- which(aufb[,"kategorie"] %in% aufb[,"inkludiert"])
    if(length(weg)>0) { aufb <- aufb[-weg,]}
    if(length(which( aufb[,"toNA"] == TRUE))>0) {              ### Fuer alle, die zu "NA" recodiert werden, muss nur ein Recodierungsstatement, nicht mehrere verfasst werden
      minNum <- min(aufb[which( aufb[,"toNA"] == TRUE),"Nummer"])
      aufb[which( aufb[,"toNA"] == TRUE),"Nummer"] <- minNum
    }
    misLab<- setdiff(names(werteM), names(werte))              ### Missinglabels fuer Variable
    recSt1<- c("RECODE", as.character(tr[["variable"]]) )      ### erster Teil des Recodierungsstatements
    recSt2<- unlist(by(data = aufb, INDICES = aufb[,"Nummer"], FUN = function ( r ) {
      if(r[1,"toNA"] == FALSE) {
        newValue<- r[1,"kategorie"]
        recStat1<- paste("(",as.numeric(as.character(r[1,"kategorie"])), " THRU ", max(as.numeric(as.character(r[,"inkludiert"]))), " = ", newValue, ")",sep="")
      }  else  {
        allVal  <- sort(unique(stats::na.omit(c(as.numeric(as.character(r[,"kategorie"])), as.numeric(as.character(r[,"inkludiert"]))))))
        if ( length(allVal)>1) {
          recStat1<- paste("(",allVal[1], " THRU ", allVal[length(allVal)], " = SYSMIS )",sep="")
        }  else  {
          recStat1<- paste("(",allVal[1], " = SYSMIS )",sep="")
        }
      }
      return(recStat1)}))                                    ### Syntaxgenerierung: "c:\Users\weirichs\Dropbox\IQB\Projekte\Aleks\Aufbereitung_SUFs_StEG_ak_Elterndaten.sps"
    recSt3<- c("(ELSE = COPY)", "INTO", paste( as.character(tr[["variable"]]), "_FDZ.\n", sep=""),
               paste("VARIABLE LABELS ", paste( as.character(tr[["variable"]]), "_FDZ", sep="")," '",
                     varLab[which(varLab[,"varName"] == as.character(tr[["variable"]])), "varLabel"], " (FDZ)'.", sep=""))
    recSt4<- unlist(by(data = aufb, INDICES = aufb[,"Nummer"], FUN = function ( r ) {
      if(r[1,"toNA"] == FALSE) {
        newValue<- r[1,"kategorie"]
        recStat <- paste("VALUE LABELS ", paste( as.character(tr[["variable"]]), "_FDZ ", sep=""), newValue,
                         " 'von ",as.numeric(as.character(r[1,"kategorie"]))," bis ",max(as.numeric(as.character(r[,"inkludiert"]))),
                         " (zur Anonymisierung aggregiert (FDZ))'.",sep="")
      }  else  {
        recStat <- NULL
      }
      return(recStat)}))
    ### wertelabels fuer missings, falls vorhanden
    recSt4b <- NULL # initialisieren
    lbs <- df$labels[df$labels$varName == as.character(tr[["variable"]]),]
    lbs <- lbs[which(lbs[,"missings"]=="miss"),]
    new_misLab <- lbs[["value"]]
    if ( length(new_misLab)>0) {
      stopifnot(nrow(lbs)>0)
      recSt4b<- unlist(apply(lbs, MARGIN = 1, FUN = function (r){
        paste("VALUE LABELS ", paste( as.character(tr[["variable"]]), "_FDZ ", sep=""), r[["value"]],
              " '", r[["valLabel"]], "'.", sep="")}))
    }
    recSt5<- c ( paste(c("VARIABLE LEVEL ", paste( as.character(tr[["variable"]]), "_FDZ ", sep=""), "(ORDINAL)."), sep="", collapse=""),
                 paste("FORMATS ", paste( as.character(tr[["variable"]]), "_FDZ ", sep=""), "(F3.0).", sep="", collapse=""))
    if(length(new_misLab)>0) {
      recSt5 <- c(recSt5, paste("MISSING VALUES ", paste( as.character(tr[["variable"]]), "_FDZ ", sep=""), "(", paste(new_misLab, collapse=", "),").",sep="", collapse=""))
    }
    recSt6<- "EXECUTE.\n\n"
    recSt <- c(recSt1, recSt2, recSt3, recSt4, recSt4b, recSt5, recSt6)
    return(recSt)}))
  return(snipp1)}


makeNumeric <- function (x, df_labels, liste, datOM) {
  message("Recode ", length(x), " non-numeric variables into numeric variables.")
  liste[x, "recodeToNumeric"] <- TRUE
  toRec <- liste[which(liste[,"recodeToNumeric"]==TRUE),]
  snipp2<- unlist(by(toRec, INDICES = toRec[,"variable"], FUN = function ( tr ) {
    werte <- eatTools::crop(names(table(datOM[, as.character(tr[["variable"]]) ] )))
    if ( length(setdiff(werte, ""))==0 ) {
      recSt <- NULL
    }  else  {
      miss  <- df_labels[intersect(which(df_labels[,"varName"] == as.character(tr[["variable"]])), which(df_labels[,"missings"] == "miss")),]
      wom   <- setdiff ( setdiff (werte, miss[,"value"]), "")## werte ohne missings
      # if (length(wom)==0) {browser()}
      recSt1<- c("RECODE", as.character(tr[["variable"]]) ) ### erster Teil des Recodierungsstatements
      oldnew<- data.frame ( old = wom, new = 1:length(wom), stringsAsFactors = FALSE)
      recSt2<- unlist(by ( data = oldnew, INDICES = oldnew[,"old"], FUN = function (z) { paste0("('",z[["old"]], "' = ", z[["new"]], ")") }))
      recSt3<- c("INTO" , paste0(as.character(tr[["variable"]]), "_FDZ."))
      recSt4<- paste0("VARIABLE LABELS ", as.character(tr[["variable"]]), "_FDZ '",as.character(tr[["varLab"]]), "'.")
      recSt5<- paste0("VALUE LABELS ", as.character(tr[["variable"]]), "_FDZ '", paste(oldnew[,"new"], paste0("'",oldnew[,"old"], "'") , collapse=" "), ".")
      recSt6<- paste0("VARIABLE LEVEL ", as.character(tr[["variable"]]), "_FDZ (NOMINAL).")
      recSt7<- paste0("FORMATS ", as.character(tr[["variable"]]), "_FDZ (F8.0).")
      recSt8<- NULL                                         ### initialisieren
      if(length(stats::na.omit(miss[,"value"]))>0) {
        recSt8<- paste0("MISSING VALUES ", as.character(tr[["variable"]]), "_FDZ (", paste(stats::na.omit(miss[,"value"]), collapse = ", "), ").")
      }
      recSt9<- "EXECUTE."
      recSt <- c(recSt1, recSt2, recSt3, recSt4, recSt5, recSt6, recSt7, recSt8, recSt9)
    }
    return(recSt)}))
  return(snipp2)}
