# FDZ Data Cleaning

This vignette illustrates how the [Research Data
Centre](https://www.iqb.hu-berlin.de/fdz) (FDZ) at the [Institute for
Educational Quality Improvement](https://www.iqb.hu-berlin.de/) (IQB)
cleans and tidies data for secondary usage purposes. For secondary
usage, data is expected to be of high quality, traceable,
comprehensible, and anonymized. Furthermore, meaningful metadata should
enable secondary users to understand the data. For this purpose,
operations such as recoding of identifier variables, emptying variables,
changing labels, creating grouping variables, and many more are
performed and therefore discussed in this vignette. Overall, the
following aspects should be adressed when cleaning data:

- Removing all non-ASCII characters
- Setting appropriate missing tags
- Adding non-informative identifier variables
- Converting strings to labeled numeric variables
- Anonymization of variables
- Adding variable and value labels

The setup for this illustration is the following:

``` r
## if necessary, install eatGADS and eatFDZ
#install.packages("eatGADS")
#remotes::install_github("beckerbenj/eatFDZ")

# load eatGADS
library(eatGADS)

# path to example data set
sav_path <- system.file("extdata", "example_data.sav", package = "eatFDZ")
```

`eatGADS` is the R package used by the FDZ at IQB for data cleaning
purposes. It is available on
[CRAN](https://cran.r-project.org/package=eatGADS) and extensively
documented via vignettes (e.g., the [Comprehensive Data Cleaning
Guide](https://beckerbenj.github.io/eatGADS/articles/data_cleaning.html)).

For illustrative purposes, a small, artificial SPSS example data set of
secondary school students in Berlin is used. The data set is
intentionally flawed and messy. The example data set is part of the
`eatFDZ` package and installed alongside.

## Loading the data

``` r
dat <- import_spss(sav_path)
str(dat$dat) # for a small overview in the variables of the data set
```

    ## 'data.frame':    10 obs. of  15 variables:
    ##  $ ID        : chr  "BY1342" "RP7763" "ST1213" "NW5763" ...
    ##  $ ID_name   : chr  "Finn" "Lukas" "Malia" "Lennard" ...
    ##  $ info      : chr  "Father Markus helps with homework" "family always goes to Cortina ice cream parlor after school" "-97" "big sister is student representative" ...
    ##  $ sex       : num  1 1 2 1 2 1 1 2 2 1
    ##  $ subjfav   : chr  "Math" "Physical Education" "Chemistry" "Art" ...
    ##  $ age       : num  14 15 14 14 13 15 14 17 14 13
    ##  $ siblings  : num  -9 0 2 1 35 0 1 0 3 1
    ##  $ home      : num  1 1 1 1 2 2 1 1 2 -98
    ##  $ birth     : chr  "01/11/2009" "05/23/2007" "08/31/2008" "12/07/2008" ...
    ##  $ books     : num  6 4 -99 1 NA 2 3 2 4 5
    ##  $ school    : num  4 -99 -98 3 -99 2 3 -97 4 4
    ##  $ grade_math: num  1 3 4 2 6 2 3 5 4 1
    ##  $ grade_germ: num  2 3 2 6 5 4 2 1 1 2
    ##  $ grade_eng : num  3 4 1 3 2 3 5 2 1 6
    ##  $ career    : chr  "scientist" "sport psychologist" "-99" "graphic designer" ...

The data set is loaded via the
[`import_spss()`](https://beckerbenj.github.io/eatGADS/reference/import_spss.html)
command. The data set contains 14 variables with 10 observations,
including demographic variables such as age and sex of the students,
their family situation and selected grades.

Note that the data set is imported as a `GADSdat` object. For detailed
explanations on the corresponding object structure and technical
details, we refer readers to the `eatGADS`
[documentation](https://beckerbenj.github.io/eatGADS/articles/import_spss.html).

## Removing all non-ASCII characters

Non-ASCII characters frequently lead to issues depending on the
operating system and statistical software used. If your data contains
non-ASCII characters, it might cause compatibility issues or errors when
processing the data.
[`fixEncoding()`](https://beckerbenj.github.io/eatGADS/reference/fixEncoding.html)
removes non-ASCII characters from a character vector or a `GADSdat`
object.

``` r
dat$dat$ID_name
```

    ##  [1] "Finn"    "Lukas"   "Malia"   "Lennard" "Jule"    "Gerrit"  "Emil"   
    ##  [8] "Mila"    "Clara"   "Malek"

``` r
dat <- fixEncoding(dat, input = "other")
dat$dat$ID_name
```

    ##  [1] "Finn"    "Lukas"   "Malia"   "Lennard" "Jule"    "Gerrit"  "Emil"   
    ##  [8] "Mila"    "Clara"   "Malek"

The non-ASCII character in the ID name has been changed to `ae`.

## Defining missings semi-automatically

A crucial meta data property for SPSS data are **missing tags**.
Sometimes not all missing values are correctly tagged as missing. Via
`eatGADS`, missing tags can be corrected semi-automatically. This can
either be done based on wordings of existing value labels
([`checkMissings()`](https://beckerbenj.github.io/eatGADS/reference/checkMissings.html))
or based on a value range of existing value labels
([`checkMissingsByValues()`](https://beckerbenj.github.io/eatGADS/reference/checkMissings.html)).

[`checkMissings()`](https://beckerbenj.github.io/eatGADS/reference/checkMissings.html)
tests whether a set of specified regular expressions occurs in the value
labels and compares the corresponding missing tags. For instance the
variable `books` contains a value label `omitted`, which has not been
tagged as missing.

``` r
extractMeta(dat, vars = c("books")) # usually, we wouldn't know yet that this variable contains these value labels. This is for demonstration purposes to see the before and after effect of the function
```

    ##    varName                varLabel format display_width labeled value
    ## 12   books Number of books at home  F10.0            NA     yes   -99
    ## 13   books Number of books at home  F10.0            NA     yes     1
    ## 14   books Number of books at home  F10.0            NA     yes     2
    ## 15   books Number of books at home  F10.0            NA     yes     3
    ## 16   books Number of books at home  F10.0            NA     yes     4
    ## 17   books Number of books at home  F10.0            NA     yes     5
    ## 18   books Number of books at home  F10.0            NA     yes     6
    ##               valLabel missings
    ## 12             omitted    valid
    ## 13          0-10 books    valid
    ## 14         11-25 books    valid
    ## 15        26-100 books    valid
    ## 16       101-200 books    valid
    ## 17                        valid
    ## 18 more than 500 books    valid

``` r
missinglabels <- paste("missing", "unknown",
                       "omitted",
                       sep = "|")
dat1 <- checkMissings(dat, missingLabel = missinglabels)
```

    ## The following variables have value labels including the term 'missing|unknown|omitted' which are not coded as missing:
    ## books, school

    ## 'miss' is inserted into column missings for 3 rows.

``` r
extractMeta(dat1, vars = c("books"))
```

    ##    varName                varLabel format display_width labeled value
    ## 12   books Number of books at home  F10.0            NA     yes   -99
    ## 13   books Number of books at home  F10.0            NA     yes     1
    ## 14   books Number of books at home  F10.0            NA     yes     2
    ## 15   books Number of books at home  F10.0            NA     yes     3
    ## 16   books Number of books at home  F10.0            NA     yes     4
    ## 17   books Number of books at home  F10.0            NA     yes     5
    ## 18   books Number of books at home  F10.0            NA     yes     6
    ##               valLabel missings
    ## 12             omitted     miss
    ## 13          0-10 books    valid
    ## 14         11-25 books    valid
    ## 15        26-100 books    valid
    ## 16       101-200 books    valid
    ## 17                        valid
    ## 18 more than 500 books    valid

[`checkMissings()`](https://beckerbenj.github.io/eatGADS/reference/checkMissings.html)
has now automatically tagged the value `-99` with the label `omitted` as
missing (`miss`).

[`checkMissingsByValues()`](https://beckerbenj.github.io/eatGADS/reference/checkMissings.html)
checks whether value labels exist for a specified range of numeric
values and whether missing tags are provided accordingly:

``` r
extractMeta(dat1, vars = c("school")) # usually, we wouldn't know yet that this variable contains these value labels. This is for demonstration purposes to see the before and after effect of the function
```

    ##    varName varLabel format display_width labeled value                 valLabel
    ## 19  school      XXX   F8.2            NA     yes   -99                  omitted
    ## 20  school      XXX   F8.2            NA     yes   -98           unclear answer
    ## 21  school      XXX   F8.2            NA     yes   -97                  unknown
    ## 22  school      XXX   F8.2            NA     yes     1              Hauptschule
    ## 23  school      XXX   F8.2            NA     yes     2               Realschule
    ## 24  school      XXX   F8.2            NA     yes     3 Integrierte Gesamtschule
    ## 25  school      XXX   F8.2            NA     yes     4                Gymnasium
    ##    missings
    ## 19     miss
    ## 20    valid
    ## 21     miss
    ## 22    valid
    ## 23    valid
    ## 24    valid
    ## 25    valid

``` r
dat2 <- checkMissingsByValues(dat1, missingValues = -50:-99)
```

    ## The following variables have values in the 'missingValues' range which are not coded as missing:
    ## school

    ## 'miss' is inserted into column missings for 1 rows.

``` r
extractMeta(dat2, vars = c("school"))
```

    ##    varName varLabel format display_width labeled value                 valLabel
    ## 19  school      XXX   F8.2            NA     yes   -99                  omitted
    ## 20  school      XXX   F8.2            NA     yes   -98           unclear answer
    ## 21  school      XXX   F8.2            NA     yes   -97                  unknown
    ## 22  school      XXX   F8.2            NA     yes     1              Hauptschule
    ## 23  school      XXX   F8.2            NA     yes     2               Realschule
    ## 24  school      XXX   F8.2            NA     yes     3 Integrierte Gesamtschule
    ## 25  school      XXX   F8.2            NA     yes     4                Gymnasium
    ##    missings
    ## 19     miss
    ## 20     miss
    ## 21     miss
    ## 22    valid
    ## 23    valid
    ## 24    valid
    ## 25    valid

The previous function had already tagged two of the missings correctly,
but the value label `-98` with the value label `unclear answer` was not
used. Now, it is contained in the specified range and therefore tagged
as a missing.

## Defining missing values by hand

At times, only individual missings need to be tagged.
[`changeMissings()`](https://beckerbenj.github.io/eatGADS/reference/changeMissings.html)
tags missing values as missings by specifying them under `value` and
marks them as `miss` under `missings.`

``` r
extractMeta(dat2, vars = c("info"))
```

    ##   varName      varLabel format display_width labeled value valLabel missings
    ## 3    info General notes     A8            NA      no    NA     <NA>     <NA>

``` r
dat3 <- changeMissings(dat2, varName = "info", value = c("-97", "-98", "-99"), missings = c("miss", "miss", "miss"))
extractMeta(dat3, vars = c("info"))
```

    ##   varName      varLabel format display_width labeled value valLabel missings
    ## 3    info General notes     A8            NA     yes   -99     <NA>     miss
    ## 4    info General notes     A8            NA     yes   -98     <NA>     miss
    ## 5    info General notes     A8            NA     yes   -97     <NA>     miss

The values `-97`, `-98` and `-99` are now tagged as `miss`.

Changing the missing tags is also possible for multiple variables at the
same time using
[`changeMissings()`](https://beckerbenj.github.io/eatGADS/reference/changeMissings.html).

``` r
extractMeta(dat2, vars = c("info", "career"))
```

    ##    varName          varLabel format display_width labeled value valLabel
    ## 3     info     General notes     A8            NA      no    NA     <NA>
    ## 29  career Career aspiration     A8            NA      no    NA     <NA>
    ##    missings
    ## 3      <NA>
    ## 29     <NA>

``` r
dat3 <- changeMissings(dat2, varName = c("info", "career"), value = c("-97", "-98", "-99"), missings = c("miss", "miss", "miss"))
extractMeta(dat3, vars = c("info", "career"))
```

    ##    varName          varLabel format display_width labeled value valLabel
    ## 3     info     General notes     A8            NA     yes   -99     <NA>
    ## 4     info     General notes     A8            NA     yes   -98     <NA>
    ## 5     info     General notes     A8            NA     yes   -97     <NA>
    ## 31  career Career aspiration     A8            NA     yes   -99     <NA>
    ## 32  career Career aspiration     A8            NA     yes   -98     <NA>
    ## 33  career Career aspiration     A8            NA     yes   -97     <NA>
    ##    missings
    ## 3      miss
    ## 4      miss
    ## 5      miss
    ## 31     miss
    ## 32     miss
    ## 33     miss

Here, the values for both variables were simultaneously tagged as
missings.

## Recoding IDs

ID variables are recoded so no hidden identifiers such as state, school
or even name codes allow conclusions to be drawn about individual
persons. To ensure that the IDs remain the same across multiple subsets
and describe the same person, they are recoded using a template. First,
a path for the template is created.

``` r
f <- tempfile()
ID_recode_template <- file.path("f") # use your own file path instead of the tempfile
```

Then there are two options: Creating a new template (option 1 - for the
first subset) or applying an existing template (option 2 - for the
following subsets).

### Option 1: Recoding IDs with creation of a template as .csv

[`autoRecode()`](https://beckerbenj.github.io/eatGADS/reference/autoRecode.html)
creates a recoding template for the variable `ID`, saved as a .csv file,
and in the course of this a new variable with the variable suffix `_FDZ`
and an explanatory label suffix.

``` r
dat3 <- autoRecode(dat3, var = "ID", var_suffix = "_FDZ", csv_path = ID_recode_template, label_suffix = " (recoded by FDZ)")
```

### Option 2: Recoding IDs with application of a template (e.g. created by a previously prepared, different data set).

Already existing templates can be used for following subsets.
[`read.csv()`](https://rdrr.io/r/utils/read.table.html) imports the
template, which can be applied with
[`autoRecode()`](https://beckerbenj.github.io/eatGADS/reference/autoRecode.html)

``` r
template <- read.csv(ID_recode_template)
dat3 <- autoRecode(dat3, var = "ID", suffix = "_FDZ", csv_path = ID_recode_template, template = template,
                   label_suffix = "(rekodiert FDZ)") # Apply template and overwrite
```

[`removeVars()`](https://beckerbenj.github.io/eatGADS/reference/extractVars.html)
deletes variables from the data set. In this case, the old ID variable
is deleted.

``` r
dat3 <- removeVars(dat3, vars = c("ID"))
```

## Converting string variables to numeric variables

For (semi)open variables there are two procedures. If it is possible
(e.g., for a small data set) to go through all responses to check
whether there are no strong privacy violations or insults included, the
variables are converted into numeric ones and then emptied in the
Scientific Use Files. Thereby, the information remain accessible on a
meta-level, but can no longer be assigned to a person. If there are too
many responses to check or privacy cannot be granted, the variable is
emptied entirely in the Scientific Use Files. To convert the string
variables into numeric ones, all string variables are identified first.

``` r
all_types <- do.call(rbind, lapply(namesGADS(dat3), function(nam) data.frame(varName = nam, type = class(dat3$dat[[nam]]))))
all_types[all_types$type == "character", ]
```

    ##    varName      type
    ## 1       ID character
    ## 2  ID_name character
    ## 3     info character
    ## 5  subjfav character
    ## 9    birth character
    ## 15  career character

In this case the variables `ID_name`, `info`, `subjfav` and `birth` were
recognized as string variables. In the next step they are converted.

### Option 1: Converting all string variables automatically (overwrite variables)

[`multiChar2fac()`](https://beckerbenj.github.io/eatGADS/reference/multiChar2fac.html)
converts the string variables identified in advance into numeric
variables using a for loop.

``` r
charNames <- all_types[all_types$type == "character", "varName"]
for(charName in charNames) {
  dat4 <- multiChar2fac(dat3, vars = charName, var_suffix = "", label_suffix = "")
}
```

### Option 2: Converting string variable individually

[`multiChar2fac()`](https://beckerbenj.github.io/eatGADS/reference/multiChar2fac.html)
converts the string variables named in `vars` individually into numeric
variables. If the option `var_suffix` is used, a new variable is
created.

``` r
dat4 <- multiChar2fac(dat4, vars = c("ID_name", "info", "subjfav", "birth"), var_suffix = "_FDZ", label_suffix = "")
```

If the `var_suffix` option is left blank, the existing variable is
overwritten.

``` r
dat4 <- multiChar2fac(dat4, vars = c("ID_name", "info", "subjfav", "birth"), var_suffix = "", label_suffix = "")
```

## Emptying variables

Variables that may not even be offered via a remote computing system due
to strong data protection concerns are emptied for all data sets.
[`emptyTheseVariables()`](https://beckerbenj.github.io/eatGADS/reference/emptyTheseVariables.html)
empties the listed variables and adds an explanation to the variable
label on why the information was removed.

``` r
extractMeta(dat4, vars = c("info", "ID_name"))
```

    ##   varName      varLabel format display_width labeled value valLabel missings
    ## 2 ID_name           XXX     A8            NA      no    NA     <NA>     <NA>
    ## 3    info General notes     A8            NA     yes   -99     <NA>     miss
    ## 4    info General notes     A8            NA     yes   -98     <NA>     miss
    ## 5    info General notes     A8            NA     yes   -97     <NA>     miss

``` r
dat4_empty <- c("info",
                "ID_name")
dat5 <- emptyTheseVariables(dat4,
                            vars = dat4_empty,
                            label_suffix = " (Zur Anonymisierung geleert (FDZ))")
extractMeta(dat5, vars = c("info", "ID_name"))
```

    ##   varName                                          varLabel format
    ## 2 ID_name           XXX  (Zur Anonymisierung geleert (FDZ))     A8
    ## 3    info General notes  (Zur Anonymisierung geleert (FDZ))     A8
    ## 4    info General notes  (Zur Anonymisierung geleert (FDZ))     A8
    ## 5    info General notes  (Zur Anonymisierung geleert (FDZ))     A8
    ##   display_width labeled value valLabel missings
    ## 2            NA      no    NA     <NA>     <NA>
    ## 3            NA     yes   -99     <NA>     miss
    ## 4            NA     yes   -98     <NA>     miss
    ## 5            NA     yes   -97     <NA>     miss

`dat4` corresponds to the data set, `vars` lists the variables to be
emptied and `label_suffix` automatically adds the explanation to the
variable label indicating that the data has been emptied for
anonymization reasons.

## Changing variable and value labels

Variable and value labels help us with the traceability and
comprehensibility of a data set. `ChangeVarLabels()` selects the
variable to be changed with `varName` and assigns the corresponding
label with `varLabel`. `ChangeValLabels()` works in a similar way, the
corresponding value is selected in `value` and the label for this value
is created with `valLabel`.

1.  Changing variable labels

``` r
extractMeta(dat5, vars = c("school"))
```

    ##    varName varLabel format display_width labeled value                 valLabel
    ## 21  school      XXX   F8.2            NA     yes   -99                  omitted
    ## 22  school      XXX   F8.2            NA     yes   -98           unclear answer
    ## 23  school      XXX   F8.2            NA     yes   -97                  unknown
    ## 24  school      XXX   F8.2            NA     yes     1              Hauptschule
    ## 25  school      XXX   F8.2            NA     yes     2               Realschule
    ## 26  school      XXX   F8.2            NA     yes     3 Integrierte Gesamtschule
    ## 27  school      XXX   F8.2            NA     yes     4                Gymnasium
    ##    missings
    ## 21     miss
    ## 22     miss
    ## 23     miss
    ## 24    valid
    ## 25    valid
    ## 26    valid
    ## 27    valid

``` r
dat6 <- changeVarLabels(dat5, varName = "school", varLabel = "School type")
extractMeta(dat6, vars = c("school"))
```

    ##    varName    varLabel format display_width labeled value
    ## 21  school School type   F8.2            NA     yes   -99
    ## 22  school School type   F8.2            NA     yes   -98
    ## 23  school School type   F8.2            NA     yes   -97
    ## 24  school School type   F8.2            NA     yes     1
    ## 25  school School type   F8.2            NA     yes     2
    ## 26  school School type   F8.2            NA     yes     3
    ## 27  school School type   F8.2            NA     yes     4
    ##                    valLabel missings
    ## 21                  omitted     miss
    ## 22           unclear answer     miss
    ## 23                  unknown     miss
    ## 24              Hauptschule    valid
    ## 25               Realschule    valid
    ## 26 Integrierte Gesamtschule    valid
    ## 27                Gymnasium    valid

2.  Changing value labels

``` r
extractMeta(dat6, vars = c("books"))
```

    ##    varName                varLabel format display_width labeled value
    ## 14   books Number of books at home  F10.0            NA     yes   -99
    ## 15   books Number of books at home  F10.0            NA     yes     1
    ## 16   books Number of books at home  F10.0            NA     yes     2
    ## 17   books Number of books at home  F10.0            NA     yes     3
    ## 18   books Number of books at home  F10.0            NA     yes     4
    ## 19   books Number of books at home  F10.0            NA     yes     5
    ## 20   books Number of books at home  F10.0            NA     yes     6
    ##               valLabel missings
    ## 14             omitted     miss
    ## 15          0-10 books    valid
    ## 16         11-25 books    valid
    ## 17        26-100 books    valid
    ## 18       101-200 books    valid
    ## 19                        valid
    ## 20 more than 500 books    valid

``` r
dat7 <- changeValLabels(dat6, varName = "books", value = 5, valLabel = "201-500 books")
extractMeta(dat7, vars = c("books"))
```

    ##    varName                varLabel format display_width labeled value
    ## 14   books Number of books at home  F10.0            NA     yes   -99
    ## 15   books Number of books at home  F10.0            NA     yes     1
    ## 16   books Number of books at home  F10.0            NA     yes     2
    ## 17   books Number of books at home  F10.0            NA     yes     3
    ## 18   books Number of books at home  F10.0            NA     yes     4
    ## 19   books Number of books at home  F10.0            NA     yes     5
    ## 20   books Number of books at home  F10.0            NA     yes     6
    ##               valLabel missings
    ## 14             omitted     miss
    ## 15          0-10 books    valid
    ## 16         11-25 books    valid
    ## 17        26-100 books    valid
    ## 18       101-200 books    valid
    ## 19       201-500 books    valid
    ## 20 more than 500 books    valid

## Forming grouping variables

Small case numbers pose a risk of anonymity. For variables with a number
of cases \<6, which are not ratings, feelings or opinions and that
contain sensitive information about individuals, it is advisable to
combine small numbers of cases into meaningful groups. To do so,
[`cloneVariable()`](https://beckerbenj.github.io/eatGADS/reference/cloneVariable.html)
creates a new \_FDZ variable by cloning the variable to be grouped. For
`varName` the original variable name is entered, for `new_varName` the
variable name including the appendix “\_FDZ”. The variable label is
automatically adjusted with the option `label_suffix`.
[`recodeGADS()`](https://beckerbenj.github.io/eatGADS/reference/recodeGADS.html)
replaces the old values (`oldValues`) by new ones (`newValues`) and
[`changeValLabels()`](https://beckerbenj.github.io/eatGADS/reference/changeValLabels.html)
changes the value labels of the new groupings.

``` r
extractMeta(dat7, vars = c("age"))
```

    ##   varName varLabel format display_width labeled value valLabel missings
    ## 9     age      Age  F10.0            NA      no    NA     <NA>     <NA>

``` r
dat8 <- cloneVariable(dat7, varName = "age", new_varName = "age_FDZ", label_suffix = " (Zur Anonymisierung aggregiert (FDZ))")
dat8 <- recodeGADS(dat8, varName = "age_FDZ", oldValues = c(13, 14, 15, 17),
                  newValues = c(13, 13, 15, 15))
dat8 <- changeValLabels(dat8, varName = "age_FDZ", value = c(13, 15), valLabel = c("13-14", "15-17"))
extractMeta(dat8, vars = c("age_FDZ"))
```

    ##    varName                                   varLabel format display_width
    ## 41 age_FDZ Age  (Zur Anonymisierung aggregiert (FDZ))  F10.0            NA
    ## 42 age_FDZ Age  (Zur Anonymisierung aggregiert (FDZ))  F10.0            NA
    ##    labeled value valLabel missings
    ## 41     yes    13    13-14    valid
    ## 42     yes    15    15-17    valid

Groupings for multiple variables can also be performed using a loop. For
this the variables are given a temporary name consisting of the variable
name and the suffix “\_FDZ”. `varname` represents each individual
variable, which was summarized before in `gr_var`. The individual steps
([`cloneVariable()`](https://beckerbenj.github.io/eatGADS/reference/cloneVariable.html),
[`recodeGADS()`](https://beckerbenj.github.io/eatGADS/reference/recodeGADS.html),[`changeValLabels()`](https://beckerbenj.github.io/eatGADS/reference/changeValLabels.html))
are therefore performed for each of the variables in turn.

``` r
extractMeta(dat8, vars = c("grade_math"))
```

    ##       varName          varLabel format display_width labeled value valLabel
    ## 28 grade_math Grade mathematics   F8.2            NA      no    NA     <NA>
    ##    missings
    ## 28     <NA>

``` r
dat9 <- dat8
gr_var <- c("grade_math", "grade_germ", "grade_eng")
for (varname in gr_var) {
  tempnewname <- paste0(varname, "_FDZ")
  dat9 <- cloneVariable(dat9, varName = varname,
                        new_varName = tempnewname, label_suffix = " (Zur Anonymisierung aggregiert (FDZ))")
  dat9 <- recodeGADS(dat9, varName = tempnewname,
                      oldValues = c(1:6),
                      newValues = c(rep(1,4),rep(2,2)))
  dat9 <- changeValLabels(dat9, varName = tempnewname, value = c(1, 2),
                           valLabel = c("passed", "not passed"))
}
extractMeta(dat9, vars = c("grade_math_FDZ"))
```

    ##           varName                                                 varLabel
    ## 43 grade_math_FDZ Grade mathematics  (Zur Anonymisierung aggregiert (FDZ))
    ## 44 grade_math_FDZ Grade mathematics  (Zur Anonymisierung aggregiert (FDZ))
    ##    format display_width labeled value   valLabel missings
    ## 43   F8.2            NA     yes     1     passed    valid
    ## 44   F8.2            NA     yes     2 not passed    valid

Now two groups have been created. The first group includes the students
with grades from 1-4, which means they have passed. In the other group,
there are the students with grades 5 and 6, which means they have not
passed. These groups were created for all three subjects Math, German
and English at once.

## Creating the version variable

To indicate the state of the data set, each data set is provided with a
version variable. It contains the version of the data record and the
date of the last change.
[`createVariable()`](https://beckerbenj.github.io/eatGADS/reference/createVariable.html)
creates this variable whereas
[`relocateVariable()`](https://beckerbenj.github.io/eatGADS/reference/relocateVariable.html)
places it at the beginning of the record so it has a consistent, visible
place.

``` r
version_name <- "Version_v1_2023_11"
dat10 <- createVariable(dat9, varName = version_name)
dat10 <- relocateVariable(dat10, var = version_name, after = NULL)
```

## Changing variable order

Newly created variables are initially placed at the end of a data set.
[`orderLike()`](https://beckerbenj.github.io/eatGADS/reference/orderLike.html)
rearranges the variables by specifying the variables in their new order.

``` r
dat11 <- orderLike(dat10, newOrder = c("Version_v1_2023_11", "ID", "ID_name", "info", "home", "birth", "age", "age_FDZ", "sex", "siblings", "books", "school", "subjfav", "grade_math", "grade_math_FDZ", "grade_germ", "grade_germ_FDZ", "grade_eng", "grade_eng_FDZ", "career"))
```

Often it is only a matter of individual variables that are supposed to
be sorted in, such as newly created grouping variables behind their
emptied original variable.
[`relocateVariable()`](https://beckerbenj.github.io/eatGADS/reference/relocateVariable.html)
sets the variables after the selected one.

``` r
dat11 <- relocateVariable(dat11, var = "age_FDZ", after = "age")
```

## Exporting the data

Once the data set has been cleaned, it can be saved. The export
functions
[`write_spss()`](https://beckerbenj.github.io/eatGADS/reference/write_spss.html)
and
[`write_stata()`](https://beckerbenj.github.io/eatGADS/reference/write_spss.html)
are offered for this purpose. The file paths must be adapted in each
case.

``` r
write_spss(dat11, filePath = "filePath.sav")
write_stata(dat11, filePath = "filePath.dta")
```
