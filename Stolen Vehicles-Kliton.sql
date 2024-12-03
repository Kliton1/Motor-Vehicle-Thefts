USE Stolen_vehicles_db; 
-- MAKE_ID is present in make_details and stolen_vehicles tables 
-- Location_id is present in locations and stolen_vehicles tables 

SELECT *
FROM locations; 

SELECT COUNT(*)
FROM locations; 

SELECT *
FROM make_details; 

SELECT COUNT(*)
FROM make_details; 

SELECT *
FROM stolen_vehicles; 

/* FIRST PART 
Identify when vehicles are likely to be stolenYour first objective is to explore the vehicle and 
date fields in the stolen_vehicles table to identify when vehicles tend to be stolen.
*/

-- Find the number of vehicles stolen each year
-- Find the number of vehicles stolen each month
-- Find the number of vehicles stolen each day of the week
-- Replace the numeric day of week values with the full name of each day of the week (Sunday, Monday, Tuesday, etc.)
-- Create a bar chart that shows the number of vehicles stolen on each day of the week


-- Find the number of vehicles stolen each year
SELECT 
    YEAR(date_stolen), COUNT(vehicle_id) AS stolen_vehicle
FROM
    stolen_vehicles
GROUP BY YEAR(date_stolen); 
-- Solution: There are 1668 stolen vehicles in 2021 and 2885 stolen vehicles in 2022 

-- Find the number of vehicles stolen each month
SELECT 
    YEAR(date_stolen),
    MONTH(date_stolen),
    COUNT(vehicle_id) AS stolen_vehicle
FROM
    stolen_vehicles
GROUP BY YEAR(date_stolen) , MONTH(date_stolen)
ORDER BY MONTH(date_stolen); 


-- Find the number of vehicles stolen each day of the week
SELECT 
    DAYOFWEEK(date_stolen), COUNT(vehicle_id) AS stolen_vehicle
FROM
    stolen_vehicles
GROUP BY DAYOFWEEK(date_stolen)
ORDER BY DAYOFWEEK(date_stolen); 

-- Replace the numeric day of week values with the full name of each day of the week (Sunday, Monday, Tuesday, etc.)
SELECT DAYOFWEEK(date_stolen) as DOW, 
    CASE WHEN DAYOFWEEK(date_stolen) = 1 THEN 'SUNDAY'
	WHEN DAYOFWEEK(date_stolen) = 2 THEN 'MONDAY'
    WHEN DAYOFWEEK(date_stolen) = 3 THEN 'TUESDAY'
    WHEN DAYOFWEEK(date_stolen) = 4 THEN 'WEDNESDAY'
    WHEN DAYOFWEEK(date_stolen) = 5 THEN 'THURSDAY'
    WHEN DAYOFWEEK(date_stolen) = 6 THEN 'FRIDAY'
    ELSE 'SATURDAY' END AS day_of_week,
COUNT(vehicle_id) AS stolen_vehicle
FROM
    stolen_vehicles
GROUP BY DAYOFWEEK(date_stolen), day_of_week
ORDER BY DOW; 

-- Create a bar chart that shows the number of vehicles stolen on each day of the week
-- CREATE ON EXCEL 


/* SECOND PART
Identify which vehicles are likely to be stolen 
Your second objective is to explore the vehicle type, age, luxury vs standard and 
color fields in the stolen_vehicles table to identify which vehicles are most likely to be stolen.
*/

-- Find the vehicle types that are most often and least often stolen
-- For each vehicle type, find the average age of the cars that are stolen
-- For each vehicle type, find the percent of vehicles stolen that are luxury versus standard
/* Create a table where the rows represent the top 10 vehicle types, 
the columns represent the top 7 vehicle colors (plus 1 column for all other colors) 
and the values are the number of vehicles stolen
*/
-- Create a heat map of the table comparing the vehicle types and colors


-- Find the vehicle types that are most often and least often stolen
SELECT vehicle_type, COUNT(vehicle_type) as num_vehicle_stolen
FROM stolen_vehicles
GROUP BY vehicle_type
ORDER BY num_vehicle_stolen DESC;
-- THE MOST STOLEN VEHICLE TYPE ARE StationWagon at 945!!

