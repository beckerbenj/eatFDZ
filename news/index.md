# Changelog

## eatFDZ 0.7.1

- fixed
  [`compare_data()`](https://beckerbenj.github.io/eatFDZ/reference/compare_data.md)
  for cases with meta data differences either only on value or only
  variable level
- [`compare_data()`](https://beckerbenj.github.io/eatFDZ/reference/compare_data.md)
  now uses
  [`eatGADS::equalMeta()`](https://beckerbenj.github.io/eatGADS/reference/equalGADS.html)
  instead of
  [`eatGADS::equalGADS()`](https://beckerbenj.github.io/eatGADS/reference/equalGADS.html),
  reducing unnecessary overhead
- renamed
  [`compare_data()`](https://beckerbenj.github.io/eatFDZ/reference/compare_data.md)
  output (#30)

## eatFDZ 0.7.0

- Initial Github release.
