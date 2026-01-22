# Check documentation of data sets.

Check if all variables of one or multiple data sets saved as `sav` are
included in the `excel` documentation.

## Usage

``` r
check_docu_excel(sav_path, excel_path, case_sensitive = FALSE, encoding = NULL)
```

## Arguments

- sav_path:

  Character vector with paths to the `.sav` files.

- excel_path:

  Character vector with paths to the `.xlsx` files.

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
(`count`), and the name of the data set in which the variable occurs
(`data_set`).

## Details

A common requirement for data documentation is a complete codebook. The
`check_docu_excel` function can be used to check, whether all variables
(column names) in one or multiple `sav` data sets are mentioned in the
documentation, provided as `excel` files. Multiple `pdf` files are
treated as one single `pdf` file. For multiple data sets the output is
sorted by data set and the `data_set` column indicates to which data set
the variable name belongs.

For easier reading of the output, the output can be written to an
`excel` file, for example using the `write.xlsx` function from the
`openxlsx` package or the `write_xlsx` function from the `eatAnalysis`
package.

## Examples

``` r
# File pathes
sav_path1 <- system.file("extdata", "helper_spss_p1.sav", package = "eatFDZ")
sav_path2 <- system.file("extdata", "helper_spss_p2.sav", package = "eatFDZ")
excel_path1 <- system.file("extdata", "helper_codebook_p1.xlsx", package = "eatFDZ")

check_df <- check_docu_excel(sav_path = c(sav_path1, sav_path2),
                       excel_path = c(excel_path1))
```
