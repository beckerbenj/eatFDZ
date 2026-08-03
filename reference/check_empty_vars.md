# Check for empty variables

Identifies variables that contain only missing values. Values tagged as
missing in the metadata are treated as missing.

## Usage

``` r
check_empty_vars(GADSdat)
```

## Arguments

- GADSdat:

  A `GADSdat` object.

## Value

A `data.frame` with the variable name and variable label. If no empty
variables are found, an empty `data.frame` is returned.
