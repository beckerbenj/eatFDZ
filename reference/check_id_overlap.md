# Check ID overlaps across datasets

Imports selected ID variables from SPSS files and checks their overlap
across datasets. A Venn diagram is created for each ID variable that
occurs in two to five datasets.

## Usage

``` r
check_id_overlap(sav_paths, id_vars, plot = TRUE)
```

## Arguments

- sav_paths:

  A named character vector containing paths to SPSS files.

- id_vars:

  Character vector of ID variables to be checked.

- plot:

  Logical. Should Venn diagrams be drawn?

## Value

A named list of \`euler\` objects, returned invisibly. Entries for
skipped ID variables are \`NULL\`.
