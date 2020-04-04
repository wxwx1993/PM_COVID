library(tidyverse)
library(sp)
library("raster")
library("dplyr")
library("sf")
library("stringr")
library("ggplot2")
library(grid) 
library(pBrackets) 
library(gridExtra)
library("lme4")

# Figure 1 the US PM2.5 and COVID-19 death maps
us<-map_data('state')

#Plot prevalence of COVID-19
states <- st_read("./cb_2017_us_county_500k/cb_2017_us_county_500k.shp")

aggregate_pm_census_cdc_test_beds$fips = str_pad(aggregate_pm_census_cdc_test_beds$fips, 5, pad = "0")
covid_us <- mutate(aggregate_pm_census_cdc_test_beds,
                   STATEFP = str_sub(fips, 1, 2),
                   COUNTYFP = str_sub(fips, 3, 5))
str(covid_us)
str(states)
states$STATEFP=as.character(states$STATEFP)
states$COUNTYFP=as.character(states$COUNTYFP)
statesCOVID <- left_join(states, covid_us, by = c("STATEFP", "COUNTYFP"))
statesCOVID$mortality = statesCOVID$Deaths/statesCOVID$population*10^6
statesCOVID$logmortality = log10(statesCOVID$Deaths/statesCOVID$population*10^6)
statesCOVID$logmortality[statesCOVID$logmortality < 0] = -1
g1<-ggplot(statesCOVID)+
  xlim(-125,-65)+ylim(25,50)+
  #  geom_sf(aes(fill = PD_p),color=NA,size=0.025)+
  geom_sf(aes(fill = logmortality),color='grey',size=0.005)+
  #  scale_fill_viridis_c(option="magma",begin=0.4)+
  scale_fill_gradient2(expression(paste("# COVID-19 deaths per 1 million")),low  = "#1e90ff", mid="#ffffba", high = "#8b0000",midpoint = 1.2,
                       breaks = c(-1,0,1,2,3,4),
                       labels = c("0","1","10","100","1000","10000+"),limits = c(-1,4.5) , na.value = "white") +
  # labs(title = expression(paste("Cumulative Deaths Related to COVID-19 until March 30, 2020"))) +
  theme_minimal() +
  theme(plot.title = element_text(size = 24*2,hjust = 0.5),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        line = element_blank(),
        axis.title = element_blank(),
        legend.position = "bottom",
        legend.direction = "horizontal", 
        legend.text = element_text(angle = 60,  size = 20*2),
        legend.text.align = 0.75,
        legend.title = element_text(size = 18*2),
        legend.key.width = unit(150*2, "points"),
        panel.grid.major = element_line(colour = "transparent"))

png("county_covid.jpeg", height = 1024*0.6*2, width = 1024*2)
g1
dev.off()

county_pm_aggregated = county_pm %>% 
  group_by(fips) %>% 
  summarise(mean_pm25 = mean(pm25))

county_pm_aggregated$fips = str_pad(county_pm_aggregated$fips, 5, pad = "0")
county_pm_aggregated <- mutate(county_pm_aggregated,
                               STATEFP = str_sub(fips, 1, 2),
                               COUNTYFP = str_sub(fips, 3, 5))
str(county_pm_aggregated)
str(states)
states$STATEFP=as.character(states$STATEFP)
states$COUNTYFP=as.character(states$COUNTYFP)
statesPM <- left_join(states, county_pm_aggregated, by = c("STATEFP", "COUNTYFP"))

