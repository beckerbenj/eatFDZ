# Write formatted disclosure control reports

Writes disclosure control results to the Excel template included in
\`eatFDZ\`. A separate worksheet is created for each dataset.

## Usage

``` r
write_sdc_report(x, file_path, overwrite = FALSE)
```

## Arguments

- x:

  A named list of data frames returned by \[sdc_check()\].

- file_path:

  Path of the Excel file to be created.

- overwrite:

  Logical. Should an existing file be overwritten?

## Value

The output file path, returned invisibly.
