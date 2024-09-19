test_that("download FDZ pisa 2018 student questionaire data", {
  old_timeout <- getOption("timeout")
  pisa2018 <- download_fdz(study = "PISA", year = "2018", data_type = "stud_quest")

  expect_equal(ncol(pisa2018$dat), 1008)
  expect_equal(nrow(pisa2018$dat), 0)
  expect_equal(old_timeout, getOption("timeout"))
})

test_that("download FDZ pisa 2015 student questionaire data", {
  old_timeout <- getOption("timeout")
  pisa2018 <- download_fdz(study = "PISA", year = "2015", data_type = "stud_quest")

  expect_equal(ncol(pisa2018$dat), 898)
  expect_equal(nrow(pisa2018$dat), 0)
  expect_equal(old_timeout, getOption("timeout"))
})

