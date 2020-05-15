# eatFDZ

<!-- badges: start -->
[![Travis build status](https://travis-ci.org/beckerbenj/eatFDZ.svg?branch=master)](https://travis-ci.org/beckerbenj/eatFDZ)
<!-- badges: end -->

## Workflow

An `R` package that automates workflows for the Forschungsdatenzentrum (*FDZ*) at IQB.


## Installation

```R
# Install eatFDZ from GitHub via
remotes::install_github("beckerbenj/eatFDZ")
```

## Usage

```R
### Check if all variables in the data set are mentioned in the codebook
check_docu(sav_path = "example_data.sav", 
           pdf_path = "example_codebook.pdf", )
```
