SELECT *
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 3,4
;


--SELECT *
--FROM PortfolioProject.dbo.CovidVaccinations
--ORDER BY 3,4
--;

SELECT 
	location, date,total_cases,new_cases,total_deaths,population
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 1,2;

-- Total Cases VS Total Deaths
-- Shows likelihood of dying 

SELECT 
	location, date,total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 1,2;

-- Total Cases vs Population
-- Shows percentage of population got Covid

SELECT 
	location, date, total_cases, population, (total_cases/population)*100 AS Infectedpercentage
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 1, 2;

-- Countries with Highest Infection Rate vs Population

SELECT 
	location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 AS Infectedpercentage
FROM PortfolioProject.dbo.CovidDeaths
GROUP BY location, population
ORDER BY Infectedpercentage DESC;

-- Showing the countries with the highest death rate vs population

SELECT 
	location, MAX(cast(total_deaths AS INT)) AS TotalDeathCounts
FROM PortfolioProject.dbo.CovidDeaths
GROUP BY location
ORDER BY TotalDeathCounts DESC;

-- Break Things Down by Continent
-- Showing the continents with the highest death count per population

SELECT 
	location, MAX(cast(total_deaths AS INT)) AS TotalDeathCounts
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is NOT NULL
GROUP BY location 
ORDER BY TotalDeathCounts DESC;


-- Global numbers
-- Use aggreagate function

--SELECT 
--	Date,
--	SUM(new_cases) AS Cases, 
--	SUM(cast(new_deaths AS INT)) AS Deaths, 
--	SUM(cast(new_deaths AS INT))/SUM(new_cases)*100  AS GlobalDeathRate
--	FROM PortfolioProject.dbo.CovidDeaths
--WHERE continent is NOT NULL
--GROUP BY Date
--ORDER BY 1 ;


--SELECT 
--	SUM(new_cases) AS Cases, 
--	SUM(cast(new_deaths AS INT)) AS Deaths, 
--	SUM(cast(new_deaths AS INT))/SUM(new_cases)*100  AS GlobalDeathRate
--	FROM PortfolioProject.dbo.CovidDeaths
--WHERE continent is NOT NULL
--;

-- Global Death Percentage

SELECT 
	SUM(new_cases) AS total_cases,
	SUM(convert(int,new_deaths)) AS total_deaths,
	SUM(convert(int,new_deaths))/SUM(new_cases)*100 AS GlobalDeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is NOT NULL
ORDER BY 1,2;



--SELECT *
--FROM PortfolioProject.dbo.CovidVaccinations
--ORDER BY 3,4
--;

--SELECT *
--FROM PortfolioProject.dbo.CovidVaccinations
--WHERE location = 'Malaysia'
--ORDER BY 3,4
--;

-- Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
ORDER BY 1, 2;

SELECT continent, location, date, population, new_vaccinations
FROM PortfolioProject.dbo.CovidVaccinations vac
WHERE continent is NOT NULL
ORDER BY 1, 2;


--SELECT 
--	continent,
--	location,
--	population,
--	date,
--	new_vaccinations,
--	SUM(CAST(new_vaccinations AS INT)) OVER (PARTITION BY location)
--FROM PortfolioProject.dbo.CovidVaccinations
--WHERE continent is NOT NULL
--ORDER BY 2,3;


SELECT 
	continent,
	location,
	population,
	date,
	new_vaccinations,
	SUM(CONVERT(int, new_vaccinations)) OVER (PARTITION BY location ORDER BY location, date) AS SumVaccinated
FROM PortfolioProject.dbo.CovidVaccinations
WHERE continent is NOT NULL
ORDER BY 2,3;



-- USE CTE

With PopvsVac (Continent, Location, Population, Date, new_vaccinations, SumVaccinated)
AS (
SELECT 
	continent,
	location,
	population,
	date,
	new_vaccinations,
	SUM(CONVERT(int, new_vaccinations)) OVER (PARTITION BY location ORDER BY location, date) AS SumVaccinated
FROM PortfolioProject.dbo.CovidVaccinations
WHERE continent is NOT NULL
)

SELECT *, (SumVaccinated/population)*100 AS VaccinatedPercentage
FROM PopvsVac;

