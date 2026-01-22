# Create a Statistical Disclosure Control Report.

Create a statistical disclosure control report: Which variables have
categories with low absolute frequencies, which might lead to
statistical data disclosure issues?

## Usage

``` r
sdc_check(fileName, boundary = 5, exclude = NULL, encoding = NULL)
```

## Arguments

- fileName:

  Character string of the SPSS file

- boundary:

  Integer number: categories with less than or equal to `boundary`
  observations will be flagged

- exclude:

  Optional: character vector of variable names which should be excluded
  from the report

- encoding:

  Optional: The character encoding used for reading the `.sav` file. The
  default, `NULL`, uses the encoding specified in the file, but
  sometimes this value is incorrect and it is useful to be able to
  override it.

## Value

A `data.frame`.

## Details

Individual participants of studies such as educational large-scale
assessments usually must remain non-identifiable on individual level.
This function checks all variables in a `GADSdat` object for low
frequency categories which might lead to statistical disclosure control
issues. Currently, only a uni-variate check is implemented.

## Examples

``` r
sav_path <- system.file("extdata", "LV_2011_CF.sav", package = "eatFDZ")

## don't report low frequencies for unique id variables
exclude<- c("idstud_FDZ", "idsch_FDZ")

##
sdc_report <- sdc_check(fileName = sav_path, exclude=exclude)


```
