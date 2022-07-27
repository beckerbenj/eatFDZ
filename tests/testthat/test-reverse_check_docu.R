

test_that("Errors", {
  #out <- reverse_check_docu(sav_path = list("tests/testthat/helper_spss_p1.sav"), pdf_path = "tests/testthat/helper_codebook_p1.pdf")
  expect_error(reverse_check_docu(white_list = 1, sav_path = list("helper_spss_p1.sav"), pdf_path = "helper_codebook_p1.pdf"),
               "'white_list' must be a character vector.")

})

test_that("One pdf, one .sav data set", {
  #out <- reverse_check_docu(sav_path = list("tests/testthat/helper_spss_p1.sav"), pdf_path = "tests/testthat/helper_codebook_p1.pdf")
  out <- reverse_check_docu(sav_path = "helper_spss_p1.sav",
                            pdf_path = "helper_codebook_p1.pdf")

  #cat("What happens after test 1?")
  expect_equal(names(out), c("suspicious_words", "missing_documention", "comment"))
  expect_equal(out[["suspicious_words"]], c("P1", "Var1", "ID-Variable"))
  #cat("What happens after test 1b?")
})

test_that("One pdf, two .sav data set", {
  #out <- reverse_check_docu(sav_path = list("tests/testthat/helper_spss_p1.sav", "tests/testthat/helper_spss_p2.sav"), pdf_path = "tests/testthat/helper_codebook_p1.pdf")
  out <- reverse_check_docu(sav_path = c("helper_spss_p1.sav", "helper_spss_p2.sav"),
                            pdf_path = "helper_codebook_p1.pdf")

  expect_equal(names(out), c("suspicious_words", "missing_documention", "comment"))
  expect_equal(out[["suspicious_words"]], c("P1", "ID-Variable"))
})


test_that("separated german words", {
  #out <- reverse_check_docu(sav_path = list("tests/testthat/helper_spss_p1.sav", "tests/testthat/helper_spss_p2.sav"), pdf_path = "tests/testthat/helper_codebook_p3.pdf")
  out <- reverse_check_docu(sav_path = c("helper_spss_p1.sav", "helper_spss_p2.sav"),
                            pdf_path = "helper_codebook_p3.pdf")

  #cat("What happens after the test?")
  expect_equal(names(out), c("suspicious_words", "missing_documention", "comment"))
  expect_equal(out[["suspicious_words"]], c("ID-Variable"))
})


test_that("Multiple pdfs, multiple data sets", {
  #out <- reverse_check_docu(sav_path = list("tests/testthat/helper_spss_p1.sav", "tests/testthat/helper_spss_p2.sav"), pdf_path = "tests/testthat/helper_codebook_p1.pdf")
  out <- reverse_check_docu(sav_path = c("helper_spss_p1.sav", "helper_spss_p2.sav"),
                            pdf_path = c("helper_codebook_p1.pdf", "helper_codebook_p2.pdf", "helper_codebook_p3.pdf"))

  expect_equal(names(out), c("suspicious_words", "missing_documention", "comment"))
  expect_equal(out[["suspicious_words"]], c("P1", "ID-Variable"))
})
