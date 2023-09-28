select * 
from PortfolioProject_1..covidDeaths 
where continent is not null
order by 3,4

select * from PortfolioProject_1..covidVacinations order by 3,4

--selecting the data we need 

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject_1..covidDeaths
order by 1,2

--Looking at total cases vs total deaths
-- Shows the liklihood to dying if you get covid in a particular country
select location,date,total_cases,total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 as Death_Percentage
from PortfolioProject_1..covidDeaths 
where location like '%india%'
order by 1,2

--Looking at total cases vs population
-- Shows  what percentage of the population was infected
select location,date,population,total_cases,(CONVERT(float, total_cases) / NULLIF(CONVERT(float,population), 0)) * 100 as InfectedPercentage
from PortfolioProject_1..covidDeaths 
--where location like '%india%'
order by 1,2

--Looking at the countires with the highest infected rate
select location,population,MAX(CONVERT(float, total_cases)) HigestInfectedCount,MAX((CONVERT(float, total_cases) / NULLIF(CONVERT(float,population), 0)) * 100) as InfectedPercentage
from PortfolioProject_1..covidDeaths 
--where location like '%india%'
group by location,population
order by InfectedPercentage desc

--Showing countries with the highest death count per population
select location,MAX(cast(total_deaths as int)) as TotalDeaths
from PortfolioProject_1..covidDeaths 
where continent is not null
--where location like '%india%'
group by location
order by TotalDeaths desc

--Breaking things down by continent
--Showing continents with the highest death per population
select continent,MAX(cast(total_deaths as int)) as TotalDeaths
from PortfolioProject_1..covidDeaths 
where continent is not null
--where location like '%india%'
group by continent
order by TotalDeaths desc

--GLOBAL NUMBER
select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, ISNULL(SUM(CAST(new_deaths AS INT)) / NULLIF(SUM(new_cases), 0) * 100, 0) AS DeathPercentage
from PortfolioProject_1..covidDeaths 
--where location like '%india%'
where continent is not null
--group by date
order by 1,2 


--Looking at Total Population vs Vaccination

select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location order by dea.location,dea.date)
as RollingPeopleVaccinated
from PortfolioProject_1..covidVacinations vac
Join PortfolioProject_1..covidDeaths dea
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3

 --Use CTE

With PopVsVac (Continent, Location, Date, Population,new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location order by dea.location,dea.date)
as RollingPeopleVaccinated
from PortfolioProject_1..covidVacinations vac
Join PortfolioProject_1..covidDeaths dea
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3
 )

 select *, (RollingPeopleVaccinated/Population)*100
 From PopVsVac

--TEMP TABLE
Drop Table if exists #PrecentPopulationVaccinated
Create Table #PrecentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)



Insert into #PrecentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location order by dea.location,dea.date)
as RollingPeopleVaccinated
from PortfolioProject_1..covidVacinations vac
Join PortfolioProject_1..covidDeaths dea
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3
 
 select *, (RollingPeopleVaccinated/Population)*100
 From #PrecentPopulationVaccinated

 -- Creating View to store data for later visualization
create view PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location order by dea.location,dea.date)
as RollingPeopleVaccinated
from PortfolioProject_1..covidVacinations vac
Join PortfolioProject_1..covidDeaths dea
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null


 --Creating a View for Total deaths in each continent
create view 
ContinentDeaths as
select continent,MAX(cast(total_deaths as int)) as TotalDeaths
from PortfolioProject_1..covidDeaths 
where continent is not null
--where location like '%india%'
group by continent
--order by TotalDeaths desc

SELECT * FROM ContinentDeaths;
