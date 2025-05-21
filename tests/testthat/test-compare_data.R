
data1 <- eatGADS::import_spss(test_path("helper_compare_dataset1.sav"))
data2 <- eatGADS::import_spss(test_path("helper_compare_dataset2.sav"))


test_that("Compare different data", {
  out <- compare_data(data1 = data1, data2 = data2, name_data1 = "FDZ", name_data2 = "OECD")
  expect_equal(length(out), 4)
  expect_equal(names(out), c("not_in_FDZ_data", "not_in_OECD_data",
                             "differences_variable_level", "differences_value_level"))
  expect_equal(out$not_in_FDZ_data$varName, c("var2", "var4"))
  expect_equal(out$not_in_OECD_data$varName, c("var3"))
  expect_equal(out$differences_variable_level$varName, c("var1"))
  expect_equal(names(out$differences_variable_level), c("varName", "varLabel_FDZ", "SPSS_format_FDZ",
                                                         "varLabel_OECD", "SPSS_format_OECD"))
  expect_equal(out$differences_value_level$value, c(-99, 2, 3))
  expect_equal(names(out$differences_value_level), c("varName", "value",
                                                      "valLabel_FDZ", "missingTag_FDZ",
                                                      "valLabel_OECD", "missingTag_OECD"))
})

test_that("Compare identical data", {
  outp <- compare_data(data1 = data1, data2 = data1, name_data1 = "dataset1", name_data2 = "dataset2")
  expect_equal(length(outp), 4)
})

test_that("Compare data with only variable level differences", {
  data1b <- eatGADS::changeVarLabels(data1, "var1", varLabel = "Var 1")
  outp <- compare_data(data1 = data1, data2 = data1b, name_data1 = "dataset1", name_data2 = "dataset2")
  expect_equal(length(outp), 4)
  expect_equal(nrow(outp$differences_variable_level), 1)
})

test_that("Compare data with only value level differences", {
  data1b <- eatGADS::changeValLabels(data1, "var1", value = 1, valLabel = "value 1b")
  outp <- compare_data(data1 = data1, data2 = data1b, name_data1 = "dataset1", name_data2 = "dataset2")
  expect_equal(length(outp), 4)
  expect_equal(nrow(outp$differences_value_level), 1)
})

test_that("Compare data with a combination of different variable level differences", {
  data1b <- eatGADS::changeVarLabels(data1, c("var1", "var3"), varLabel = c("Var 1", "Var 3"))
  data1b <- eatGADS::changeSPSSformat(data1b, c("var1"), format = c("F7.2"))
  outp <- compare_data(data1 = data1, data2 = data1b, name_data1 = "dataset1", name_data2 = "dataset2")

  expect_equal(length(outp), 4)
  expect_equal(nrow(outp$differences_variable_level), 2)
})
