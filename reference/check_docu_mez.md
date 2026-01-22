# Check documentation of data sets.

This is a specific version of
[`check_docu`](https://beckerbenj.github.io/eatFDZ/reference/check_docu.md)
written for the `MEZ` study. If a variable name can not be found in the
documentation, the variable name is split at the first numeral and `*`
is added to the stem.

## Usage

``` r
check_docu_mez(
  sav_path,
  pdf_path,
  post_words = 2,
  case_sensitive = FALSE,
  encoding = NULL
)
```

## Arguments

- sav_path:

  Character vector with paths to the `.sav` files.

- pdf_path:

  Character vector with paths to the `.pdf` files.

- post_words:

  Number of words after the variable names that should be extracted from
  the PDF.

- case_sensitive:

  If `TRUE`, upper and lower case are differentiated for variable name
  matching. If `FALSE`, case is ignored.

- encoding:

  Optional: The character encoding used for reading the `.sav` file. The
  default, `NULL`, uses the encoding specified in the file, but
  sometimes this value is incorrect and it is useful to be able to
  override it.

## Value

A `data.frame` with the variable names, count of mentions in the `pdf`
(`count`), words after the variable names (`post`) and the name of the
data set in which the variable occurs (`data_set`).
