#### Set up dummy directoy and materials ####
##### folders #####
pathbase <- test_path("helper_for_ReadMe")
studybase <- file.path(pathbase, "all_studies")
pathstud1 <- file.path(studybase, "IQB-BT_2021_v1")
pathstud2 <- file.path(studybase, "PISA 2006_v1")
pathstud2_sub1 <- file.path(pathstud2, "PISA_2006-E")
pathstud2_sub2 <- file.path(pathstud2, "PISA_2006-I")
for (this_dir in c(pathbase, studybase, pathstud1, pathstud2, pathstud2_sub1, pathstud2_sub2)) {
  if (!dir.exists(this_dir)) dir.create(this_dir)
}

##### files #####
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

##### control tables #####
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
multi_line_header <- c("This header", "looks", "WAAAAY", "cooler!")
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
multi_line_contbox <- c("IQB Trends in Student Achievement 2021", "PISA 2006")
if (!file.exists(template_contbox)) {
  this_template <- data.frame(contbox_de = c(single_line_contbox, ""),
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
  empty_path <- file.path(pathstud1, "empty")
  deeper_empty_path <- file.path(empty_path, "emptier", "emptiest")
  dir.create(deeper_empty_path, recursive = TRUE)
  expect_error(createReadMe(empty_path, create_table = "overview"),
               "^There are no")
  expect_error(createReadMe(deeper_empty_path, create_table = "overview"),
               "^There are no")
  unlink(empty_path, recursive = TRUE)

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
                 1, rep(2, length(filesstud2_sub1) + length(filesstud2_sub2) + 2)))
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
                 0, rep(1, length(filesstud2_sub1) + length(filesstud2_sub2) + 2)))
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

test_that("Directory mode describes files correctly", {
  ### overview table ###
  # dont skip base
  study_overview_noskip <- createReadMe(studybase, create_table = "overview")
  expect_equal(sum(grepl(x = study_overview_noskip$description_de, pattern = "^Datensatz")),
               9)
  # skip base
  study_overview_skip <- createReadMe(studybase, create_table = "overview", skip_empty_base = TRUE)
  expect_equal(sum(grepl(x = study_overview_skip$description_de, pattern = "^Datensatz")),
               9)

  ### control table ###
  # dont skip base
  study_control_noskip <- createReadMe(studybase, create_table = "control")
  expect_equal(sum(grepl(x = study_control_noskip[[1]]$description_en, pattern = "^Dataset")),
               2)
  expect_equal(sum(grepl(x = study_control_noskip[[2]]$description_en, pattern = "^Dataset")),
               7)
  # skip base
  study_control_skip <- createReadMe(studybase, create_table = "control", skip_empty_base = TRUE)
  expect_equal(sum(grepl(x = study_control_skip[[1]]$description_en, pattern = "^Dataset")),
               2)
  expect_equal(sum(grepl(x = study_control_skip[[2]]$description_en, pattern = "^Dataset")),
               7)

  ### ReadMe text ###
  # dont skip base
  study_text_noskip <- createReadMe(studybase, create_table = "text")
  expect_equal(sum(grepl(x = study_text_noskip$de, pattern = "- Datensatz in")), 9)
  expect_equal(sum(grepl(x = study_text_noskip$en, pattern = "- Dataset in")), 9)
  # skip base
  study_text_skip <- createReadMe(studybase, create_table = "text", skip_empty_base = TRUE)
  expect_equal(sum(grepl(x = study_text_skip$de, pattern = "- Datensatz in")), 9)
  expect_equal(sum(grepl(x = study_text_skip$en, pattern = "- Dataset in")), 9)
})

test_that("Directory mode sets depth and group correctly", {
  # dont skip base
  study_overview_noskip <- createReadMe(studybase, create_table = "overview")
  expect_equal(study_overview_noskip$depth,
               c(0, rep(1, length(filesstud1) + 1),
                 1, rep(2, length(filesstud2_sub1) + length(filesstud2_sub2) + 2)))
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
  expect_equal(study_overview_skip$depth,
               c(rep(0, length(filesstud1) + 1),
                 0, rep(1, length(filesstud2_sub1) + length(filesstud2_sub2) + 2)))
  expect_identical(study_overview_skip$group,
                   c(rep(basename(pathstud1), length(filesstud1) + 1),
                     basename(pathstud2),
                     rep(file.path(basename(pathstud2), basename(pathstud2_sub1)),
                         length(filesstud2_sub1) + 1),
                     rep(file.path(basename(pathstud2), basename(pathstud2_sub2)),
                         length(filesstud2_sub2) + 1)))
})

