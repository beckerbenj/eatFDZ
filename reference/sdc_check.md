# Create a Statistical Disclosure Control Report

This function generates a statistical disclosure control (SDC) report,
identifying variables with categories that have low absolute
frequencies. Such low-frequency categories could potentially lead to
statistical data disclosure issues, particularly in datasets involving
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
sav_path <- system.file("extdata", "LV_2011_CF.sav", package = "eatFDZ")

# Exclude unique identifier variables from the SDC check
exclude_vars <- c("idstud_FDZ", "idsch_FDZ")

# Generate the SDC report
sdc_report <- sdc_check(fileName = sav_path, boundary = 5, exclude = exclude_vars)

# Print the SDC report
print(sdc_report)
#>                 variable
#> 1             idstud_FDZ
#> 2              idsch_FDZ
#> 3                wgtSTUD
#> 4                 JKZone
#> 5                  JKrep
#> 6                 tr_sex
#> 7                 tr_age
#> 8                  Emigr
#> 9                  EDezh
#> 10                EHisei
#> 11           EHisced_akt
#> 12                ESfmwC
#> 13                ESfmvC
#> 14              SBuecher
#> 15                SLesZt
#> 16              tr_NotDe
#> 17              tr_NotMa
#> 18              tr_Ueber
#> 19              tr_Wdh_r
#> 20               SSkDe_a
#> 21               SSkDe_b
#> 22               SSkDe_c
#> 23               SSkDe_d
#> 24               SSkMa_a
#> 25               SSkMa_b
#> 26               SSkMa_c
#> 27               SSkMa_d
#> 28              SBezMs_a
#> 29              SBezMs_b
#> 30              SBezMs_c
#> 31              SBezMs_d
#> 32                 SSkDe
#> 33                 SSkMa
#> 34                SBezMs
#> 35                SKFTN2
#> 36                SKFTV1
#> 37             wle_lesen
#> 38            wle_hoeren
#> 39             wle_mathe
#> 40            pv01_lesen
#> 41            pv02_lesen
#> 42            pv03_lesen
#> 43            pv04_lesen
#> 44            pv05_lesen
#> 45           pv01_hoeren
#> 46           pv02_hoeren
#> 47           pv03_hoeren
#> 48           pv04_hoeren
#> 49           pv05_hoeren
#> 50            pv01_mathe
#> 51            pv02_mathe
#> 52            pv03_mathe
#> 53            pv04_mathe
#> 54            pv05_mathe
#> 55 Version_v2_09.01.2020
#>                                                                                             varLab
#> 1                                                                                Schueler-ID (FDZ)
#> 2                                                                                   Schul-ID (FDZ)
#> 3                                                                            Schuelergesamtgewicht
#> 4                                                                                   Jackknife Zone
#> 5                                                                              Jackknife Replicate
#> 6                                                                                       Geschlecht
#> 7                                                                                            Alter
#> 8                                                Zuwanderungshintergrund der Eltern (Elternangabe)
#> 9                                                                  Deutsch zu Hause (Elternangabe)
#> 10        HISEI - Highest International Socio-economic Index of Occupational Status (Elternangabe)
#> 11 HISCED 1997: Int. hoechster Schul- und Berufsausbildungsabschluss in der Familie (Elternangabe)
#> 12                                  Gewuenschte Schulart fuer Kind nach Grundschule (Elternangabe)
#> 13                             Voraussichtliche Schulart fuer Kind nach Grundschule (Elternangabe)
#> 14                                                                                Buecher zu Hause
#> 15                                                                                        Lesezeit
#> 16                                                                          Halbjahresnote Deutsch
#> 17                                                                            Halbjahresnote Mathe
#> 18                                                          Empfehlung fuer weiterfuehrende Schule
#> 19                                                                         Klassenstufe wiederholt
#> 20                                                                Selbstkonzept Deutsch: zufrieden
#> 21                                              Selbstkonzept Deutsch: muss mehr lernen als andere
#> 22                                                      Selbstkonzept Deutsch: verstehe das meiste
#> 23                                        Selbstkonzept Deutsch: kann Aufgaben meistens gut loesen
#> 24                                                                  Selbstkonzept Mathe: zufrieden
#> 25                                                Selbstkonzept Mathe: muss mehr lernen als andere
#> 26                                                        Selbstkonzept Mathe: verstehe das meiste
#> 27                                          Selbstkonzept Mathe: kann Aufgaben meistens gut loesen
#> 28                                               Soziale Integration: Mitschueler sind nett zu mir
#> 29                                                  Soziale Integration: Mitschueler troesten mich
#> 30                                                             Soziale Integration: wenige Freunde
#> 31                                          Soziale Integration: die anderen suchen Streit mit mir
#> 32                                                          Skalenmittelwert Selbstkonzept Deutsch
#> 33                                                            Skalenmittelwert Selbstkonzept Mathe
#> 34                                                            Skalenmittelwert Soziale Integration
#> 35                                                  Summenscore Kognitive Faehigkeiten (nonverbal)
#> 36                                                     Summenscore Kognitive Faehigkeiten (verbal)
#> 37                                                                           Kompetenzen Lesen WLE
#> 38                                                                        Kompetenzen Zuhoeren WLE
#> 39                                                                      Kompetenzen Mathematik WLE
#> 40                                                                           Kompetenzen Lesen PV1
#> 41                                                                           Kompetenzen Lesen PV2
#> 42                                                                           Kompetenzen Lesen PV3
#> 43                                                                           Kompetenzen Lesen PV4
#> 44                                                                           Kompetenzen Lesen PV5
#> 45                                                                        Kompetenzen Zuhoeren PV1
#> 46                                                                        Kompetenzen Zuhoeren PV2
#> 47                                                                        Kompetenzen Zuhoeren PV3
#> 48                                                                        Kompetenzen Zuhoeren PV4
#> 49                                                                        Kompetenzen Zuhoeren PV5
#> 50                                                                      Kompetenzen Mathematik PV1
#> 51                                                                      Kompetenzen Mathematik PV2
#> 52                                                                      Kompetenzen Mathematik PV3
#> 53                                                                      Kompetenzen Mathematik PV4
#> 54                                                                      Kompetenzen Mathematik PV5
#> 55                                                                            internes Kennzeichen
#>    existVarLab existValLab     skala nKatOhneMissings nValid  nKl5 exclude
#> 1         TRUE       FALSE   numeric             3005   3005  TRUE    TRUE
#> 2         TRUE       FALSE   numeric              201   3005  TRUE    TRUE
#> 3         TRUE       FALSE   numeric             3005   3005  TRUE   FALSE
#> 4         TRUE       FALSE   numeric               87   3005 FALSE   FALSE
#> 5         TRUE       FALSE   numeric                2   3005 FALSE   FALSE
#> 6         TRUE        TRUE   numeric                2   3005 FALSE   FALSE
#> 7         TRUE        TRUE   numeric               45   2998  TRUE   FALSE
#> 8         TRUE        TRUE   numeric                2   2459 FALSE   FALSE
#> 9         TRUE        TRUE   numeric                2   2537 FALSE   FALSE
#> 10        TRUE        TRUE   numeric               69   2383  TRUE   FALSE
#> 11        TRUE        TRUE   numeric                6   2520 FALSE   FALSE
#> 12        TRUE        TRUE   numeric                2   2516 FALSE   FALSE
#> 13        TRUE        TRUE   numeric                2   2526 FALSE   FALSE
#> 14        TRUE        TRUE   numeric                5   2935 FALSE   FALSE
#> 15        TRUE        TRUE   numeric                4   2908 FALSE   FALSE
#> 16        TRUE        TRUE   numeric                5   2874 FALSE   FALSE
#> 17        TRUE        TRUE   numeric                5   2878 FALSE   FALSE
#> 18        TRUE        TRUE   numeric                6   2947 FALSE   FALSE
#> 19        TRUE        TRUE   numeric                2   2998 FALSE   FALSE
#> 20        TRUE        TRUE   numeric                4   2913 FALSE   FALSE
#> 21        TRUE        TRUE   numeric                4   2884 FALSE   FALSE
#> 22        TRUE        TRUE   numeric                4   2879 FALSE   FALSE
#> 23        TRUE        TRUE   numeric                4   2882 FALSE   FALSE
#> 24        TRUE        TRUE   numeric                4   2923 FALSE   FALSE
#> 25        TRUE        TRUE   numeric                4   2890 FALSE   FALSE
#> 26        TRUE        TRUE   numeric                4   2884 FALSE   FALSE
#> 27        TRUE        TRUE   numeric                4   2903 FALSE   FALSE
#> 28        TRUE        TRUE   numeric                4   2841 FALSE   FALSE
#> 29        TRUE        TRUE   numeric                4   2806 FALSE   FALSE
#> 30        TRUE        TRUE   numeric                4   2832 FALSE   FALSE
#> 31        TRUE        TRUE   numeric                4   2833 FALSE   FALSE
#> 32        TRUE        TRUE   numeric               19   2910  TRUE   FALSE
#> 33        TRUE        TRUE   numeric               19   2920  TRUE   FALSE
#> 34        TRUE        TRUE   numeric               17   2860 FALSE   FALSE
#> 35        TRUE        TRUE   numeric               25   3000  TRUE   FALSE
#> 36        TRUE        TRUE   numeric               24   1513  TRUE   FALSE
#> 37        TRUE        TRUE   numeric             3005   3005  TRUE   FALSE
#> 38        TRUE        TRUE   numeric             3005   3005  TRUE   FALSE
#> 39        TRUE        TRUE   numeric             3005   3005  TRUE   FALSE
#> 40        TRUE        TRUE   numeric             3005   3005  TRUE   FALSE
#> 41        TRUE        TRUE   numeric             3005   3005  TRUE   FALSE
#> 42        TRUE        TRUE   numeric             3005   3005  TRUE   FALSE
#> 43        TRUE        TRUE   numeric             3005   3005  TRUE   FALSE
#> 44        TRUE        TRUE   numeric             3005   3005  TRUE   FALSE
#> 45        TRUE        TRUE   numeric             3005   3005  TRUE   FALSE
#> 46        TRUE        TRUE   numeric             3005   3005  TRUE   FALSE
#> 47        TRUE        TRUE   numeric             3005   3005  TRUE   FALSE
#> 48        TRUE        TRUE   numeric             3005   3005  TRUE   FALSE
#> 49        TRUE        TRUE   numeric             3005   3005  TRUE   FALSE
#> 50        TRUE        TRUE   numeric             3005   3005  TRUE   FALSE
#> 51        TRUE        TRUE   numeric             3005   3005  TRUE   FALSE
#> 52        TRUE        TRUE   numeric             3005   3005  TRUE   FALSE
#> 53        TRUE        TRUE   numeric             3005   3005  TRUE   FALSE
#> 54        TRUE        TRUE   numeric             3005   3005  TRUE   FALSE
#> 55        TRUE       FALSE character                1   3005 FALSE   FALSE
```
