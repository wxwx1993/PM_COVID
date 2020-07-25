library("dplyr")
library(stringr)
library(RCurl)
library(httr)

date_of_study = "05-05-2020"
# Historical data
covid_hist = read.csv(text=getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/03-30-2020.csv"))
covid_us_hist = subset(covid_hist, Country_Region == "US" & is.na(FIPS)==F)

# Import outcome data from JHU CSSE
covid = read.csv(text=getURL(paste0("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/",date_of_study,".csv")))
covid_us = subset(covid,Country_Region == "US")[,1:12]
covid_us = rbind(covid_us,subset(covid_us_hist, (!(FIPS %in% covid_us$FIPS))  & Confirmed == 0 & Deaths == 0 & is.na(FIPS)==F))
covid_us$FIPS = str_pad(covid_us$FIPS, 5, pad = "0")

# Import exposure PM2.5 data
county_pm = read.csv(text=getURL("https://raw.githubusercontent.com/wxwx1993/PM_COVID/master/Data/county_pm25.csv"))

county_temp = read.csv(text=getURL("https://raw.githubusercontent.com/wxwx1993/PM_COVID/master/Data/temp_seasonal_county.csv"))
# Import census, brfss, testing, mortality, hosptial beds data as potential confounders
county_census = read.csv(text=getURL("https://raw.githubusercontent.com/wxwx1993/PM_COVID/master/Data/census_county_interpolated.csv"))
county_brfss<-read.csv(text=getURL("https://www.countyhealthrankings.org/sites/default/files/media/document/analytic_data2020.csv"),skip = 1)
county_brfss<-county_brfss[,c('fipscode','v011_rawvalue','v009_rawvalue')]
names(county_brfss)<-c('fips','obese','smoke')
county_brfss$fips = str_pad(county_brfss$fips, 5, pad = "0")

state_test = read.csv(text=getURL("https://covidtracking.com/api/v1/states/daily.csv"))
state_test = subset(state_test, date ==paste0(substring(str_remove_all(date_of_study, "-"),5,8),substring(str_remove_all(date_of_study, "-"),1,4)))[,-20]
statecode = read.csv(text=getURL("https://raw.githubusercontent.com/wxwx1993/PM_COVID/master/Data/statecode.csv"))

hospitals = read.csv(text=getURL("https://opendata.arcgis.com/datasets/6ac5e325468c4cb9b905f1728d6fbf0f_0.csv?outSR=%7B%22latestWkid%22%3A3857%2C%22wkid%22%3A102100%7D"))
hospitals$BEDS[hospitals$BEDS < 0] = NA

county_base_mortality = read.table(text=getURL("https://raw.githubusercontent.com/wxwx1993/PM_COVID/master/Data/county_base_mortality.txt"), sep = "",header = T)
county_old_mortality = read.table(text=getURL("https://raw.githubusercontent.com/wxwx1993/PM_COVID/master/Data/county_old_mortality.txt"), sep = "",header = T)
county_014_mortality = read.table("https://raw.githubusercontent.com/wxwx1993/PM_COVID/master/Data/county_014_mortality.txt", sep = "",header = T)
county_1544_mortality = read.table("https://raw.githubusercontent.com/wxwx1993/PM_COVID/master/Data/county_1544_mortality.txt", sep = "",header = T)
county_4564_mortality = read.table("https://raw.githubusercontent.com/wxwx1993/PM_COVID/master/Data/county_4564_mortality.txt", sep = "",header = T)

colnames(county_old_mortality)[4] = c("older_Population")
colnames(county_014_mortality)[4] = c("014_Population")
colnames(county_1544_mortality)[4] = c("1544_Population")
colnames(county_4564_mortality)[4] = c("4564_Population")

county_base_mortality = merge(county_base_mortality,county_old_mortality[,c(2,4)] ,by = "County.Code",all.x = T)
county_base_mortality = merge(county_base_mortality,county_014_mortality[,c(2,4)] ,by = "County.Code",all.x = T)
county_base_mortality = merge(county_base_mortality,county_1544_mortality[,c(2,4)] ,by = "County.Code",all.x = T)
county_base_mortality = merge(county_base_mortality,county_4564_mortality[,c(2,4)] ,by = "County.Code",all.x = T)

county_base_mortality$older_pecent = county_base_mortality$older_Population/county_base_mortality$Population
county_base_mortality$"young_pecent" = county_base_mortality$"014_Population"/county_base_mortality$Population
county_base_mortality$"prime_pecent" = county_base_mortality$"1544_Population"/county_base_mortality$Population
county_base_mortality$"mid_pecent" = county_base_mortality$"4564_Population"/county_base_mortality$Population
county_base_mortality$"older_pecent"[is.na(county_base_mortality$"older_pecent")] = 0
county_base_mortality$"prime_pecent"[is.na(county_base_mortality$"prime_pecent")] = 0
county_base_mortality$"mid_pecent"[is.na(county_base_mortality$"mid_pecent")] = 0
county_base_mortality$"young_pecent"[is.na(county_base_mortality$"young_pecent")] = 0

# Import NCHS Urban-Rural Classification Scheme for Counties
NCHSURCodes2013 = read.csv("https://raw.githubusercontent.com/wxwx1993/PM_COVID/master/Data/NCHSURCodes2013.csv")
NCHSURCodes2013$FIPS = str_pad(NCHSURCodes2013$FIPS, 5, pad = "0")

# Import FB survey on covid-like sympton data
script <- getURL("https://raw.githubusercontent.com/cmu-delphi/delphi-epidata/master/src/client/delphi_epidata.R", ssl.verifypeer = FALSE)
eval(parse(text = script))

# Import social distancing measure data
state_policy = read.csv("https://raw.githubusercontent.com/wxwx1993/PM_COVID/master/Data/state_policy0410.csv")
colnames(state_policy)[6] = "stay_at_home"

# merging data
state_test = merge(state_test,statecode,by.x = "state" ,by.y = "Code" )
state_test = merge(state_test,state_policy[,c(1,6)],by = "State")
state_test$date_since_social = as.numeric(as.Date(Sys.Date()) - as.Date((strptime(state_test$stay_at_home, "%m/%d/%Y"))))
state_test[is.na(state_test$date_since_social)==T,]$date_since_social = 0

# pm2.5 average over 17 years
county_pm_aggregated = county_pm %>% 
    group_by(fips) %>% 
    summarise(mean_pm25 = mean(pm25))

# temperature and relative humidity average over 17 years
county_temp_aggregated = county_temp %>% 
  group_by(fips) %>% 
  summarise(mean_winter_temp= mean(winter_tmmx),
            mean_summer_temp= mean(summer_tmmx),
            mean_winter_rm= mean(winter_rmax),
            mean_summer_rm= mean(summer_rmax))

county_pm_aggregated = merge(county_pm_aggregated,county_temp_aggregated,by="fips",all.x = T)

county_hospitals_aggregated = hospitals %>%
  group_by(COUNTYFIPS) %>%
  summarise(beds = sum(BEDS, na.rm=TRUE))
county_hospitals_aggregated$COUNTYFIPS = str_pad(county_hospitals_aggregated$COUNTYFIPS, 5, pad = "0")

county_census_aggregated2 = subset(county_census, year==2016)

county_census_aggregated2$q_popdensity = 1
quantile_popdensity = quantile(county_census_aggregated2$popdensity,c(0.2,0.4,0.6,0.8))
county_census_aggregated2$q_popdensity[county_census_aggregated2$popdensity<=quantile_popdensity[1]] = 1
county_census_aggregated2$q_popdensity[county_census_aggregated2$popdensity>quantile_popdensity[1] &
                                         county_census_aggregated2$popdensity<=quantile_popdensity[2]] = 2
county_census_aggregated2$q_popdensity[county_census_aggregated2$popdensity>quantile_popdensity[2] &
                                         county_census_aggregated2$popdensity<=quantile_popdensity[3]] = 3
county_census_aggregated2$q_popdensity[county_census_aggregated2$popdensity>quantile_popdensity[3] &
                                         county_census_aggregated2$popdensity<=quantile_popdensity[4]] = 4
county_census_aggregated2$q_popdensity[county_census_aggregated2$popdensity>quantile_popdensity[4]] = 5

county_census_aggregated2$fips = str_pad(county_census_aggregated2$fips, 5, pad = "0")
county_census_aggregated2 = merge(county_census_aggregated2,county_brfss,
                                  by="fips",all.x=T)

county_pm_aggregated$fips = str_pad(county_pm_aggregated$fips, 5, pad = "0")
aggregate_pm = merge(county_pm_aggregated,covid_us,by.x="fips",by.y = "FIPS")

aggregate_pm_census = merge(aggregate_pm,county_census_aggregated2,by.x="fips",by.y = "fips")

county_base_mortality$County.Code = str_pad(county_base_mortality$County.Code, 5, pad = "0")
aggregate_pm_census_cdc = merge(aggregate_pm_census,county_base_mortality[,c(1,4,12:15)],by.x = "fips",by.y = "County.Code",all.x = T)

aggregate_pm_census_cdc = aggregate_pm_census_cdc[is.na(aggregate_pm_census_cdc$fips) ==F,]

aggregate_pm_census_cdc_test = merge(aggregate_pm_census_cdc,state_test[, -26],by.x="Province_State",by.y = "State")

aggregate_pm_census_cdc_test_beds = merge(aggregate_pm_census_cdc_test,county_hospitals_aggregated,by.x = "fips",by.y = "COUNTYFIPS",all.x = T)
aggregate_pm_census_cdc_test_beds$beds[is.na(aggregate_pm_census_cdc_test_beds$beds)] = 0

# Import outcome data from JHU CSSE, calculate the timing of the 1st confirmed case for each county
date_of_all = format(seq(as.Date("2020-03-22"), as.Date(strptime(date_of_study,"%m-%d-%Y")), by = "days"),"%m-%d-%Y")
covid_us_daily_confirmed = lapply(date_of_all,
                                  function(date_of_all){
                                    covid_daily = read.csv(text=getURL(paste0("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/",date_of_all,".csv")))
                                    covid_daily = covid_daily[!duplicated(covid_daily$FIPS),1:12]
                                    return(subset(covid_daily,Country_Region == "US" & is.na(FIPS)!=T & Confirmed >0 ))
                                  }
)

covid_us_new_confirmed = list()
covid_us_new_confirmed[1] = covid_us_daily_confirmed[1]
covid_us_new_confirmed[[1]]$date_since = length(covid_us_daily_confirmed) 

covid_us_new_confirmed[2:length(date_of_all)] =  lapply(2:(length(covid_us_daily_confirmed)),
                                                        function(i){
                                                          covid_us_new_confirmed =subset(covid_us_daily_confirmed[[i]],!(FIPS %in% unlist(sapply(1:(i-1),function(k)covid_us_daily_confirmed[[k]]$FIPS))))
                                                          if (nrow(covid_us_new_confirmed)>0){
                                                            covid_us_new_confirmed$date_since = length(covid_us_daily_confirmed) - i + 1
                                                            return(covid_us_new_confirmed)
                                                          } else{return(NA)}
                                                        })

covid_us_new_confirmed.df <- do.call("rbind", covid_us_new_confirmed)[,c("FIPS","date_since")]
covid_us_new_confirmed.df$FIPS = str_pad(covid_us_new_confirmed.df$FIPS, 5, pad = "0")
aggregate_pm_census_cdc_test_beds = merge(aggregate_pm_census_cdc_test_beds,covid_us_new_confirmed.df,
                                          by.x = "fips",by.y = "FIPS", all.x = T)
aggregate_pm_census_cdc_test_beds$date_since[is.na(aggregate_pm_census_cdc_test_beds$date_since)] = 0

aggregate_pm_census_cdc_test_beds = merge(aggregate_pm_census_cdc_test_beds,NCHSURCodes2013[,c(1,7)],
                                          by.x = "fips",by.y="FIPS", all.x = T)

# Combine five boroughs of NYC
aggregate_pm_census_cdc_test_beds[aggregate_pm_census_cdc_test_beds$Admin2=="New York City",]$population =
  subset(aggregate_pm_census_cdc_test_beds,Admin2=="New York City"& Province_State=="New York")$population +
  subset(aggregate_pm_census_cdc_test_beds, Admin2=="Bronx"& Province_State=="New York")$population +
  subset(aggregate_pm_census_cdc_test_beds, Admin2=="Kings"& Province_State=="New York")$population +
  subset(aggregate_pm_census_cdc_test_beds, Admin2=="Queens"& Province_State=="New York")$population +
  subset(aggregate_pm_census_cdc_test_beds, Admin2=="Richmond"& Province_State=="New York")$population
aggregate_pm_census_cdc_test_beds[aggregate_pm_census_cdc_test_beds$Admin2=="New York City",]$beds =
  subset(aggregate_pm_census_cdc_test_beds,Admin2=="New York City"& Province_State=="New York")$beds +
  subset(aggregate_pm_census_cdc_test_beds, Admin2=="Bronx"& Province_State=="New York")$beds +
  subset(aggregate_pm_census_cdc_test_beds, Admin2=="Kings"& Province_State=="New York")$beds +
  subset(aggregate_pm_census_cdc_test_beds, Admin2=="Queens"& Province_State=="New York")$beds +
  subset(aggregate_pm_census_cdc_test_beds, Admin2=="Richmond"& Province_State=="New York")$beds

vars = c("mean_pm25","poverty","medianhousevalue","medhouseholdincome","pct_owner_occ",
        "education","pct_blk","hispanic","older_pecent","prime_pecent","mid_pecent","obese","smoke",
       "mean_summer_temp","mean_summer_rm","mean_winter_temp","mean_winter_rm")
aggregate_pm_census_cdc_test_beds[aggregate_pm_census_cdc_test_beds$Admin2=="New York City",][,vars] = 
sapply(vars,function(var){
  (subset(aggregate_pm_census_cdc_test_beds,Admin2=="New York City"& Province_State=="New York")[,var]*subset(aggregate_pm_census_cdc_test_beds,Admin2=="New York City"& Province_State=="New York")$population +
    subset(aggregate_pm_census_cdc_test_beds, Admin2=="Bronx"& Province_State=="New York")[,var]*subset(aggregate_pm_census_cdc_test_beds,Admin2=="Bronx"& Province_State=="New York")$population +
    subset(aggregate_pm_census_cdc_test_beds, Admin2=="Kings"& Province_State=="New York")[,var]*subset(aggregate_pm_census_cdc_test_beds,Admin2=="Kings"& Province_State=="New York")$population +
    subset(aggregate_pm_census_cdc_test_beds, Admin2=="Queens"& Province_State=="New York")[,var]*subset(aggregate_pm_census_cdc_test_beds,Admin2=="Queens"& Province_State=="New York")$population +
    subset(aggregate_pm_census_cdc_test_beds, Admin2=="Richmond"& Province_State=="New York")[,var]*subset(aggregate_pm_census_cdc_test_beds,Admin2=="Richmond"& Province_State=="New York")$population)/(
      subset(aggregate_pm_census_cdc_test_beds,Admin2=="New York City"& Province_State=="New York")$population+subset(aggregate_pm_census_cdc_test_beds,Admin2=="Bronx"& Province_State=="New York")$population+
      subset(aggregate_pm_census_cdc_test_beds, Admin2=="Kings"& Province_State=="New York")$population+ subset(aggregate_pm_census_cdc_test_beds,Admin2=="Queens"& Province_State=="New York")$population +
        subset(aggregate_pm_census_cdc_test_beds,Admin2=="Richmond"& Province_State=="New York")$population)
})
aggregate_pm_census_cdc_test_beds = subset(aggregate_pm_census_cdc_test_beds,
                                           !(Admin2=="Bronx"& Province_State=="New York")&
                                             !(Admin2=="Kings"& Province_State=="New York")&
                                             !(Admin2=="Queens"& Province_State=="New York")&
                                             !(Admin2=="Richmond"& Province_State=="New York"))

# Request FB survey data from CMU COVIDcast Delphi Research Group
aggregate_pm_census_cdc_test_beds$cli  = 
  sapply(aggregate_pm_census_cdc_test_beds$fips, 
         function(fips){
           if (Epidata$covidcast('fb-survey', 'smoothed_cli', 'day', 'county', list(Epidata$range(20200401, paste0(substring(str_remove_all(date_of_study, "-"),5,8),substring(str_remove_all(date_of_study, "-"),1,4)))),fips)[[2]]!="no results"){
             return(mean(sapply(Epidata$covidcast('fb-survey', 'smoothed_cli', 'day', 'county', list(Epidata$range(20200401, paste0(substring(str_remove_all(date_of_study, "-"),5,8),substring(str_remove_all(date_of_study, "-"),1,4)))),fips)[[2]],function(i){i$value}),na.rm=T))
           }else {return(NA)}})

# Mobility data from Facebook Data for Good
## https://www.facebook.com/geoinsights/
date_of_mobility = seq(as.Date("2020-03-01"), as.Date(strptime(date_of_study,"%m-%d-%Y")), by = "days")

covid_us_daily_mobility = lapply(date_of_mobility,
                                 function(date_of_mobility){
                                    covid_mobility = read.csv(paste0("/mobility/Covid19 Mobility Metrics US_county_US_county_",date_of_mobility,".csv"))
                                    colnames(covid_mobility)[12] = "fips"
                                    covid_mobility$fips = str_pad(covid_mobility$fips, 5, pad = "0")
                                    return(covid_mobility)
                                  }
)

## all_day_bing_tiles_visited_relative_change: the average number of level 16 Bing tiles (0.6km by 0.6km) that a Facebook user (mobile app + location history) was present 
## in during a 24 hour period compared to pre-crisis levels.
## all_day_bing_tiles_visited_relative_change indicates the relative change of mobility for each county during the COVID-19 pandemic
relative_mobility = data.frame(aggregate_pm_census_cdc_test_beds[,c("fips","mean_pm25")])
for (i in 1:length(covid_us_daily_mobility)){
  relative_mobility = merge(relative_mobility, 
                            covid_us_daily_mobility[[i]][,c("all_day_bing_tiles_visited_relative_change","fips")], 
                            by = "fips", all.x = T)
}
## mean_visited_change: average all_day_bing_tiles_visited_relative_change over the study period.
relative_mobility$mean_visited_change = 
  rowMeans(relative_mobility[,3:dim(relative_mobility)[2]], na.rm = T)

## all_day_ratio_single_tile_users: the percentage of Facebook users (mobile app + location history) that were present in only one such level 16 Bing tile in at least 3 different hours of the day.
## all_day_ratio_single_tile_users indicates the absolute amount of mobility for each county during the COVID-19 pandemic
ratio_mobility = data.frame(aggregate_pm_census_cdc_test_beds[,c("fips","mean_pm25")])
for (i in 1:length(covid_us_daily_mobility)){
  ratio_mobility = merge(ratio_mobility, 
                         covid_us_daily_mobility[[i]][,c("all_day_ratio_single_tile_users","fips")], 
                         by = "fips", all.x = T)
}
## mean_ratio: average all_day_ratio_single_tile_users over the whole study period.
ratio_mobility$mean_ratio = rowMeans(ratio_mobility[,3:dim(ratio_mobility)[2]], na.rm = T)

aggregate_pm_census_cdc_test_beds_mobility = merge(aggregate_pm_census_cdc_test_beds, 
                                                   relative_mobility[,c("fips","mean_visited_change")],
                                                   by = "fips", all.x = T)
aggregate_pm_census_cdc_test_beds_mobility = merge(aggregate_pm_census_cdc_test_beds_mobility, 
                                                   ratio_mobility[,c("fips","mean_ratio")],
                                                   by = "fips", all.x = T)



