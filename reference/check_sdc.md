# Create a Statistical Disclosure Control Report.

Create a statistical disclosure control report: Which variables have
categories with low absolute frequencies, which might lead to
statistical data disclosure issues?

## Usage

``` r
check_sdc(GADSdat, vars = eatGADS::namesGADS(GADSdat), boundary = 5)
```

## Arguments

- GADSdat:

  A `GADSdat` object.

- vars:

  Character vector of variable names. Which variables should be checked?

- boundary:

  Integer number: categories with less than or equal to `boundary`
  observations will be flagged

## Value

A `data.frame`.

## Details

Individual participants of studies such as educational large-scale
assessments usually must remain non-identifiable on individual level.
This function checks the specified variables in a `GADSdat` object for
low frequency categories which might lead to statistical disclosure
control issues. Currently, only a uni-variate check is implemented.

## Examples

``` r
# tbd

```
