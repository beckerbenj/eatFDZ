

#out <- check_docu(sav_path = "C:/Benjamin_Becker/02_Repositories/packages/eatFDZ/tests/testthat/helper_spss.sav", pdf_path = "C:/Benjamin_Becker/02_Repositories/packages/eatFDZ/tests/testthat/helper_codebook.pdf")

test_that("multiplication works", {
  out <- check_docu(sav_path = "helper_spss.sav",
             pdf_path = "helper_codebook.pdf")
  expect_equal(names(out), c("variable", "count", "post"))
  expect_equal(out[out$variable == "ID", "count"], 1)
  expect_equal(out[2, "count"], 2)
  expect_equal(out[out$variable == "Var3", "count"], 0)

  expect_equal(out[out$variable == "ID", "post"], "ID-Variable Var1")
})
