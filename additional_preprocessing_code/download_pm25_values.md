County aggregation of PM25 predictions from The Atmospheric Composition
Analysis Group
================
Ben Sabath
September 10, 2020

This document contains code and documentation related to aggregating
PM25 predictions from [The Atmospheric Composition Analysis Group at
Dalhouse
University](ftp://stetson.phys.dal.ca/Aaron/MAPLE_20191008/NetCDF/NA/PM25/)to
the county level. This is derieved from code primarily written by Ista,
but using updated pm25 data through 2018. Output data is located at

    ci3_exposure/pm25/whole_us/annual/counties/county_rm/data

``` r
library(tidyverse)
```

    ## Warning: As of rlang 0.4.0, dplyr must be at least version 0.8.0.
    ## * dplyr 0.7.6 is too old for rlang 0.4.5.9000.
    ## * Please update dplyr with `install.packages("dplyr")` and restart R.

``` r
library(raster)
library(sf)
library(velox)

years <- 2000L:2018L
outdir <- "data/county_data/data"
```

First we list and download all the upstream pm25 prediction data
files.

``` r
pm25_pred_files <- paste0("ftp://stetson.phys.dal.ca/Aaron/V4NA03/NetCDF/NA/PM25/V4NA03_PM25_NA_", 2000:2018, "01_", 2000:2018, "12-RH35.nc")

if(!dir.exists("data/county_data/cache")) dir.create("data/county_data/cache")
for(file in pm25_pred_files) {
  cachefile <- str_c("data/county_data/cache/", basename(file), sep = "")
  if(!file.exists(cachefile)) download.file(file, cachefile)
}
```

Next we write a function to aggregate a particular year. Note that both
the pm25 data and the county data features use the same coordinate
reference system.

``` r
agg_rm_pm25 <- function(pm25.nc, polygons) {
  pm25 <- raster(pm25.nc)
  county.poly <- read_sf(polygons)
  county.poly <- filter(county.poly, !STATEFP %in% c("02","15","60","66","69","72","78")) ## No Alaska or Hawaii or colonies
  county.poly <- county.poly %>%
    mutate(pm25 = velox(pm25)$extract(county.poly,
                                      small = FALSE,
                                      fun = function(x) mean(x, na.rm = TRUE))[,1])
  return(county.poly)
}
```

Finally we iterate over years and aggregate to zip codes. Note that we
check for existing files, and don’t write over them if they exist.

``` r
if(!dir.exists(outdir)) dir.create(outdir)

pmfiles <- list.files("data/county_data/cache/", full.names = TRUE)

for(year in years) {
  ## input files
  pmfile <- str_subset(pmfiles, as.character(year))
  polyfile <- "/nfs/nsaph_ci3/scratch/county_shapefile/cb_2017_us_county_500k/cb_2017_us_county_500k.shp"
  
  ## output files
  polyout <- str_c(outdir, 
                   "/county_", 
                   tools::file_path_sans_ext(basename(pmfile)),
                   ".geojson", 
                   sep = "")
  csvout <- str_c(outdir, "/county_pm25_", year, ".csv", sep = "")
  
  if(!all(file.exists(polyout, csvout))) {
    out <- agg_rm_pm25(pmfile, polyfile)
    out <- dplyr::select(out, fips = GEOID, pm25) %>% mutate(year = year)
    write_sf(out, 
             polyout, 
             driver = "GeoJSON")
    write_csv(dplyr::select(as.data.frame(out), -geometry), 
              csvout)
  }
}
```

Thats all folks.
