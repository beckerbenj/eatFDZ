


test_that("download pisa 2018 student questionaire data", {

  skip_if_not(isTRUE(as.logical(Sys.getenv("CI", "false"))))

  old_timeout <- getOption("timeout")
  pisa2018 <- download_pisa(year = "2018", data_type = "stud_quest")

  expect_equal(ncol(pisa2018), 1119)
  expect_equal(nrow(pisa2018), 1)
  expect_equal(old_timeout, getOption("timeout"))
})


