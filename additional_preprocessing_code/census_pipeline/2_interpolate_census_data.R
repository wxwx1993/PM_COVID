## Code to perform temporal interpolation for each county

source("interpolate_function.R")

county_data <- read.csv("../data/census_data/census_county_uninterpolated.csv")
interpolate_vars <- setdiff(names(county_data), c("fips","NAME","land_area","year"))

for (var in interpolate_vars) {
  print(var)
  county_data[[var]] <- interpolate_ts(county_data, var, location = "fips", area_var = "land_area")
}

write.csv(county_data, "../data/census_data/census_county_interpolated.csv", row.names=F)
