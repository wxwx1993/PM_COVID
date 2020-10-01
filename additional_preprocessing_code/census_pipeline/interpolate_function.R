library(dplyr)
library(imputeTS)
library(gstat)

interpolate_time <- function(data, variable, location = "ID", time_var = "year") {
  data <- select(data, variable, location, time_var)
  for (i in unique(data[[location]])) {
    # break data up across each location and interpolate within each location
    #print(i)
    small_set <- data[data[[location]] == i,]
    missing_vals <- which(is.na(small_set[[variable]])) # list position of missing values
    known_vals <- which(!is.na(small_set[[variable]])) # list position of known values
    if (length(known_vals) == 0 | length(missing_vals) ==  0) {
      # if all known or all missing, skip
      next
    }
    m <- 1 # position in missing vector
    k <- 1 # position in known vector
    if(missing_vals[1] == 1) {
      # handle missingness at the begining of a location
      # use slope across all known region as the general slope
      
      slope <- (small_set[[variable]][known_vals[length(known_vals)]] - small_set[[variable]][known_vals[1]]) / 
        (small_set[[time_var]][known_vals[length(known_vals)]] - small_set[[time_var]][known_vals[1]])
      while (missing_vals[m] < known_vals[1]) {
        #print(m)
        # signs are ok, the difference on the time variable will be negative
        small_set[[variable]][missing_vals[m]] <- small_set[[variable]][known_vals[1]] + 
          (slope * (small_set[[time_var]][missing_vals[m]] - small_set[[time_var]][known_vals[1]]))
        m <- m+1
        if (is.na(missing_vals[m])) {
          #if all missingness is at the begining, break out
          break
        }
      }
    }
    while(m <= length(missing_vals) & k <= length(known_vals)) {
      if (known_vals[k] < missing_vals[m]) {
        k <- k+1
      } else {
        # stretch of missingness identified
        # slope between known points on either side of gap used
        slope <- (small_set[[variable]][known_vals[k]] - small_set[[variable]][known_vals[k-1]]) / 
          (small_set[[time_var]][known_vals[k]] - small_set[[time_var]][known_vals[k-1]])
        #print(slope)
        while (missing_vals[m] < known_vals[k]) {
          small_set[[variable]][missing_vals[m]] <- small_set[[variable]][known_vals[k-1]] + 
            (slope * (small_set[[time_var]][missing_vals[m]] - small_set[[time_var]][known_vals[k-1]]))
          m <- m + 1
          if (is.na(missing_vals[m])) {
            break
          }
        }
      }
    }
    if (is.na(small_set[[variable]][missing_vals[m]])) {
      # missingness at the end of the data
      if (!exists("slope")) {
        # use slope from previous missing section, otherwise use slope across whole period
        slope <- (small_set[[variable]][known_vals[length(known_vals)]] - small_set[[variable]][known_vals[1]]) / 
          (small_set[[time_var]][known_vals[length(known_vals)]] - small_set[[time_var]][known_vals[1]])
      }
      
      while (!is.na(missing_vals[m])) {
        small_set[[variable]][missing_vals[m]] <- small_set[[variable]][known_vals[length(known_vals)]] + 
          (slope * (small_set[[time_var]][missing_vals[m]] - small_set[[time_var]][known_vals[length(known_vals)]]))
        m <- m+1
      }
    }
    data[[variable]][data[[location]] == i] <- small_set[[variable]]
  }
  
  return(data[[variable]])
} 

interpolate_simple <- function(data, variable, location = "ID", time_var = "year") {
  data <- select(data, variable, location, time_var)
  for (i in unique(data[[location]])) {
    small_set <- data[data[[location]] == i,]
    missing_vals <- which(is.na(small_set[[variable]])) # list position of missing values
    known_vals <- which(!is.na(small_set[[variable]])) # list position of known values
    if (length(known_vals) == 0 | length(missing_vals) ==  0) {
      # if all known or all missing, skip
      next
    }
    linear_formula <- paste(variable, "~", time_var)
    model <- lm(as.formula(linear_formula), small_set)
    new_vals <- predict(model, newdata = small_set)
    small_set[[variable]][is.na(small_set[[variable]])] <- new_vals[is.na(small_set[[variable]])]
    data[[variable]][data[[location]] == i] <- small_set[[variable]]
  }
  
  return(data[[variable]])
}

interpolate_ts <- function(data, variable, location = "ID", time_var = "year", area_var = NULL) {
  data <- select(data, variable, location, time_var)
  for (i in unique(data[[location]])) {
    small_set <- data[data[[location]] == i,]
    missing_vals <- which(is.na(small_set[[variable]])) # list position of missing values
    known_vals <- which(!is.na(small_set[[variable]])) # list position of known values
    if (length(known_vals) == 0 | length(missing_vals) ==  0) {
      # if all known or all missing, skip
      next
    }
    if (length(known_vals) == 1 || variable == area_var) {
      small_set[[variable]][is.na(small_set[[variable]])] <- small_set[[variable]][known_vals[1]]
    }
    else {
      new_vals <- na.ma(small_set[[variable]])
      small_set[[variable]][is.na(small_set[[variable]])] <- new_vals[is.na(small_set[[variable]])]
    }
    data[[variable]][data[[location]] == i] <- small_set[[variable]]
  }
  
  return(data[[variable]])
}
    
    
interpolate_krige <- function(data, variable, time_var =  "year") {
  ## assumes data has already had coordinates assigned
  krige_formula <- paste0(variable, " ~ 1")
  for (year in unique(data[[time_var]])) {
    year_data <- data[data[[time_var]] == year,]
    if (all(is.na(year_data[[variable]]))) {
      next
    }
    int_values <- krige(as.formula(krige_formula), year_data[!is.na(year_data[[variable]]),], newdata = year_data)
    year_data[[variable]][is.na(year_data[[variable]])] <- int_values$var1.pred[is.na(year_data[[variable]])]
    data[[variable]][data[[time_var]] == year] <- year_data[[variable]]
  }
  
  return(data[[variable]])
}    
  
  