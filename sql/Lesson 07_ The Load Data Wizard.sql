----LESSON 7: THE LOAD DATA WIZARD ----

-- WALKTHROUGH EXERCISES --

--1) create vegetable details table
CREATE TABLE garden_plants.veggies.vegetable_details
    (
    PLANT_NAME VARCHAR(25)
    , ROOT_DEPTH_CODE VARCHAR(1)
    );

SELECT * 
FROM VEGETABLE_DETAILS
ORDER BY PLANT_NAME DESC;


--CHALLENGE: load 2nd table from file
SELECT *
FROM vegetables_details
ORDER BY Plant_Name DESC;

--2) find duplicate plant-names
SELECT 
    plant_name,
    count(*) as ROW_COUNT
FROM vegetable_details
GROUP BY 1
ORDER BY ROW_COUNT DESC;

--3) isolate spinach rows    
SELECT *
FROM vegetable_details
WHERE plant_name = 'Spinach'
AND root_depth_code ='D';

--4) delete 'deep' spinach row
DELETE FROM vegetable_details
WHERE plant_name = 'Spinach'
AND root_depth_code = 'D';

--5) check data with spinach 'deep' removed
SELECT *
FROM vegetable_details;
