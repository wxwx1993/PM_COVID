library("dplyr")
library("MASS")
library("lme4")
library("glmmTMB")
library("gamm4")

# Main
mode.nb.random.off.main = glmer.nb(Deaths ~ mean_pm25 + factor(q_popdensity)
                                    + scale(poverty)  + scale(log(medianhousevalue))
                                    + scale(log(medhouseholdincome)) + scale(pct_owner_occ) 
                                    + scale(education) + scale(pct_blk) + scale(hispanic)
                                    + scale(older_pecent) + scale(prime_pecent) + scale(mid_pecent) 
                                    + scale(date_since_social) + scale(date_since)
                                    + scale(beds/population) 
                                    + scale(obese) + scale(smoke)
                                    + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                                    + (1|state)
                                    + offset(log(population)), data = aggregate_pm_census_cdc_test_beds)
summary(mode.nb.random.off.main)
exp(summary(mode.nb.random.off.main)[10]$coefficients[2,1])
exp(summary(mode.nb.random.off.main)[10]$coefficients[2,1] - 1.96*summary(mode.nb.random.off.main)[10]$coefficients[2,2])
exp(summary(mode.nb.random.off.main)[10]$coefficients[2,1] + 1.96*summary(mode.nb.random.off.main)[10]$coefficients[2,2])
summary(mode.nb.random.off.main)[10]$coefficients[2,4]

# - beds
mode.nb.random.off.beds = glmer.nb(Deaths ~ mean_pm25 + factor(q_popdensity)
                                   + scale(poverty) + scale(log(medianhousevalue))
                                   + scale(log(medhouseholdincome)) + scale(pct_owner_occ) 
                                   + scale(education) + scale(pct_blk) + scale(hispanic)
                                   + scale(older_pecent) + scale(prime_pecent) + scale(mid_pecent) 
                                   + scale(date_since_social) + scale(date_since)
                                   #+ scale(beds/population) 
                                   + scale(obese) + scale(smoke)
                                   + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                                   + (1|state)
                                   + offset(log(population)), data = aggregate_pm_census_cdc_test_beds)
summary(mode.nb.random.off.beds)
exp(summary(mode.nb.random.off.beds)[10]$coefficients[2,1])
exp(summary(mode.nb.random.off.beds)[10]$coefficients[2,1] - 1.96*summary(mode.nb.random.off.beds)[10]$coefficients[2,2])
exp(summary(mode.nb.random.off.beds)[10]$coefficients[2,1] + 1.96*summary(mode.nb.random.off.beds)[10]$coefficients[2,2])
summary(mode.nb.random.off.beds)[10]$coefficients[2,4]

# - smoking + bmi
mode.nb.random.off.brfss = glmer.nb(Deaths ~ mean_pm25 + factor(q_popdensity)
                                   + scale(poverty)  + scale(log(medianhousevalue))
                                   + scale(log(medhouseholdincome)) + scale(pct_owner_occ) 
                                   + scale(education) + scale(pct_blk) + scale(hispanic)
                                   + scale(older_pecent) + scale(prime_pecent) + scale(mid_pecent) 
                                   + scale(date_since_social) + scale(date_since)
                                   + scale(beds/population) 
                                   #+ scale(obese) + scale(smoke)
                                   + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                                   + (1|state)
                                   + offset(log(population)), data = aggregate_pm_census_cdc_test_beds)
summary(mode.nb.random.off.brfss)
exp(summary(mode.nb.random.off.brfss)[10]$coefficients[2,1])
exp(summary(mode.nb.random.off.brfss)[10]$coefficients[2,1] - 1.96*summary(mode.nb.random.off.brfss)[10]$coefficients[2,2])
exp(summary(mode.nb.random.off.brfss)[10]$coefficients[2,1] + 1.96*summary(mode.nb.random.off.brfss)[10]$coefficients[2,2])
summary(mode.nb.random.off.brfss)[10]$coefficients[2,4]


# - temp + humidity
mode.nb.random.off.weather = glmer.nb(Deaths ~ mean_pm25 + factor(q_popdensity)
                                   + scale(poverty)  + scale(log(medianhousevalue))
                                   + scale(log(medhouseholdincome)) + scale(pct_owner_occ) 
                                   + scale(education) + scale(pct_blk) + scale(hispanic)
                                   + scale(older_pecent) + scale(prime_pecent) + scale(mid_pecent) 
                                   + scale(date_since_social) + scale(date_since)
                                   + scale(beds/population) 
                                   + scale(obese) + scale(smoke)
                                   #+ scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                                   + (1|state)
                                   + offset(log(population)), data = aggregate_pm_census_cdc_test_beds)
