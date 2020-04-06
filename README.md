# Exposure to air pollution and COVID-19 mortality in the United States
This is the data repository for public available code and data to reproduce analyses in "Exposure to air pollution and COVID-19 mortality in the United States".

<b>Code: </b><br>
[`Prepossing.R`](https://github.com/wxwx1993/PM_COVID/blob/master/Preprocessing.R) includes the code to extract all necessary data and prepocess data for statistical analyses.

[`Analyses.R`](https://github.com/wxwx1993/PM_COVID/blob/master/Analyses.R) includes the code to implement zero-inflated negative binomial mixed models in primary, secondary and sensitivity analyses.

[`Figure.R`](https://github.com/wxwx1993/PM_COVID/blob/master/Figure.R) includes the code to generate figures in Main Text and Supplementary Materials.

[`additional_preprocessing_code`](https://github.com/wxwx1993/PM_COVID/tree/master/additional_preprocessing_code)


<b>Additional Data Source: </b><br>
The county-level PM2.5 exposure data can be created via PM2.5 predictions from The Atmospheric Composition Analysis Group at Dalhouse University (http://fizz.phys.dal.ca/~atmos/martin/). Please visit the detailed instructions below

- Download PM25 predictions: https://github.com/wxwx1993/PM_COVID/blob/master/additional_preprocessing_code/download_pm25_values.md. This code makes use of ZIP code shape files provided by ESRI.
- County-level aggregation: https://github.com/wxwx1993/PM_COVID/blob/master/additional_preprocessing_code/rm_pm25_to_county.md

We thank Randall Martin and the members of the Atmospheric Composition Analysis Group at Dalhouse University for providing access to their open-source datasets. The specific data that we used can be found here: https://sites.wustl.edu/acag/datasets/surface-pm2-5/

<b>Contact Us: </b><br>
* Email: fdominic@hsph.harvard.edu

<b>Terms of Use:</b><br>
Authors/funders retain copyright (where applicable) of code on this Github repo and the article posted on medRxiv (under review). Anyone who wishes to share, reuse, remix, or adapt this material must obtain permission from the corresponding author. By using the contents on this Github repo and the article, you agree to cite:

Wu, X., Nethery, R.C., Sabath, M.B., Braun, D. and Dominici, F., 2020. Exposure to air pollution and COVID-19 mortality in the United States. medRxiv.

This GitHub repo and its contents herein, including data, link to data source, and analysis code that are intended solely for reproducing the results in the manuscript "Exposure to air pollution and COVID-19 mortality in the United States". The analyses rely upon publicly available data from multiple sources, that are often updated without advance notice. We hereby disclaim any and all representations and warranties with respect to the site, including accuracy, fitness for use, and merchantability. By using this site, its content, information, and software you agree to assume all risks associated with your use or transfer of information and/or software. You agree to hold the authors harmless from any claims relating to the use of this site.

