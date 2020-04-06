Create Rough County NO2 Estimates
================
Ben Sabath
March 25, 2020

### Aggregation Plan

In order to allow for quick analysis of COVID data, we create rough
estimates of the county level of the NO2 previously aggregated to the
zip code level from the intiial 1km by 1km grids. We do this by just
averaging values for all of zip codes in each county. A better method
would be to create the county estimates directly from the grids, however
under short notice this method works well enough.

``` r
library(NSAPHutils)
set_threads()
library(data.table)

no2_data <- fread("../data/no2/all_years.csv")
county_crosswalk <- fread("/nfs/nsaph_ci3/scratch/locations/combined/zips_with_county.csv")
county_crosswalk <- county_crosswalk[, .(ZIP, fips)]
no2_data <- merge(no2_data, county_crosswalk, by = "ZIP")

no2_data <- no2_data[, .(no2 = mean(no2, na.rm = T)), by = c("fips", "year")]

fwrite(no2_data, "../data/no2_out/rough_county_no2.csv")
```
