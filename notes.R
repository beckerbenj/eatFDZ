
remotes::install_github("beckerbenj/eatFDZ")


out <- check_all("tests/testthat/helper_example_data2.sav", sdcVars = )

eatAnalysis::write_xlsx(out, "test.xlsx")


### further checks (tbd)?
# lengthy variable names? => sehr grosszuegig
# variables with no missing tags at all? -> or unlabeled values within range?
# extended fixEncoding (further special signs?) => umsetzen
# character variables? => Liste; Datengebende muessen ankreuzen, dass sie es gechecked haben

# tbd
# genauere Beschreibungen in xlsx; Beispiel .xlsx?
# AUfschluesselung Sonderzeichen Metadaten in Variablen & Werte; Verletzung anzeigen?
# ID-Variablen: auch fuer mehrere
# unused value labels raus
# missing tags ueberhaupt vergeben?
# Spaltenname nkl5?
# SHB check => 0llen Auswaehlen?

##
