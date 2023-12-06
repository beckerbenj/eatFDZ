

test_that("Write check report", {
  outp <- capture.output(out <- check_all(test_path("helper_example_data2.sav")))
  f <- tempfile(fileext = ".xlsx")
  write_check_report(out, file_path = f)

  overview <- openxlsx::read.xlsx(f, sheet = "Overview")
  expect_equal(overview$Handlungsbedarf[1], "Keine weitere Bearbeitung noetig.")
  expect_equal(overview$Handlungsbedarf[2:11], rep("Details siehe entsprechender Reiter", 10))

  sheet_names <- openxlsx::getSheetNames(f)
  expect_equal(sheet_names[1:2], c("Overview", "special_signs_variable_names"))
})
