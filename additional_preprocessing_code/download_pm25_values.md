Zipcode aggregation of PM25 predictions from The Atmospheric Composition
Analysis Group
================
Ista Zahn and Ben Sabath
October 29th 2019

This document contains code and documentation related to aggregating
PM25 predictions from [The Atmospheric Composition Analysis Group at
Dalhouse
University](ftp://stetson.phys.dal.ca/Aaron/MAPLE_20191008/NetCDF/NA/PM25/)to
the zipcode level. Ista previously downloaded and aggregated earlier
versions of the data. This document processes the updated versions of
these data. The output files are located
    at:

    ci3_exposure/pm25/whole_us/annual/zipcode/rm_predictions/ben_2019_10_29

``` r
library(tidyverse)
library(raster)
library(sf)
library(velox)

years <- 2000L:2016L
outdir <- "data/pm_data/data_acag_pm25_zip-year"
```

First we list and download all the upstream pm25 prediction data
files.

``` r
pm25_pred_files <- paste0("ftp://stetson.phys.dal.ca/Aaron/MAPLE_20191008/NetCDF/NA/PM25/GWRwSPEC.HEI.ELEVandURB_PM25_NA_", 2000:2016, "01_", 2000:2016, "12-RH35.nc")

if(!dir.exists("data/pm_data/cache")) dir.create("data/pm_data/cache")
for(file in pm25_pred_files) {
  cachefile <- str_c("data/pm_data/cache/", basename(file), sep = "")
  if(!file.exists(cachefile)) download.file(file, cachefile)
}
```

We have zip code polygons and PO box data that we can use as geometries
to aggregate to.

``` r
zipdir <- "~/shared_space/ci3_nsaph_scratch/zip_for_loop/"
```

Next we write a function to aggregate a particular year. Note that both
the pm25 data and the zipcode features use the same coordinate reference
system.

``` r
agg_rm_pm25 <- function(pm25.nc, polygons, points) {
  pm25 <- raster(pm25.nc)
  zip.poly <- read_sf(polygons)
  zip.point <- st_as_sf(read_csv(points,col_types = cols(ZIP = col_character())), 
                        coords = c("POINT_X", "POINT_Y"),
                        crs = "+proj=longlat +datum=WGS84")
  zip.poly <- filter(zip.poly, !STATE %in% c("AK", "HI"))
  zip.point <- filter(zip.point, !STATE %in% c("AK", "HI"))
  zip.poly <- zip.poly %>%
    mutate(pm25 = velox(pm25)$extract(zip.poly,
                                      small = TRUE,
                                      fun = function(x) mean(x, na.rm = TRUE))[,1])
  zip.point <- zip.point %>%
    mutate(pm25 = velox(pm25)$extract_points(zip.point)[,1])
  pm25 <- bind_rows(as.data.frame(zip.poly)[,c("ZIP", "STATE", "pm25")], 
                    as.data.frame(zip.point)[,c("ZIP", "STATE", "pm25")])
  list(poly = zip.poly, point = zip.point, pm25 = pm25)
}
```

Finally we iterate over years and aggregate to zip codes. Note that we
check for existing files, and don’t write over them if they exist.

``` r
if(!dir.exists(outdir)) dir.create(outdir)

pmfiles <- list.files("data/pm_data/cache", full.names = TRUE)
polyfiles <- list.files(str_c(zipdir, "polygon", sep = "/"),
                        full.names = TRUE,
                        pattern = "\\.shp$")
pointfiles <- list.files(str_c(zipdir, "pobox_csv", sep = "/"),
                         full.names = TRUE,
                         pattern = "\\.csv$")

for(year in years) {
  ## input files
  pmfile <- str_subset(pmfiles, as.character(year))
  polyfile <- str_subset(polyfiles, str_c(str_sub(year, 3, 4), "USZIP", sep = ""))
  pointfile <- str_subset(pointfiles, str_c(str_sub(year, 3, 4), "USZIP", sep = ""))
  
  ## output files
  polyout <- str_c(outdir, 
                   "/zip_poly_", 
                   tools::file_path_sans_ext(basename(pmfile)),
                   ".geojson", 
                   sep = "")
  pointout <- str_c(outdir, 
                    "/zip_point_", 
                    tools::file_path_sans_ext(basename(pmfile)),
                    ".geojson",
                    sep = "")
  csvout <- str_c(outdir, "/zip_pm25_", year, ".csv", sep = "")
  
  if(!all(file.exists(polyout, pointout, csvout))) {
    out <- agg_rm_pm25(pmfile, polyfile, pointfile)
    write_sf(out[["poly"]], 
             polyout, 
             driver = "GeoJSON")
    write_sf(out[["point"]], 
             pointout, 
             driver = "GeoJSON")
    write_csv(out[["pm25"]], 
              csvout)
  }
}
```

Thats all folks.
