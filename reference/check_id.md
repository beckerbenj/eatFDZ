# Check for uniqueness and non-missingness in an identifier variable

This function checks whether an identifier variable in a `GADSdat`
object meets key requirements for data quality:

- The identifier variable must be unique (i.e., no duplicate values).

- The identifier variable must not contain any missing values (`NA`).

These checks help ensure that the identifier variable can uniquely and
reliably index rows within the data.

## Usage

``` r
check_id(GADSdat, idVar = NULL)
```

## Arguments

- GADSdat:

  A `GADSdat` object containing the data to be checked.

- idVar:

  A character string specifying the name of the identifier variable in
  the `GADSdat` object. If `NULL`, the first variable in the dataset
  will be used as the identifier variable.

## Value

A `list` with two components summarizing the issues found:

- `missing_ids`: A `data.frame` with the row indices of observations
  where the identifier variable has missing values.

- `duplicate_ids`: A `data.frame` with the values of duplicate
  identifiers (if any).

If there are no missing or duplicate identifiers, the respective
`data.frame` will be empty.

## Examples

``` r
# Example usage

# Load example GADSdat object
GADSdat <- eatGADS::import_spss(system.file("extdata", "example_data2.sav", package = "eatFDZ"))

# Check identifier variable for uniqueness and non-missingness
id_check <- check_id(GADSdat, idVar = "IDSTUD")
#> Error: The following 'vars' are not variables in the GADSdat: IDSTUD

# View rows with missing identifier values
print(id_check$missing_ids)
#> Error: object 'id_check' not found

# View duplicate identifier values
print(id_check$duplicate_ids)
#> Error: object 'id_check' not found
```
