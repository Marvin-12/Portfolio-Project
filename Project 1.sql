SELECT*
FROM [Projects ]..Coviddeaths
Where continent is not null
Order by 3,4

--SELECT*
--FROM [Projects ]..CovidVaccinations
--Where continent is not null
--Order by 3,4

SELECT location, Date, total_cases, new_cases, total_deaths, population
FROM [Projects ]..Coviddeaths
Where location like 'Nigeria'
--Where continent is not null
Order by 1,2

SELECT location, Date, total_cases, total_deaths,(total_cases/total_deaths)*100 as Pecentage
FROM [Projects ]..Coviddeaths
Where continent is not null
Order by 1,2

--looking at total cases vs population

SELECT location, Date,  population, total_cases, (total_cases/population)*100 as PecentPopulationInfected
FROM [Projects ]..Coviddeaths
--Where continent is not null
--Where Location like 'Nigeria'
Order by 1,2

--Looking at Countries with Highest Infection Rate Compare To Population

SELECT location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PecentPopulationInfected
FROM [Projects ]..Coviddeaths
--Where continent is not null
--Where Location like 'Nigeria'
Group by location, population 
Order by PecentPopulationInfected desc

--Countries with highest death count per Population

SELECT location, Max(Cast(total_deaths as int)) as TotalDeathsCount
FROM [Projects ]..Coviddeaths
Where continent is not null
--Where Location like 'Nigeria'
Group by location 
Order by TotalDeathsCount desc


--Let's Break Things Down to Continent

SELECT continent, Max(Cast(total_deaths as int)) as TotalDeathsCount
FROM [Projects ]..Coviddeaths
--Where Location like 'Nigeria'
Where continent is not null
Group by continent 
Order by TotalDeathsCount desc

SELECT location, Max(Cast(total_deaths as int)) as TotalDeathsCount
FROM [Projects ]..Coviddeaths
--Where Location like 'Nigeria'
Where continent is null
Group by  location 
Order by TotalDeathsCount desc

--Looking at each Continent
--Let's Break Things Down to Continent

SELECT continent, Max(Cast(total_deaths as int)) as TotalDeathsCount
FROM [Projects ]..Coviddeaths
--Where Location like 'Nigeria'
Where continent is not null
Group by continent 
Order by TotalDeathsCount desc

--GLOBAL NUMBERS

SELECT Sum(new_cases) as total_cases, Sum(Cast(new_deaths as int)) as total_deaths, Sum(Cast(new_deaths as int))/Sum(new_cases)*100 as DeathPecentage
FROM [Projects ]..Coviddeaths
--Where location Like 'Nigeria'
Where continent is not null
--Group by date
Order by 1,2

--Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(Cast(vac.new_vaccinations as int)) Over (Partition By dea.location)
From [Projects ]..Coviddeaths dea
join [Projects ]..CovidVaccinations vac
  On dea.location = vac.location
  and dea.date = vac.date
  Where dea.continent is not null
 Order by 2,3

 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(Convert(Int,vac.new_vaccinations)) Over (Partition By dea.location Order by dea.location, dea. date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From [Projects ]..Coviddeaths dea
join [Projects ]..CovidVaccinations vac
  On dea.location = vac.location
  and dea.date = vac.date
  Where dea.continent is not null
 Order by 2,3

 --USE CTE

 With PopvsVac(continent, location, date, population, new_Vaccinations, RollingPeopleVaccinated)
 as
(
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(Convert(Int,vac.new_vaccinations)) Over (Partition By dea.location Order by dea.location, dea. date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From [Projects ]..Coviddeaths dea
join [Projects ]..CovidVaccinations vac
  On dea.location = vac.location
  and dea.date = vac.date
  Where dea.continent is not null
 --Order by 2,3
 )

Select*, (RollingPeopleVaccinated/population)
From PopvsVac

--TEMP TABLE
Drop Table if exists #PecentPopulationVaccinated
Create Table #PecentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PecentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(Convert(Int,vac.new_vaccinations)) Over (Partition By dea.location Order by dea.location, dea. date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From [Projects ]..Coviddeaths dea
join [Projects ]..CovidVaccinations vac
  On dea.location = vac.location
  and dea.date = vac.date
 Where dea.continent is not null
 --Order by 2,3

 Select*, (RollingPeopleVaccinated/population)*100
From #PecentPopulationVaccinated



Create View PecentPopulationVaccinated123 as

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(Convert(Int,vac.new_vaccinations)) Over (Partition By dea.location Order by dea.location, dea. date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From [Projects ]..Coviddeaths dea
join [Projects ]..CovidVaccinations vac
  On dea.location = vac.location
  and dea.date = vac.date
 Where dea.continent is not null
 --Order by 2,3