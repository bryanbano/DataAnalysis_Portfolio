Select location, date, total_cases, new_cases, total_deaths, population
From SQLProject1.dbo.CovidDeaths$
Where continent is not null
Order by 1,2

--Total Cases vs Total Deaths in United States (Percentage of total cases that died)

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From SQLProject1.dbo.CovidDeaths$
Where location = 'United States'
and continent is not null
Order by 1,2

--Total Cases vs Population in United States (Percentage of population that got COVID)

Select location, date, total_cases, population, (total_cases/population)*100 as CasePercentage
From SQLProject1.dbo.CovidDeaths$
Where location = 'United States'
and continent is not null
Order by 1,2

--Countries with highest infection rate compared to Population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From SQLProject1.dbo.CovidDeaths$
Where continent is not null
Group by location, population
Order by PercentPopulationInfected desc

--Countries with highest death count compared to Population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From SQLProject1.dbo.CovidDeaths$
Where continent is not null
Group by location
Order by TotalDeathCount desc

--Continents with the highest death count per population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From SQLProject1.dbo.CovidDeaths$
Where continent is null
Group by location
Order by TotalDeathCount desc


--Global new cases and new deaths by date

Select date, SUM(new_cases) as GlobalNewCases, SUM(cast(new_deaths as int)) as GlobalNewDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as GlobalDeathPercentage
From SQLProject1.dbo.CovidDeaths$
Where continent is not null
Group by date
Order by 1,2



--Total Population vs. New Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date) as TotalVaccinations
From SQLProject1.dbo.CovidDeaths$ dea
Join SQLProject1.dbo.CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3



--CTE
With PopvsVac (continent, location, date, population, new_vaccinations, TotalVaccinations)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date) as TotalVaccinations
From SQLProject1.dbo.CovidDeaths$ dea
Join SQLProject1.dbo.CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)

Select *, (TotalVaccinations/population)*100 as PercentVaccinated
From PopvsVac
Order by 2,3


--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date) as TotalVaccinations
From SQLProject1.dbo.CovidDeaths$ dea
Join SQLProject1.dbo.CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

Select *
From PercentPopulationVaccinated