--PART 1: Exploring the data
--This is for familiarising with the data and is not designed to address the 3 questions.

--Select Data that we're going to be using
Select location, date, total_cases, new_cases, total_deaths, population
From covidDeaths
Order by 1,2

--Looking at total cases vs total deaths globally
Select location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 as death_percentage
From covidDeaths
Order by 1,2

--Looking at total cases vs total deaths in Hong Kong (HK)
--Shows likelihood of dying if you contract COVID-19 in HK
Select location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 as death_percentage
From covidDeaths
Where location like '%hong kong%'
Order by 1,2

--Looking at the total_cases vs population in HK
--Shows what percentage of population got COVID-19 in HK
Select location, date, population, total_cases,
(total_cases/population)*100 as percent_of_population_infected
From covidDeaths
Where location like '%hong kong%'
Order by 1,2

--Looking at countries with highest infection rate compared to population
Select location, population, MAX(total_cases) as highest_infection_count,
MAX(total_cases/population)*100 as percent_of_population_infected
From covidDeaths
Group by location, population
Order by percent_of_population_infected desc

---Looking at countries with highest infection rate compared to population and date
Select location, population, date, MAX(total_cases) as highest_infection_count,
MAX((total_cases/population))*100 as percent_population_infected
From covidDeaths
Group by location, population, date
order by percent_population_infected desc

--Showing countries with highest death count per population by country
--Type of total_deaths is nvarchar, so we need to cast its type to integer
Select location, MAX(CAST(total_deaths as int)) as total_death_count
From covidDeaths
Group by location
Order by total_death_count desc

--Showing continents with the highest death count by continent
--Type of total_deaths is nvarchar, so we need to cast its type to integer
Select continent, MAX(CAST(total_deaths as int)) as total_death_count
From covidDeaths
Where continent is not null
Group by continent
Order by total_death_count desc

--The death counts in each continent seems to be too few (as compared to news report).
--Let's see which countries the data has included. Take N. America for example.
--Type of total_deaths is nvarchar, so we need to cast its type to integer
Select continent, MAX(CAST(total_deaths as int)) as total_death_count
From covidDeaths
Where continent is not null and location in ('United States', 'Canada')
Group by continent
Order by total_death_count desc
--It has the same death counts as the aggregated query 2 blocks above!

--Let's use the default continent to see the results. 
--Showing continents with the highest death count by continent
--Type of total_deaths is nvarchar, so we need to cast its type to integer
Select location, MAX(CAST(total_deaths as int)) as total_death_count
From covidDeaths
Where continent is null
Group by location
Order by total_death_count desc

--GLOBAL NUMBERS
--Aggregate of countries
Select SUM(new_cases) as total_new_cases,
SUM(CAST(new_deaths as int)) as total_new_deaths, 
SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as death_percentage
From covidDeaths
Where continent is not null
Order by 1,2

--Aggregate of continents
--European Union is part of Europe
Select location, SUM(CAST(new_deaths as int)) as total_death_count
From covidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by total_death_count desc

--Looking at total population vs vaccinations
--Type of new_vaccinations is nvarchar, so we need to cast its type to integer
Select d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUM(CAST(v.new_vaccinations as int)) OVER (Partition by d.location Order by d.location,
d.date) as rolling_people_vaccinated
From covidDeaths d Join covidVaccinations v
On d.location = v.location and d.date = v.date
Where d.continent is not null
Order by 2,3

-- We cannot use an alias to conduct calculations, so we use Common Table Expressions (CTE)
With pop_vac (continent, location, date, population, new_vaccinations,
rolling_people_vaccinated)
as 
(
Select d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUM(CAST(v.new_vaccinations as int)) OVER (Partition by d.location Order by d.location,
d.date) as rolling_people_vaccinated
From covidDeaths d Join covidVaccinations v
On d.location = v.location and d.date = v.date
Where d.continent is not null
--Order by 2,3
)
Select *, rolling_people_vaccinated/population*100
From pop_vac

--Temp table
Drop table if exists percent_population_vaccinated
Create table percent_population_vaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric
)

Insert into percent_population_vaccinated
Select d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUM(CAST(v.new_vaccinations as int)) OVER (Partition by d.location Order by d.location,
d.date) as rolling_people_vaccinated
From covidDeaths d Join covidVaccinations v
On d.location = v.location and d.date = v.date
Where d.continent is not null

