

#out <- check_docu_excel(sav_path = c("tests/testthat/helper_spss_p1.sav", "tests/testthat/helper_spss_p2.sav"), excel_path = "tests/testthat/helper_codebook_p1.xlsx")

test_that("One excel, mulitple .sav data set", {
  out <- check_docu_excel(sav_path = c("helper_spss_p1.sav", "helper_spss_p2.sav"),
                    excel_path = "helper_codebook_p1.xlsx")
  expect_equal(names(out), c("variable", "count", "data_set"))
  expect_equal(out[out$variable == "ID", "count"], c(2, 2))
  expect_equal(out[out$variable == "Var3", "count"], 0)

  expect_equal(out$data_set[1], "helper_spss_p1.sav")
  expect_equal(out$data_set[3], "helper_spss_p2.sav")
  expect_equal(out$count[5], 0)
})

#out <- check_docu_excel(sav_path = c("tests/testthat/helper_spss.sav"), excel_path = c("tests/testthat/helper_codebook_p1.xlsx", "tests/testthat/helper_codebook_p3.xlsx"))

test_that("Multiple pdf, one .sav data set", {
  out <- check_docu_excel(sav_path = c("helper_spss.sav"),
                    excel_path = c("helper_codebook_p1.xlsx", "helper_codebook_p3.xlsx"))
  expect_equal(names(out), c("variable", "count", "data_set"))
  expect_equal(out[out$variable == "ID", "count"], 4)
  expect_equal(out[2, "count"], 1)
  expect_equal(out[out$variable == "Var3", "count"], 2)

  expect_equal(out$data_set[1], "helper_spss.sav")
  expect_equal(length(unique(out$data_set)), 1)
})

test_that("case sensitivity", {
  out <- check_docu_excel(sav_path = c("helper_spss.sav"),
                          excel_path = c("helper_codebook_p1.xlsx", "helper_codebook_p3.xlsx"),
                          case_sensitive = TRUE)
  expect_equal(out[out$variable == "Var3", "count"], 1)
})






