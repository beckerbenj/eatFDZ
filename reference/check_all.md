# Run all data checks for a GADSdat object

This function performs a series of comprehensive data quality checks on
a `GADSdat` object. It aggregates the functionality of multiple
individual checks, validating the structure, consistency, and
documentation of the dataset. The checks include:

- [`check_file_name`](https://beckerbenj.github.io/eatFDZ/reference/check_file_name.md):
  Verifies the validity of the file name.

- [`check_var_names`](https://beckerbenj.github.io/eatFDZ/reference/check_var_names.md):
  Checks variable names for e.g. special characters.

- [`check_meta_encoding`](https://beckerbenj.github.io/eatFDZ/reference/check_meta_encoding.md):
  Ensures proper encoding in metadata.

- [`check_id`](https://beckerbenj.github.io/eatFDZ/reference/check_id.md):
  Validates the uniqueness and non-missingness of identifier variables.

- [`check_var_labels`](https://beckerbenj.github.io/eatFDZ/reference/check_var_labels.md):
  Checks for the existence of variable labels.

- [`checkMissingValLabels`](https://beckerbenj.github.io/eatGADS/reference/checkEmptyValLabels.html):
  Ensures missing value labels are correctly defined.

- [`check_missing_range`](https://beckerbenj.github.io/eatFDZ/reference/check_missing_range.md):
  Validates whether values fall within a defined missing value range.

- [`check_missing_regex`](https://beckerbenj.github.io/eatFDZ/reference/check_missing_regex.md):
  Identifies missing value labels based on a regular expression.

- [`sdc_check`](https://beckerbenj.github.io/eatFDZ/reference/sdc_check.md):
  Performs a statistical disclosure control check for variables with low
  category frequencies.

- [`check_docu`](https://beckerbenj.github.io/eatFDZ/reference/check_docu.md):
  Verifies that all variables are referenced in external documentation
  (e.g., codebooks in `.pdf` format).

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

  Character string specifying the path to the SPSS file (`.sav`).

- pdf_path:

  Optional. A character string specifying the path to the `.pdf` file
  containing the codebook or documentation. If not provided, checks
  related to documentation are skipped.

- encoding:

  Optional. A character string specifying the encoding used for reading
  the `.sav` file. If `NULL` (default), the encoding defined in the file
  is used.

- missingRange:

  Numeric. A range of values that should be declared as missing.
  Defaults to `-50:-99`.

- missingRegex:

  Character. A regular expression pattern used to identify labels that
  should be treated as missing. Defaults to
  `"missing|omitted|not reached|nicht beantwortet|ausgelassen"`.

- idVar:

  Optional. A character vector specifying the name(s) of identifier
  variables in the `GADSdat` object. If `NULL` (default), the first
  variable in the data set is used as the identifier variable.

- sdcVars:

  Optional. A character vector of variable names to be checked for
  statistical disclosure control risks. If `NULL`, all variables are
  checked.

## Value

A `list` containing:

- `Overview`: A `data.frame` summarizing which checks passed or detected
  issues.

- Detailed reports for each check: A series of `data.frame`s generated
  during the checks, each labeled with the respective check name (e.g.,
  `"lengthy_variable_names"`, `"missing_IDs"`).

## Details

This function provides a comprehensive overview of potential issues,
helping to ensure data set quality and consistency. It outputs a summary
of detected issues as well as detailed reports for each individual
check.

## Examples

``` r
# Specify the path to an SPSS file
sav_path <- system.file("extdata", "example_data2.sav", package = "eatFDZ")

# Run all checks with default parameters
check_results <- check_all(sav_path = sav_path)
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
