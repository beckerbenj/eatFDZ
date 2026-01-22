# Check an identifier variable.

Check the uniqueness and non-missingness of a variable in a `GADSdat`.

## Usage

``` r
check_id(GADSdat, idVar = NULL)
```

## Arguments

- GADSdat:

  `GADSdat` object.

- idVar:

  Name(s) of the identifier variable in the `GADSdat` object. If `NULL`,
  the first variable in the data set is taken as the `idVar`.

## Value

Returns the test report.

## Details

Checks include

- Is the identifier variable unique (i.e., no duplicates)?

- Are there any missing values in the identifier variable?

## Examples

``` r
# tbd
```
