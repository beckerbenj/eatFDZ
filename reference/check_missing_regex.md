# Check if labeled values match a missing value regex pattern

This function checks whether labeled values in the meta data of a
`GADSdat` object match a specified regular expression (`missingRegex`)
for missing value labels. It identifies values that are marked as valid
but whose labels suggest they should be declared as missing, based on
the provided pattern.

## Usage

``` r
check_missing_regex(
  GADSdat,
  missingRegex = "missing|omitted|not reached|nicht beantwortet|ausgelassen"
)
```

## Arguments

- GADSdat:

  A `GADSdat` object containing the data to be checked.

- missingRegex:

  A character string specifying the regular expression pattern used to
  identify value labels that should be treated as missing. The default
  pattern is
  `"missing|omitted|not reached|nicht beantwortet|ausgelassen"`.

## Value

A `data.frame` listing value labels that match the specified
`missingRegex` pattern but are marked as valid in the meta data. The
output includes the following columns:

- `varName`: The name of the variable containing the value.

- `value`: The value itself that has a label matching the
  `missingRegex`.

- `valLabel`: The label associated with the value.

- `missings`: The current missing status in the meta data (should be
  `"valid"` if reported here).

If no issues are found, the function returns an empty `data.frame`.

## Examples

``` r
# Example usage:

# Load example GADSdat object
GADSdat <- eatGADS::import_spss(system.file("extdata", "example_data2.sav", package = "eatFDZ"))

# Check if labeled values match the missing value regex pattern
missing_regex_report <- check_missing_regex(GADSdat)

# Print the report
print(missing_regex_report)
#>   varName value valLabel missings
#> 1   books   -99  omitted    valid
#> 2  school   -99  omitted    valid

# Using a custom regex pattern
custom_report <- check_missing_regex(GADSdat, missingRegex = "unanswered|unknown|keine Angabe")
print(custom_report)
#>   varName value valLabel missings
#> 1  school   -97  unknown    valid
```
