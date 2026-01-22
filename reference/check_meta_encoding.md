# Check encoding issues in meta data

This function checks the meta data of a `GADSdat` object for encoding
issues, such as the presence of special characters (e.g., `"Umlaute"` or
other non-ASCII characters). Encoding problems in meta data (e.g.,
variable labels, value labels) can lead to inconsistencies and issues
when working with data across systems that expect clean encoding.

## Usage

``` r
check_meta_encoding(GADSdat)
```

## Arguments

- GADSdat:

  A `GADSdat` object containing the data to be checked for meta data
  encoding issues.

## Value

A `data.frame` that reports the variables and labels with encoding
issues:

- `"varName"`: The name of the variable with encoding issues (if
  applicable).

- `"value"`: The problematic value (if applicable).

- `"GADSdat_varLabel"`: The variable label with the detected encoding
  issue.

- `"GADSdat_valLabel"`: The value label with the detected encoding
  issue.

If no issues are found, the function returns an empty `data.frame`.

## Details

Checks in the meta data include

- special signs such as `Umlaute`

## Examples

``` r
# Example usage:
# Load example GADSdat object
GADSdat <- eatGADS::import_spss(system.file("extdata", "example_data2.sav", package = "eatFDZ"))

# Check for encoding issues in meta data
meta_encoding_issues <- check_meta_encoding(GADSdat)

# Print the result
print(meta_encoding_issues)
#>   varName GADSdat_varLabel value GADSdat_valLabel
#> 1 ID_name                ä    NA             <NA>
#> 2  school             <NA>     5     Förderschule
```