g2<-ggplot(statesPM)+
  xlim(-125,-65)+ylim(25,50)+
  geom_sf(aes(fill = mean_pm25),color='grey',size=0.005)+
  #  scale_fill_viridis_c(option="magma",begin=0.4)+
  # scale_fill_viridis_c(option="magma",begin=0,direction = -1, breaks = c(0,4,8,12,16,20))+
  scale_fill_gradient2(expression(paste("PM"[2.5])),low  = "#1e90ff", mid="#ffffba", high = "#8b0000",midpoint = 9,
                       breaks = c(0,3,6,9,12),
                       labels = c("0","3","6","9","12+"),limits = c(0,15) , na.value = "white") +
  # labs(title = expression(paste("Annual Average of PM"[2.5]," per ",mu,g/m^3," in 2000-2016"))) +
  theme_minimal() +
  theme(plot.title = element_text(size = 24*2,hjust = 0.5),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        line = element_blank(),
        axis.title = element_blank(),
        legend.position = "bottom",
        legend.direction = "horizontal", 
        legend.text = element_text(angle = 60,  size = 20*2),
        legend.text.align = 0.75,
        legend.title = element_text(size = 24*2),
        legend.key.width = unit(150*2, "points"),
        panel.grid.major = element_line(colour = "transparent"))

png("county_pm.jpeg", height = 1024*0.6*2, width = 1024*2)
g2
dev.off()

# Figure 2 main analyses

data <- data.frame(method = c("Main Analysis", "Adjust for # Hospital Beds", "Adjust for # Tested","Adjust for BRFSS","Adjust for BRFSS", "Exclude NY State"),
                   RR = exp(c(0.13, 0.17, 0.13, 0.14, 0.09)
                   ),
                   lower_CI = exp(c(0.06,0.08,0.06,0.06,0.02)
                   ),
                   upper_CI = exp(c(0.20,0.26,0.20,0.22,0.17)
                   ),
                   Methods = c(1:5))

bracketsGrob <- function(...){ 
  l <- list(...) 
  e <- new.env() 
  e$l <- l 
  grid:::recordGrob( { 
    do.call(grid.brackets, l) 
  }, e) 
} 

# Figure 2
pdf("RR1.pdf",width = 28, height = 11)
#jpeg("RR1.jpeg", height = 1024*0.85, width = 1024*2)
p1 <- ggplot(data[1:5,], aes(x=Methods, y=RR),size= 5) + 
  ylab("Mortality Rate Ratios") +
  geom_point(aes(size = 1)) +
  geom_errorbar(aes(ymin=lower_CI, ymax=upper_CI), width=.2,size=1) +
  geom_hline(yintercept = 1.0, linetype="dashed", size=0.8)  +
  annotate(geom = "text", x = seq_len(nrow(data)), y = 1-12/100, label = data$method, size = 6*2) +
  #annotate(geom = "text", x = c(3), y = 1+21/100, label = c("Entire Medicare Enrollees (2000-2016)"), size = 8) +
  #annotate(geom = "text", x = c(c(1.5+5 * (0),4+5 * (0))), y = 1-1.75/100, label = c(rep(c("Regression"),1),rep(c("Causal"),1)), size = 8) +
  coord_cartesian(ylim = c(0.90, 1.4), xlim = c(0.5, 5.5), expand = FALSE, clip = "off")  +
  #geom_segment(aes(x = 2.5, y = 1-10/100, xend = 2.5, yend = 1),colour="black") +
  theme_bw() +
  theme(plot.margin = unit(c(3, 2, 4, 1), "lines"),
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size=16*2),
        axis.title.y = element_text(size = 20*2),
        legend.position = "none")
p1
dev.off()


# Figure S1
mode.nb.random.off = glmer.nb(Deaths ~ mean_pm25 +scale(poverty)   +scale(medianhousevalue) + scale(popdensity)
                              +scale(medhouseholdincome) + scale(pct_owner_occ)  +scale(hispanic)  
                              +scale(education)  +scale(pct_blk) + scale(older_pecent) + (1|state)
                              + offset(log(population)), data = aggregate_pm_census_cdc_test_beds)
summary(mode.nb.random.off)


