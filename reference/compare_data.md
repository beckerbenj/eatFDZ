# Compare existing variables and meta data structure between two data sets.

Compare existing variables and meta data structure between two data
sets.

## Usage

``` r
compare_data(
  data1,
  data2,
  name_data1 = "data1",
  name_data2 = "data2",
  metaExceptions = c("display_width", "labeled")
)
```

## Arguments

- data1:

  Data set one, provided as a `GADSdat` object.

- data2:

  Data set two, provided as a `GADSdat` object.

- name_data1:

  Character vector of length 1. Name of `data1`.

- name_data2:

  Character vector of length 1. Name of `data2`.

- metaExceptions:

  Should certain meta data columns be excluded from the comparison?

## Details

The function performs a comparison between two `GADSdat` objects.
Variables included in each data set are compared and reported, as well
as meta data differences (variable labels, SPSS format, value labels,
missing tags).

## Examples

``` r
# tbd
```
