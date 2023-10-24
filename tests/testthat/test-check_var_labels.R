
dat <- data.frame(var1 = 1, var2 = 1)
gads <- eatGADS::import_DF(dat)

gads2 <- eatGADS::changeVarLabels(gads, varName = "var1", varLabel = c("a descriptive label"))
gads3 <- eatGADS::changeVarLabels(gads2, varName = "var2", varLabel = c("a descriptive label"))

test_that("Check variable labels", {
  out <- check_var_labels(gads3)
  expect_equal(out, data.frame(varName = character()))

  out2 <- check_var_labels(gads2)
  expect_equal(out2, data.frame(varName = c("var2")))

  out3 <- check_var_labels(gads)
  expect_equal(out3, data.frame(varName = c("var1", "var2")))
})