summary(mode.nb.random.off.weather)
exp(summary(mode.nb.random.off.weather)[10]$coefficients[2,1])
exp(summary(mode.nb.random.off.weather)[10]$coefficients[2,1] - 1.96*summary(mode.nb.random.off.weather)[10]$coefficients[2,2])
exp(summary(mode.nb.random.off.weather)[10]$coefficients[2,1] + 1.96*summary(mode.nb.random.off.weather)[10]$coefficients[2,2])
summary(mode.nb.random.off.weather)[10]$coefficients[2,4]

# - outbreak
mode.nb.random.off.outbreak = glmer.nb(Deaths ~ mean_pm25 + factor(q_popdensity)
                                   + scale(poverty)  + scale(log(medianhousevalue))
                                   + scale(log(medhouseholdincome)) + scale(pct_owner_occ) 
                                   + scale(education) + scale(pct_blk) + scale(hispanic)
                                   + scale(older_pecent) + scale(prime_pecent) + scale(mid_pecent) 
                                   + scale(date_since_social) #+ scale(date_since)
                                   + scale(beds/population) 
                                   + scale(obese) + scale(smoke)
                                   + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                                   + (1|state)
                                   + offset(log(population)), data = aggregate_pm_census_cdc_test_beds)
summary(mode.nb.random.off.outbreak)
exp(summary(mode.nb.random.off.outbreak)[10]$coefficients[2,1])
exp(summary(mode.nb.random.off.outbreak)[10]$coefficients[2,1] - 1.96*summary(mode.nb.random.off.outbreak)[10]$coefficients[2,2])
exp(summary(mode.nb.random.off.outbreak)[10]$coefficients[2,1] + 1.96*summary(mode.nb.random.off.outbreak)[10]$coefficients[2,2])
summary(mode.nb.random.off.outbreak)[10]$coefficients[2,4]


# exclude NY Metro
mode.nb.random.off.nyc = glmer.nb(Deaths ~ mean_pm25 + factor(q_popdensity)
                                   + scale(poverty)  + scale(log(medianhousevalue))
                                   + scale(log(medhouseholdincome)) + scale(pct_owner_occ) 
                                   + scale(education) + scale(pct_blk) + scale(hispanic)
                                   + scale(older_pecent) + scale(prime_pecent) + scale(mid_pecent) 
                                   + scale(date_since_social) + scale(date_since)
                                   + scale(beds/population) 
                                   + scale(obese) + scale(smoke)
                                   + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                                   + (1|state)
                                   + offset(log(population)),data = subset(aggregate_pm_census_cdc_test_beds,!(fips %in% c("09001","42089","36111","09009","36059","36103","34013",
                                                                                                            "34019","34027","34037","34039","42103","34023","34025","34029",
                                                                                                            "34035", "34003", "34017", "34031","36005","36047","36061",
                                                                                                            "36079","36081",  "36085",  "36087",  "36119",  "36027", 
                                                                                                            "36071",  "09005",  "34021"))))
summary(mode.nb.random.off.nyc)
exp(summary(mode.nb.random.off.nyc)[10]$coefficients[2,1])
exp(summary(mode.nb.random.off.nyc)[10]$coefficients[2,1] - 1.96*summary(mode.nb.random.off.nyc)[10]$coefficients[2,2])
exp(summary(mode.nb.random.off.nyc)[10]$coefficients[2,1] + 1.96*summary(mode.nb.random.off.nyc)[10]$coefficients[2,2])
summary(mode.nb.random.off.nyc)[10]$coefficients[2,4]

# exclude <10 confirmed
mode.nb.random.off.large = glmer.nb(Deaths ~ mean_pm25 + factor(q_popdensity)
                               + scale(poverty)  + scale(log(medianhousevalue))
                               + scale(log(medhouseholdincome)) + scale(pct_owner_occ) 
                               + scale(education) + scale(pct_blk) + scale(hispanic)
                               + scale(older_pecent) + scale(prime_pecent) + scale(mid_pecent) 
                               + scale(date_since_social) + scale(date_since)
                               + scale(beds/population) 
                               + scale(obese) + scale(smoke)
                               + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                               + (1|state)
                               + offset(log(population)), data = subset(aggregate_pm_census_cdc_test_beds,Confirmed >=10)) 
