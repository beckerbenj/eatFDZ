# Check for missing variable labels

This function checks whether all variables in a `GADSdat` object have
been assigned a variable label. Missing variable labels can indicate
poorly documented data and may lead to issues in data analysis or
reporting.

## Usage

``` r
check_var_labels(GADSdat)
```

## Arguments

- GADSdat:

  A `GADSdat` object containing the data for which variable labels
  should be checked.

## Value

A `data.frame` with the names of variables that lack variable labels:

- `varName`: The name of the variable without a label.

If all variables have labels, the function returns an empty
`data.frame`.

## Examples

``` r
# Example usage

# Load example GADSdat object
GADSdat <- eatGADS::import_spss(system.file("extdata", "example_data2.sav", package = "eatFDZ"))

# Check for variables missing labels
missing_labels <- check_var_labels(GADSdat)

# Print the result
print(missing_labels)
#>   varName
#> 1  school
```