test_that("Directory mode flattens depth and issues the appropriate warning", {
  long_subdir_list <- c("this", "directory", "is", "way", "too", "deep",
                        "and", "should", "therefore", "really", "be", "flattened")
  very_deep_base <- file.path(pathbase, long_subdir_list[[1]])
  very_deep_dir <- pathbase
  for (subdir in long_subdir_list) {
    very_deep_dir <- file.path(very_deep_dir, subdir)
    dir.create(very_deep_dir)
    file.create(file.path(very_deep_dir, "any_file.txt"))
  }

  expect_warning(overview_deep_noflat <- createReadMe(very_deep_base, create_table = "overview"),
                 regexp = "^This directory has")
  expect_identical(overview_deep_noflat$depth[[24]], 11)

  expect_no_warning(overview_deep_flat_high <- createReadMe(very_deep_base,
                                                            create_table = "overview",
                                                            flat_depth = 15))
  expect_identical(overview_deep_noflat, overview_deep_flat_high)

  expect_no_warning(overview_deep_flat_low <- createReadMe(very_deep_base,
                                                           create_table = "overview",
                                                           flat_depth = 3))
  expect_equal(overview_deep_flat_low$depth,
               c(rep(0, 2), rep(1, 2), rep(2, 2), rep(3, 18)))

  unlink(very_deep_base, recursive = TRUE)
})

test_that("Directory mode sets flags correctly", {
  # dont skip base
  study_control_noskip <- createReadMe(studybase, create_table = "control", lang = "en")
  expect_identical(study_control_noskip[[1]]$flag, c("header", "subheader/1", "", "", "", ""))
  expect_identical(study_control_noskip[[2]]$flag,
                   c("header", "subheader/2", "", "", "", "", "subheader/2", "", "", "", ""))

  # skip base
  study_control_skip <- createReadMe(studybase, create_table = "control", skip_empty_base = TRUE)
  expect_identical(study_control_skip[[1]]$flag, c("header", "", "", "", ""))
  expect_identical(study_control_skip[[2]]$flag,
                   c("header", "subheader/1", "", "", "", "", "subheader/1", "", "", "", ""))
})

test_that("Table mode creates ReadMe file successfully", {
  rmfile_onelang <- file.path(pathbase, "ReadMe_IQB-BT_2021.txt")
  rmfile_de <- file.path(pathbase, "ReadMe_IQB-BT_2021_de.txt")
  rmfile_en <- file.path(pathbase, "ReadMe_IQB-BT_2021_en.txt")

  expect_false(file.exists(rmfile_onelang))
  expect_false(file.exists(rmfile_de))
  expect_false(file.exists(rmfile_en))

  # one language
  expect_null(createReadMe(template_stud1, out_path = rmfile_onelang, sep = ",", lang = "de"))
  expect_true(file.exists(rmfile_onelang))
  file.remove(rmfile_onelang)

  # two languages
  expect_null(createReadMe(template_stud1, out_path = rmfile_onelang, sep = ","))
  expect_true(file.exists(rmfile_de))
  expect_true(file.exists(rmfile_en))
  file.remove(rmfile_de, rmfile_en)

  # from Excel file
  excel_name <- sub(x = template_stud1, pattern = "\\.csv$", replacement = ".xlsx")
  csv_content <- read.table(template_stud1, sep = ",", header = TRUE)
  openxlsx::write.xlsx(x = csv_content, file = excel_name)
  expect_null(createReadMe(excel_name, out_path = rmfile_onelang, sep = ",", lang = "de"))
  expect_true(file.exists(rmfile_onelang))
  file.remove(rmfile_onelang)
  file.remove(excel_name)
})

test_that("Table mode interprets flags correctly", {
  tab_overview_replace <- createReadMe(template_stud1, sep = ",", lang = "de",
                                       create_table = "overview")
  expect_equal(tab_overview_replace$depth,
               c(0, rep(0, length(filesstud1))))
  expect_identical(tab_overview_replace$group,
                   rep(file.path(basename(pathstud1)), length(filesstud1) + 1))
})