summary(mode.nb.random.off.large)
exp(summary(mode.nb.random.off.large)[10]$coefficients[2,1])
exp(summary(mode.nb.random.off.large)[10]$coefficients[2,1] - 1.96*summary(mode.nb.random.off.large)[10]$coefficients[2,2])
exp(summary(mode.nb.random.off.large)[10]$coefficients[2,1] + 1.96*summary(mode.nb.random.off.large)[10]$coefficients[2,2])
summary(mode.nb.random.off.large)[10]$coefficients[2,4]

# rural
mode.nb.random.off.rural = glmer.nb(Deaths ~ mean_pm25 + factor(q_popdensity)
                               + scale(poverty)  + scale(log(medianhousevalue))
                               + scale(log(medhouseholdincome)) + scale(pct_owner_occ) 
                               + scale(education) + scale(pct_blk) + scale(hispanic)
                               + scale(older_pecent) + scale(prime_pecent) + scale(mid_pecent) 
                               + scale(date_since_social) + scale(date_since)
                               + scale(beds/population) 
                               + scale(obese) + scale(smoke)
                               + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                               + (1|state)
                               + offset(log(population)), data = subset(aggregate_pm_census_cdc_test_beds,X2013.code>4)) 
summary(mode.nb.random.off.rural)
exp(summary(mode.nb.random.off.rural)[10]$coefficients[2,1])
exp(summary(mode.nb.random.off.rural)[10]$coefficients[2,1] - 1.96*summary(mode.nb.random.off.rural)[10]$coefficients[2,2])
exp(summary(mode.nb.random.off.rural)[10]$coefficients[2,1] + 1.96*summary(mode.nb.random.off.rural)[10]$coefficients[2,2])
summary(mode.nb.random.off.rural)[10]$coefficients[2,4]

#urban
mode.nb.random.off.urban = glmer.nb(Deaths ~ mean_pm25 + factor(q_popdensity)
                               + scale(poverty)  + scale(log(medianhousevalue))
                               + scale(log(medhouseholdincome)) + scale(pct_owner_occ) 
                               + scale(education) + scale(pct_blk) + scale(hispanic)
                               + scale(older_pecent) + scale(prime_pecent) + scale(mid_pecent) 
                               + scale(date_since_social) + scale(date_since)
                               + scale(beds/population) 
                               + scale(obese) + scale(smoke)
                               + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                               + (1|state)
                               + offset(log(population)), data = subset(aggregate_pm_census_cdc_test_beds,X2013.code<=4)) 
summary(mode.nb.random.off.urban)
exp(summary(mode.nb.random.off.urban)[10]$coefficients[2,1])
exp(summary(mode.nb.random.off.urban)[10]$coefficients[2,1] - 1.96*summary(mode.nb.random.off.urban)[10]$coefficients[2,2])
exp(summary(mode.nb.random.off.urban)[10]$coefficients[2,1] + 1.96*summary(mode.nb.random.off.urban)[10]$coefficients[2,2])
summary(mode.nb.random.off.urban)[10]$coefficients[2,4]



# main analysis with category PM
aggregate_pm_census_cdc_test_beds$q_pm = 1
quantile_pm = quantile(aggregate_pm_census_cdc_test_beds$mean_pm25,c(0.2,0.4,0.6,0.8))
aggregate_pm_census_cdc_test_beds$q_pm[aggregate_pm_census_cdc_test_beds$mean_pm25<=quantile_pm[1]] = 1
aggregate_pm_census_cdc_test_beds$q_pm[aggregate_pm_census_cdc_test_beds$mean_pm25>quantile_pm[1] &
                                         aggregate_pm_census_cdc_test_beds$mean_pm25<=quantile_pm[2]] = 2
aggregate_pm_census_cdc_test_beds$q_pm[aggregate_pm_census_cdc_test_beds$mean_pm25>quantile_pm[2] &
                                         aggregate_pm_census_cdc_test_beds$mean_pm25<=quantile_pm[3]] = 3
