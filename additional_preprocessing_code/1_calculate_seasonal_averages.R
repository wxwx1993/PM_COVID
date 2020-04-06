library(data.table)
library(NSAPHutils)
library(lubridate)

set_threads()

temp_data <- fread("../data/temperature/temp_daily_county.csv")
temp_data[, fips := paste0(sprintf("%02d", STATEFP), sprintf("%03d", COUNTYFP))]
temp_data[, date := ymd(date)]

summer  <- NULL
winter <- NULL

for (year_ in 2000:2016) {
  summer_int <- interval(ymd(paste0(year_, "0601")), ymd(paste0(year_, "0831")))
  if (leap_year(year_)) {
     winter_int <- interval(max(ymd(paste0(year_ - 1,  "1201")), ymd("20000101")),  ymd(paste0(year_, "0229")))
  } else {
    winter_int <- interval(max(ymd(paste0(year_ - 1,  "1201")), ymd("20000101")),  ymd(paste0(year_, "0228")))
  }
  
  summer_year <- temp_data[date %within% summer_int, .(summer_tmmx = mean(tmmx, na.rm = T), summer_rmax = mean(rmax,  na.rm = T)), by = fips]
  summer_year[, year := year_]
  summer <- rbind(summer, summer_year)
  
  winter_year <- temp_data[date %within% winter_int, .(winter_tmmx = mean(tmmx, na.rm = T), winter_rmax = mean(rmax, na.rm = T)), by = fips]
  winter_year[, year := year_]
  winter <- rbind(winter, winter_year)
}

out <- merge(summer, winter, by = c("fips", "year"))
fwrite(out, "../data/temperature/temp_seasonal_county.csv")
