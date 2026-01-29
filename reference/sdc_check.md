# Create a Statistical Disclosure Control Report

This function generates a statistical disclosure control (SDC) report,
identifying variables with categories that have low absolute
frequencies. Such low-frequency categories could potentially lead to
statistical data disclosure issues, particularly in data sets involving
individual-level data from studies like large-scale assessments. The
function currently performs only a uni-variate check, flagging
categories with a frequency below a specified threshold.

## Usage

``` r
sdc_check(fileName, boundary = 5, exclude = NULL, encoding = NULL)
```

## Arguments

- fileName:

  A character string specifying the path to the SPSS file to import as a
  `GADSdat` object.

- boundary:

  An integer specifying the frequency threshold for identifying
  low-frequency categories. Categories with less than or equal to this
  number of observations will be flagged. The default value is `5`.

- exclude:

  An optional character vector containing variable names that should be
  excluded from the report.

- encoding:

  An optional character string specifying the character encoding for
  importing the SPSS file. If `NULL` (default), the encoding specified
  in the file is used.

## Value

A `data.frame` summarizing categories with low frequencies, including
the following columns:

- `variable`: The name of the variable with low-frequency categories.

- `varLab`: The label for the variable (if present).

- `existVarLab`: Whether a variable label exists (`TRUE` or `FALSE`).

- `existValLab`: Whether value labels exist for the variable (`TRUE` or
  `FALSE`).

- `skala`: Information on the variable type/classification.

- `nKatOhneMissings`: The total number of non-missing categories.

- `nValid`: The total number of valid observations for the variable.

- `nKl5`: Indicator for variables with categories flagged as low
  frequency (`TRUE` or `FALSE`).

- `exclude`: Whether the variable has been excluded based on the
  `exclude` argument.

## Examples

``` r
# Load an example SPSS file
sav_path <- system.file("extdata", "example_data2.sav", package = "eatFDZ")

# Exclude unique identifier variables from the SDC check
exclude_vars <- c("ID", "ID_name")

# Generate the SDC report
sdc_report <- sdc_check(fileName = sav_path, boundary = 5, exclude = exclude_vars)

# Print the SDC report
print(sdc_report)
#>      variable                  varLab existVarLab existValLab     skala
#> 1          ID          Participant ID        TRUE       FALSE character
#> 2     ID_name                       ä        TRUE       FALSE character
#> 3       infoß           General notes        TRUE       FALSE character
#> 4         sex                     Sex        TRUE        TRUE   numeric
#> 5     subjfav        Favorite subject        TRUE       FALSE character
#> 6         äge                     Age        TRUE       FALSE   numeric
#> 7    siblings      Number of siblings        TRUE       FALSE   numeric
#> 8        home      Place of residence        TRUE        TRUE   numeric
#> 9       birth                Birthday        TRUE       FALSE character
#> 10      books Number of books at home        TRUE        TRUE   numeric
#> 11     school                    <NA>       FALSE        TRUE   numeric
#> 12 grade_math       Grade mathematics        TRUE       FALSE   numeric
#> 13 grade_germ            Grade German        TRUE       FALSE   numeric
#> 14  grade_eng           Grade English        TRUE       FALSE   numeric
#>    nKatOhneMissings nValid nKl5 exclude
#> 1                10     11 TRUE    TRUE
#> 2                11     12 TRUE    TRUE
#> 3                10     12 TRUE   FALSE
#> 4                 2     12 TRUE   FALSE
#> 5                 8     12 TRUE   FALSE
#> 6                 4     12 TRUE   FALSE
#> 7                 6     12 TRUE   FALSE
#> 8                 3     12 TRUE   FALSE
#> 9                10     12 TRUE   FALSE
#> 10                7     11 TRUE   FALSE
#> 11                6     12 TRUE   FALSE
#> 12                6     12 TRUE   FALSE
#> 13                6     12 TRUE   FALSE
#> 14                6     12 TRUE   FALSE
```
