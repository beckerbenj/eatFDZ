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


#### Actual tests ####
test_that("Invalid inputs are rejected", {
  expect_error(createReadMe(1:5),
               "^'in_path'")
  expect_error(createReadMe(file.path(pathbase, "SUF_Remote")),
               "^Directory ")
  expect_error(createReadMe(studybase, out_path = file.path(pathbase, "templates")),
               "^'out_path'")
  expect_error(createReadMe(studybase, margin = 4.5),
               "^'margin'")
  expect_error(createReadMe(studybase, header = file.path(pathstud1, filesstud1[[3]])),
               "^Unsupported file format")
  expect_error(createReadMe(studybase, footer = file.path(pathbase, "template_footer.csv"),
                            sep = ",", lang = "fr"),
               "^No matching column")
  expect_error(createReadMe(studybase, footer = file.path(pathbase, "template_footer.csv"),
                            sep = ",", replace_id = "_Antrag"),
               "^'replace_id'")
  expect_error(createReadMe(file.path(pathbase, "template_IQB-BT_2021_v1.tab")),
               "^Could not find")
  expect_error(createReadMe(file.path(pathstud1, filesstud1[[3]])),
               "^Unsupported file format")
  expect_error(createReadMe(file.path(pathbase, "template_IQB-BT_2021_v1.csv"), lang = "fr"),
               "^No matching column")
})

test_that("Directory mode: Outputs have correct formats", {
  ### overview table ###
  # two languages
  expect_no_error(study_overview_2lang <- createReadMe(pathstud1, create_table = "overview"))
  expect_s3_class(study_overview_2lang, "data.frame")
  expect_equal(ncol(study_overview_2lang), 5)
  expect_identical(sort(names(study_overview_2lang)),
                   sort(c("file_name", "description_de", "description_en", "depth", "group")))
  # one language
  expect_no_error(study_overview_1lang <- createReadMe(pathstud1, create_table = "overview", lang = "de"))
  expect_equal(ncol(study_overview_1lang), 4)
  expect_identical(sort(names(study_overview_1lang)),
                   sort(c("file_name", "description_de", "depth", "group")))

  ### control table ###
  # two languages
  expect_no_error(study_control_2lang <- createReadMe(pathstud1, create_table = "control"))
  expect_type(study_control_2lang, "list")
  expect_s3_class(study_control_2lang[[1]], "data.frame")
  expect_equal(length(study_control_2lang), 1)
  expect_equal(ncol(study_control_2lang[[1]]), 4)
  expect_identical(names(study_control_2lang), basename(pathstud1))
  expect_identical(sort(names(study_control_2lang[[1]])),
                   sort(c("file_name", "description_de", "description_en", "flag")))
  # one language
  expect_no_error(study_control_1lang <- createReadMe(pathstud1, create_table = "control", lang = "en"))
  expect_equal(ncol(study_control_1lang[[1]]), 3)
  expect_identical(sort(names(study_control_1lang[[1]])),
                   sort(c("file_name", "description_en", "flag")))

  ### ReadMe text ###
  # two languages
  expect_no_error(study_text_2lang <- createReadMe(pathstud1, create_table = "text"))
  expect_type(study_text_2lang, "list")
  expect_type(study_text_2lang[[1]], "character")
  expect_equal(length(study_text_2lang), 2)
  expect_gt(length(study_text_2lang[[1]]), 5)
  expect_identical(sort(names(study_text_2lang)),
                   sort(c("de", "en")))
  # one language
  expect_no_error(study_text_1lang <- createReadMe(pathstud1, create_table = "text", lang = "de"))
  expect_equal(length(study_text_1lang), 1)
  expect_gt(length(study_text_1lang[[1]]), 5)
  expect_identical(names(study_text_1lang), "de")
})

