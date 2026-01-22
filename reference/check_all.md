# Run all data checks.

Run all data checks.

## Usage

``` r
check_all(
  sav_path,
  pdf_path = NULL,
  encoding = NULL,
  missingRange = -50:-99,
  missingRegex = "missing|omitted|not reached|nicht beantwortet|ausgelassen",
  idVar = NULL,
  sdcVars = NULL
)
```

## Arguments

- sav_path:

  Path to the SPSS file

- pdf_path:

  Path to the `.pdf` file

- encoding:

  Optional: The character encoding used for reading the `.sav` file. The
  default, `NULL`, uses the encoding specified in the file, but
  sometimes this value is incorrect and it is useful to be able to
  override it.

- missingRange:

  Numerical range for missing tags.

- missingRegex:

  Regular expression for value labels for missing tags.

- idVar:

  Name(s) of the identifier variable in the `GADSdat` object. If `NULL`,
  the first variable in the data set is taken as the `idVar`.

- sdcVars:

  Variable names of variables with potential statistical disclosure
  control issues.

## Value

A `data.frame`.

## Details

This functions calls
[`check_file_name`](https://beckerbenj.github.io/eatFDZ/reference/check_file_name.md),
[`check_var_names`](https://beckerbenj.github.io/eatFDZ/reference/check_var_names.md),
[`check_meta_encoding`](https://beckerbenj.github.io/eatFDZ/reference/check_meta_encoding.md),
[`check_id`](https://beckerbenj.github.io/eatFDZ/reference/check_id.md),
[`check_var_labels`](https://beckerbenj.github.io/eatFDZ/reference/check_var_labels.md),
[`checkMissingValLabels`](https://beckerbenj.github.io/eatGADS/reference/checkEmptyValLabels.html),
[`check_missing_range`](https://beckerbenj.github.io/eatFDZ/reference/check_missing_range.md),
[`check_missing_regex`](https://beckerbenj.github.io/eatFDZ/reference/check_missing_regex.md),
[`sdc_check`](https://beckerbenj.github.io/eatFDZ/reference/sdc_check.md),
and
[`check_docu`](https://beckerbenj.github.io/eatFDZ/reference/check_docu.md).

## Examples

``` r
dataset <- system.file("extdata", "example_data2.sav", package = "eatFDZ")
out <- check_all(dataset)
#>                              Test          Result
#> 1          lengthy_variable_names         passing
#> 2    special_signs_variable_names Issues detected
#> 3         special_signs_meta_data Issues detected
#> 4                     missing_IDs Issues detected
#> 5                   duplicate_IDs Issues detected
#> 6         missing_variable_labels Issues detected
#> 7            missing_value_labels Issues detected
#> 8              missing_range_tags Issues detected
#> 9              missing_regex_tags Issues detected
#> 10 statistical_disclosure_control Issues detected
#> 11            character_variables Issues detected
#> 12                     docu_check      Not tested
```
