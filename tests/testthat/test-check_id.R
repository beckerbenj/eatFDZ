
dat <- data.frame(id = 1:3, var1 = 3:1)
dat2 <- data.frame(id = c(1, 1, 3), var1 = 3:1)
dat3 <- data.frame(var1 = 3:1, id = c(1, NA, 3))
dat4 <- data.frame(id = c(1, NA, 3, 1, NA, 4, 4), var1 = 1:7)
dat5 <- data.frame(id = c(1, 1, 1, 2, 2, 2),
                   imp = c(1, 2, 3, 1, 2, 3), var1 = 1:6)
dat6 <- data.frame(id = c(1, 1, 1, 2, 2, NA),
                   imp = c(1, NA, 3, 1, 2, 3), var1 = 1:6)
dat7 <- data.frame(id = c(1, 1, 1, 2, 2, 2, 2),
                   imp = c(1, 2, 3, 1, 2, 3, 2), var1 = 1:7)


gads <- eatGADS::import_DF(dat)
gads2 <- eatGADS::import_DF(dat2)
gads3 <- eatGADS::import_DF(dat3)
gads4 <- eatGADS::import_DF(dat4)
gads5 <- eatGADS::import_DF(dat5)
gads6 <- eatGADS::import_DF(dat6)
gads7 <- eatGADS::import_DF(dat7)

test_that("Check identifier variable", {
  out <- check_id(gads)
  expect_equal(out$missing_ids, data.frame(Rows = numeric()))
  expect_equal(out$duplicate_ids, data.frame(id = numeric()))

  out2 <- check_id(gads2)
  rownames(out2$duplicate_ids) <- NULL
  expect_equal(out2$missing_ids, data.frame(Rows = numeric()))
  expect_equal(out2$duplicate_ids, data.frame(id = 1))

  out3 <- check_id(gads3, idVar = "id")
  expect_equal(out3$missing_ids, data.frame(Rows = 2))
  expect_equal(out3$duplicate_ids, data.frame(id = numeric()))

  out4 <- check_id(gads4)
  rownames(out4$duplicate_ids) <- NULL
  expect_equal(out4$missing_ids, data.frame(Rows = c(2, 5)))
  expect_equal(out4$duplicate_ids, data.frame(id = c(1, 4)))
})

test_that("Check combination of identifier variables", {
  out5 <- check_id(gads5, idVar = c("id", "imp"))
  expect_equal(out5$missing_ids, data.frame(Rows = numeric()))
  expect_equal(out5$duplicate_ids, data.frame(id = numeric(), imp = numeric()))

  out6 <- check_id(gads6, idVar = c("id", "imp"))
  expect_equal(out6$missing_ids, data.frame(Rows = c(2, 6)))
  expect_equal(out6$duplicate_ids, data.frame(id = numeric(), imp = numeric()))

  out7 <- check_id(gads7, idVar = c("id", "imp"))
  rownames(out7$duplicate_ids) <- NULL
  expect_equal(out7$missing_ids, data.frame(Rows = numeric()))
  expect_equal(out7$duplicate_ids, data.frame(id = 2, imp = 2))
})
