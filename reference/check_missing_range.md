# Check if labeled values fall within the specified missing value range

This function checks whether all labeled values in the meta data of a
`GADSdat` object fall within the specified range for missing values. It
identifies values that are labeled as valid but should be declared as
missing based on the defined `missingRange`.

## Usage

``` r
check_missing_range(GADSdat, missingRange = -50:-99)
```

## Arguments

- GADSdat:

  A `GADSdat` object containing the data to be checked.

- missingRange:

  A numeric vector specifying the range of values that should be treated
  as missing. The default is `-50:-99`, but this can be customized.

## Value

A `data.frame` listing labeled values that are within the specified
`missingRange` but marked as valid in the meta data. The output includes
the following columns:

- `varName`: The name of the variable containing the value.

- `value`: The value itself that falls within the `missingRange`.

- `valLabel`: The label associated with the value.

- `missings`: The current missing status in the meta data (should be
  `"valid"` if reported here).

If all values within the `missingRange` are already declared as missing,
the function returns an empty `data.frame`.

## Examples

``` r
# Example usage:

# Load example GADSdat object
GADSdat <- eatGADS::import_spss(system.file("extdata", "example_data2.sav", package = "eatFDZ"))

# Check if labeled values are within the missing value range (-50 to -99 by default)
missing_range_report <- check_missing_range(GADSdat)

# Print the report
print(missing_range_report)
#>   varName value       valLabel missings
#> 1   books   -99        omitted    valid
#> 2  school   -99        omitted    valid
#> 3  school   -98 unclear answer    valid
#> 4  school   -97        unknown    valid
```
