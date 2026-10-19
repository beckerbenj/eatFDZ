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
    # Skip extraction if none of the requested IDs are present
    if (length(vars) == 0L) {return(data.frame())}
    gads <- suppressMessages(eatGADS::extractVars(gads, vars))
    eatGADS::extractData2(gads)
  })
  message("ID variables found in each dataset:")
  print(lapply(id_data, names))

  results <- stats::setNames(vector("list", length(id_vars)), id_vars)

  for (id in id_vars) {
    message("\nChecking ID: ", id)

    # Identify datasets containing the ID variable
    datasets_with_id <- names(id_data)[sapply(id_data, function(dat) {
      id %in% names(dat)
    })]

    # Extract unique, non-missing ID values
    id_values <- lapply(id_data, function(dat) {
      if (id %in% names(dat)) {
        unique(stats::na.omit(dat[[id]]))
      }
    })

    id_values <- id_values[lengths(id_values) > 0L]
    n_datasets <- length(id_values)

    # Case 1: ID variable not found
    if (length(datasets_with_id) == 0L) {
      warning(
        "ID variable '", id, "' was not found in any dataset. ",
        "Check the variable name in 'id_vars'.",
        call. = FALSE
      )
      next
    }

    # Case 2: ID variable found in only one dataset
    if (length(datasets_with_id) == 1L) {
      warning(
        "ID variable '", id, "' was found only in dataset '",
        datasets_with_id, "'. ",
        "At least two datasets are required for an overlap check.",
        call. = FALSE
      )
      next
    }

    # Case 3: Fewer than two datasets contain non-missing ID values
    if (n_datasets < 2L) {
      warning(
        "ID variable '", id, "' occurs in multiple datasets, ",
        "but fewer than two contain non-missing ID values. ",
        "The overlap check is skipped.",
        call. = FALSE
      )
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
      font_size <- min(10, 14 - n_datasets)
      plot_labels <- names(id_values)

      # Split long labels near the middle, preferably at a separator
      for (i in which(nchar(plot_labels) > 16)) {
        label <- plot_labels[i]
        split_at <- ceiling(nchar(label) / 2)
        separators <- gregexpr("[_ -]", label)[[1]]

        if (separators[1] > 0) {
          split_at <- separators[which.min(abs(separators - split_at))]
        }

        plot_labels[i] <- paste(
          substr(label, 1, split_at),
          substring(label, split_at + 1),
          sep = "\n"
        )
      }

      # Draw the diagram with labels beside the ellipses
      print(graphics::plot(
        result,
        labels = list(
          labels = plot_labels,
          position = "outside",
          fontsize = font_size,
          font = 1,
          lineheight = 1
        ),
        quantities = list(fontsize = font_size),
        fills = "grey95",
        edges = "grey35",
        main = list(
          label = paste("Overlap for", id),
          fontsize = 14,
          cex = 1
        )
      ))
    }

    print(result$original.values)
  }
  invisible(results)
}
