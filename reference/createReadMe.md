# Create a ReadMe file documenting directory contents

List and describe the contents of a directory, including all its
subdirectories, reflecting the directory structure. Use this function
to...

- create an overview (and, optionally, a control table for future ReadMe
  construction) for an existing directory, or

- combine and apply control tables to describe a newly created
  directory.

## Usage

``` r
createReadMe(
  in_path,
  out_path = NULL,
  lang = c("de", "en"),
  margin = 4,
  col_width = 90,
  indent_per_level = 2,
  max_indent = 10,
  create_table = c("none", "control", "overview", "text"),
  sep = c(";", ","),
  flat_depth = NULL,
  skip_empty_base = FALSE,
  header = NULL,
  content_box = NULL,
  remarks = NULL,
  footer = NULL,
  replace_id = NULL,
  include_rm = NULL
)
```

## Arguments

- in_path:

  Either a single directory path or a `character vector` of at least one
  control table path.

- out_path:

  Optional [`file.path`](https://rdrr.io/r/base/file.path.html) (incl.
  file name) for the ReadMe to be created in.
  [writeLines](https://rdrr.io/r/base/writeLines.html) needs to be able
  to write a plain-text ReadMe here. If `NULL` (the default), no file is
  created.

- lang:

  Which language(s) should the ReadMe be created in? By default, German
  (`"de"`) and English (`"en"`) are supported, esp. for directory mode
  (see details). In table mode, any language acronym that matches a
  description column in the control tables can be selected. If more than
  one language is specified and an `out_path` is provided, one ReadMe
  will be created for each language, using `lang` as the file name
  suffix.

- margin:

  Formatting option: `numeric` value of the minimum number of spaces
  that should separate file names and file descriptions. All formatting
  options only apply if a ReadMe is written to `out_path`.

- col_width:

  Formatting option: `numeric` value of the default width at which the
  file descriptions should start. If `max(nchar(file names))` \>
  `col_width`, width will be set to `max(nchar(file names))` and
  `margin` will be applied on that.

- indent_per_level:

  Formatting option: `numeric` value of the number of spaces used to
  indent a line to indicate its contents are one level lower than
  another line.

- max_indent:

  Formatting option: `numeric` value of the maximum number of
  indentation spaces to use from `indent_per_level`.

- create_table:

  Optional `character` argument to control the return value of this
  function (see details).

- sep:

  Which column separator is used in the control tables (c.f.
  [read.table](https://rdrr.io/r/utils/read.table.html))?

- flat_depth:

  Directory mode only: `numeric` value indicating the depth at which the
  function should start pretending that all files and folders are on the
  same level. If `NULL`, every file's depth will be represented
  truthfully. Flattening the depth may prevent file tables from blowing
  up, but you may also consider not using the function on a very deep
  directory structure.

- skip_empty_base:

  Directory mode only: Should the first level be ignored if it contains
  no direct files? This is useful in creating control tables over many
  folders at once.

- header, content_box, remarks, footer:

  For each of these optional file sections, either a `character vector`
  of the specific text to be added in the corresponding place of the
  ReadMe file, a single valid
  [`file.path`](https://rdrr.io/r/base/file.path.html) to a control
  table with the text(s) in columns named "\[irrelevant\]\_\[`lang`\]"
  (i.e., "language-coded"), or a list with "language-coded" names that
  would result from importing the control table file(s).

- replace_id:

  Optional `character vector` of length 2 to replace an ID placeholder
  (in the FDZ context usually: "\_Antrag") with the specific ID (e.g.,
  "2601-01a"). The first element is a
  [regex](https://rdrr.io/r/base/regex.html) expression to be used as
  `pattern`, and replaced by the simple string in the second element of
  the vector. Usually, this only makes sense in table mode.

- include_rm:

  Optional `logical` argument: Should the ReadMe file be included in
  itself? Only applies if a file is created at `out_path`. If `NULL`
  (the default), a default setting depending on the function mode will
  be applied: `FALSE` in directory mode, and `TRUE` in table mode.

## Value

Depending on `create_table`, this function may return...

- `"none"` - By default, `NULL` will be returned.

- `"control"` - A `list` of `data.frame`s, one for each subdirectory.
  These `data.frame`s may be saved as individual control table files
  that could be used as input for this function's table mode. Each
  `data.frame` consists of at least three columns: `file_name` (names of
  individual files and lower subdirectories), `description` (default
  descriptions of each file; one column per `lang`), and `flag`
  (formatting flags to mirror the directory structure if reused in table
  mode).

- `"overview"` - A flat `data.frame` with at least four columns:
  `file_name`, `description`, as well as each file's `depth` and `group`
  (i.e. first-level directory).

- `"text"` - A `list` of one `character vector` per `lang` constituting
  the ReadMe text written to `out_path` if requested.

## Details

This function serves the general purpose of creating a ReadMe that
describes the contents of a folder/directory. While it can be used on an
existing directory, its main purpose is to create ReadMes for data
packages delivered to the Research Data Centre's data users. The
function has two modes, which are selected based on the content of
`in_path`:

1.  **Directory mode**: If `in_path` is a single `file.path` that does
    not lead to a (table) file, this function runs in directory mode. It
    will list all files in the supplied directory and all its
    subdirectories. While this can be used to create a simple ReadMe to
    give an overview of this directory, its main purpose is in creating
    control tables (see the `create_table` argument), which may then be
    enhanced with more specific file descriptions and reused by this
    function in table mode.

2.  **Table mode**: If `in_path` is a vector of at least one `file.path`
    that leads to a control table file, this function runs in table
    mode. It will load each control table, paste together all tables'
    contents, and apply formatting to reflect the described directory
    structure. This mode may be used to describe data packages that are
    themselves created from a fixed inventory of data products described
    in the control tables.

## Formatting

The appearance of the ReadMe file can be adjusted using a number of
arguments. File names and file descriptions are set in a two-column
table with a minimum `margin` between them and with the right column
starting no more to the left than at `col_width`. File names are
indented by x = `indent_per_level` spaces/blanks under the (sub)headline
of their respective folder names, which may themselves be indented under
their higher-level folder's names by the same number of spaces per
level, but no more than `max_indent`.

Additional text sections may be added. For table mode, it is recommended
to have one control table per section, with each table containing a
column named, e.g., "header_de" for a German header, that can be
supplied to the function. Currently, the following sections are
supported:

- `header` - A centrally aligned header to the whole file, for example,
  stating the name of the institution sending out the data package. It
  is added to the very top of the file. Aesthetic lines will be added
  above and below the header. The line styles are not yet customisable,
  but this functionality may be added on request.

- `content_box` - A higher-level table of contents, further abstracting
  from the detailed file table below. It is added between the header and
  the main body/file table. The contents are indented by one tab, and
  aesthetic lines will be added above and below. It may be used to list
  the "intermediate" data product packages/"studies" of the overall data
  package.

- `remarks` - A section of additional remarks about using the data. It
  is added below the main body/file table with a simple header above it.
  The header is not yet customisable, but this functionality may be
  added.

- `footer` - A footer section added to the very end of the file with
  decorative lines above and below. Use this to present, e.g., contact
  information.

## Control tables

This function's table mode uses "control tables" as input, which have to
meet certain criteria. First, only `.csv` and `.xlsx` files are being
supported so far. Second, each file has to include at least the
following three columns with the column names in the first row:

- `file_name` - The name of the file to be described. Placeholder
  sections may be used in the file name, which could then be replaced by
  setting the `replace_id` argument.

- `description` - The description of the file, e.g., its content or
  intended range of use. One or more description columns are allowed to
  describe the same file in different languages. Each description column
  has to end with the language acronym (e.g., `_de`). This/these columns
  can also be used to set (language-specific) headers instead of the
  folder name.

- `flag` - Either empty or a formatting flag. Regular files should have
  an empty cell here. Two flags are supported so far: `header` marks the
  section's header. `subheader/x` marks a subheader for a subsection. In
  the subheader flag, `x` indicates the subsection's level relative to
  the overall header as an integer number with higher values signifying
  deeper levels. All files under a subheader are considered to belong to
  this subsection. Each subsection is separated from the other
  subsections by empty lines. If `indent_per_level` is \> 0, each file
  will be indented relative to its (sub)header and each subheader will
  be indented relative to the overall header, which is never indented.

## Examples

``` r
# Create dummy directory
somedir <- tempfile("example")
dir.create(somedir)
dir.create(file.path(somedir, "literature"))
dir.create(file.path(somedir, "data"))
file.create(file.path(somedir, "data", c("a_text.txt", "my_data.csv")))
#> [1] TRUE TRUE
file.create(file.path(somedir, "literature", "Rucker_Weigt_Burblies_Schipolowski_2026.pdf"))
#> [1] TRUE

# Directory mode
createReadMe(somedir, lang = "en", create_table = "overview")
#>                                     file_name              description_en depth
#> 1                         example1c64736a310f                                 0
#> 2                    example1c64736a310f/data                                 1
#> 3                                  a_text.txt              ReadMe in data     1
#> 4                                 my_data.csv             Dataset in data     1
#> 5              example1c64736a310f/literature                                 1
#> 6 Rucker_Weigt_Burblies_Schipolowski_2026.pdf Documentation in literature     1
#>                            group
#> 1            example1c64736a310f
#> 2       example1c64736a310f/data
#> 3       example1c64736a310f/data
#> 4       example1c64736a310f/data
#> 5 example1c64736a310f/literature
#> 6 example1c64736a310f/literature

control_table <- createReadMe(somedir, lang = "en", create_table = "control")
control_table
#> $example1c64736a310f
#>                                     file_name              description_en
#> 1                         example1c64736a310f                            
#> 2                    example1c64736a310f/data                            
#> 3                                  a_text.txt              ReadMe in data
#> 4                                 my_data.csv             Dataset in data
#> 5              example1c64736a310f/literature                            
#> 6 Rucker_Weigt_Burblies_Schipolowski_2026.pdf Documentation in literature
#>          flag
#> 1      header
#> 2 subheader/1
#> 3            
#> 4            
#> 5 subheader/1
#> 6            
#> 
write.table(control_table, file.path(somedir, "ReadMeControl.csv"), sep = ",",
            row.names = FALSE, col.names = c("file_name", "description_en", "flag"))

# Table mode
read.csv(file.path(somedir, "ReadMeControl.csv"))
#>                                     file_name              description_en
#> 1                         example1c64736a310f                            
#> 2                    example1c64736a310f/data                            
#> 3                                  a_text.txt              ReadMe in data
#> 4                                 my_data.csv             Dataset in data
#> 5              example1c64736a310f/literature                            
#> 6 Rucker_Weigt_Burblies_Schipolowski_2026.pdf Documentation in literature
#>          flag
#> 1      header
#> 2 subheader/1
#> 3            
#> 4            
#> 5 subheader/1
#> 6            
createReadMe(file.path(somedir, "ReadMeControl.csv"), lang = "en", create_table = "text",
             sep = ",", header = c("This", "is a", "HUGE HEADER"))
#> $en
#>                                                                                                                           
#> "_______________________________________________________________________________________________________________________" 
#>                                                                                                                           
#> "¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯" 
#>                                                                                                                      This 
#>                                                                                     " \t\t\t\t\t\t\tThis  \t\t\t\t\t\t\t" 
#>                                                                                                                      is a 
#>                                                                                     " \t\t\t\t\t\t\tis a  \t\t\t\t\t\t\t" 
#>                                                                                                               HUGE HEADER 
#>                                                                         "      \t\t\t\t\t\tHUGE HEADER      \t\t\t\t\t\t" 
#>                                                                                                                           
#> "_______________________________________________________________________________________________________________________" 
#>                                                                                                                           
#> "¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯" 
#>                                                                                                                           
#>                                                                                                                        "" 
#>                                                                                                                           
#>                                                                                                                        "" 
#>                                                                                                                           
#>                                                                                                     "[ C O N T E N T S ]" 
#>                                                                                                                           
#> "¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯" 
#>                                                                                                                           
#>                                                                                                                        "" 
#>                                                                                                                           
#>                                                                                                                      "  " 
#>                                                                                                                           
#>                                                                    "    a_text.txt    \t\t\t\t\t\t\t\t\t- ReadMe in data" 
#>                                                                                                                           
#>                                                                   "    my_data.csv   \t\t\t\t\t\t\t\t\t- Dataset in data" 
#>                                                                                                                           
#>                                                                                                                        "" 
#>                                                                                                                           
#>                                                                                                                      "  " 
#>                                                                                                                           
#>                               "    Rucker_Weigt_Burblies_Schipolowski_2026.pdf   \t\t\t\t\t- Documentation in literature" 
#> 

# Clean-up
unlink(somedir, recursive = TRUE)

```
