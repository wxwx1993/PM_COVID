library("dplyr")
library(stringr)
library(RCurl)

date_of_study = "04-04-2020"
# Historical data
covid_hist = read.csv(text=getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/03-30-2020.csv"))
covid_us_hist = subset(covid_hist, Country_Region == "US" & is.na(FIPS)==F)

# Import outcome data from JHU CSSE
covid = read.csv(text=getURL(paste0("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/",date_of_study,".csv")))
covid_us = subset(covid,Country_Region == "US" & is.na(FIPS)!=T)
covid_us = rbind(covid_us,subset(covid_us_hist, (!(FIPS %in% covid_us$FIPS))  & Confirmed == 0 & Deaths == 0 & is.na(FIPS)==F))

# Import exposure PM2.5 data
county_pm = read.csv(text=getURL("https://raw.githubusercontent.com/wxwx1993/PM_COVID/master/Data/county_pm25.csv"))

county_temp = read.csv(text=getURL("https://raw.githubusercontent.com/wxwx1993/PM_COVID/master/Data/temp_seasonal_county.csv"))
# Import census, brfss, testing, mortality, hosptial beds data as potential confounders
county_census = read.csv(text=getURL("https://raw.githubusercontent.com/wxwx1993/PM_COVID/master/Data/census_county_interpolated.csv"))
county_brfss = read.csv(text=getURL("https://raw.githubusercontent.com/wxwx1993/PM_COVID/master/Data/brfss_county_interpolated.csv"))

state_test = read.csv(text=getURL("https://covidtracking.com/api/v1/states/daily.csv"))
state_test = subset(state_test, date ==paste0(substring(str_remove_all(date_of_study, "-"),5,8),substring(str_remove_all(date_of_study, "-"),1,4)))[,-20]
statecode = read.csv(text=getURL("https://raw.githubusercontent.com/wxwx1993/PM_COVID/master/Data/statecode.csv"))

hospitals = read.csv(text=getURL("https://opendata.arcgis.com/datasets/6ac5e325468c4cb9b905f1728d6fbf0f_0.csv?outSR=%7B%22latestWkid%22%3A3857%2C%22wkid%22%3A102100%7D"))
hospitals$BEDS[hospitals$BEDS < 0] = 0

county_base_mortality = read.table(text=getURL("https://raw.githubusercontent.com/wxwx1993/PM_COVID/master/Data/county_base_mortality.txt"), sep = "",header = T)
county_old_mortality = read.table(text=getURL("https://raw.githubusercontent.com/wxwx1993/PM_COVID/master/Data/county_old_mortality.txt"), sep = "",header = T)
colnames(county_old_mortality)[4] = c("older_Population")
county_base_mortality = merge(county_base_mortality,county_old_mortality[,c(2,4)] ,by = "County.Code")
county_base_mortality$older_pecent = county_base_mortality$older_Population/county_base_mortality$Population

# merging data
state_test = merge(state_test,statecode,by.x = "state" ,by.y = "Code" )

# pm average over 17 years
county_pm_aggregated = county_pm %>% 
  group_by(fips) %>% 
  summarise(mean_pm25 = mean(pm25))
# pm most recent 2016
#county_pm_aggregated = subset(county_pm , year==2016)
#county_pm_aggregated$mean_pm25 = county_pm_aggregated$pm25

# pm average over 17 years
county_temp_aggregated = county_temp %>% 
  group_by(fips) %>% 
  summarise(mean_winter_temp= mean(winter_tmmx),
            mean_summer_temp= mean(summer_tmmx),
            mean_winter_rm= mean(winter_rmax),
            mean_summer_rm= mean(summer_rmax))

county_pm_aggregated = merge(county_pm_aggregated,county_temp_aggregated,by="fips",all.x = T)

county_hospitals_aggregated = hospitals %>%
  group_by(COUNTYFIPS) %>%
  summarise(beds = sum(BEDS))

county_census_aggregated2 = subset(county_census, year==2016)
county_census_aggregated2$q_popdensity = 1
quantile_popdensity = quantile(county_census_aggregated2$popdensity,c(0.25,0.5,0.75))
county_census_aggregated2$q_popdensity[county_census_aggregated2$popdensity<=quantile_popdensity[1]] = 1
county_census_aggregated2$q_popdensity[county_census_aggregated2$popdensity>quantile_popdensity[1] &
                                         county_census_aggregated2$popdensity<=quantile_popdensity[2]] = 2
county_census_aggregated2$q_popdensity[county_census_aggregated2$popdensity>quantile_popdensity[2] &
                                         county_census_aggregated2$popdensity<=quantile_popdensity[3]] = 3
county_census_aggregated2$q_popdensity[county_census_aggregated2$popdensity>quantile_popdensity[3]] = 4

county_brfss_aggregated = subset(county_brfss, year==2012)

county_census_aggregated2 = merge(county_census_aggregated2,county_brfss_aggregated,
                                  by="fips",all.x=T)

aggregate_pm = merge(county_pm_aggregated,covid_us,by.x="fips",by.y = "FIPS")

aggregate_pm_census = merge(aggregate_pm,county_census_aggregated2,by.x="fips",by.y = "fips")

aggregate_pm_census_cdc = merge(aggregate_pm_census,county_base_mortality[,c(1,4:5,8:9)],by.x = "fips",by.y = "County.Code",all.x = T)

aggregate_pm_census_cdc = aggregate_pm_census_cdc[is.na(aggregate_pm_census_cdc$fips) ==F,]

aggregate_pm_census_cdc_test = merge(aggregate_pm_census_cdc,state_test,by.x="Province_State",by.y = "State")
aggregate_pm_census_cdc_test = aggregate_pm_census_cdc_test %>%
  group_by(Province_State) %>%
  mutate(population_frac_county = population/sum(population),
         totalTestResults_county = population_frac_county*totalTestResults)


aggregate_pm_census_cdc_test_beds = merge(aggregate_pm_census_cdc_test,county_hospitals_aggregated,by.x = "fips",by.y = "COUNTYFIPS",all.x = T)


