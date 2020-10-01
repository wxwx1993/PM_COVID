# combine_county_pm.R
# After aggregating, the county level pm2.5 data is available in separate files for each year. This code
# combines the files for easier use.

library(NSAPHutils)
set_threads()
library(data.table)

pm_data <- NULL
for (year in 2000:2018) {
  temp <- fread(paste0("/nfs/nsaph_ci3/ci3_exposure/pm25/whole_us/annual/counties/county_rm/data/county_pm25_", year, ".csv"))
  pm_data <- rbind(pm_data, temp)
}

fwrite(pm_data, "../Data/county_pm25.csv")