y = subset(aggregate_pm_census_cdc_test_beds,is.na(older_pecent)==F)$Deaths
n = length(y)
E.y. <- predict(mode.nb.random.off)
par(mfrow=c(2,1))
plot(E.y., y - E.y.)
plot(E.y., (y - E.y.)/sqrt(E.y.))
plot(y - E.y.)
plot((y - E.y.)/sqrt(E.y.))
par(mfrow=c(1,2))
plot(E.y.,y,cex.lab=2,cex.axis = 2)
plot(log(E.y.+1),log(y+1),cex.lab=2,cex.axis = 2)

# Figure S2
data <- data.frame(method = c(rep(c("Main Analysis", "Adjust for # Hospital Beds", "Adjust for # Tested","Adjust for BRFSS","Adjust for Weather", "Exclude NY State", "Exclude Confirmed < 10"),4)),
                   RR = exp(c(0.13, 0.17, 0.13, 0.14, 0.17, 0.09, 0.04,
                              0.14, 0.18, 0.13, 0.14, 0.18, 0.09, 0.05,
                              0.10, 0.11, 0.10, 0.10, 0.14, 0.06, 0.04,
                              0.11, 0.08, 0.11, 0.11, 0.17, 0.06, 0.06)
                   ),
                   lower_CI = exp(c(0.06, 0.08, 0.06, 0.06, 0.09, 0.02,-0.05,
                                    0.06, 0.08, 0.06, 0.05, 0.08, 0.01, -0.06,
                                    0.03, -0.01, 0.00, 0.00, 0.06, -0.04, -0.02,
                                    0.02, -0.03, 0.01, 0.00, 0.07, -0.04, -0.07)
                   ),
                   upper_CI = exp(c(0.20, 0.26, 0.20, 0.22, 0.24, 0.17, 0.14,
                                    0.22, 0.28, 0.21, 0.23, 0.27, 0.17, 0.15,
                                    0.17, 0.20, 0.17, 0.18, 0.22, 0.13, 0.13,
                                    0.21, 0.20, 0.20, 0.21, 0.28, 0.16, 0.19)
                   ),
                   Methods = c(1:7,1:7,1:7,1:7),
                   Exposure = c(rep("17-year mean (2000-2016) by (1)",7),rep("the most recent (2016) by (1)",7),
                                rep("17-year mean (2000-2016) by (2)",7),rep("the most recent (2016) by (2)",7)))

# Figure 3
pdf("RR_sup.pdf",width = 40, height = 44)

p1 <- ggplot(data[1:7,], aes(x=Methods, y=RR),size= 5) + 
  ylab("Mortality Rate Ratios") +
  geom_point(aes(size = 1)) +
  geom_errorbar(aes(ymin=lower_CI, ymax=upper_CI), width=.2,size=1) +
  geom_hline(yintercept = 1.0, linetype="dashed", size=0.8)  +
  annotate(geom = "text", x = seq_len(nrow(data)), y = 1-12/100, label = data$method, size = 6.5*2) +
  annotate(geom = "text", x = c(4), y = 1+42/100, label = c(expression(paste("P-1"))), size = 9*2) +
  #annotate(geom = "text", x = c(c(1.5+5 * (0),4+5 * (0))), y = 1-1.75/100, label = c(rep(c("Regression"),1),rep(c("Causal"),1)), size = 8) +
  coord_cartesian(ylim = c(0.90, 1.4), xlim = c(0.5, 7.5), expand = FALSE, clip = "off")  +
  #geom_segment(aes(x = 2.5, y = 1-10/100, xend = 2.5, yend = 1),colour="black") +
  theme_bw() +
  theme(plot.margin = unit(c(4, 2, 4, 2), "lines"),
        plot.title = element_text(hjust=0.5),
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size=16*2),
        axis.title.y = element_text(size = 18*2),
        legend.position = "none")


