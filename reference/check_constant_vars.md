# Check for constant variables

Identifies variables that contain exactly one distinct non-missing
value. Values defined as missing in the metadata are excluded from the
check.

## Usage

``` r
check_constant_vars(GADSdat)
```

## Arguments

- GADSdat:

  A `GADSdat` object.

## Value

A `data.frame` with variable names, labels, and constant values.
