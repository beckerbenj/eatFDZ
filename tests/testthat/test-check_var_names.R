
dat <- dat2 <- data.frame(1, 1, 1, 1)
names(dat) <- c("var1", "var2", "var3", "var4")
names(dat2) <- c("var1", "var.2", "var\U00DF", "var4")
gads <- eatGADS::import_DF(dat)
gads2 <- eatGADS::import_DF(dat2, checkVarNames = FALSE)

test_that("Check varNames", {
  out <- check_var_names(gads)
  expect_equal(out, data.frame(varName = character()))

  out2 <- check_var_names(gads2)
  expect_equal(out2, data.frame(varName = c("var.2", "var\U00DF")))
})
