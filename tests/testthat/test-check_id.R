
dat <- data.frame(id = 1:3, var1 = 3:1)
dat2 <- data.frame(id = c(1, 1, 3), var1 = 3:1)
dat3 <- data.frame(var1 = 3:1, id = c(1, NA, 3))
dat4 <- data.frame(id = c(1, NA, 3, 1, NA, 4, 4), var1 = 1:7)

gads <- eatGADS::import_DF(dat)
gads2 <- eatGADS::import_DF(dat2)
gads3 <- eatGADS::import_DF(dat3)
gads4 <- eatGADS::import_DF(dat4)

test_that("Check identifier variable", {
  out <- check_id(gads)
  expect_equal(out$missing_ids, data.frame(Rows = numeric()))
  expect_equal(out$duplicate_ids, data.frame(IDs = numeric()))

  out2 <- check_id(gads2)
  expect_equal(out2$missing_ids, data.frame(Rows = numeric()))
  expect_equal(out2$duplicate_ids, data.frame(IDs = 1))

  out3 <- check_id(gads3, idVar = "id")
  expect_equal(out3$missing_ids, data.frame(Rows = 2))
  expect_equal(out3$duplicate_ids, data.frame(IDs = numeric()))

  out4 <- check_id(gads4)
  expect_equal(out4$missing_ids, data.frame(Rows = c(2, 5)))
  expect_equal(out4$duplicate_ids, data.frame(IDs = c(1, 4)))
})
