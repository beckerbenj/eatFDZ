
# throws error in some systems...
#sav_path <- system.file("extdata", "LV_2011_CF.sav", package = "eatFDZ")

#g <- eatGADS::import_spss("tests/testthat/LV_2011_CF.sav")
suppressMessages(g <- eatGADS::import_spss("LV_2011_CF.sav"))

test_that("create_overview", {
  suppressMessages(g2 <- eatGADS::extractVars(g, vars = c("idstud_FDZ", "wgtSTUD", "Emigr")))
  out <- create_overview(g2, boundary = 5)

  expect_equal(out$existValLab, c(FALSE, FALSE, TRUE))
  expect_equal(out$existVarLab, c(TRUE, TRUE, TRUE))
})

test_that("FDZ data cleaning", {
  out_folder <- tempdir()
  #out_syntax <- data_clean(fileName = "tests/testthat/LV_2011_CF.sav", saveFolder = out_folder)
  out_mess <- capture_messages(out_syntax <- data_clean(fileName = "LV_2011_CF.sav", saveFolder = out_folder))

  expect_true(is.character(out_syntax))
  expect_equal(length(out_syntax), 119)
  expect_equal(out_mess[3], "6 numeric variables with category size <= 5 will be recoded anonymously.\n")
  expect_equal(out_mess[4], "Recode 1 non-numeric variables into numeric variables.\n")
})

test_that("Warnings and messages", {
  out_folder <- tempdir()
  suppressMessages(expect_warning(out_syntax <- data_clean(fileName = "LV_2011_CF.sav", saveFolder = out_folder, exclude = "some_var"),
                                  "Variables 'some_var' from the 'exclude' argument are not available in the data set and will be ignored."))
  suppressMessages(expect_warning(out_syntax <- data_clean(fileName = "LV_2011_CF.sav", saveFolder = file.path(tempdir(), paste0("folder_", sample(1:1e+3, size = 1)))),
                                  regexp = "^Specified folder."))
  out_mess <- capture_messages(out_liste <- data_clean(fileName = "LV_2011_CF.sav", saveFolder = out_folder, boundary = 0,
                                                        exclude = "Version_v2_09.01.2020"))
  expect_equal(out_mess[3], "No recoding necessary.\n")

})

test_that("Incorrect folder specification with trailing /", {
  out_folder <- tempdir()
  out_folder <- paste0(out_folder, "/")
  out_cat <- capture_output(suppressMessages(out_syntax <- data_clean(fileName = "LV_2011_CF.sav", saveFolder = out_folder)))

  expect_true(is.character(out_syntax))
  expect_equal(length(out_syntax), 119)
})
