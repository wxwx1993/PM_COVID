library("dplyr")
library("pscl")
library("MASS")
library("R2admb")
library("glmmADMB")
library("nonnest2")
library(NBZIMM)


# main analysis
glmm.zinb.off = glmm.zinb(fixed = Deaths ~ mean_pm25 +scale(poverty) + scale(popdensity)  +scale(medianhousevalue) 
                          +scale(medhouseholdincome) + scale(pct_owner_occ)  +scale(hispanic) 
                          +scale(education)  +scale(pct_blk) + scale(older_pecent) 
                          + scale(totalTestResults) + 
                            + scale(beds) 
                          + scale(mean_bmi) + scale(smoke_rate)
                          + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                          + offset(log(population)), 
                          random = ~ 1 | state, data = (aggregate_pm_census_cdc_test_beds)) 
summary(glmm.zinb.off)
fixed(glmm.zinb.off)$dist[2,1]
fixed(glmm.zinb.off)$dist[2,1] - 1.96*fixed(glmm.zinb.off)$dist[2,2]
fixed(glmm.zinb.off)$dist[2,1] + 1.96*fixed(glmm.zinb.off)$dist[2,2]
fixed(glmm.zinb.off)$dist[2,3]

glmm.zinb.log = glmm.zinb(fixed = Deaths ~ mean_pm25 +scale(poverty) + scale(popdensity)  +scale(medianhousevalue) 
                          +scale(medhouseholdincome) + scale(pct_owner_occ)  +scale(hispanic) 
                          +scale(education)  +scale(pct_blk) + scale(older_pecent)
                          + scale(beds) 
                          + scale(mean_bmi) + scale(smoke_rate)
                          + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                          + scale(totalTestResults)
                          + scale(log(population)), 
                          random = ~ 1 | state, data = (aggregate_pm_census_cdc_test_beds)) 
summary(glmm.zinb.log)
fixed(glmm.zinb.log)$dist[2,1]
fixed(glmm.zinb.log)$dist[2,1] - 1.96*fixed(glmm.zinb.log)$dist[2,2]
fixed(glmm.zinb.log)$dist[2,1] + 1.96*fixed(glmm.zinb.log)$dist[2,2]
fixed(glmm.zinb.log)$dist[2,3]

glmm.zinb.nonlog = glmm.zinb(fixed = Deaths ~ mean_pm25 +scale(poverty) + scale(popdensity)  +scale(medianhousevalue) 
                             +scale(medhouseholdincome) + scale(pct_owner_occ)  +scale(hispanic) 
                             +scale(education)  +scale(pct_blk) + scale(older_pecent)
                             + scale(beds) 
                             + scale(mean_bmi) + scale(smoke_rate)
                             + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                             + scale(totalTestResults)
                             + scale((population)), 
                             random = ~ 1 | state, data = (aggregate_pm_census_cdc_test_beds)) 
summary(glmm.zinb.nonlog)
fixed(glmm.zinb.nonlog)$dist[2,1]
fixed(glmm.zinb.nonlog)$dist[2,1] - 1.96*fixed(glmm.zinb.nonlog)$dist[2,2]
fixed(glmm.zinb.nonlog)$dist[2,1] + 1.96*fixed(glmm.zinb.nonlog)$dist[2,2]
fixed(glmm.zinb.nonlog)$dist[2,3]

# - beds
glmm.zinb.off = glmm.zinb(fixed = Deaths ~ mean_pm25 +scale(poverty) + scale(popdensity)  +scale(medianhousevalue) 
                          +scale(medhouseholdincome) + scale(pct_owner_occ)  +scale(hispanic) 
                          +scale(education)  +scale(pct_blk) + scale(older_pecent)
                          #+ scale(beds) 
                          + scale(mean_bmi) + scale(smoke_rate)
                          + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                          + scale(totalTestResults)
                          + offset(log(population)), 
                          random = ~ 1 | state, data = (aggregate_pm_census_cdc_test_beds)) 
summary(glmm.zinb.off)
fixed(glmm.zinb.off)$dist[2,1]
fixed(glmm.zinb.off)$dist[2,1] - 1.96*fixed(glmm.zinb.off)$dist[2,2]
fixed(glmm.zinb.off)$dist[2,1] + 1.96*fixed(glmm.zinb.off)$dist[2,2]
fixed(glmm.zinb.off)$dist[2,3]


