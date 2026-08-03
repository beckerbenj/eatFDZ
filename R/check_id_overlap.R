#' Check ID overlaps across datasets
#'
#' Imports selected ID variables from SPSS files and checks their overlap
#' across datasets. A Venn diagram is created for each ID variable that occurs
#' in two to five datasets.
#'
#' @param sav_paths A named character vector containing paths to SPSS files.
#' @param id_vars Character vector of ID variables to be checked.
#' @param plot Logical. Should Venn diagrams be drawn?
#'
#' @return A named list of `euler` objects, returned invisibly. Entries for
#'   skipped ID variables are `NULL`.
#'
#' @export
check_id_overlap <- function(sav_paths, id_vars, plot = TRUE) {

  dataset_names <- names(sav_paths)

  if (is.null(dataset_names) ||
      anyNA(dataset_names) ||
      any(!nzchar(dataset_names))) {
    stop("'sav_paths' must be a named vector.", call. = FALSE)
  }

  # Import the datasets and retain only the required ID variables
  id_data <- lapply(sav_paths, function(path) {
    gads <- eatGADS::import_spss(path)
    vars <- intersect(id_vars, eatGADS::namesGADS(gads))
    gads <- suppressMessages(eatGADS::extractVars(gads, vars))
    eatGADS::extractData2(gads)
  })
  message("ID variables found in each dataset:")
  print(lapply(id_data, names))

  results <- stats::setNames(vector("list", length(id_vars)), id_vars)

  for (id in id_vars) {
    message("\nChecking ID: ", id)

    id_values <- lapply(id_data, function(dat) {
      if (id %in% names(dat)) {
        unique(stats::na.omit(dat[[id]]))
      }
    })

    # Remove datasets without non-missing values for the selected ID
    id_values <- id_values[lengths(id_values) > 0L]
    n_datasets <- length(id_values)

    if (n_datasets < 2L) {
      message(
        "Fewer than two datasets contain non-missing values for '",
        id, "'. The check is skipped.")
      next
    }


    if (n_datasets > 5L) {
      warning(
        "More than five datasets contain non-missing values for '",
        id,
        "'. The check is skipped because Venn diagrams can only be ",
        "created for up to five datasets. Re-run check_id_overlap() ",
        "with a subset of no more than five relevant datasets.",
        call. = FALSE
      )
      next
    }

    result <- eulerr::venn(id_values)
    results[[id]] <- result

    if (plot) {
      print(graphics::plot(result,main = paste("Overlap for", id)))
    }
    print(result$original.values)
  }
  invisible(results)
}
