
data1 <- eatGADS::import_spss(test_path("helper_compare_dataset1.sav"))
data2 <- eatGADS::import_spss(test_path("helper_compare_dataset2.sav"))


test_that("Compare different data", {
  out <- compare_data(data1 = data1, data2 = data2, name_data1 = "FDZ", name_data2 = "OECD", ID_var = "ID_var")
  expect_equal(length(out), 4)
  expect_equal(names(out), c("not_in_FDZ_data", "not_in_OECD_data",
                             "differences_variable_labels", "differences_value_labels"))
  expect_equal(out$not_in_FDZ_data$varName, c("var2", "var4"))
  expect_equal(out$not_in_OECD_data$varName, c("var3"))
  expect_equal(out$differences_variable_labels$varName, c("var1"))
  expect_equal(names(out$differences_variable_labels), c("varName", "varLabel_FDZ", "SPSS_format_FDZ",
                                                         "varLabel_OECD", "SPSS_format_OECD"))
  expect_equal(out$differences_value_labels$value, c(-99, 2, 3))
  expect_equal(names(out$differences_value_labels), c("varName", "value",
                                                      "valLabel_FDZ", "missingTag_FDZ",
                                                      "valLabel_OECD", "missingTag_OECD"))
})

test_that("Compare identical data", {
  outp <- compare_data(data1 = data1, data2 = data1, name_data1 = "dataset1", name_data2 = "dataset2", ID_var = "ID_var")
  expect_equal(length(outp), 4)
})
