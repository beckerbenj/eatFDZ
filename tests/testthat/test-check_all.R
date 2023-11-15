
#dfSAV <- eatGADS::import_spss("helper_example_data2.sav")

test_that("Run all checks", {
  outp <- capture.output(out <- check_all(test_path("helper_example_data2.sav")))
  expect_equal(length(out), 11)
})
