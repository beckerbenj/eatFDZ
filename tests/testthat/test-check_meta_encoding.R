
dat <- data.frame(var1 = 1, var2 = 1, var3 = 1)
gads2 <- gads <- eatGADS::import_DF(dat)

gads2 <- eatGADS::changeVarLabels(gads2, varName = "var2", varLabel = c("Te\U00DFt"))
gads2 <- eatGADS::changeValLabels(gads2, varName = "var3", value = 1, valLabel = "T\U00E4st")


test_that("Check meta data", {
  out <- check_meta_encoding(gads)
  expect_equal(out, data.frame(varName = character()))

  out2 <- check_meta_encoding(gads2)
  expect_equal(out2, data.frame(varName = c("var2", "var3")))
})
