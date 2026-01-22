# Check for lengthy variable names.

This function checks whether variable names in a `GADSdat` object exceed
the allowed number of characters. This can help ensure that variable
names adhere to naming conventions and avoid potential issues with
downstream processing or compatibility.

## Usage

``` r
check_var_names_length(GADSdat, boundary = 30)
```

## Arguments

- GADSdat:

  `GADSdat` object.

- boundary:

  An integer specifying the maximum length (number of characters) a
  variable name is allowed to have. Default is 30.

## Value

A `data.frame` containing the variable names that exceed the boundary,
along with their respective character counts. If all variable names are
within the boundary, an empty `data.frame` is returned.

## Examples

``` r
# Example usage:
# Load example GADSdat object
GADSdat <- eatGADS::import_spss(system.file("extdata", "example_data2.sav", package = "eatFDZ"))

# Check for variable names longer than 30 characters
lengthy_names <- check_var_names_length(GADSdat, boundary = 30)

# Print the result
print(lengthy_names)
#> [1] varName nChars 
#> <0 rows> (or 0-length row.names)
```