Select *, rolling_people_vaccinated/population*100
From percent_population_vaccinated

--Creating view to store data for later visualisations (Create more!)
Create view percent_population_vaccinated as
Select d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUM(CAST(v.new_vaccinations as int)) OVER (Partition by d.location Order by d.location,
d.date) as rolling_people_vaccinated
From covidDeaths d Join covidVaccinations v
On d.location = v.location and d.date = v.date
Where d.continent is not null

--PART 2: Addressing the three questions

--Which country/region has the highest average death rate in each continent?
Drop table if exists highest_death_percentage_in_each_continent
Create table highest_death_percentage_in_each_continent
(
continent nvarchar(255),
location nvarchar(255),
population numeric,
total_death_count numeric,
avg_percent_of_population_died float
)

Insert into highest_death_percentage_in_each_continent
Select Top (1) continent, location, population, SUM(CAST(total_deaths as int)) as total_death_count,
AVG(CAST(total_deaths as int)/population*100) as avg_percent_of_population_died
From covidDeaths
Where continent is not null and continent like '%North America%'
Group by continent, location, population
Order by avg_percent_of_population_died desc

Insert into highest_death_percentage_in_each_continent
Select Top (1) continent, location, population, SUM(CAST(total_deaths as int)) as total_death_count,
AVG(CAST(total_deaths as int)/population*100) as avg_percent_of_population_died
From covidDeaths
Where continent is not null and continent like '%South America%'
Group by continent, location, population
Order by avg_percent_of_population_died desc

Insert into highest_death_percentage_in_each_continent
Select Top (1) continent, location, population, SUM(CAST(total_deaths as int)) as total_death_count,
AVG(CAST(total_deaths as int)/population*100) as avg_percent_of_population_died
From covidDeaths
Where continent is not null and continent like '%Africa%'
Group by continent, location, population
Order by avg_percent_of_population_died desc

Insert into highest_death_percentage_in_each_continent
Select Top (1) continent, location, population, SUM(CAST(total_deaths as int)) as total_death_count,
AVG(CAST(total_deaths as int)/population*100) as avg_percent_of_population_died
From covidDeaths
Where continent is not null and continent like '%Asia%'
Group by continent, location, population
Order by avg_percent_of_population_died desc

Insert into highest_death_percentage_in_each_continent
Select Top (1) continent, location, population, SUM(CAST(total_deaths as int)) as total_death_count,
AVG(CAST(total_deaths as int)/population*100) as avg_percent_of_population_died
From covidDeaths
Where continent is not null and continent like '%Oceania%'
Group by continent, location, population
Order by avg_percent_of_population_died desc

Select *
From highest_death_percentage_in_each_continent
Order by avg_percent_of_population_died desc

--Which country/region has the fastest average new cases rate in each continent?
Drop table if exists fastest_new_cases_development
Create table fastest_new_cases_development
(
continent nvarchar(255),
location nvarchar(255),
avg_new_cases float,
avg_total_cases float,
avg_percent_of_new_cases_development float
)

Insert into fastest_new_cases_development
Select Top (1) continent, location, AVG(new_cases) as avg_new_cases,
AVG(total_cases) as avg_total_cases,
AVG(new_cases/total_cases*100) as avg_percent_of_new_cases_development
From covidDeaths
Where continent is not null and continent like '%North America%'
Group by continent, location
Order by avg_percent_of_new_cases_development desc

Insert into fastest_new_cases_development
Select Top (1) continent, location, AVG(new_cases) as avg_new_cases,
AVG(total_cases) as avg_total_cases,
AVG(new_cases/total_cases*100) as avg_percent_of_new_cases_development
From covidDeaths
Where continent is not null and continent like '%South America%'
Group by continent, location
Order by avg_percent_of_new_cases_development desc

Insert into fastest_new_cases_development
Select Top (1) continent, location, AVG(new_cases) as avg_new_cases,
AVG(total_cases) as avg_total_cases,
AVG(new_cases/total_cases*100) as avg_percent_of_new_cases_development
From covidDeaths
Where continent is not null and continent like '%Africa%'
Group by continent, location
Order by avg_percent_of_new_cases_development desc

