Create Rough County Census Estimates
================
Ben Sabath
March 25, 2020

### Aggregation Plan

In order to allow for quick analysis of COVID data, we create rough
estimates of the county level of the various confounders often used in
our analysis.We do this by just averaging values for all of zip codes in
each county.

``` r
library(NSAPHutils)
set_threads()
library(data.table)
library(NSAPHplatform)
```

    ## 
    ## Attaching package: 'NSAPHplatform'

    ## The following object is masked from 'package:NSAPHutils':
    ## 
    ##     medicaid_csv_dir_to_fst

``` r
census_data <- fread("../data/census_data/census_interpolated_zips.csv")
census_data[, V1 := NULL]
county_crosswalk <- fread("/nfs/nsaph_ci3/ci3_confounders/locations/combined/zips_with_county.csv")
county_crosswalk <- county_crosswalk[, .(ZIP, fips)]
census_data <- merge(census_data, county_crosswalk, by = "ZIP")
census_data <- de_duplicate(census_data, id_vars = c("year", "zcta"))
census_data[, population := sum(population, na.rm = T), by  = c("fips", "year")]

census_data <- census_data[, lapply(.SD, mean, na.rm = T), by = c("fips", "year"), 
           .SDcols = setdiff(names(census_data), c("fips","year","ZIP","zcta"))]
fwrite(census_data, "../data/census_data/rough_county_interpolated.csv")
```
