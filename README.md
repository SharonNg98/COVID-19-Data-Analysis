---
Title: "How to Take Effective Measures against COVID-19: A Data Analysis"
Author: "Sharon Ng"
Date: "2021/9/29"
Output: html_document
---

# Ask
### Three Questions to Guide the Direction for Effective Measures
1. Which country/region has the highest average death rate in each continent?
2. Which country/region has the fastest average new cases rate in each continent?
3. Which country/region has the lowest vaccination rate in each continent?

### Business Task
1. Actions to prevent COVID-19 deaths in countries/regions with the highest average death rate.
2. Actions to curb countries/regions with the fastest development of COVID-19 cases.
3. Actions to increase vaccination rates in countries/regions with low vaccination activity.

### Key Stakeholders
- World Health Organisation (WHO): Global measures can be taken and we can advise WHO with respect to the most prominent cases.
- Local governments: Address their severity and advise measures to keep the the public informed.
- Local hospital authorities: Alert them of any abnormalies and distinct figures dervied from the analysis to keep the infected and death cases lower. 

# Prepare
### How the Data is Organised
The downloaded files are stored in a local drive but not the cloud. The website data containing the COVID-19 data is downloaded in CSV format. Futher breakdown of the CSV file into vaccination and death category is done. These two files act as the original datasets and any modifications to that will not occur.  

### Bias or Credibility
#### Is the Data Reliable, Original, Comprehensive, Current and Cited (ROCCC)?
- Reliable: All visualizations, data, and code produced by [Our World in Data](https://ourworldindata.org/covid-deaths) are completely open access under the [Creative Commons BY license](https://creativecommons.org/licenses/by/4.0/).
- Original: It is a primary source.
- Comprehensive: It covers all countries from populated continents.
- Current: It is up-to-date and is updated daily.
- Cited: The authors are acknowledged on the [same website](https://ourworldindata.org/covid-deaths#acknowledgements).

### Partitioning the Data
The original file downloaded from the website is broken down into death and vaccination categories (files).  

In the death category, the variables are iso_code, continent, location, date, population, total_cases, new_cases, new_cases_smoothed, total_deaths, new_deaths, new_deaths_smoothed, total_cases_per_million, new_cases_per_million, new_cases_smoothed_per_million, total_deaths_per_million, new_deaths_per_million, new_deaths_smoothed_per_million, reproduction_rate, icu_patients, icu_patients_per_million, hosp_patients, hosp_patients_per_million, weekly_icu_admissions, weekly_icu_admissions_per_million, weekly_hosp_admissions, weekly_hosp_admissions_per_million.  

In the vaccination category, the variables are iso_code, continent, location, date, new_tests, total_tests, total_tests_per_thousand, new_tests_per_thousand, new_tests_smoothed, new_tests_smoothed_per_thousand, positive_rate, tests_per_case, tests_units, total_vaccinations, people_vaccinated, people_fully_vaccinated, total_boosters, new_vaccinations, new_vaccinations_smoothed, total_vaccinations_per_hundred, people_vaccinated_per_hundred, people_fully_vaccinated_per_hundred, total_boosters_per_hundred, new_vaccinations_smoothed_per_million, stringency_index, population_density, median_age, aged_65_older, aged_70_older, gdp_per_capita, extreme_poverty, cardiovasc_death_rate, diabetes_prevalence, female_smokers, male_smokers, handwashing_facilities, hospital_beds_per_thousand, life_expectancy, human_development_index, excess_mortality_cumulative_absolute, excess_mortality_cumulative, excess_mortality, excess_mortality_cumulative_per_million.

### Cleaning the Data
In SQL, 
- cast the type nvarchar in total_deaths to integer.
- cast the type nvarchar in new_vaccinations to integer.
- the location data contains continents, countries, regions and the European Union (EU). When comparing data among countries, write 'WHERE continent is not null' to omit irrelevant locations.

# Process
### Tools
Excel for data partition, SQL for data cleaning and analysis, Tableau for data visualisation.

# Analysis 
Click [here](https://github.com/SharonNg98/COVID-19-Data-Analysis/blob/main/covid-19-analysis.sql) for the script.

# Share
Click [here](https://public.tableau.com/views/COVID-19DataAnalysis_16333425115240/Dashboard1?:language=en-US&publish=yes&:display_count=n&:origin=viz_share_link) for the Tableau visualisations.

# Act
### Three Suggestions 
1. Alert relevant government officials about the severity of deaths and new cases development where necessary. 
2. Send vaccines and open up more hospital beds for catering very ill patients.
3. Create incentives (e.g. cash rewards) to boost vaccination rates in lowly vaccinated countries/regions.

**Credits:** This project was inspired by [Alex Freburg](https://www.youtube.com/channel/UC7cs8q-gJRlGwj4A8OmCmXg). Some codes were borrowed from him but for most of the part, they were my original codes.