rmfile <- file.path(pathbase, "ReadMe_IQB-BT_2021.txt")
test_that("Basic ReadMe formatting (indentation, section header, recursive mention) is correct", {
  rmname_en <- sub(x = rmfile, pattern = "\\.txt", replacement = "_en.txt")
  rmname_de <- sub(x = rmfile, pattern = "\\.txt", replacement = "_de.txt")

  # table mode with ReadMe file mention
  createReadMe(template_stud1, out_path = rmfile, sep = ",")
  rmlines1_en <- readLines(rmname_en)
  rmlines1_de <- readLines(rmname_de)
  file.remove(rmname_en)
  file.remove(rmname_de)

  # directory mode without max_indent
  createReadMe(pathstud2, out_path = rmfile, sep = ",", lang = "en")
  rmlines2 <- readLines(rmfile)

  # directory mode with max_indent
  createReadMe(pathstud2, out_path = rmfile, sep = ",", lang = "de", max_indent = 2)
  rmlines3 <- readLines(rmfile)

  # table mode without ReadMe file mention
  createReadMe(template_stud1, out_path = rmfile, sep = ",", lang = "de", include_rm = FALSE)
  rmlines4 <- readLines(rmfile)

  # Section header
  expect_identical(rmlines1_en[[1]], "[ C O N T E N T S ]")
  expect_match(rmlines1_en[[2]], "^¯*$")
  expect_identical(nchar(rmlines1_en[[2]]), max(nchar(rmlines1_en)))

  # ReadMe file mention
  expect_match(rmlines1_en[[3]], paste0("^", basename(rmname_en), "[ \t]+- this file$"))
  expect_match(rmlines1_de[[3]], paste0("^", basename(rmname_de), "[ \t]+- diese Datei$"))
  expect_no_match(rmlines2, paste0("^", basename(rmfile), "[ \t]+- this file$"))
  expect_no_match(rmlines4, paste0("^", basename(rmfile), "[ \t]+- diese Datei$"))

  # specific lines
  expect_identical(rmlines1_en[1:6] == "", c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE))
    # 4th should be empty, but because of a workaround there are pointless blanks there
  expect_match(rmlines1_en[[7]], "^  IQB-BT_2021.+\\.sav[ \t]+- student data$")

  # indentation from table mode
  rmlines1_without_leading_spaces <- gsub(x = rmlines1_en, pattern = "^[[:blank:]]*",
                                          replacement = "")
  n_leading_spaces1 <- nchar(rmlines1_en) - nchar(rmlines1_without_leading_spaces)
  expect_equal(n_leading_spaces1[6:10], c(0, 2, 2, 2, 2))

  # indentation from directory mode without max_indent
  rmlines2_without_leading_spaces <- gsub(x = rmlines2, pattern = "^[[:blank:]]*", replacement = "")
  n_leading_spaces2 <- nchar(rmlines2) - nchar(rmlines2_without_leading_spaces)
  expect_equal(n_leading_spaces2[3:11], c(0, 2, 4, 4, 4, 4, 0, 2, 4))

  # indentation from directory mode with max_indent
  rmlines3_without_leading_spaces <- gsub(x = rmlines3, pattern = "^[[:blank:]]*", replacement = "")
  n_leading_spaces3 <- nchar(rmlines3) - nchar(rmlines3_without_leading_spaces)
  expect_equal(n_leading_spaces3[3:11], c(0, 2, 2, 2, 2, 2, 0, 2, 2))
})

test_that("Subsection headers are created correctly", {
  # header text in description (average case)
  createReadMe(template_stud1, out_path = rmfile, lang = "en", sep = ",")
  rmlines1 <- readLines(rmfile)
  expect_identical(rmlines1[[6]], "IQB Trends in Student Achievement 2021")

  # no header text in description (worse case)
  alternative_name <- sub(x = template_stud1, pattern = "\\.csv$", replacement = "_2.csv")
  csv_content <- read.table(template_stud1, sep = ",", header = TRUE)
  csv_content$description_de[[1]] <- ""
  write.table(x = csv_content,
              file = alternative_name,
              sep = ",",
              row.names = FALSE)
  createReadMe(alternative_name, out_path = rmfile, lang = "de", sep = ",")
  rmlines2 <- readLines(rmfile)
  expect_identical(rmlines2[[6]], csv_content$file_name[[1]])
  file.remove(alternative_name)
})