p2 <- ggplot(data[8:14,], aes(x=Methods, y=RR),size= 5) + 
  ylab("Mortality Rate Ratios") +
  geom_point(aes(size = 1)) +
  geom_errorbar(aes(ymin=lower_CI, ymax=upper_CI), width=.2,size=1) +
  geom_hline(yintercept = 1.0, linetype="dashed", size=0.8)  +
  annotate(geom = "text", x = seq_len(nrow(data)), y = 1-12/100, label = data$method, size = 6.5*2) +
  annotate(geom = "text", x = c(4), y = 1+42/100, label = c(expression(paste("P-2"))), size = 9*2) +
  #annotate(geom = "text", x = c(c(1.5+5 * (0),4+5 * (0))), y = 1-1.75/100, label = c(rep(c("Regression"),1),rep(c("Causal"),1)), size = 8) +
  coord_cartesian(ylim = c(0.90, 1.4), xlim = c(0.5, 7.5), expand = FALSE, clip = "off")  +
  #geom_segment(aes(x = 2.5, y = 1-10/100, xend = 2.5, yend = 1),colour="black") +
  theme_bw() +
  theme(plot.margin = unit(c(4, 2, 4, 2), "lines"),
        plot.title = element_text(hjust=0.5),
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size=16*2),
        axis.title.y = element_text(size = 18*2),
        legend.position = "none")

p3 <- ggplot(data[15:21,], aes(x=Methods, y=RR),size= 5) + 
  ylab("Mortality Rate Ratios") +
  geom_point(aes(size = 1)) +
  geom_errorbar(aes(ymin=lower_CI, ymax=upper_CI), width=.2,size=1) +
  geom_hline(yintercept = 1.0, linetype="dashed", size=0.8)  +
  annotate(geom = "text", x = seq_len(nrow(data)), y = 1-12/100, label = data$method, size = 6.5*2) +
  annotate(geom = "text", x = c(4), y = 1+42/100, label = c(expression(paste("P-3"))), size = 9*2) +
  #annotate(geom = "text", x = c(c(1.5+5 * (0),4+5 * (0))), y = 1-1.75/100, label = c(rep(c("Regression"),1),rep(c("Causal"),1)), size = 8) +
  coord_cartesian(ylim = c(0.90, 1.4), xlim = c(0.5, 7.5), expand = FALSE, clip = "off")  +
  #geom_segment(aes(x = 2.5, y = 1-10/100, xend = 2.5, yend = 1),colour="black") +
  theme_bw() +
  theme(plot.margin = unit(c(4, 2, 4, 2), "lines"),
        plot.title = element_text(hjust=0.5),
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size=16*2),
        axis.title.y = element_text(size = 18*2),
        legend.position = "none")

p4 <- ggplot(data[22:28,], aes(x=Methods, y=RR),size= 5) + 
  ylab("Mortality Rate Ratios") +
  geom_point(aes(size = 1)) +
  geom_errorbar(aes(ymin=lower_CI, ymax=upper_CI), width=.2,size=1) +
  geom_hline(yintercept = 1.0, linetype="dashed", size=0.8)  +
  annotate(geom = "text", x = seq_len(nrow(data)), y = 1-12/100, label = data$method, size = 6.5*2) +
  annotate(geom = "text", x = c(4), y = 1+42/100, label = c(expression(paste("P-4"))), size = 9*2) +
  #annotate(geom = "text", x = c(c(1.5+5 * (0),4+5 * (0))), y = 1-1.75/100, label = c(rep(c("Regression"),1),rep(c("Causal"),1)), size = 8) +
  coord_cartesian(ylim = c(0.90, 1.4), xlim = c(0.5, 7.5), expand = FALSE, clip = "off")  +
  #geom_segment(aes(x = 2.5, y = 1-10/100, xend = 2.5, yend = 1),colour="black") +
  theme_bw() +
  theme(plot.margin = unit(c(4, 2, 4, 2), "lines"),
        plot.title = element_text(hjust=0.5),
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size=16*2),
        axis.title.y = element_text(size = 18*2),
        legend.position = "none")

grid.arrange(p1, p2,p3,p4, nrow = 4)

dev.off()