aggregate_pm_census_cdc_test_beds$q_pm[aggregate_pm_census_cdc_test_beds$mean_pm25>quantile_pm[3] &
                                         aggregate_pm_census_cdc_test_beds$mean_pm25<=quantile_pm[4]] = 4
aggregate_pm_census_cdc_test_beds$q_pm[aggregate_pm_census_cdc_test_beds$mean_pm25>quantile_pm[4]] = 5

mode.nb.random.off.catepm = glmer.nb(Deaths ~ factor(q_pm) + factor(q_popdensity)
                                + scale(poverty)  + scale(log(medianhousevalue))
                                + scale(log(medhouseholdincome)) + scale(pct_owner_occ) 
                                + scale(education) + scale(pct_blk) + scale(hispanic)
                                + scale(older_pecent) + scale(prime_pecent) + scale(mid_pecent) 
                                + scale(date_since_social) + scale(date_since)
                                + scale(beds/population) 
                                + scale(obese) + scale(smoke)
                                + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                                + (1|state)
                                + offset(log(population)), data = (aggregate_pm_census_cdc_test_beds)) 
summary(mode.nb.random.off.urban)
exp(summary(mode.nb.random.off.catepm)[10]$coefficients[2,1])
exp(summary(mode.nb.random.off.catepm)[10]$coefficients[2,1] - 1.96*summary(mode.nb.random.off.catepm)[10]$coefficients[2,2])
exp(summary(mode.nb.random.off.catepm)[10]$coefficients[2,1] + 1.96*summary(mode.nb.random.off.catepm)[10]$coefficients[2,2])
summary(mode.nb.random.off.catepm)[10]$coefficients[2,4]

exp(summary(mode.nb.random.off.catepm)[10]$coefficients[3,1])
exp(summary(mode.nb.random.off.catepm)[10]$coefficients[3,1] - 1.96*summary(mode.nb.random.off.catepm)[10]$coefficients[3,2])
exp(summary(mode.nb.random.off.catepm)[10]$coefficients[3,1] + 1.96*summary(mode.nb.random.off.catepm)[10]$coefficients[3,2])
summary(mode.nb.random.off.catepm)[10]$coefficients[3,4]

exp(summary(mode.nb.random.off.catepm)[10]$coefficients[4,1])
exp(summary(mode.nb.random.off.catepm)[10]$coefficients[4,1] - 1.96*summary(mode.nb.random.off.catepm)[10]$coefficients[4,2])
exp(summary(mode.nb.random.off.catepm)[10]$coefficients[4,1] + 1.96*summary(mode.nb.random.off.catepm)[10]$coefficients[4,2])
summary(mode.nb.random.off.catepm)[10]$coefficients[4,4]

exp(summary(mode.nb.random.off.catepm)[10]$coefficients[5,1])
exp(summary(mode.nb.random.off.catepm)[10]$coefficients[5,1] - 1.96*summary(mode.nb.random.off.catepm)[10]$coefficients[5,2])
exp(summary(mode.nb.random.off.catepm)[10]$coefficients[5,1] + 1.96*summary(mode.nb.random.off.catepm)[10]$coefficients[5,2])
summary(mode.nb.random.off.catepm)[10]$coefficients[5,4]

# tested
mode.nb.random.off.tested = glmer.nb(Deaths ~ mean_pm25 + factor(q_popdensity)
                                + scale(poverty)  + scale(log(medianhousevalue))
                                + scale(log(medhouseholdincome)) + scale(pct_owner_occ) 
                                + scale(education) + scale(pct_blk) + scale(hispanic)
                                + scale(older_pecent) + scale(prime_pecent) + scale(mid_pecent) 
                                + scale(date_since_social) + scale(date_since)
                                + scale(beds/population) 
                                + scale(obese) + scale(smoke)
                                + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                                + (1|state)
                                + scale(totalTestResults)  
                                + offset(log(population)), data = (aggregate_pm_census_cdc_test_beds)) 
summary(mode.nb.random.off.tested)
exp(summary(mode.nb.random.off.tested)[10]$coefficients[2,1])
exp(summary(mode.nb.random.off.tested)[10]$coefficients[2,1] - 1.96*summary(mode.nb.random.off.tested)[10]$coefficients[2,2])
exp(summary(mode.nb.random.off.tested)[10]$coefficients[2,1] + 1.96*summary(mode.nb.random.off.tested)[10]$coefficients[2,2])
summary(mode.nb.random.off.tested)[10]$coefficients[2,4]