test_that("Default sections revert to English if requested language is not implemented", {
  french_descriptions <- c("IQB Tendances en matiere de Resultats Scolaires",
                           "donnees sur les eleves",
                           "donnees sur les enseignants avec un nom de fichier tres long",
                           "Nous remercions l'IA pour cette traduction",
                           "article exceptionnel sur les donnees")
  alternative_name <- sub(x = template_stud1, pattern = "\\.csv$", replacement = "_fr.csv")
  csv_content <- read.table(template_stud1, sep = ",", header = TRUE)
  csv_content$description_fr <- french_descriptions
  write.table(x = csv_content,
              file = alternative_name,
              sep = ",",
              row.names = FALSE)

  expect_warning(createReadMe(alternative_name, out_path = rmfile, sep = ",", lang = "fr"),
                 regexp = "^No default content.* Reverting to English\\.$")
  expect_warning(createReadMe(alternative_name, out_path = rmfile, sep = ",", lang = "fr"),
                 regexp = "^No default ReadMe.* Reverting to English\\.$")
  expect_warning(createReadMe(alternative_name, out_path = rmfile, sep = ",", lang = "fr",
                              remarks = "Ne me pose pas de questions en francais, s'il vous plait"),
                 regexp = "^No default remarks.* Reverting to English\\.$")
  expect_true(file.exists(rmfile))
  rmlines <- readLines(rmfile)
  expect_match(rmlines[[3]], paste0("^", basename(rmfile), "[ \t]+- this file$"))
  expect_identical(rmlines[[6]], french_descriptions[[1]])
  expect_identical(rmlines[[13]], "[ A D D I T I O N A L   R E M A R K S ]")
  file.remove(alternative_name)
})

test_that("Pattern replacement in file names works correctly", {
  # directory mode
  dir_overview_replace <- createReadMe(studybase, create_table = "overview",
                                       skip_empty_base = TRUE, replace_id = c("_Remote_Antrag",
                                                                              "_2608-05a"))
  expect_equal(sum(grepl(x = dir_overview_replace$file_name, pattern = "_Remote_Antrag")), 0)
  expect_equal(sum(grepl(x = dir_overview_replace$file_name, pattern = "_2608-05a")),
               length(list.files(studybase, pattern = "_Remote_Antrag", recursive = TRUE)))

  # table mode
  tab_overview_replace <- createReadMe(template_stud1, out_path = rmfile, sep = ",", lang = "de",
                                       create_table = "overview", replace_id = c("_Remote_Antrag",
                                                                                 "_2608-05a"))
  expect_equal(sum(grepl(x = tab_overview_replace$file_name, pattern = "_Remote_Antrag")), 0)
  expect_equal(sum(grepl(x = tab_overview_replace$file_name, pattern = "_2608-05a")),
               length(list.files(pathstud1, pattern = "_Remote_Antrag", recursive = TRUE)))
  rmlines <- readLines(rmfile)
  expect_equal(sum(grepl(x = rmlines, pattern = "_Remote_Antrag")), 0)
  expect_equal(sum(grepl(x = rmlines, pattern = "_2608-05a")),
               length(list.files(pathstud1, pattern = "_Remote_Antrag", recursive = TRUE)))
})

test_that("Formatting of the overall header is correct + an Excel table is accepted", {
  # one-line header
  createReadMe(template_stud1, out_path = rmfile, sep = ",", lang = "de", header = template_header)
  rmlines <- readLines(rmfile)
  expect_match(rmlines[[2]], "^¯*$")
  expect_identical(nchar(rmlines[[2]]), max(nchar(rmlines)))
  expect_match(rmlines[[3]], paste0("^[ \t]+", single_line_header, "[ \t]+$"))
  expect_identical(rmlines[[1]], rmlines[[4]])
  expect_identical(rmlines[[2]], rmlines[[5]])
  expect_identical(rmlines[[2]], rmlines[[9]])
  expect_identical(rmlines[1:8] == "", c(FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE))

  # very wide one-line header
  wide_header <- paste0("This is a w", paste0(rep("i", 150), collapse = ""), "de header")
  createReadMe(template_stud1, out_path = rmfile, sep = ",", lang = "de", header = wide_header)
  rmlines <- readLines(rmfile)
  expect_identical(rmlines[[3]], wide_header)

  # multi-line header
  createReadMe(template_stud1, out_path = rmfile, sep = ",", lang = "en", header = template_header)
  rmlines <- readLines(rmfile)
  expect_match(rmlines[[3]], paste0("^[ \t]+", multi_line_header[[1]], "[ \t]+$"))
  expect_match(rmlines[[6]], paste0("^[ \t]+", multi_line_header[[4]], "[ \t]+$"))
  expect_identical(rmlines[[1]], rmlines[[7]])
  expect_identical(rmlines[[2]], rmlines[[8]])


  # from Excel file
  excel_name <- sub(x = template_header, pattern = "\\.csv$", replacement = ".xlsx")
  csv_content <- read.table(template_header, sep = ",", header = TRUE)
  openxlsx::write.xlsx(x = csv_content, file = excel_name)
  expect_no_message(createReadMe(template_stud1, out_path = rmfile, sep = ",", lang = "en",
                                 header = excel_name))
  rmlines_excel <- readLines(rmfile)
  expect_identical(rmlines, rmlines_excel)
  file.remove(excel_name)
})

