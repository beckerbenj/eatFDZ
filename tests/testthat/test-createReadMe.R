#### Set up dummy directoy and materials ####
# folders
pathbase <- test_path("helper_for_ReadMe")
studybase <- file.path(pathbase, "all_studies")
pathstud1 <- file.path(studybase, "IQB-BT_2021_v1")
pathstud2 <- file.path(studybase, "PISA 2006_v1")
pathstud2_sub1 <- file.path(pathstud2, "PISA 2006-E")
pathstud2_sub2 <- file.path(pathstud2, "PISA 2006-I")
for (this_dir in c(pathbase, studybase, pathstud1, pathstud2, pathstud2_sub1, pathstud2_sub2)) {
  if (!dir.exists(this_dir)) dir.create(this_dir)
}

# files
filesstud1 <- c("IQB-BT_2021_student_quest_v1_SUF_Remote_Antrag.sav",
                "IQB-BT_2021_teacher_quest_group-specific_v1_SUF_Remote_Antrag.sav",
                "IQB-BT_2021_v1.sha",
                "Rucker_Weigt_Burblies_Schipolowski_2026.pdf")
filesstud2_sub1 <- c("PISA2006-E_Datensatz_Eltern_9KL_v1_SUF_Remote_Antrag.sav",
                     "PISA2006-E_Datensatz_Eltern_15J_v1_SUF_Remote_Antrag.sav",
                     "PISA2006-E_Datensatz_Eltern_15J_v1_1_SUF_Remote_Antrag.dta",
                     "PISA2006-E_Noten_kodiert_v1_SUF_Remote_Antrag.csv")
filesstud2_sub2 <- c("PISA2006-I_Datensatz_Eltern_9KL_v1_SUF_Remote_Antrag.sav",
                     "PISA2006-I_Datensatz_Eltern_15J_v1_SUF_Remote_Antrag.sav",
                     "PISA2006-I_Datensatz_Schulleitung_v1_SUF_Remote_Antrag.sav",
                     "remove-before-flight.txt")
for (filelist in c("filesstud1", "filesstud2_sub1", "filesstud2_sub2")) {
  this_dir <- get(sub(x = filelist, pattern = "^files", replacement = "path"))
  full_paths <- file.path(this_dir, get(filelist))
  for (this_file in full_paths) {
    if (!file.exists(this_file)) file.create(this_file)
  }
}

# control tables
template_stud1 <- file.path(pathbase, "template_IQB-BT_2021_v1.csv")
if (!file.exists(template_stud1)) {
  this_template <- data.frame(file_name = c(basename(pathstud1),
                                            filesstud1),
                              description_de = c("IQB-Bildungstrend 2021",
                                                 "Datensatz Schueler*innen",
                                                 "Datensatz Lehrkraefte lerngruppenspezifisch",
                                                 "Bitte loesche diese Checksumme",
                                                 "Großartige Datendokumentation"),
                              description_en = c("IQB Trends in Student Achievement 2021",
                                                 "student data",
                                                 "teacher data with a very long file name",
                                                 "checksum that we forgot to delete",
                                                 "amazing data paper"),
                              flag = c("header", "", "", "", ""))
  write.table(x = this_template,
              file = template_stud1,
              sep = ",",
              row.names = FALSE)
}

template_header <- file.path(pathbase, "template_header.csv")
single_line_header <- "Dies ist eine tolle Kopfzeile"
multi_line_header <- c("This header", "look", "WAAAAY", "cooler!")
if (!file.exists(template_header)) {
  this_template <- data.frame(header_de = c(single_line_header, "", "", ""),
                              header_en = multi_line_header)
  write.table(x = this_template,
              file = template_header,
              sep = ",",
              row.names = FALSE)
}

template_contbox <- file.path(pathbase, "template_contbox.csv")
single_line_contbox <- "IQB-Bildungstrend 2021"
multi_line_contbox <- c("IQB Trends in Student Achievement", "PISA 2006")
if (!file.exists(template_contbox)) {
  this_template <- data.frame(contbox_de = c(single_line_contbox, "", "", ""),
                              contbox_en = multi_line_contbox)
  write.table(x = this_template,
              file = template_contbox,
              sep = ",",
              row.names = FALSE)
}

template_remarks <- file.path(pathbase, "template_remarks.csv")
multi_line_remarks <- c('[ abweichende Variablennamen ]',
                        'Um Konflikte mit Funktionstermen zu vermeiden, wurde ggf. bestimmten Variablennamen das Suffix "Var" angehaengt.',
                        'Dies betrifft bspw. Variablen wie "Alter" oder "analyze". Es koennen daher entsprechend Unterschiede zwischen den',
                        'Datensaetzen und den Dokumentationsmaterialien auftreten.')
empty_remarks <- c("", "", "", "")
if (!file.exists(template_remarks)) {
  this_template <- data.frame(remarks_de = multi_line_remarks,
                              remarks_en = empty_remarks)
  write.table(x = this_template,
              file = template_remarks,
              sep = ",",
              row.names = FALSE)
}

template_footer <- file.path(pathbase, "template_footer.csv")
single_line_footer <- "Angaben ohne Gewaehr"
multi_line_footer <- c("FDZ", "am", "IQB")
if (!file.exists(template_footer)) {
  this_template <- data.frame(footer_de = c(single_line_footer, "", ""),
                              footer_en = multi_line_footer)
  write.table(x = this_template,
              file = template_footer,
              sep = ",",
              row.names = FALSE)
}

