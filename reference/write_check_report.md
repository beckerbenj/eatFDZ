# Write a check report.

Write a check report as created by
[`check_all`](https://beckerbenj.github.io/eatFDZ/reference/check_all.md)
to excel.

## Usage

``` r
write_check_report(check_report, file_path, language = c("German", "English"))
```

## Arguments

- check_report:

  The check report as created by
  [`check_all`](https://beckerbenj.github.io/eatFDZ/reference/check_all.md).

- file_path:

  File destination.

- language:

  In which language should the output be written? Currently only German
  is supported.

## Details

The function writes a check report provided by
[`check_all`](https://beckerbenj.github.io/eatFDZ/reference/check_all.md)
via `openxlsx` to excel. Formating and additional explanations are added
to increase readability and usability.

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
write_check_report(out, file_path = tempfile())
```
