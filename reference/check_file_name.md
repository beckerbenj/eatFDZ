# Check and validate a file name

This function checks the validity of a file name, ensuring that it does
not contain special characters (e.g., `Umlaute`) or spaces. File names
with problematic encoding or formatting are flagged, as these issues may
cause errors when processing files in different systems or environments.

## Usage

``` r
check_file_name(path)
```

## Arguments

- path:

  A character string specifying the file path to be checked.

## Value

This function returns an error if any issues are detected with the file
name (e.g., special characters or spaces). If the file name is valid, no
output is returned.

## Examples

``` r
# Example of a valid file name
valid_path <- system.file("extdata", "example_data2.sav", package = "eatFDZ")
check_file_name(valid_path)

# Example of an invalid file name (this will throw an error)
invalid_path <- "invalid file name.sav"
check_file_name(invalid_path)
#> Error in check_file_name(invalid_path): File name contains special characters or spaces.
```
