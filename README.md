# eatFDZ

<!-- badges: start -->
[![Travis build status](https://travis-ci.org/beckerbenj/eatFDZ.svg?branch=master)](https://travis-ci.org/beckerbenj/eatFDZ)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/beckerbenj/eatFDZ?branch=master&svg=true)](https://ci.appveyor.com/project/beckerbenj/eatFDZ)
[![codecov](https://codecov.io/github/beckerbenj/eatFDZ/branch/master/graphs/badge.svg)](https://codecov.io/github/beckerbenj/eatFDZ)
<!-- badges: end -->

## Workflow

An `R` package that automates workflows for the Forschungsdatenzentrum (*FDZ*) at IQB.


## Installation

```R
# Install eatFDZ from GitHub via
remotes::install_github("beckerbenj/eatFDZ")

# Install eatAnalysis (for writing Excel files) from GitHub via
remotes::install_github("beckerbenj/eatAnalysis")
```

## Codebook checks

```R
library(eatFDZ)
### Check if all variables in the data set are mentioned in the codebook
out <- check_docu(sav_path = "example_data.sav", 
           pdf_path = "example_codebook.pdf", )

# write to Excel
eatAnalysis::write_xlsx(out, filePath = "codebook_checks.xlsx", row.names = FALSE)
```

## Data cleaning and anonymization

```R
syntax <- data_clean(fileName = sav_path,
             saveFolder = tempdir(), nameListe = "liste2.csv",
             nameSyntax = "syntax2.txt", exclude=exclude)
```
