
#dfSAV <- eatGADS::import_spss("helper_example_data2.sav")

test_that("Run all checks", {
  #outp <- capture_output(out <- check_all("tests/testthat/helper_example_data2.sav"))
  outp <- capture.output(out <- check_all("helper_example_data2.sav"))
  expect_equal(length(out), 12)
})