test_that("Table mode: Outputs have correct formats", {
  contrtab <- file.path(pathbase, "template_IQB-BT_2021_v1.csv")
  ### overview table ###
  # two languages
  expect_no_error(study_overview_2lang <- createReadMe(contrtab, create_table = "overview",
                                                       sep = ","))
  expect_s3_class(study_overview_2lang, "data.frame")
  expect_equal(ncol(study_overview_2lang), 5)
  expect_identical(sort(names(study_overview_2lang)),
                   sort(c("file_name", "description_de", "description_en", "depth", "group")))
  # one language
  expect_no_error(study_overview_1lang <- createReadMe(contrtab, create_table = "overview",
                                                       sep = ",", lang = "de"))
  expect_equal(ncol(study_overview_1lang), 4)
  expect_identical(sort(names(study_overview_1lang)),
                   sort(c("file_name", "description_de", "depth", "group")))

  ### control table ###
  # two languages
  expect_no_error(study_control_2lang <- createReadMe(contrtab, create_table = "control",
                                                      sep = ","))
  expect_type(study_control_2lang, "list")
  expect_s3_class(study_control_2lang[[1]], "data.frame")
  expect_equal(length(study_control_2lang), 1)
  expect_equal(ncol(study_control_2lang[[1]]), 4)
  expect_identical(names(study_control_2lang), basename(pathstud1))
  expect_identical(sort(names(study_control_2lang[[1]])),
                   sort(c("file_name", "description_de", "description_en", "flag")))
  # one language
  expect_no_error(study_control_1lang <- createReadMe(contrtab, create_table = "control",
                                                      sep = ",", lang = "en"))
  expect_equal(ncol(study_control_1lang[[1]]), 3)
  expect_identical(sort(names(study_control_1lang[[1]])),
                   sort(c("file_name", "description_en", "flag")))

  ### ReadMe text ###
  # two languages
  expect_no_error(study_text_2lang <- createReadMe(contrtab, create_table = "text",
                                                   sep = ","))
  expect_type(study_text_2lang, "list")
  expect_type(study_text_2lang[[1]], "character")
  expect_equal(length(study_text_2lang), 2)
  expect_gt(length(study_text_2lang[[1]]), 5)
  expect_identical(sort(names(study_text_2lang)),
                   sort(c("de", "en")))
  # one language
  expect_no_error(study_text_1lang <- createReadMe(contrtab, create_table = "text",
                                                   sep = ",", lang = "de"))
  expect_equal(length(study_text_1lang), 1)
  expect_gt(length(study_text_1lang[[1]]), 5)
  expect_identical(names(study_text_1lang), "de")
})

test_that("Directory mode lists all files", {
  ### overview table ###
  # dont skip base
  study_overview_noskip <- createReadMe(studybase, create_table = "overview")
  expect_all_true(sapply(c(filesstud1, filesstud2_sub1, filesstud2_sub2),
                  function(this_file_name) this_file_name %in% study_overview_noskip$file_name))
  expect_equal(study_overview_noskip$depth,
               c(0, rep(1, length(filesstud1) + 1),
                 1, rep(2, length(filesstud2_sub1) + length(filesstud2_sub1) + 2)))
  expect_identical(study_overview_noskip$group,
                   c(basename(studybase),
                     rep(file.path(basename(studybase), basename(pathstud1)), length(filesstud1) + 1),
                     file.path(basename(studybase), basename(pathstud2)),
                     rep(file.path(basename(studybase), basename(pathstud2), basename(pathstud2_sub1)),
                         length(filesstud2_sub1) + 1),
                     rep(file.path(basename(studybase), basename(pathstud2), basename(pathstud2_sub2)),
                         length(filesstud2_sub2) + 1)))
  # skip base
  study_overview_skip <- createReadMe(studybase, create_table = "overview", skip_empty_base = TRUE)
  expect_all_true(sapply(c(filesstud1, filesstud2_sub1, filesstud2_sub2),
                         function(this_file_name) this_file_name %in% study_overview_skip$file_name))
  expect_equal(study_overview_skip$depth,
               c(rep(0, length(filesstud1) + 1),
                 0, rep(1, length(filesstud2_sub1) + length(filesstud2_sub1) + 2)))
  expect_identical(study_overview_skip$group,
                   c(rep(basename(pathstud1), length(filesstud1) + 1),
                     basename(pathstud2),
                     rep(file.path(basename(pathstud2), basename(pathstud2_sub1)),
                         length(filesstud2_sub1) + 1),
                     rep(file.path(basename(pathstud2), basename(pathstud2_sub2)),
                         length(filesstud2_sub2) + 1)))

  ### control table ###
  # dont skip base
  study_control_noskip <- createReadMe(studybase, create_table = "control", lang = "en")
  expect_all_true(sapply(filesstud1,
                         function(this_file_name) this_file_name %in% study_control_noskip[[1]]$file_name))
  expect_all_true(sapply(c(filesstud2_sub1, filesstud2_sub2),
                         function(this_file_name) this_file_name %in% study_control_noskip[[2]]$file_name))
  # skip base
  study_control_skip <- createReadMe(studybase, create_table = "control", skip_empty_base = TRUE)
  expect_all_true(sapply(filesstud1,
                         function(this_file_name) this_file_name %in% study_control_skip[[1]]$file_name))
  expect_all_true(sapply(c(filesstud2_sub1, filesstud2_sub2),
                         function(this_file_name) this_file_name %in% study_control_skip[[2]]$file_name))

  ### ReadMe text ###
  # dont skip base
  study_text_noskip <- createReadMe(studybase, create_table = "text")
  expect_all_true(sapply(c(filesstud1, filesstud2_sub1, filesstud2_sub2),
                         function(this_file_name) {
                           sum(grepl(x = study_text_noskip$de, pattern = this_file_name)) == 1
                         }))
  # skip base
  study_text_skip <- createReadMe(studybase, create_table = "text", skip_empty_base = TRUE)
  expect_all_true(sapply(c(filesstud1, filesstud2_sub1, filesstud2_sub2),
                         function(this_file_name) {
                           sum(grepl(x = study_text_skip$de, pattern = this_file_name)) == 1
                         }))
})

})
