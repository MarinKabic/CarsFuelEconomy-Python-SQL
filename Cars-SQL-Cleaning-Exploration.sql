--------------------------------
-------Glance at the data-------
--------------------------------

SELECT *
FROM cars


-------------------------------------------------------------------------------
-----------Separating Car_name into Car Year, Car Brand and Car Model----------
-------------------------------------------------------------------------------

SELECT 
    CAST(SUBSTRING(Car_name, 1, 4) AS INT) AS CarYear,
    SUBSTRING(Car_name, 6, CHARINDEX(' ', Car_name, 6) - 6) AS CarBrand,
    SUBSTRING(Car_name, CHARINDEX(' ', Car_name, 6) + 1, LEN(Car_name)) AS CarModel
FROM cars;


-------------------------------------------
----Adding New columns to the the table----
-------------------------------------------

ALTER TABLE cars
ADD Car_Year INT

UPDATE cars
SET Car_Year = CAST(SUBSTRING(Car_name, 1, 4) AS INT)

ALTER TABLE cars
ADD Car_Brand nvarchar(255)

UPDATE cars
SET Car_Brand = SUBSTRING(Car_name, 6, CHARINDEX(' ', Car_name, 6) - 6)

ALTER TABLE cars
ADD Car_Model nvarchar(255)

UPDATE cars
SET Car_Model = SUBSTRING(Car_name, CHARINDEX(' ', Car_name, 6) + 1, LEN(Car_name))


--------------------------------
-------Select the new data------
--------------------------------

SELECT Car_Year, Car_Brand, Car_Model, Manual_Motor, MPG, Annual_Fuel_Cost
FROM cars


-----------------------------------
------Separate the motor type------
-----------------------------------
	
SELECT
    REVERSE(SUBSTRING(REVERSE(Manual_Motor), 1, CHARINDEX(',', REVERSE(Manual_Motor))-2)) AS motor_type
FROM cars;




ALTER TABLE cars
ADD Motor_type nvarchar(255)

UPDATE cars
SET Motor_type = REVERSE(SUBSTRING(REVERSE(Manual_Motor), 1, CHARINDEX(',', REVERSE(Manual_Motor)) - 2))


------------------------
-----View the data------
------------------------

SELECT Car_Year, Car_Brand, Car_Model, Motor_type, MPG, Annual_Fuel_Cost
FROM cars
ORDER BY MPG DESC




---------------------------------------------------------------------
--------------------------Data exploration---------------------------
---------------------------------------------------------------------

----------------------------------------------------
---How many car brands and motor types are there?---
----------------------------------------------------

SELECT COUNT(DISTINCT(Car_Brand)) AS Car_brands_count,
       COUNT(DISTINCT(Motor_type)) AS Motor_type_count
FROM cars


-------------------------------------------------------------
---Order Car Brands by amount of models produced each year---
-------------------------------------------------------------

SELECT Car_Year, 
       Car_Brand,
	   COUNT(Car_Brand) AS Amount_of_models
FROM cars
GROUP BY Car_Year, 
       Car_Brand
ORDER BY 3 DESC




---------------------------------------------------------------------
-----------------------Car models analysis---------------------------
---------------------------------------------------------------------


--------------------------------------------------------------
----Order Car Brands by amount of models for observed year----
--------------------------------------------------------------

SELECT Car_Year, 
       Car_Brand,
	   COUNT(Car_Brand) AS Amount_of_models
FROM cars
WHERE Car_Year = '2022'
GROUP BY Car_Year, 
       Car_Brand
ORDER BY 3 DESC


---------------------------------------------------------------------
----------------------Motor types analysis---------------------------
---------------------------------------------------------------------


--------------------------------------------
--------Motor types with most models--------
--------------------------------------------

SELECT Motor_type, 
       COUNT(Car_Model) AS Amount_of_models
FROM cars 
GROUP BY Motor_type
ORDER BY Amount_of_models DESC


--------------------------------------------
----Car brands and all their motor types----
--------------------------------------------

SELECT Car_Brand,
	   Motor_type,
	   COUNT(DISTINCT(Car_Model)) AS Models_per_motor
FROM cars
GROUP BY Car_Brand,
	   Motor_type
ORDER BY Car_Brand, Models_per_motor DESC 


--------------------------------------------------
------Most popular motor types per car Brand------
--------------------------------------------------

WITH CTE AS
(
	SELECT Car_Brand,
		   Motor_type,
		   COUNT(DISTINCT(Car_Model)) AS Models_per_motor,
		   DENSE_RANK() OVER(PARTITION BY Car_Brand ORDER BY COUNT(DISTINCT(Car_Model)) DESC) AS Motor_type_rank
	FROM cars
	GROUP BY Car_Brand,
		     Motor_type
)
SELECT Car_Brand, 
       Motor_type 
