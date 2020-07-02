

sav_path <- system.file("extdata", "LV_2011_CF.sav", package = "eatFDZ")

test_that("FDZ data cleaning", {
  out_folder <- tempdir()
  out_cat <- capture_output(suppressMessages(out_syntax <- data_clean(fileName = sav_path, saveFolder = out_folder)))

  expect_true(is.character(out_syntax))
  expect_equal(length(out_syntax), 119)
  expect_equal(out_cat, "\n   6 numeric variables with category size <= 5 will be recoded anonymously.\n\n   Recode 1 non-numeric variables into numeric variables.")
})
