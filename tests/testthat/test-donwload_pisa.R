
test_that("Errors", {
  expect_error(download_pisa(year = "2000", data_type = "stud_quest"),
              "The corresponding download has not been implemented yet.")
})


test_that("download pisa 2018 student questionaire data", {

  skip_if_not(isTRUE(as.logical(Sys.getenv("CI", "false"))))

  old_timeout <- getOption("timeout")
  pisa2018 <- download_pisa(year = "2018", data_type = "stud_quest")

  expect_equal(ncol(pisa2018$dat), 1119)
  expect_equal(nrow(pisa2018$dat), 1)
  expect_equal(old_timeout, getOption("timeout"))
})

test_that("download pisa 2015 student questionaire data", {

  skip_if_not(isTRUE(as.logical(Sys.getenv("CI", "false"))))

  old_timeout <- getOption("timeout")
  pisa2015 <- download_pisa(year = "2015", data_type = "stud_quest")

  expect_equal(ncol(pisa2015$dat), 921)
  expect_equal(nrow(pisa2015$dat), 1)
  expect_equal(old_timeout, getOption("timeout"))
})