# - tested
glmm.zinb.off = glmm.zinb(fixed = Deaths ~ mean_pm25 +scale(poverty) + scale(popdensity)  +scale(medianhousevalue) 
                          +scale(medhouseholdincome) + scale(pct_owner_occ)  +scale(hispanic) 
                          +scale(education)  +scale(pct_blk) + scale(older_pecent)
                          + scale(beds) 
                          + scale(mean_bmi) + scale(smoke_rate)
                          + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                          #+ scale(totalTestResults)
                          + offset(log(population)), 
                          random = ~ 1 | state, data = (aggregate_pm_census_cdc_test_beds)) 
summary(glmm.zinb.off)
fixed(glmm.zinb.off)$dist[2,1]
fixed(glmm.zinb.off)$dist[2,1] - 1.96*fixed(glmm.zinb.off)$dist[2,2]
fixed(glmm.zinb.off)$dist[2,1] + 1.96*fixed(glmm.zinb.off)$dist[2,2]
fixed(glmm.zinb.off)$dist[2,3]

# - smoking + bmi
glmm.zinb.off = glmm.zinb(fixed = Deaths ~ mean_pm25 +scale(poverty) + scale(popdensity)  +scale(medianhousevalue) 
                          +scale(medhouseholdincome) + scale(pct_owner_occ)  +scale(hispanic) 
                          +scale(education)  +scale(pct_blk) + scale(older_pecent)
                          + scale(beds) 
                          #+ scale(mean_bmi) + scale(smoke_rate)
                          + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                          + scale(totalTestResults)
                          + offset(log(population)), 
                          random = ~ 1 | state, data = (aggregate_pm_census_cdc_test_beds)) 
summary(glmm.zinb.off)
fixed(glmm.zinb.off)$dist[2,1]
fixed(glmm.zinb.off)$dist[2,1] - 1.96*fixed(glmm.zinb.off)$dist[2,2]
fixed(glmm.zinb.off)$dist[2,1] + 1.96*fixed(glmm.zinb.off)$dist[2,2]
fixed(glmm.zinb.off)$dist[2,3]


# - temp + humidity
glmm.zinb.off = glmm.zinb(fixed = Deaths ~ mean_pm25 +scale(poverty) + scale(popdensity)  +scale(medianhousevalue) 
                          +scale(medhouseholdincome) + scale(pct_owner_occ)  +scale(hispanic) 
                          +scale(education)  +scale(pct_blk) + scale(older_pecent) 
                          + scale(beds) 
                          + scale(mean_bmi) + scale(smoke_rate)
                          #+ scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                          + scale(totalTestResults)
                          + offset(log(population)), 
                          random = ~ 1 | state, data = (aggregate_pm_census_cdc_test_beds)) 
summary(glmm.zinb.off)
fixed(glmm.zinb.off)$dist[2,1]
fixed(glmm.zinb.off)$dist[2,1] - 1.96*fixed(glmm.zinb.off)$dist[2,2]
fixed(glmm.zinb.off)$dist[2,1] + 1.96*fixed(glmm.zinb.off)$dist[2,2]
fixed(glmm.zinb.off)$dist[2,3]

# exclude NY
glmm.zinb.off = glmm.zinb(fixed = Deaths ~ mean_pm25 +scale(poverty) + scale(popdensity)  +scale(medianhousevalue) 
                          +scale(medhouseholdincome) + scale(pct_owner_occ)  +scale(hispanic) 
                          +scale(education)  +scale(pct_blk) + scale(older_pecent)
                          + scale(beds) 
                          + scale(mean_bmi) + scale(smoke_rate)
                          + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                          + scale(totalTestResults)
                          + offset(log(population)), 
                          random = ~ 1 | state, data = subset(aggregate_pm_census_cdc_test_beds,Province_State != "New York")) 
summary(glmm.zinb.off)
fixed(glmm.zinb.off)$dist[2,1]
fixed(glmm.zinb.off)$dist[2,1] - 1.96*fixed(glmm.zinb.off)$dist[2,2]
fixed(glmm.zinb.off)$dist[2,1] + 1.96*fixed(glmm.zinb.off)$dist[2,2]
fixed(glmm.zinb.off)$dist[2,3]

# exclude <10 confirmed
glmm.zinb.off = glmm.zinb(fixed = Deaths ~ mean_pm25 +scale(poverty) + scale(popdensity)  +scale(medianhousevalue) 
                          +scale(medhouseholdincome) + scale(pct_owner_occ)  +scale(hispanic) 
                          +scale(education)  +scale(pct_blk) + scale(older_pecent)
                          + scale(beds) 
                          + scale(mean_bmi) + scale(smoke_rate)
                          + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                          + scale(totalTestResults)
                          + offset(log(population)), 
                          random = ~ 1 | state, data = subset(aggregate_pm_census_cdc_test_beds,Confirmed >=10)) 