Insert into fastest_new_cases_development
Select Top (1) continent, location, AVG(new_cases) as avg_new_cases,
AVG(total_cases) as avg_total_cases,
AVG(new_cases/total_cases*100) as avg_percent_of_new_cases_development
From covidDeaths
Where continent is not null and continent like '%Asia%'
Group by continent, location
Order by avg_percent_of_new_cases_development desc

Insert into fastest_new_cases_development
Select Top (1) continent, location, AVG(new_cases) as avg_new_cases,
AVG(total_cases) as avg_total_cases,
AVG(new_cases/total_cases*100) as avg_percent_of_new_cases_development
From covidDeaths
Where continent is not null and continent like '%Oceania%'
Group by continent, location
Order by avg_percent_of_new_cases_development desc

Select *
From fastest_new_cases_development
Order by avg_percent_of_new_cases_development desc

--Which country/region has the lowest vaccination rate in each continent?
Drop table if exists lowest_vaccination_rate
Create table lowest_vaccination_rate
(
continent nvarchar(255),
location nvarchar(255),
population numeric,
avg_total_tests float,
avg_vaccination_rate float
)

Insert into lowest_vaccination_rate
Select Top(1) v.continent, v.location, d.population,
AVG(CAST(v.total_tests as float)) as avg_total_tests,
AVG(CAST(v.total_tests as float)/d.population*100) as avg_vaccination_rate
From covidDeaths d Join covidVaccinations v
On d.continent = v.continent and d.location = v.location
Where v.continent is not null and v.continent like '%North America%'
Group by v.continent, v.location, d.population
Having AVG(CAST(v.total_tests as float)) is not null and
AVG(CAST(v.total_tests as float)/d.population*100) is not null
Order by avg_vaccination_rate asc

Insert into lowest_vaccination_rate
Select Top(1) v.continent, v.location, d.population,
AVG(CAST(v.total_tests as float)) as avg_total_tests,
AVG(CAST(v.total_tests as float)/d.population*100) as avg_vaccination_rate
From covidDeaths d Join covidVaccinations v
On d.continent = v.continent and d.location = v.location
Where v.continent is not null and v.continent like '%South America%'
Group by v.continent, v.location, d.population
Having AVG(CAST(v.total_tests as float)) is not null and
AVG(CAST(v.total_tests as float)/d.population*100) is not null
Order by avg_vaccination_rate asc

Insert into lowest_vaccination_rate
Select Top(1) v.continent, v.location, d.population,
AVG(CAST(v.total_tests as float)) as avg_total_tests,
AVG(CAST(v.total_tests as float)/d.population*100) as avg_vaccination_rate
From covidDeaths d Join covidVaccinations v
On d.continent = v.continent and d.location = v.location
Where v.continent is not null and v.continent like '%Africa%'
Group by v.continent, v.location, d.population
Having AVG(CAST(v.total_tests as float)) is not null and
AVG(CAST(v.total_tests as float)/d.population*100) is not null
Order by avg_vaccination_rate asc

Insert into lowest_vaccination_rate
Select Top(1) v.continent, v.location, d.population,
AVG(CAST(v.total_tests as float)) as avg_total_tests,
AVG(CAST(v.total_tests as float)/d.population*100) as avg_vaccination_rate
From covidDeaths d Join covidVaccinations v
On d.continent = v.continent and d.location = v.location
Where v.continent is not null and v.continent like '%Asia%'
Group by v.continent, v.location, d.population
Having AVG(CAST(v.total_tests as float)) is not null and
AVG(CAST(v.total_tests as float)/d.population*100) is not null
Order by avg_vaccination_rate asc

Insert into lowest_vaccination_rate
Select Top(1) v.continent, v.location, d.population,
AVG(CAST(v.total_tests as float)) as avg_total_tests,
AVG(CAST(v.total_tests as float)/d.population*100) as avg_vaccination_rate
From covidDeaths d Join covidVaccinations v
On d.continent = v.continent and d.location = v.location
Where v.continent is not null and v.continent like '%Oceania%'
Group by v.continent, v.location, d.population
Having AVG(CAST(v.total_tests as float)) is not null and
AVG(CAST(v.total_tests as float)/d.population*100) is not null
Order by avg_vaccination_rate asc

Select *
From lowest_vaccination_rate
Order by avg_vaccination_rate asc