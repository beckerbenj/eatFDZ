

nam1 <- "c:/user/test1.sav"
nam2 <- "c:/user/test 1.sav"
nam3 <- "c:/user/te\U00DFt1.sav"
nam4 <- "c:/u\U00DFer/tet1.sav"

test_that("Check file name", {
  expect_silent(check_file_name(nam1))
  expect_silent(check_file_name(nam4))
  expect_error(check_file_name(nam2),
               "File name contains special characters or spaces.")
  expect_error(check_file_name(nam3),
               "File name contains special characters or spaces.")
})
