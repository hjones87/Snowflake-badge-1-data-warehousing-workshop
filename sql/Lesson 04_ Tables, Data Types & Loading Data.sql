
----LESSON 4: TABLES, DATA TYPES and LOADING DATA----

---WORKTHROUGH EXERCISES---

-- 1) create table for root depth
CREATE OR REPLACE TABLE ROOT_DEPTH (
    ROOT_DEPTH_ID number(1),
    ROOT_DEPTH_CODE text(1),
    ROOT_DEPTH_NAME text(7),
    UNIT_OF_MEASURE text(2),
    RANGE_MIN number(2),
    RANGE_MAX number(2)
    );

--2) rename table
ALTER TABLE GARDEN_PLANTS.VEGGIES.ROOTDEPTH
RENAME to GARDEN_PLANTS.VEGGIES.ROOT_DEPTH;

-- 3) move table
ALTER TABLE GARDEN_PLANTS.FLOWERS.ROOTDEPTH
RENAME GARDEN_PLANTS.VEGGIES.ROOT_DEPTH;

--CHALLENGE LAB - Add two more rows to ROOT_DEPTH table
INSERT INTO ROOT_DEPTH
VALUES
(
    3,
    'D',
    'Deep',
    'cm',
    60,
    90
);

SELECT *
FROM ROOTH_DEPTH;


--THESE ARE JUST EXAMPLES! - YOU SHOULD NOT RUN THIS CODE WITHOUT EDITING IT FOR YOUR NEEDS.

--To add more than one row at a time
INSERT INTO root_depth (root_depth_id, root_depth_code
     , root_depth_name, unit_of_measure
     , range_min, range_max)  
VALUES
     (5,'X','short','in',66,77)
     ,(8,'Y','tall','cm',98,99)
;

-- To remove a row you do not want in the table
DELETE FROM root_depth
WHERE root_depth_id = 9;

--To change a value in a column for one particular row
UPDATE root_depth
SET root_depth_id = 7
WHERE root_depth_id = 9;

--To remove all the rows and start over
TRUNCATE TABLE root_depth;