SELECT vehicle_type, COUNT(vehicle_type) as num_vehicle_stolen
FROM stolen_vehicles
GROUP BY vehicle_type
ORDER BY num_vehicle_stolen;
-- THE LEAST STOLEN VEHICLE TYPE ARE Special Purpose Vehicle, Articulated Truck at 1


-- For each vehicle type, find the average age of the cars that are stolen
SELECT 
    vehicle_type,
    AVG(YEAR(date_stolen) - model_year) AS avg_age_stolencars
FROM
    stolen_vehicles
GROUP BY vehicle_type
ORDER BY avg_age_stolencars DESC;
-- THE SPECIAL PURPOSE VEHICLE HAS THE LONGEST STOLEN AVG TIME 


-- For each vehicle type, find the percent of vehicles stolen that are luxury versus standard
-- SOLUTION: WE NEED TO COMBINE THE STOLEN_VEHICLES TABLE WITH THE MAKE_DETAILS TABLE USING THE MAKE_ID 
SELECT * FROM stolen_vehicles;

SELECT * FROM make_details;

SELECT 
    sv.vehicle_type,
    SUM(CASE WHEN md.make_type = 'Luxury' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS PercentLuxury,
    SUM(CASE WHEN md.make_type = 'Standard' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS PercentStandard
FROM 
    stolen_vehicles_db.stolen_vehicles sv
JOIN 
    stolen_vehicles_db.make_details md ON sv.make_id = md.make_id
GROUP BY 
    sv.vehicle_type
ORDER BY 
    sv.vehicle_type;


/* Create a table where the rows represent the top 10 vehicle types, 
the columns represent the top 7 vehicle colors (plus 1 column for all other colors) 
and the values are the number of vehicles stolen
*/
SELECT
    vt.vehicle_type, COUNT(vehicle_id) as num_vehicle,
    SUM(CASE WHEN sv.color = 'Silver' THEN 1 ELSE 0 END) AS Silver,
    SUM(CASE WHEN sv.color = 'Black' THEN 1 ELSE 0 END) AS Black,
    SUM(CASE WHEN sv.color = 'Blue' THEN 1 ELSE 0 END) AS Blue,
    SUM(CASE WHEN sv.color = 'White' THEN 1 ELSE 0 END) AS White,
    SUM(CASE WHEN sv.color = 'Grey' THEN 1 ELSE 0 END) AS Grey,
    SUM(CASE WHEN sv.color = 'Green' THEN 1 ELSE 0 END) AS Green,
    SUM(CASE WHEN sv.color = 'Yellow' THEN 1 ELSE 0 END) AS Yellow,
    SUM(CASE WHEN sv.color NOT IN ('Silver', 'Black', 'Blue', 'White', 'Grey', 'Green', 'Yellow') THEN 1 ELSE 0 END) AS OtherColors
FROM
    (SELECT 
         vehicle_type
     FROM 
         stolen_vehicles_db.stolen_vehicles
     GROUP BY 
         vehicle_type
     ORDER BY 
		COUNT(*) DESC
     LIMIT 10) vt
JOIN 
    stolen_vehicles_db.stolen_vehicles sv ON vt.vehicle_type = sv.vehicle_type
GROUP BY 
    vt.vehicle_type
ORDER BY 
    num_vehicle DESC;
-- WE SEE THAT THE MOST STOLEN VEHICLE TYPE IS THE STATIONWAGON AND THE MOST STOLEN VEHILE COLOR IS SILVER 

SELECT color, COUNT(*) FROM stolen_vehicles
GROUP BY color;

-- Create a heat map of the table comparing the vehicle types and colors
-- TO DO IN EXCEL 




/* PART 3 
Identify where vehicles are likely to be stolenYour third objective is to explore the population 
and density statistics in the regions table to identify where vehicles are getting stolen, 
and visualize the results using a scatter plot and map.
*/ 
-- Find the number of vehicles that were stolen in each region
-- Combine the previous output with the population and density statistics for each region
-- Do the types of vehicles stolen in the three most dense regions differ from the three least dense regions?
-- Create a scatter plot of population versus density, and change the size of the points based on the number of vehicles stolen in each region
-- Create a map of the regions and color the regions based on the number of stolen vehicles

/* FINAL PART
How many total vehicles were stolen in the most dense region?
*/

-- Find the number of vehicles that were stolen in each region
SELECT * FROM locations;
SELECT * FROM stolen_vehicles; 

SELECT 
    l.region,
    COUNT(sv.vehicle_id) AS NumberOfThefts
FROM 
    stolen_vehicles_db.stolen_vehicles sv
JOIN 
    stolen_vehicles_db.locations l ON sv.location_id = l.location_id
GROUP BY 
    l.region
ORDER BY 
    NumberOfThefts DESC;
-- THE MOST STOLEN VEHICLES ARE FROM THE AUCKLAND AREA AT 1638 THEFTS


-- Combine the previous output with the population and density statistics for each region
SELECT 
    l.region,
    COUNT(sv.vehicle_id) AS NumberOfThefts,
    l.population,
    l.density
FROM 
    stolen_vehicles_db.stolen_vehicles sv
JOIN 
    stolen_vehicles_db.locations l ON sv.location_id = l.location_id
GROUP BY 
    l.region, l.population, l.density
ORDER BY 
    NumberOfThefts DESC;





-- Do the types of vehicles stolen in the three most dense regions differ from the three least dense regions?

-- Step 1: Identify the three most and three least dense regions
-- Get the three most dense regions
SELECT region
FROM 
    stolen_vehicles_db.locations
ORDER BY 
    density DESC
LIMIT 3;
-- THE MOST DENSE REGIONS ARE 'Auckland', 'Nelson', 'Wellington'

-- Get the three least dense regions
SELECT region
FROM 
    stolen_vehicles_db.locations
ORDER BY 
    density ASC
LIMIT 3;
-- THE LEAST DENSE REGIONS ARE 'West Coast', 'Southland', 'Marlborough'


-- Step 2: Filter the data for vehicle thefts in these regions
-- Find the three most dense regions
WITH MostDenseRegions AS (SELECT region
    FROM 
        stolen_vehicles_db.locations
    ORDER BY 
        density DESC
    LIMIT 3
),

-- Find the three least dense regions
LeastDenseRegions AS (SELECT region
    FROM 
        stolen_vehicles_db.locations
    ORDER BY 
        density ASC
    LIMIT 3
)

-- Step 3: Count the types of vehicles stolen in these regions and compare them
-- Count vehicle types in the most dense regions
SELECT 
    sv.vehicle_type,
    COUNT(sv.vehicle_id) AS NumberOfThefts,
    'Most Dense Regions' AS RegionType
FROM 
    stolen_vehicles_db.stolen_vehicles sv
JOIN 
    stolen_vehicles_db.locations l ON sv.location_id = l.location_id
WHERE 
    l.region IN (SELECT region FROM MostDenseRegions)
GROUP BY 
    sv.vehicle_type

UNION

-- Count vehicle types in the least dense regions
SELECT 
    sv.vehicle_type,
    COUNT(sv.vehicle_id) AS NumberOfThefts,
    'Least Dense Regions' AS RegionType
FROM 
    stolen_vehicles_db.stolen_vehicles sv
JOIN 
    stolen_vehicles_db.locations l ON sv.location_id = l.location_id
WHERE 
    l.region IN (SELECT region FROM LeastDenseRegions)
GROUP BY 
    sv.vehicle_type
ORDER BY 
    RegionType, NumberOfThefts DESC;



-- EXPORT TO EXCEL FOR THE TASKS BELOW 
-- Create a scatter plot of population versus density, and change the size of the points based on the number of vehicles stolen in each region
-- Create a map of the regions and color the regions based on the number of stolen vehicles



-- Identify the most dense region
WITH MostDenseRegion AS (
    SELECT 
        region
    FROM 
        stolen_vehicles_db.locations
    ORDER BY 
        density DESC
    LIMIT 1
)

-- Count the total vehicles stolen in the most dense region
SELECT 
    COUNT(sv.vehicle_id) AS NumberOfThefts
FROM 
    stolen_vehicles_db.stolen_vehicles sv
JOIN 
    stolen_vehicles_db.locations l ON sv.location_id = l.location_id
WHERE 
    l.region = (SELECT region FROM MostDenseRegion);