summary(glmm.zinb.off)
fixed(glmm.zinb.off)$dist[2,1]
fixed(glmm.zinb.off)$dist[2,1] - 1.96*fixed(glmm.zinb.off)$dist[2,2]
fixed(glmm.zinb.off)$dist[2,1] + 1.96*fixed(glmm.zinb.off)$dist[2,2]
fixed(glmm.zinb.off)$dist[2,3]


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

glmm.zinb.off = glmm.zinb(fixed = Deaths ~ factor(q_pm) +scale(poverty) + scale(popdensity)  +scale(medianhousevalue) 
                          +scale(medhouseholdincome) + scale(pct_owner_occ)  +scale(hispanic) 
                          +scale(education)  +scale(pct_blk) + scale(older_pecent)
                          + scale(beds) 
                          + scale(mean_bmi) + scale(smoke_rate)
                          + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                          + scale(totalTestResults)
                          + offset(log(population)), 
                          random = ~ 1 | state, data = (aggregate_pm_census_cdc_test_beds)) 
summary(glmm.zinb.off)
fixed(glmm.zinb.off)$dist[2,1]
fixed(glmm.zinb.off)$dist[2,1] - 1.96*fixed(glmm.zinb.off)$dist[2,2]
fixed(glmm.zinb.off)$dist[2,1] + 1.96*fixed(glmm.zinb.off)$dist[2,2]
fixed(glmm.zinb.off)$dist[2,3]

fixed(glmm.zinb.off)$dist[3,1]
fixed(glmm.zinb.off)$dist[3,1] - 1.96*fixed(glmm.zinb.off)$dist[3,2]
fixed(glmm.zinb.off)$dist[3,1] + 1.96*fixed(glmm.zinb.off)$dist[3,2]
fixed(glmm.zinb.off)$dist[3,3]

fixed(glmm.zinb.off)$dist[4,1]
fixed(glmm.zinb.off)$dist[4,1] - 1.96*fixed(glmm.zinb.off)$dist[4,2]
fixed(glmm.zinb.off)$dist[4,1] + 1.96*fixed(glmm.zinb.off)$dist[4,2]
fixed(glmm.zinb.off)$dist[4,3]

fixed(glmm.zinb.off)$dist[5,1]
fixed(glmm.zinb.off)$dist[5,1] - 1.96*fixed(glmm.zinb.off)$dist[5,2]
fixed(glmm.zinb.off)$dist[5,1] + 1.96*fixed(glmm.zinb.off)$dist[5,2]
fixed(glmm.zinb.off)$dist[5,3]


# + q_popdensity
glmm.zinb.off = glmm.zinb(fixed = Deaths ~ mean_pm25 +scale(poverty) + factor(q_popdensity)  +scale(medianhousevalue) 
                          +scale(medhouseholdincome) + scale(pct_owner_occ)  +scale(hispanic) 
                          +scale(education)  +scale(pct_blk) + scale(older_pecent)
                          + scale(beds) 
                          + scale(mean_bmi) + scale(smoke_rate)
                          + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                          + scale(totalTestResults)
                          + offset(log(population)), 
                          random = ~ 1 | state, data = (aggregate_pm_census_cdc_test_beds)) 
#summary(glmm.zinb.off)
fixed(glmm.zinb.off)$dist[2,1]
fixed(glmm.zinb.off)$dist[2,1] - 1.96*fixed(glmm.zinb.off)$dist[2,2]
fixed(glmm.zinb.off)$dist[2,1] + 1.96*fixed(glmm.zinb.off)$dist[2,2]
fixed(glmm.zinb.off)$dist[2,3]


# Negative binomial
mode.nb.random.off = glmer.nb(Deaths ~ mean_pm25 +scale(poverty)   +scale(medianhousevalue) + scale(popdensity)
                              +scale(medhouseholdincome) + scale(pct_owner_occ)  +scale(hispanic)  
                              +scale(education)  +scale(pct_blk) + scale(older_pecent) 
                              + scale(beds) 
                              + scale(mean_bmi) + scale(smoke_rate)
                              + scale(mean_summer_temp) + scale(mean_winter_temp) + scale(mean_summer_rm) + scale(mean_winter_rm)
                              + scale(totalTestResults)
                              + (1|state)
                              + offset(log(population)), data = aggregate_pm_census_cdc_test_beds)
summary(mode.nb.random.off)


