
# throws error in some systems...
#sav_path <- system.file("extdata", "LV_2011_CF.sav", package = "eatFDZ")

suppressMessages(g <- eatGADS::import_spss(test_path("LV_2011_CF.sav")))
suppressMessages(g2 <- eatGADS::import_spss(test_path("helper_example_data2.sav")))


test_that("create_overview", {
  out <- check_sdc(g, vars = c("idstud_FDZ", "wgtSTUD", "Emigr"), boundary = 5)

  expect_equal(out$variable, c("idstud_FDZ", "wgtSTUD"))
  expect_equal(out$existValLab, c(FALSE, FALSE))
  expect_equal(out$skala, c("numeric", "numeric"))
  expect_equal(out$nKatOhneMissings, c(3005, 3005))

  out2 <- check_sdc(g2, vars = c("sex", "äge", "home", "siblings"), boundary = 3)

  expect_equal(out2$existValLab, c(FALSE, TRUE, FALSE))
  expect_equal(out2$skala, c("numeric", "numeric", "numeric"))
  expect_equal(out2$nKatOhneMissings, c(4, 3, 6))
  expect_equal(out2$nValid, rep(12, 3))
  expect_equal(out2$values, c("15, 17", "-98, 2", "-9, 0, 2, 3, 35"))
})
