# CarsFuelEconomy-Python-SQL

This projects is about web scraping in **Python**, data cleaning and data exploration in **SQL Server** on various data about cars released from 2016 to 2022.

The dataset that is analyzed is web scraped using Python from https://www.fueleconomy.gov 

More precisely from this https://www.fueleconomy.gov/feg/PowerSearch.do?action=noform&year1=2016&year2=2022&minmsrpsel=0&maxmsrpsel=0&city=0&hwy=0&comb=0&YearSel=2016-2022&make=&mclass=&vfuel=&vtype=&trany=&drive=&cyl=&MpgSel=000&sortBy=Comb&Units=&url=SearchServlet&opt=new&minmsrp=0&maxmsrp=0&minmpg=0&maxmpg=0&sCharge=&tCharge=&startstop=&cylDeact=&rowLimit=50&pageno=1&tabView=0 

The scraped file is named "cars" which is also uploaded here.

## Deliverables

The project starts with web-scraping all the available pages in Python from the selected website. 

This project will analyze different aspects of car data, i.e. popularity of car brands, motor types, fuel economy.
-	Libraries that were used in Python are: BeautifulSoup, requests, pandas.
Some of the insights that the analysis will provide:
-	How many car brands and motor types are there?
-	Order Car Brands by amount of models produced each year
-	Order Car Brands by amount of models for observed year
-	Motor types analysis
     - Motor types with most models
     - Car brands and all their motor types
     - Most popular motor types per car Brand
     - Car brands with most models per motor type
-	MPG analysis (miles per gallon analysis)
     - Average MPG per motor type of all the car brands
     - Highest AVG MPG car brand per motor type
     - Car models with highest MPG per motor type
     - AVG MPG of motor types for top 100 cars(per MPG), and the count of models per motor type
-	Creating Views

## Skills used 
Aggregate Functions, Windows Functions, Converting Data Types, CTE's, Temp Tables, Creating Views
