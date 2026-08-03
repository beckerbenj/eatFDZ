write_test_sav <- function(data) {
  path <- tempfile(fileext = ".sav")
  gads <- eatGADS::import_DF(
    data,
    checkVarNames = FALSE)
  eatGADS::write_spss(gads, path)
  path
} # schreibt kl. kuenstlichen Datensatz in temporaere SPSS-Datei

with_test_pdf <- function(code) {
  path <- tempfile(fileext = ".pdf")
  grDevices::pdf(path)
  on.exit(grDevices::dev.off(), add = TRUE)
  force(code)
} # fuer Plot-Test

test_that("sav_paths must have complete names", {
  paths <- c("first.sav", "second.sav")
  expect_error(
    check_id_overlap(
      paths,
      id_vars = "ID",
      plot = FALSE
    ),
    "'sav_paths' must be a named vector.",
    fixed = TRUE
  )

  names(paths) <- c("", "second")
  expect_error(
    check_id_overlap(
      paths,
      id_vars = "ID",
      plot = FALSE
    ),
    "'sav_paths' must be a named vector.",
    fixed = TRUE
  )

  names(paths) <- c(NA_character_, "second")
  expect_error(
    check_id_overlap(
      paths,
      id_vars = "ID",
      plot = FALSE
    ),
    "'sav_paths' must be a named vector.",
    fixed = TRUE
  )
})


test_that("ID overlaps are calculated correctly", {
  paths <- c(
    first = write_test_sav(
      data.frame(
        ID = c(1, 2, 2, NA),
        ONLY_FIRST = c(10, 11, 12, 13)
      )
    ),
    second = write_test_sav(
      data.frame(
        ID = c(2, 3, NA)
      )
    ),
    all_missing = write_test_sav(
      data.frame(
        ID = c(NA_real_, NA_real_)
      )
    )
  )

  capture.output(
    result <- suppressMessages(
      check_id_overlap(
        paths,
        id_vars = c("ID", "ONLY_FIRST", "ABSENT"),
        plot = FALSE
      )
    )
  )

  expect_named(
    result,
    c("ID", "ONLY_FIRST", "ABSENT")
  )

  expect_true(
    inherits(
      result$ID,
      c("eulerr_venn", "venn", "euler")
    )
  )

  expect_null(result$ONLY_FIRST)
  expect_null(result$ABSENT)
  values <- result$ID$original.values
  expect_equal(sum(values), 3)
  expect_equal(
    unname(
      values[
        grepl("&", names(values), fixed = TRUE)
      ]
    ),
    1
  )
})


test_that("IDs in more than five datasets are skipped", {

  paths <- vapply(
    seq_len(6),
    function(i) {
      write_test_sav(
        data.frame(ID = i)
      )
    },
    character(1)
  )

  names(paths) <- paste0(
    "dataset",
    seq_along(paths)
  )

  expect_warning(
    capture.output(
      result <- suppressMessages(
        check_id_overlap(
          paths,
          id_vars = "ID",
          plot = FALSE
        )
      )
    ),
    "More than five datasets"
  )

  expect_named(result, "ID")
  expect_null(result$ID)
})


test_that("a Venn diagram is drawn when plot is TRUE", {

  paths <- c(
    first = write_test_sav(
      data.frame(ID = c(1, 2))
    ),
    second = write_test_sav(
      data.frame(ID = c(2, 3))
    )
  )

  capture.output(
    result <- suppressMessages(
      with_test_pdf(
        check_id_overlap(
          paths,
          id_vars = "ID",
          plot = TRUE
        )
      )
    )
  )
  expect_false(is.null(result$ID))
})
