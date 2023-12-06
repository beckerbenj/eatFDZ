dat <- data.frame(var1 = 1:5, var2 = c(1, -89, -99, -90, 9))
gads <- eatGADS::import_DF(dat)

gads2 <- eatGADS::changeValLabels(gads, varName = "var2",
                                  value = c(-89, -99, -90, 9),
                                  valLabel = c("missing", "omitted", "not reached", "not seen"))
gads3 <- eatGADS::changeValLabels(gads, varName = "var2",
                                  value = c(-89, -90, 9),
                                  valLabel = c("missing", "not reached", "not seen"))
gads4 <- eatGADS::changeValLabels(gads, varName = "var2",
                                  value = c(-89, -90, 9),
                                  valLabel = c("missing", "not reached", "not seen"))
gads4 <- eatGADS::changeMissings(gads4, varName = "var2", value = -90, missings = "miss")

test_that("Check missing range", {
  out <- check_missing_regex(gads)
  expect_equal(out, data.frame(varName = character(), value = numeric(),
                               valLabel = character(), missings = character()))

  out2 <- check_missing_regex(gads2)
  expect_equal(out2, data.frame(varName = rep("var2", 3), value = c(-99, -90, -89),
                                valLabel = c("omitted", "not reached", "missing"),
                                missings = rep("valid", 3)))

  out2b <- check_missing_regex(gads2, missingRegex = c("miss|not seen"))
  expect_equal(out2b, data.frame(varName = rep("var2", 2), value = c(-89, 9),
                                 valLabel = c("missing", "not seen"),
                                 missings = rep("valid", 2)))

  out3 <- check_missing_regex(gads3)
  expect_equal(out3, data.frame(varName = rep("var2", 2), value = c(-90, -89),
                                valLabel = c("not reached", "missing"),
                                missings = rep("valid", 2)))

  out4 <- check_missing_regex(gads4)
  expect_equal(out4, data.frame(varName = rep("var2", 1), value = c(-89),
                                valLabel = c("missing"),
                                missings = rep("valid", 1)))
})
