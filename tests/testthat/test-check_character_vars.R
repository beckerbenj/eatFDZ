

dat <- data.frame(var1 = 1, var2 = factor("a"), var3 = "a")
gads <- eatGADS::import_DF(dat)

dat1 <- data.frame(var1 = 1, var2 = factor("a"), var3 = 3)
gads1 <- eatGADS::import_DF(dat1)

dat2 <- data.frame(var1 = "1", var2 = factor("a"), var3 = "a")
gads2 <- eatGADS::import_DF(dat2)


test_that("Check character variables", {
  out <- check_character_vars(gads)
  expect_equal(out, data.frame(varName = "var3", nUniqueValues = 1L))

  out1 <- check_character_vars(gads1)
  expect_equal(out1, data.frame(varName = character(), nUniqueValues = integer()))

  out2 <- check_character_vars(gads2)
  expect_equal(out2, data.frame(varName = c("var1", "var3"),
                                nUniqueValues = c(1, 1)))
})
