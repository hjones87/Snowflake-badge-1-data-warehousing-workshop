----LESSON 8: NOTEBOOKS & FORMS----

---WALKTHROUGH EXERCISES---

--1) create flower_details table for input via notebooks
CREATE OR REPLACE TABLE 
    FLOWER_DETAILS (
        PLANT_NAME VARCHAR(25),
        ROOT_DEPTH_CODE VARCHAR(1)
    );

--view Uncle Yer's Root Depth Notebook.ipynb for other steps / code

--2) create fruits_details table for input via SiS forms
CREATE OR REPLACE TABLE 
    GARDEN_PLANTS.FRUITS.FRUIT_DETAILS (
        PLANT_NAME VARCHAR(25),
        ROOT_DEPTH_CODE VARCHAR(1)
    );

--view stremalit > Uncle Yer's Root Depth Entry Form for rest of steps / code    

--3) check / delete inputs from table inputed from SiS form
SELECT *
FROM GARDEN_PLANTS.FRUITS.FRUIT_DETAILS;

DELETE FROM GARDEN_PLANTS.FRUITS.FRUIT_DETAILS
WHERE PLANT_NAME = 'Apricot'
AND ROOT_DEPTH_CODE = 'D';

