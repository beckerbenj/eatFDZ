

test_that("One pdf, one .sav data set", {
  #out <- reverse_check_docu(sav_path = "helper_spss.sav",
  #                 pdf_path = "helper_codebook.pdf")

  out <- reverse_check_docu(file.path("D:/R_projekte/_Github/eatFDZ/tests/testthat"), list(file.path("D:/R_projekte/_Github/eatFDZ/tests/testthat/helper_spss_p1.sav")), file.path("D:/R_projekte/_Github/eatFDZ/tests/testthat/helper_codebook_p1.pdf"))

  #expect_error(reverse_check_docu(), "Not yet implemented.")
   expect_equal(names(out) == c("venn_docu", "unique_tokens", "ext_corpus", "variables"))
})

test_that("One pdf, two .sav data set", {

  out <- reverse_check_docu(file.path("D:/R_projekte/_Github/eatFDZ/tests/testthat"), list(file.path("D:/R_projekte/_Github/eatFDZ/tests/testthat/helper_spss_p1.sav"), file.path("D:/R_projekte/_Github/eatFDZ/tests/testthat/helper_spss_p2.sav")), file.path("D:/R_projekte/_Github/eatFDZ/tests/testthat/helper_codebook_p1.pdf"))

  #expect_error(reverse_check_docu(), "Not yet implemented.")
  expect_equal(names(out) == c("venn_docu", "unique_tokens", "ext_corpus", "variables"))
})