FROM CTE 
WHERE Motor_type_rank = 1
ORDER BY Car_Brand



--------------------------------------------------
----Car brands with most models per motor type----
--------------------------------------------------

-- using CTE
--------------------------------------------------

WITH CTE AS
(
	SELECT 
	       Car_Brand,
		   Motor_type,
		   COUNT(DISTINCT(Car_Model)) AS models_per_motor,
		   DENSE_RANK() OVER(PARTITION BY Motor_type ORDER BY COUNT(DISTINCT(Car_Model)) DESC) AS motor_rank
	FROM cars
	GROUP BY 
	       Car_Brand,
		   Motor_type
)

SELECT Car_Brand,
	   Motor_type,
	   MAX(models_per_motor) AS max_models
FROM CTE
WHERE motor_rank = 1
GROUP BY Car_Brand,Motor_type
ORDER BY max_models DESC

	
-- using Temp table
-----------------------------------------------------


CREATE TABLE #temp_table
(
	car_brand nvarchar(255),
	motor_type nvarchar(255),
	models_per_motor int,
	motor_rank int
)

INSERT INTO #temp_table 
	SELECT 
	       Car_Brand,
		   Motor_type,
		   COUNT(DISTINCT(Car_Model)) AS models_per_motor,
		   DENSE_RANK() OVER(PARTITION BY Motor_type ORDER BY COUNT(DISTINCT(Car_Model)) DESC) AS motor_rank
	FROM cars
	GROUP BY 
	       Car_Brand,
		   Motor_type

SELECT car_brand,
	   motor_type,
	   MAX(models_per_motor) AS max_models
FROM #temp_table
WHERE motor_rank = 1
GROUP BY car_Brand,motor_type
ORDER BY max_models DESC




---------------------------------------------------------------------
---------------------------MPG analysis------------------------------
---------------------------------------------------------------------


----------------------------------------------------------
-----Average MPG per motor type of all the car brands-----
----------------------------------------------------------

SELECT Car_Brand,
       Motor_type,
	   AVG(MPG) AS Average_MPG
FROM cars 
GROUP BY Car_Brand,
         Motor_type
ORDER BY Motor_type, Average_MPG DESC


----------------------------------------------------------
-------Highest AVG MPG car brand per motor type-----------
----------------------------------------------------------

WITH CTE AS
(
	SELECT Car_Brand,
		   Motor_type,
		   AVG(MPG) AS Average_MPG,
		   DENSE_RANK() OVER(PARTITION BY Motor_type ORDER BY AVG(MPG) DESC) AS MPG_rank
	FROM cars 
	GROUP BY Car_Brand,
			 Motor_type
)
SELECT Car_Brand,
       Motor_type,
	   Average_MPG 
FROM CTE 
WHERE MPG_rank = 1
ORDER BY Average_MPG DESC


----------------------------------------------------------
------Car models with highest MPG per motor type----------
----------------------------------------------------------

WITH CTE AS
(
	SELECT Car_Year, 
		   Car_Brand,
		   Car_Model,
		   Motor_type,
		   MPG,
		   DENSE_RANK() OVER(PARTITION BY Motor_type ORDER BY MPG DESC) AS MPG_rank
	FROM cars
)
SELECT CONCAT(Car_Year, ' ', Car_Brand, ' ', Car_Model) AS Full_car_name,
       Motor_type,
       MPG 
FROM CTE 
WHERE MPG_rank = 1
ORDER BY MPG DESC


-----------------------------------------------------------------------------------------------
----AVG MPG of motor types for top 100 cars(per MPG), and the count of models per motor type---
-----------------------------------------------------------------------------------------------

WITH CTE AS
(
	SELECT *,
		   ROW_NUMBER() OVER(ORDER BY MPG DESC) AS row_numb
	FROM cars 
)
SELECT Motor_type,
       AVG(MPG) AS Average_MPG,
	   COUNT(Motor_type) AS Count_of_cars
FROM CTE
WHERE row_numb < 101
GROUP BY Motor_type
ORDER BY count_of_cars DESC



------------------------------
--------Creating views--------
------------------------------

CREATE VIEW Car_Brand_Model_Count_2022 AS
SELECT Car_Year, 
       Car_Brand,
	   COUNT(Car_Brand) AS Amount_of_models
FROM cars
WHERE Car_Year = '2022'
GROUP BY Car_Year, 
       Car_Brand







