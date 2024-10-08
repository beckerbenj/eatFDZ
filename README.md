# eatFDZ <a href="https://beckerbenj.github.io/eatFDZ/"><img src="man/figures/logo.png" align="right" height="120" alt="eatFDZ website" /></a>


<!-- badges: start -->
[![R-CMD-check](https://github.com/beckerbenj/eatFDZ/workflows/R-CMD-check/badge.svg)](https://github.com/beckerbenj/eatFDZ/actions)
[![codecov](https://codecov.io/github/beckerbenj/eatFDZ/branch/master/graphs/badge.svg)](https://codecov.io/github/beckerbenj/eatFDZ)
<!-- badges: end -->

## Workflow

An `R` package that automates workflows for the Forschungsdatenzentrum (*FDZ*) at IQB. 
This mainly includes automated data checks.


## Installation

```R
# Install eatFDZ from GitHub via
remotes::install_github("beckerbenj/eatFDZ")
```

## Run all checks 

Run all checks recommended by FDZ on an example data set (`example_data2.sav`) within the package.

```R
library(eatFDZ)

# get data set path
dataset <- system.file("extdata", "example_data2.sav", package = "eatFDZ")

# run all checks
check_report <- check_all(dataset, missingRange = -50:-99,
                       missingRegex = "missing|omitted|not reached|nicht beantwortet|ausgelassen",
                       idVar = NULL,
                       sdcVars = NULL)
```

## Create a check report

Write a check report to excel (`.xlsx`).

```R
write_check_report(check_report, file_path = tempfile(fileext = ".xlsx"))
```
