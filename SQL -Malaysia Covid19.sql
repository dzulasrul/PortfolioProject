SELECT *
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 3,4
;

-- Malaysia Death Percentage

SELECT 
	location, date,total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE location like '%Malaysia%'
ORDER BY 2;

-- Latest Malaysia Death Percentage

SELECT 
	SUM(new_cases) AS 'Malaysia Total Cases',
	SUM(convert(int,new_deaths)) AS 'Malaysia Total Death',
	SUM(convert(int,new_deaths))/SUM(new_cases)*100 AS 'Malaysia Death Percentage'
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is NOT NULL AND location like 'Malaysia'
ORDER BY 1,2;

-- Malaysia Infected Percentage

SELECT 
	location, date, total_cases, population, (total_cases/population)*100 AS Infectedpercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE location like '%Malaysia%'
ORDER BY 1, 2;

-- Malaysia Highest Infected Percentage 

SELECT 
	location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 AS Infectedpercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE location like '%Malaysia%'
GROUP BY location, population;

-- Total Death Count in Malaysia

SELECT 
	Location, MAX(cast(total_deaths AS INT)) AS TotalDeathCounts
FROM PortfolioProject.dbo.CovidDeaths
WHERE location like '%Malaysia%'
GROUP BY location;

-- Vaccinated Percentage in Malaysia

With PopvsVac (Continent, Location, Population, Date, new_vaccinations, TotalVaccinated)
AS (
SELECT 
	continent,
	location,
	population,
	date,
	new_vaccinations,
	SUM(CONVERT(int, new_vaccinations)) OVER (PARTITION BY location ORDER BY location, date) AS TotalVaccinated
FROM PortfolioProject.dbo.CovidVaccinations
WHERE location = 'Malaysia'
)

SELECT *, (TotalVaccinated/population)*100 AS VaccinatedPercentage
FROM PopvsVac;


-- Vacinnated Percentage in Malaysia by Month

With PopvsVac (Location, Population, Month, Year, TotalVaccinated)
AS (
SELECT 
	location,
	population,
	MONTH(date) AS 'Month',
	YEAR(date) AS 'Year',
	SUM(CONVERT(int, new_vaccinations)) OVER (PARTITION BY MONTH(date) ORDER BY MONTH(date)) AS TotalVaccinated
FROM PortfolioProject.dbo.CovidVaccinations
WHERE location = 'Malaysia'
)

SELECT *, (TotalVaccinated/population)*100 AS VaccinatedPercentage
FROM PopvsVac
GROUP BY Location, Population, Month, Year, TotalVaccinated
ORDER BY Year;


-- Latest Vaccinated Percentage in Malaysia


With PopvsVac (Continent, Location, Population,Year, TotalVaccinated)
AS (
SELECT 
	continent,
	location,
	population,
	YEAR(date),
	SUM(CONVERT(int, new_vaccinations)) OVER (PARTITION BY YEAR(date) ORDER BY YEAR(date)) AS TotalVaccinated
FROM PortfolioProject.dbo.CovidVaccinations
WHERE location = 'Malaysia'
)

SELECT *, (MAX(TotalVaccinated)/population)*100 AS VaccinatedPercentage
FROM PopvsVac
GROUP BY Continent, Location, Population,Year, TotalVaccinated;

-- Temp Table

DROP TABLE if exists #MalaysiaVaccinatedPercentage;
CREATE TABLE #MalaysiaVaccinatedPercentage
(
Continent nvarchar(100),
Location nvarchar(100),
Population numeric,
Date datetime,
New_vaccinations numeric,
TotalVaccinated numeric);


INSERT INTO #MalaysiaVaccinatedPercentage
SELECT 
	continent,
	location,
	population,
	date,
	new_vaccinations,
	SUM(CONVERT(int, new_vaccinations)) OVER (PARTITION BY location ORDER BY location, date) AS TotalVaccinated
FROM PortfolioProject.dbo.CovidVaccinations
WHERE location = 'Malaysia';

SELECT * FROM #MalaysiaVaccinatedPercentage;