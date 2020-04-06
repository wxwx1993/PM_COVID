County Averages of EPA Monitors
================
Ben Sabath
March 27, 2020

### Aggregation Plan

This document takes the average of all EPA PM2.5 monitors (downloaded
from the AQS) for each county for use with COVID analyses.

``` r
library(NSAPHutils)
set_threads()
library(data.table)

pm_data <- fread("../data/annual_monitors/pm25_monitor_annual_average.csv")
pm_data[, fips := paste0(State.Code, sprintf("%03d", County.Code))]
pm_data <- pm_data[, .(pm25 = mean(Arithmetic.Mean, na.rm = T)), by = c("fips", "Year")]

fwrite(pm_data, "../data/monitors_out/monitor_county_pm25.csv")
```
