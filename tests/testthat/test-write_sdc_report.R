test_that("write_sdc_report creates an Excel file.", {

  x <- list(
    Schueler = data.frame(
      variable = "IDSTUD",
      varLab = "Schueler-ID",
      existValLab = TRUE,
      skala = "nominal",
      nKl5 = 0
    ),
    Schule = data.frame(
      variable = "IDSCHOOL",
      varLab = "Schul-ID",
      existValLab = TRUE,
      skala = "nominal",
      nKl5 = 0
    )
  )

  file_path <- tempfile(fileext = ".xlsx")

  expect_invisible(
    write_sdc_report(
      x,
      file_path = file_path
    )
  )

  expect_true(file.exists(file_path))

  expect_silent(
    openxlsx2::wb_load(file_path)
  )
})

test_that("write_sdc_report requires a named list", {
  x <- list(
    data.frame(
      variable = "IDSTUD",
      varLab = "Schueler-ID")
  )
  file_path <- tempfile(fileext = ".xlsx")
  expect_error(
    write_sdc_report(
      x,
      file_path = file_path
    ),
    "'x' must be a named list.",
    fixed = TRUE
  )
  expect_false(file.exists(file_path))
})