# cli
mode.nb.random.off.symptom = glmer.nb(Deaths ~ mean_pm25 + factor(q_popdensity)
                                 + scale(poverty)  + scale(log(medianhousevalue))
                                 + scale(log(medhouseholdincome)) + scale(pct_owner_occ) 
                                 + scale(education) + scale(pct_blk) + scale(hispanic)
                                 + scale(older_pecent) + scale(prime_pecent) + scale(mid_pecent) 
                                 + scale(date_since_social) + scale(date_since)
                                 + scale(beds/population) 
                                 + scale(obese) + scale(smoke)
                                 + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                                 + scale(cli)  
                                 + (1|Province_State)
                                 + offset(log(population)), data = (aggregate_pm_census_cdc_test_beds)) 
summary(mode.nb.random.off.symptom)
exp(summary(mode.nb.random.off.symptom)[10]$coefficients[2,1])
exp(summary(mode.nb.random.off.symptom)[10]$coefficients[2,1] - 1.96*summary(mode.nb.random.off.symptom)[10]$coefficients[2,2])
exp(summary(mode.nb.random.off.symptom)[10]$coefficients[2,1] + 1.96*summary(mode.nb.random.off.symptom)[10]$coefficients[2,2])
summary(mode.nb.random.off.symptom)[10]$coefficients[2,4]


# log(popdensity)
mode.nb.random.off.main.logpopdensity = glmer.nb(Deaths ~ mean_pm25 + scale(log(popdensity))
                                            + scale(poverty)  + scale(log(medianhousevalue))
                                            + scale(log(medhouseholdincome)) + scale(pct_owner_occ) 
                                            + scale(education) + scale(pct_blk) + scale(hispanic)
                                            + scale(older_pecent) + scale(prime_pecent) + scale(mid_pecent) 
                                            + scale(date_since_social) + scale(date_since)
                                            + scale(beds/population) 
                                            + scale(obese) + scale(smoke)
                                            + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                                            + (1|state)
                                            + offset(log(population)), data = aggregate_pm_census_cdc_test_beds)
summary(mode.nb.random.off.main.logpopdensity)
exp(summary(mode.nb.random.off.main.logpopdensity)[10]$coefficients[2,1])
exp(summary(mode.nb.random.off.main.logpopdensity)[10]$coefficients[2,1] - 1.96*summary(mode.nb.random.off.main.logpopdensity)[10]$coefficients[2,2])
exp(summary(mode.nb.random.off.main.logpopdensity)[10]$coefficients[2,1] + 1.96*summary(mode.nb.random.off.main.logpopdensity)[10]$coefficients[2,2])
summary(mode.nb.random.off.main.logpopdensity)[10]$coefficients[2,4]


# log
mode.nb.random.log = glmer.nb(Deaths ~ mean_pm25 + factor(q_popdensity)
                         + scale(poverty)  + scale(log(medianhousevalue))
                         + scale(log(medhouseholdincome)) + scale(pct_owner_occ) 
                         + scale(education) + scale(pct_blk) + scale(hispanic)
                         + scale(older_pecent) + scale(prime_pecent) + scale(mid_pecent) 
                         + scale(date_since_social) + scale(date_since)
                         + scale(beds/population) 
                         + scale(obese) + scale(smoke)
                         + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                         + (1|state)
                         + scale(log(population)), data = (aggregate_pm_census_cdc_test_beds)) 
summary(mode.nb.random.log)
exp(summary(mode.nb.random.log)[10]$coefficients[2,1])
exp(summary(mode.nb.random.log)[10]$coefficients[2,1] - 1.96*summary(mode.nb.random.log)[10]$coefficients[2,2])
exp(summary(mode.nb.random.log)[10]$coefficients[2,1] + 1.96*summary(mode.nb.random.log)[10]$coefficients[2,2])
summary(mode.nb.random.log)[10]$coefficients[2,4]

mode.nb.random.nonlog = glmer.nb(Deaths ~ mean_pm25 + factor(q_popdensity)
                              + scale(poverty)  + scale(log(medianhousevalue))
                              + scale(log(medhouseholdincome)) + scale(pct_owner_occ) 
                              + scale(education) + scale(pct_blk) + scale(hispanic)
                              + scale(older_pecent) + scale(prime_pecent) + scale(mid_pecent) 
                              + scale(date_since_social) + scale(date_since)
                              + scale(beds/population) 
                              + scale(obese) + scale(smoke)
                              + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                              + (1|state)
                              + scale((population)), data = (aggregate_pm_census_cdc_test_beds)) 
