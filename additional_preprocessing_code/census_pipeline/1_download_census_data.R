library(tidycensus)
library(tigris)
library(dplyr)
library(yaml)
library(tidyr)


get_variables <- function(plan, var, year) {
  data_key <- names(plan[[var]])
  data_key <- data_key[year <= data_key][1]
  return(plan[[var]][[data_key]])
}

variable_path <- "census_vars.yml"

variable_plan <- yaml.load_file(variable_path)

## ACS 5 year data available from 2009 forward, decennial data in 2000, 2010
data_years <- c(2000, 2009:2018)

out <- NULL
for (year in data_years) {
  year_plan <- list()
  acs_vars <- NULL
  dec_vars <- NULL
  
  ## Figure out what to download and from where
  for (var in names(variable_plan)) {
    year_plan[[var]] <- get_variables(variable_plan, var, year)
    if (year_plan[[var]] == "skip") {
      next
    }
    if (names(year_plan[[var]]) == "acs") {
      acs_vars <- union(acs_vars, 
                        union(year_plan[[var]][["acs"]][["num"]], 
                                        year_plan[[var]][["acs"]][["den"]]))
    } else if (names(year_plan[[var]]) == "census") {
      dec_vars <- union(dec_vars, 
                        union(year_plan[[var]][["census"]][["num"]], 
                              year_plan[[var]][["census"]][["den"]]))
    }
  }
  
  ## Make API calls
  if (!is.null(acs_vars)) {
    acs_data <- get_acs("county", variables = acs_vars, year = year)
    acs_data$moe <- NULL
    acs_data <- pivot_wider(acs_data,id_cols = c(GEOID, NAME),  names_from  = variable, values_from  = estimate)
  }
  
  if (!is.null(dec_vars)) {
    if (year == 2000) {

      ## Need to split in to sf1 and sf3
      sf1_varlist <- load_variables(year = 2000, dataset = "sf1", cache = T)
      sf3_varlist <- load_variables(year = 2000, dataset = "sf3", cache = T)
      dec_data <- get_decennial("county", 
                                variables = intersect(setdiff(dec_vars, "P004002"),sf1_varlist$name),
                                sumfile = "sf1", 
                                year = year)
      if ("P004002" %in% dec_vars) {
        dec_data <- rbind(dec_data, 
                          get_decennial("county", 
                                        variables = "P004002",
                                        sumfile = "sf1", 
                                        year = year))
      }
      dec_data <- rbind(dec_data,
                        get_decennial("county",
                                      variables = setdiff(dec_vars, sf1_varlist$name),
                                      sumfile = "sf3",
                                      year = year))
  
    } else {
      dec_data <- get_decennial("county", variables = dec_vars, year = year)
    }
    dec_data <- pivot_wider(dec_data, id_cols = c(GEOID, NAME),  names_from  = variable, values_from  = value)
  }
  
  ## Merge/unify variable names
  if (!is.null(acs_vars) & !is.null(dec_vars)) {
    data <- inner_join(acs_data, dec_data,suffix = c("", ".y"), by = c("GEOID"))
    data$NAME.y <- NULL
    rm(acs_data, dec_data)
  } else if (!is.null(acs_vars)) {
    data <- acs_data
    rm(acs_data)
  } else if (!is.null(dec_vars)) {
    data <- dec_data
    rm(dec_data)
  }
  
  ## Use variable plan to calculate values
  
  for (var in names(year_plan)) {
    if (year_plan[[var]] == "skip") {
      data[[var]] <- NA
    } else {
      data$num <- 0
      for (source_var in year_plan[[var]][[1]][["num"]]) {
        data$num <- data$num + data[[source_var]]
      }
      
      if (!is.null(year_plan[[var]][[1]][["den"]])) {
        data$den <- 0
        for (source_var in year_plan[[var]][[1]][["den"]]) {
          data$den <- data$den + data[[source_var]]
        }
        
        data[[var]] <- data$num/data$den
        data$num <- NULL
        data$den <- NULL
      } else {
        data[[var]] <- data$num
        data$num <- NULL
      }
    }
  }
  
  data <- select(data, c("GEOID","NAME", names(year_plan)))
  data$year <- year
  
  out <- rbind(out, data)
  
    
}

## Create framework to allow missingness
county_data <- counties()
county_data <- as.tbl(data.frame(fips = paste0(county_data$STATEFP, county_data$COUNTYFP),
                                 NAME = county_data$NAMELSAD,
                                 land_area = as.numeric(county_data$ALAND)/2589988, 
                                 stringsAsFactors = F))
merged_data <- NULL
for (year in 1999:2018) {
  county_data$year <- year
  merged_data <- rbind(merged_data, county_data)
}

out <- left_join(merged_data, out, by = c("fips" = "GEOID", "year"), suffix = c("", ".y"))
out$NAME.y <- NULL
if ("population" %in% names(variable_plan)) {
  out$population_density <- out$population/out$land_area
}

write.csv(out, "../data/census_data/census_county_uninterpolated.csv", row.names = F)
