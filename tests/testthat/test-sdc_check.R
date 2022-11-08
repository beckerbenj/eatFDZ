
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

test_that("FDZ sdc check", {
  out_folder <- tempdir()
  #out_df <- sdc_check(fileName = "tests/testthat/LV_2011_CF.sav")
  out_mess <- capture_messages(out_df <- sdc_check(fileName = "LV_2011_CF.sav"))

  expect_true(is.data.frame(out_df))
  expect_equal(nrow(out_df), 55)
  ## tbd inhaltliche Tests
})

test_that("Warnings and messages", {
  out_folder <- tempdir()
  suppressMessages(expect_warning(out_syntax <- sdc_check(fileName = "LV_2011_CF.sav", exclude = "some_var"),
                                  "Variables 'some_var' from the 'exclude' argument are not available in the data set and will be ignored."))
})