summary(mode.nb.random.nonlog)
exp(summary(mode.nb.random.nonlog)[10]$coefficients[2,1])
exp(summary(mode.nb.random.nonlog)[10]$coefficients[2,1] - 1.96*summary(mode.nb.random.nonlog)[10]$coefficients[2,2])
exp(summary(mode.nb.random.nonlog)[10]$coefficients[2,1] + 1.96*summary(mode.nb.random.nonlog)[10]$coefficients[2,2])
summary(mode.nb.random.nonlog)[10]$coefficients[2,4]

# zero inflated
glmmTMB.off.main = glmmTMB(Deaths ~ mean_pm25 + factor(q_popdensity)
                           + scale(poverty)  + scale(log(medianhousevalue))
                           + scale(log(medhouseholdincome)) + scale(pct_owner_occ) 
                           + scale(education) + scale(pct_blk) + scale(hispanic)
                           + scale(older_pecent) + scale(prime_pecent) + scale(mid_pecent) 
                           + scale(date_since_social) + scale(date_since)
                           + scale(beds/population) 
                           + scale(obese) + scale(smoke)
                           + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                           + offset(log(population)) + (1 | state), data = aggregate_pm_census_cdc_test_beds, 
                           family = nbinom2, ziformula  = ~ 1
)
exp(summary(glmmTMB.off.main)[6]$coefficients$cond[2,1])
exp(summary(glmmTMB.off.main)[6]$coefficients$cond[2,1] - 1.96*summary(glmmTMB.off.main)[6]$coefficients$cond[2,2])
exp(summary(glmmTMB.off.main)[6]$coefficients$cond[2,1] + 1.96*summary(glmmTMB.off.main)[6]$coefficients$cond[2,2])
summary(glmmTMB.off.main)[6]$coefficients$cond[2,4]

# fixed NB
glm.nb.off = glm.nb(Deaths ~  mean_pm25 + factor(q_popdensity)
                    + scale(poverty)  + scale(log(medianhousevalue))
                    + scale(log(medhouseholdincome)) + scale(pct_owner_occ) 
                    + scale(education) + scale(pct_blk) + scale(hispanic) 
                    + scale(older_pecent) + scale(prime_pecent) + scale(mid_pecent) 
                    + scale(date_since_social) + scale(date_since)
                    + scale(beds/population) 
                    + scale(obese) + scale(smoke)
                    + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                    + factor(state)
                    + offset(log(population)), data = aggregate_pm_census_cdc_test_beds)
summary(glm.nb.off)


# spatial-correlation gamm
gamm.off.main = gamm4(Deaths ~ mean_pm25 + factor(q_popdensity)
                         + scale(poverty)  + scale(log(medianhousevalue))
                         + scale(log(medhouseholdincome)) + scale(pct_owner_occ) 
                         + scale(education) + scale(pct_blk) + scale(hispanic) 
                         + scale(older_pecent) + scale(prime_pecent) + scale(mid_pecent) 
                         + scale(date_since_social) + scale(date_since)
                         + scale(beds/population) 
                         + scale(obese) + scale(smoke)
                         + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                         + offset(log(population)) + s(Lat) + s(Long_), data = aggregate_pm_census_cdc_test_beds, 
                         family=negbin(1), random = ~(1|state))
exp(summary(gamm.off.main.bi))


# non-linear pm
gamm.off.main.spm25 = gamm4(Deaths ~ s(mean_pm25) + factor(q_popdensity)
                         + scale(poverty)  + scale(log(medianhousevalue))
                         + scale(log(medhouseholdincome)) + scale(pct_owner_occ) 
                         + scale(education) + scale(pct_blk) + scale(hispanic) 
                         + scale(older_pecent) + scale(prime_pecent) + scale(mid_pecent) 
                         + scale(date_since_social) + scale(date_since)
                         + scale(beds/population) 
                         + scale(obese) + scale(smoke)
                         + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                         + offset(log(population)) + s(Lat) + s(Long_), data = aggregate_pm_census_cdc_test_beds, 
                         family=negbin(1), random = ~(1|state))


