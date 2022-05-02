

test_that("One pdf, one .sav data set", {
  #out <- reverse_check_docu(sav_path = "helper_spss.sav",
  #                 pdf_path = "helper_codebook.pdf")

  out <- reverse_check_docu(corpuspath = getwd(),
                            sav_path_list = list("helper_spss_p1.sav"),
                            pdf_path = "helper_codebook_p1.pdf")

  #expect_error(reverse_check_docu(), "Not yet implemented.")
   expect_equal(names(out), c("venn_docu", "unique_tokens", "ext_corpus", "variables"))
})

test_that("One pdf, two .sav data set", {
  out <- reverse_check_docu(corpuspath = getwd(),
                            sav_path_list = list("helper_spss_p1.sav", "helper_spss_p2.sav"),
                            pdf_path = "helper_codebook_p1.pdf")

  #expect_error(reverse_check_docu(), "Not yet implemented.")
  expect_equal(names(out), c("venn_docu", "unique_tokens", "ext_corpus", "variables"))
})
