# Check variable names for encoding issues and dots

This function checks whether variable names in a `GADSdat` object
contain specific formatting issues, focusing on:

- Encoding problems: Variables with non-ASCII characters, such as
  `"Umlaute"` or other special characters.

- The presence of dots (`"."`) in variable names.

## Usage

``` r
check_var_names(GADSdat)
```

## Arguments

- GADSdat:

  A `GADSdat` object containing the data whose variable names are to be
  checked.

## Value

A `data.frame` containing variable names that failed the checks. If all
variable names meet the requirements, the function returns an empty
`data.frame`.

## Details

These checks help detect and report variable naming issues that may
cause compatibility problems with certain tools or systems (e.g., Stata
or databases with strict naming conventions).

## Examples

``` r
# Example usage:
# Load example GADSdat object
GADSdat <- eatGADS::import_spss(system.file("extdata", "example_data2.sav", package = "eatFDZ"))

# Check for problematic variable names
problematic_var_names <- check_var_names(GADSdat)

# Print the result
print(problematic_var_names)#'
#>   varName
#> 1   infoß
#> 2     äge
```
