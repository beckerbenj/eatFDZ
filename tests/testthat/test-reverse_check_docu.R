

test_that("One pdf, one .sav data set", {
  #out <- reverse_check_docu(sav_path = "helper_spss.sav",
  #                 pdf_path = "helper_codebook.pdf")
  expect_error(reverse_check_docu(), "Not yet implemented.")
  # expect_equal(...)
})
