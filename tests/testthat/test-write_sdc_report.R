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

  wb <- openxlsx2::wb_load(file_path)
  sheet_names <- unname(openxlsx2::wb_get_sheet_names(wb))

  expect_false("Template" %in% sheet_names)
  expect_setequal(sheet_names, names(x))
  expect_length(sheet_names, length(x))
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


test_that("write_sdc_report rejects duplicate worksheet names", {

  common_name <- paste(rep("a", 31L), collapse = "")

  x <- list(
    first = data.frame(variable = "ID1"),
    second = data.frame(variable = "ID2")
  )

  names(x) <- paste0(common_name, c("_1", "_2"))

  expect_error(
    write_sdc_report(
      x,
      file_path = tempfile(fileext = ".xlsx")
    ),
    "unique worksheet names"
  )
})