test_that("Formatting of the content box is correct", {
  # one-line box
  createReadMe(template_stud1, out_path = rmfile, sep = ",", lang = "de",
               content_box = template_contbox)
  rmlines <- readLines(rmfile)
  expect_identical(rmlines[[1]], paste0("\t", single_line_contbox))
  expect_match(rmlines[[3]], "^¯*$")
  expect_identical(nchar(rmlines[[3]]), max(nchar(rmlines)))
  expect_identical(rmlines[1:6] == "", c(FALSE, FALSE, FALSE, TRUE, TRUE, FALSE))

  # multi-line box
  createReadMe(template_stud1, out_path = rmfile, sep = ",", lang = "en",
               content_box = template_contbox)
  rmlines <- readLines(rmfile)
  expect_identical(rmlines[[1]], paste0("\t", multi_line_contbox[[1]]))
  expect_identical(rmlines[[2]], paste0("\t", multi_line_contbox[[2]]))
  expect_identical(rmlines[[4]], rmlines[[8]])
})

test_that("Formatting of the remarks section is correct", {
  createReadMe(template_stud1, out_path = rmfile, sep = ",", lang = "de",
               remarks = template_remarks)
  rmlines <- readLines(rmfile)
  expect_identical(rmlines[10:13] == "", c(FALSE, TRUE, TRUE, FALSE))
  expect_identical(rmlines[[13]], "[ H I N W E I S E ]")
  expect_match(rmlines[[14]], "^¯*$")
})

test_that("Formatting of the overall footer is correct", {
  # one-line footer
  createReadMe(template_stud1, out_path = rmfile, sep = ",", lang = "de", footer = template_footer)
  rmlines <- readLines(rmfile)
  expect_match(rmlines[[14]], "^¯*$")
  expect_identical(rmlines[[15]], single_line_footer)
  expect_identical(rmlines[10:16] == "", c(FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE))
  expect_identical(rmlines[[13]], rmlines[[16]])
  expect_identical(rmlines[[14]], rmlines[[17]])

  # multi-line footer
  createReadMe(template_stud1, out_path = rmfile, sep = ",", lang = "en", footer = template_footer)
  rmlines <- readLines(rmfile)
  expect_identical(rmlines[[15]], multi_line_footer[[1]])
  expect_identical(rmlines[[17]], multi_line_footer[[3]])
  expect_identical(rmlines[10:16] == "", c(FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE))
})
file.remove(rmfile)

# remove dummy directory to avoid warning from R CMD
unlink(studybase, recursive = TRUE)


#### Auxiliary ####
test_that("Bracing headers would work for the future", {
  rmlines <- createReadMe(template_stud1, sep = ",", lang = "de", create_table = "text")
  multi_line_header <- c("Multi-Line", "Subheaders", "Are the future")
  rmlines <- eatFDZ:::add_header(rmlines[[1]], multi_line_header, width = 50,
                                 brace = TRUE, where = "below")
  expect_match(rmlines[[8]], paste0("^\u250c[ \t]*", multi_line_header[[1]], "[ \t]*\u2510$"))
  expect_match(rmlines[[9]], paste0("^\u2502[ \t]*", multi_line_header[[2]], "[ \t]*\u2502$"))
  expect_match(rmlines[[10]], paste0("^\u2514[ \t]*", multi_line_header[[3]], "[ \t]*\u2518$"))
})

test_that("Filling with blanks works for columns of different lengths", {
  short_col <- c("hi", "bye")
  long_col <- c("The cake", "is", "a lie")
  short_first <- eatFDZ:::fill_with_blanks(short_col, long_col, width = 10)
  long_first <- eatFDZ:::fill_with_blanks(long_col, short_col, width = 10)
  expect_identical(length(short_first), length(long_first))
})
