Select *
From [Portfolio project]..['Covid Deaths]
Order by 3,4



Select location, date,total_cases, new_cases, total_deaths, population
From [Portfolio project]..['Covid Deaths]
Order by 1,2


-- Total cases vs Total Deaths
-- Likelihood of dying if you get covid in Australia
Select location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
From [Portfolio project]..['Covid Deaths]
Where location='Australia'
Order by 1,2


-- Likelihood of dying if you get covid in the United States
Select location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
From [Portfolio project]..['Covid Deaths]
Where location like 'United States'
Order by 1,2


-- Total cases vs population in Australia
-- Percentage of infected people
Select location, date,total_cases,population,(total_cases/population)*100 as Infectedpeople
From [Portfolio project]..['Covid Deaths]
Where location like 'Australia'
Order by 1,2



--Percentage of infected people in the United States
Select location, date,total_cases,population,(total_cases/population)*100 as Infectedpeople
From [Portfolio project]..['Covid Deaths]
Where location like 'United States'
Order by 1,2


-- Countries with highest infection rate in relation to population
Select location, population,max(total_cases) as Max_cases_per_country,max(total_cases/population)*100 as max_percentage_population_infected
From [Portfolio project]..['Covid Deaths]
Group by location, population
Order by max_percentage_population_infected Desc


-- Showing countries with the highest death
Select location,population,max(cast (total_deaths as int)) as Max_death_per_country, max(cast (total_deaths as int))/population*100 as Max_Death_Rate_Per_Country
From [Portfolio project]..['Covid Deaths]
Where continent is not Null
Group by location, population
Order by  Max_death_per_country Desc



-- Death Percentage in the World
Select SUM(new_cases) as total_cases, SUM(cast (new_deaths as int)) as total_deaths, SUM(cast (new_deaths as int))/SUM(new_cases)*100 as Death_Percentage
From [Portfolio project]..['Covid Deaths]
Where continent is not Null
Order by 1,2



Select *
From [Portfolio project]..['Covid Deaths]
Order by 3,4


Select *
From [Portfolio project]..['Covid Vaccinations$']
Order by 3,4


-- Join Covid Deaths Table and Covid Vaccinations Table together, using partition by to get rolling count of people vaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
From [Portfolio project]..['Covid Deaths] dea
Join [Portfolio project]..['Covid Vaccinations$'] vac
on dea.location=vac.location
   and dea.date=vac.date
Where dea.continent is not null
order by 2,3


-- Getting help from CTE to calculate the percentage of Rolling People Vaccinated
With RPV (continent, location, date, population,new_vaccinations, Rollingpeoplevaccinated) 
as(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
From [Portfolio project]..['Covid Deaths] dea
Join [Portfolio project]..['Covid Vaccinations$'] vac
on dea.location=vac.location
   and dea.date=vac.date
Where dea.continent is not null
--order by 2,3
)
Select *, (Rollingpeoplevaccinated/population)*100 as Rate_of_rolling_people_vaccinated
From RPV



-- TEMP Table for rate of rolling people vaccinated
Drop Table if exists #Rate_of_rolling_people_vaccinated
Create Table #Rate_of_rolling_people_vaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rollingpeoplevaccinated numeric
)

Insert into #Rate_of_rolling_people_vaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
From [Portfolio project]..['Covid Deaths] dea
Join [Portfolio project]..['Covid Vaccinations$'] vac
on dea.location=vac.location
   and dea.date=vac.date
Where dea.continent is not null
--order by 2,3

Select *, (Rollingpeoplevaccinated/population)*100 as Rate_of_rolling_people_vaccinated
From #Rate_of_rolling_people_vaccinated


-- Create View from Rate of Rolling People Vaccinated
Create view  Percentageofvaccinatedpeople as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
From [Portfolio project]..['Covid Deaths] dea
Join [Portfolio project]..['Covid Vaccinations$'] vac
on dea.location=vac.location
   and dea.date=vac.date
Where dea.continent is not null
--order by 2,3

Drop view Percentageofvaccinatedpeople
























