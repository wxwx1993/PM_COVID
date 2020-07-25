# Exposure to air pollution and COVID-19 mortality in the United States
This is the data repository for public available code and data to reproduce analyses in "Exposure to air pollution and COVID-19 mortality in the United States".

<b>Code: </b><br>
[`Prepossing.R`](https://github.com/wxwx1993/PM_COVID/blob/master/Preprocessing.R) includes the code to extract all necessary data and prepocess data for statistical analyses.

[`Analyses.R`](https://github.com/wxwx1993/PM_COVID/blob/master/Analyses.R) includes the code to implement negative binomial mixed models in primary, secondary and sensitivity analyses.

[`Figure.R`](https://github.com/wxwx1993/PM_COVID/blob/master/Figure.R) includes the code to generate figures in Main Text and Supplementary Materials.

[`additional_preprocessing_code`](https://github.com/wxwx1993/PM_COVID/tree/master/additional_preprocessing_code) contains markdown files with code demonstrating the methodology we used to aggregate our zip code level data to the county level.


<b>Data: </b><br>
county_pm25.csv: the county-level PM2.5 exposure data averaged across the period 2000-2016 and averaged across grid cells in each county. For more source information see Additional Data Source section.

temp_seasonal_county.csv: the county-level seasonal temperature and relative humidity data, summer and winter averaged across the period 2000-2016 and averaged across grid cells in each county. For more source information see Additional Data Source section.

census_county_interpolated.csv: the county-level socioeconomic and demographic variables from 2012-2016 American Community Survey (https://www.census.gov/programs-surveys/acs/data.html).

county_base_mortality.txt, county_old_mortality.txt: additional county-level socioeconomic and demographic variables from 2009-2016 
US CDC Compressed Mortality Data (https://wonder.cdc.gov/cmf-ICD10.html).

brfss_county_interpolated.csv: the county-level behavioral risk factor variables for 2011 US CDC Behavioral Risk Factor Surveillance System (https://www.cdc.gov/brfss/).

statecode.csv: A map between state name and state abbreviations.

<b>Additional Data Source: </b><br>
The county-level PM2.5 exposure data can be created via PM2.5 predictions from The Atmospheric Composition Analysis Group at Dalhouse University (http://fizz.phys.dal.ca/~atmos/martin/). Please visit the detailed instructions below

- Download PM25 predictions: https://github.com/wxwx1993/PM_COVID/blob/master/additional_preprocessing_code/download_pm25_values.md. This code makes use of ZIP code shape files provided by ESRI.
- County-level aggregation: https://github.com/wxwx1993/PM_COVID/blob/master/additional_preprocessing_code/rm_pm25_to_county.md

We thank Randall Martin and the members of the Atmospheric Composition Analysis Group at Dalhouse University for providing access to their open-source datasets. Their data (V4.NA.02.MAPLE) that we used can be found here: https://sites.wustl.edu/acag/datasets/surface-pm2-5/. Citation: van Donkelaar, A., R. V. Martin, C. Li, R. T. Burnett, Regional Estimates of Chemical Composition of Fine Particulate Matter using a Combined Geoscience-Statistical Method with Information from Satellites, Models, and Monitors, Environ. Sci. Technol., doi: 10.1021/acs.est.8b06392, 2019. 

The seasonal temperature and relative humidity data can be created via 4km × 4km temperature and relative humidity predictions from Gridmet via google earth engine (https://developers.google.com/earth-engine/datasets/catalog/IDAHO_EPSCOR_GRIDMET).

We thank John Abatzoglou and members of the Climatology Lab at University of Idaho for providing the GRIDMET open-source datasets. 

Additional data required by the analyses can be directly extracted from data sources:

* Johns Hopkins University the Center for Systems Science and Engineering (CSSE) Coronavirus Resource Center: https://coronavirus.jhu.edu/ <br>
* Homeland Infrastructure Foundation- Level Data (HIFLD): https://hifld-geoplatform.opendata.arcgis.com/datasets/hospitals <br>
* The COVID tracking project: https://covidtracking.com/ <br>
* Carnegie Mellon University COVIDcast Delphi Research Group: https://covidcast.cmu.edu/ <br>
* Facebook Data for Good project: https://www.facebook.com/geoinsights/ <br>


We thank all of them for making their data public and for enabling this research to be possible.


<b>Contact Us: </b><br>
* Email: fdominic@hsph.harvard.edu

<b>Terms of Use:</b><br>
Authors/funders retain copyright (where applicable) of code on this Github repo and the article posted on medRxiv (under review). Anyone who wishes to share, reuse, remix, or adapt this material must obtain permission from the corresponding author. By using the contents on this Github repo and the article, you agree to cite:

Exposure to air pollution and COVID-19 mortality in the United States. Xiao Wu, Rachel C. Nethery, Benjamin M. Sabath, Danielle Braun, Francesca Dominici. medRxiv 2020.04.05.20054502; doi: https://doi.org/10.1101/2020.04.05.20054502

This GitHub repo and its contents herein, including data, link to data source, and analysis code that are intended solely for reproducing the results in the manuscript "Exposure to air pollution and COVID-19 mortality in the United States". The analyses rely upon publicly available data from multiple sources, that are often updated without advance notice. We hereby disclaim any and all representations and warranties with respect to the site, including accuracy, fitness for use, and merchantability. By using this site, its content, information, and software you agree to assume all risks associated with your use or transfer of information and/or software. You agree to hold the authors harmless from any claims relating to the use of this site.

