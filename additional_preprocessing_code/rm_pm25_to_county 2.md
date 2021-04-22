Create Rough County PM2.5 Estimates
================
Ben Sabath
March 25, 2020

### Aggregation Plan

In order to allow for quick analysis of COVID data, we create rough
estimates of the county level of the PM2.5 previously aggregated to the
zip code level from the intiial 1km by 1km grids. We do this by just
averaging values for all of zip codes in each county. A better method
would be to create the county estimates directly from the grids, however
under short notice this method works well enough.

``` r
library(NSAPHutils)
set_threads()
library(data.table)

pm_data <- NULL
for (year in 2000:2016) {
  temp <- fread(paste0("../data/rm_pm25/data_acag_pm25_zip-year/zip_pm25_", year, ".csv"))
  temp[, year := year]
  pm_data <- rbind(pm_data, temp)
}
county_crosswalk <- fread("/nfs/nsaph_ci3/scratch/locations/combined/zips_with_county.csv")
county_crosswalk <- county_crosswalk[, .(ZIP, fips)]
pm_data <- merge(pm_data, county_crosswalk, by = "ZIP")

pm_data <- pm_data[, .(pm25 = mean(pm25, na.rm = T)), by = c("fips", "year")]

fwrite(pm_data, "../data/rm_pm25_out/rough_county_pm25.csv")
```
