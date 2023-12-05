

test_that("Write check report", {
  outp <- capture.output(out <- check_all(test_path("helper_example_data2.sav")))
  f <- tempfile()
  write_check_report(out, file_path = "test.xlsx")
})
