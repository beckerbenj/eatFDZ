# Check for the existence of character variables

This function identifies all character variables in a `GADSdat` object
and counts the number of unique values in each of those variables.
Character variables are often of particular interest as they may contain
free text or other non-standardized inputs that require additional
review or processing.

## Usage

``` r
check_character_vars(GADSdat)
```

## Arguments

- GADSdat:

  A `GADSdat` object containing the data to be checked.

## Value

A `data.frame` with the following columns:

- `varName`: The name of the character variable.

- `nUniqueValues`: The number of unique values in the character
  variable.

If no character variables exist, the function returns an empty
`data.frame`.

## Examples

``` r
# Example usage:

# Load example GADSdat object
GADSdat <- eatGADS::import_spss(system.file("extdata", "example_data2.sav", package = "eatFDZ"))

# Check for character variables and count unique values
character_vars_report <- check_character_vars(GADSdat)

# Print the report
print(character_vars_report)
#>   varName nUniqueValues
#> 1      ID            11
#> 2 ID_name            11
#> 3   infoß            10
#> 4 subjfav             8
#> 5   birth            10
```
