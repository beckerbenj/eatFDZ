# Download and import an empty PISA public use file.

Download and import an empty PISA public use file (containing only the
first data row) from the [OECD
homepage](https://www.oecd.org/en/about/programmes/pisa/pisa-data.html).

## Usage

``` r
download_pisa(
  year = c("2018", "2015", "2012", "2009", "2006", "2003", "2000"),
  data_type = c("stud_quest")
)
```

## Arguments

- year:

  Year of the PISA cycle which the data is part of.

- data_type:

  Type of the PISA data. Currently supported is student background data
  (`"stud_quest"`).

## Details

The function downloads a zip file from the OECD homepage into a
temporary directory, unzips it and imports the data with only a single
data row via
[`read_sav`](https://haven.tidyverse.org/reference/read_spss.html). For
downloading full PISA data sets see the
[EdSurvey](https://cran.r-project.org/package=EdSurvey) package. The
data is imported as a `GADSdat` object.

## Examples

``` r
if (FALSE) { # \dontrun{
pisa <- download_pisa(year = "2015", data_type = "stud_quest")
} # }
```
