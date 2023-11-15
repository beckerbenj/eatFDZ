
dat <- data.frame(1, 1, 1, 1)
names(dat) <- c("var1111", "var111", "var11", "var1")
gads <- eatGADS::import_DF(dat)

test_that("Check varNames", {
  out <- check_var_names_length(gads, boundary = 10)
  expect_equal(out, data.frame(varName = character(), nChars = numeric()))

  out2 <- check_var_names_length(gads, boundary = 5)
  expect_equal(out2, data.frame(varName = c("var1111", "var111"),
                                nChars = c(7, 6)))
})
