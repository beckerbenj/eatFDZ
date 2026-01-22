# Download and import an empty FDZ file.

Download and import an empty data set from the [FDZ
homepage](https://www.iqb.hu-berlin.de/fdz/studies/).

## Usage

``` r
download_fdz(
  study = c("PISA"),
  year = c("2018", "2015", "2012", "2009", "2006", "2003", "2000"),
  data_type = c("stud_quest")
)
```

## Arguments

- study:

  Name of the study

- year:

  Year of the assessment (only needed for longitudinal assessments).

- data_type:

  Type of the data.

## Details

The function downloads and imports an empty data set (`Leerdatensatz`)
from the FDZ homepage. These data sets contain zero rows. The data is
imported via
[`import_spss`](https://beckerbenj.github.io/eatGADS/reference/import_spss.html)
as a `GADSdat` object.

## Examples

``` r
fdz_pisa <- download_fdz(study = "PISA", year = "2015",
                        data_type = "stud_quest")
#> Warning: Failed to open 'https://www.iqb.hu-berlin.de/fdz/studies/PISA_2015/PISA2015_Schuele_1.sav': The requested URL returned error: 404
#> Error in open.connection(con, "rb"): cannot open the connection
```
