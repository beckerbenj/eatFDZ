

#out <- check_docu(sav_path = "tests/testthat/helper_spss.sav", pdf_path = "tests/testthat/helper_codebook.pdf")

test_that("One pdf, one .sav data set", {
  out <- check_docu(sav_path = "helper_spss.sav",
             pdf_path = "helper_codebook.pdf")
  expect_equal(names(out), c("variable", "count", "post", "data_set"))
  expect_equal(out[out$variable == "ID", "count"], 1)
  expect_equal(out[2, "count"], 2)
  expect_equal(out[out$variable == "Var3", "count"], 0)

  expect_equal(out[out$variable == "ID", "post"], "ID-Variable Var1")
  expect_equal(out$data_set[1], "helper_spss.sav")
  expect_equal(length(unique(out$data_set)), 1)
})


### write separate data.frames as .sav for testing
#df1 <- data.frame(Var2 = 1, ID = 1)
#haven::write_sav(df1, "tests/testthat/helper_spss_p1.sav")
#df2 <- data.frame(Var1 = 1, ID = 1, Var3 = 4)
#haven::write_sav(df2, "tests/testthat/helper_spss_p2.sav")
#haven::read_sav("tests/testthat/helper_spss_p2.sav")


#out <- check_docu(sav_path = c("tests/testthat/helper_spss_p1.sav", "tests/testthat/helper_spss_p2.sav"), pdf_path = "tests/testthat/helper_codebook.pdf")

test_that("One pdf, mulitple .sav data set", {
  out <- check_docu(sav_path = c("helper_spss_p1.sav", "helper_spss_p2.sav"),
                    pdf_path = "helper_codebook.pdf")
  expect_equal(names(out), c("variable", "count", "post", "data_set"))
  expect_equal(out[out$variable == "ID", "count"], c(1, 1))
  expect_equal(out[3, "count"], 2)
  expect_equal(out[out$variable == "Var3", "count"], 0)

  expect_equal(out[out$variable == "ID", "post"][1], "ID-Variable Var1")
  expect_equal(out$data_set[1], "helper_spss_p1.sav")
  expect_equal(out$data_set[3], "helper_spss_p2.sav")
  expect_equal(out$post[6], NA_character_)
  expect_equal(out$count[6], 0)
})

#out <- check_docu(sav_path = c("tests/testthat/helper_spss.sav"), pdf_path = c("tests/testthat/helper_codebook_p1.pdf", "tests/testthat/helper_codebook_p2.pdf"))

test_that("Multiple pdf, one .sav data set", {
  out <- check_docu(sav_path = c("helper_spss.sav"),
                    pdf_path = c("helper_codebook_p1.pdf", "helper_codebook_p2.pdf"))
  expect_equal(names(out), c("variable", "count", "post", "data_set"))
  expect_equal(out[out$variable == "ID", "count"], 1)
  expect_equal(out[2, "count"], 3)
  expect_equal(out[out$variable == "Var3", "count"], 0)

  expect_equal(out[out$variable == "ID", "post"], "ID-Variable Var1")
  expect_equal(out$data_set[1], "helper_spss.sav")
  expect_equal(length(unique(out$data_set)), 1)
})


### write new sav for testing
#df_case <- data.frame(VAR2 = 1, id = 1, Var1 = 1, Var3 = 4)
#haven::write_sav(df_case, "tests/testthat/helper_spss_uplowcase.sav")

# out <- check_docu(sav_path = c("tests/testthat/helper_spss_uplowcase.sav"), pdf_path = c("tests/testthat/helper_codebook.pdf"))
test_that("Upper and lower case insensitive", {
  out <- check_docu(sav_path = c("helper_spss_uplowcase.sav"),
                    pdf_path = c("helper_codebook.pdf"))
  expect_equal(out[out$variable == "id", "count"], 1)
  expect_equal(out[3, "count"], 2)
  expect_equal(out[out$variable == "Var3", "count"], 0)

  expect_equal(out[out$variable == "id", "post"], "ID-Variable Var1")
  expect_equal(out$data_set[1], "helper_spss_uplowcase.sav")
  expect_equal(length(unique(out$data_set)), 1)
})

# out <- check_docu(sav_path = c("tests/testthat/helper_spss_uplowcase.sav"), pdf_path = c("tests/testthat/helper_codebook.pdf"), case_sensitive = TRUE)
test_that("Upper and lower case sensitive", {
  out <- check_docu(sav_path = c("helper_spss_uplowcase.sav"),
                    pdf_path = c("helper_codebook.pdf"), case_sensitive = TRUE)
  expect_equal(out[out$variable == "id", "count"], 0)
  expect_equal(out[out$variable == "VAR2", "count"], 0)
  expect_equal(out[out$variable == "Var3", "count"], 0)
  expect_equal(out[out$variable == "Var1", "count"][1], 2)

  expect_equal(out$data_set[1], "helper_spss_uplowcase.sav")
})


test_that("Rbind with name column", {
  l <- lapply(1:3, function(x) data.frame(v1 = x))
  out <- do_call_rbind_withName(l, name = c("one", "two", "three"), colName = "df")

  expect_equal(out$v1, 1:3)
  expect_equal(out$df, c("one", "two", "three"))
})





