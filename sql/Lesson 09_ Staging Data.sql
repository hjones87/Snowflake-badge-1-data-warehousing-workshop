----LESSON 9: STAGING DATA--------

 ---WALKTHROUGH EXERCISES---

 --A) USING COPY INTO TO LOAD DATA--

--1) create Snowflake STAGE - 'my_internal_stage'
    -- navigate to UTIL_DB > PUBLIC schema > CREATE > STAGE > SNOWFLAKE MANAGED
    -- name 'my_internal_stage', add comment 'a place to hold files before loading', check serve-sde encryption
    -- load files into stage

 --2) create soil types table

 CREATE OR REPLACE TABLE GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS_SOIL_TYPE (
    PLANT_NAME VARCHAR(25),
    SOIL_TYPE NUMBER(1,0)
 );

--3) create file format
CREATE FILE FORMAT GARDEN_PLANTS.VEGGIES.PIPECOLSEP_ONEHEADROW
    TYPE = 'CSV' -- csv used for any flat file (tsv, pipe-separated, etc)
    FIELD_DELIMITER = '|' --pipies as column separators
    SKIP_HEADER = 1 --one header per row to skip
    ;

-- 4) copy table on internal stage
COPY INTO GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS_SOIL_TYPE
FROM @UTIL_DB.PUBLIC.MY_INTERNAL_STAGE
FILES = ( 'VEG_NAME_TO_SOIL_TYPE_PIPE.txt')
FILE_FORMAT = ( FORMAT_NAME=GARDEN_PLANTS.VEGGIES.PIPECOLSEP_ONEHEADROW) ;


--B) QUERY FILE FORMAT BEFORE LOADING

 --1) create 2nd file format
 CREATE FILE FORMAT GARDEN_PLANTS.VEGGIES.COMMSEP_DBLQUOT_ONEHEADROW
    TYPE = 'CSV' --csv for comma separated files
    FIELD_DELIMITER = ',' --commas as column separators
    SKIP_HEADER = 1 --one header row
    FIELD_OPTIONALLY_ENCLOSED_BY = '"' -- means that some values will be wrapped in double-quotes bc they have commas in them
    ;

 --2) check effects of file formats on data interpretation

    --the data in the file, with no FILE FORMAT specified
    SELECT $1
    FROM @UTIL_DB.PUBLIC.MY_INTERNAL_STAGE/LU_SOIL_TYPE.TSV;

    --same file but with one of the file formats previously created
    SELECT $1, $2, $3
    FROM @UTIL_DB.PUBLIC.MY_INTERNAL_STAGE/LU_SOIL_TYPE.TSV
    (FILE_FORMAT => GARDEN_PLANTS.VEGGIES.COMMASEP_DBLQUOT_ONEHEADROW);

    --same field but with the other file format
    SELECT $1, $2, $3
    FROM @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv
    (file_format => garden_plants.veggies.PIPECOLSEP_ONEHEADROW );

--CHALLENGE: CREATE a FILE FORMAT AND USE TO COPU INTO

--1) create field format for tabs / spaces 
CREATE FILE FORMAT GARDEN_PLANTS.VEGGIES.L9_CHALLENGE_FF
    TYPE = 'CSV' --csv for comma separated files
    FIELD_DELIMITER = '\t' --tabs as column separators
    SKIP_HEADER = 1 --one header row
    --FIELD_OPTIONALLY_ENCLOSED_BY = '"' -- means that some values will be wrapped in double-quotes bc they have commas in them
    ;

--2) check formatting on table
SELECT $1, $2, $3
FROM @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv
(file_format => garden_plants.veggies.L9_CHALLENGE_FF );

--3) create soil type look up table
CREATE OR REPLACE TABLE LU_SOIL_TYPE(
    SOIL_TYPE_ID NUMBER,
    SOIL_TYPE VARCHAR (15),
    SOIL_DESCRIPTION VARCHAR(75)
);

--4) create copy into statment to load file into table
COPY INTO GARDEN_PLANTS.VEGGIES.LU_SOIL_TYPE
FROM @UTIL_DB.PUBLIC.MY_INTERNAL_STAGE
FILES = ( 'LU_SOIL_TYPE.tsv')
FILE_FORMAT = ( FORMAT_NAME=GARDEN_PLANTS.VEGGIES.L9_CHALLENGE_FF) ;

--5) check table loaded
SELECT *
FROM LU_SOIL_TYPE;

---CHALLENGE LAB: Create table and COPY INTO

CREATE OR REPLACE TABLE GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS_PLANT_HEIGHT (
    PLANT_NAME VARCHAR(25),
    UNIT_OF_MEASURE VARCHAR(1),
    RANGE_MIN NUMBER(2),
    RANGE_MAX NUMBER(2)
);

CREATE FILE FORMAT GARDEN_PLANTS.VEGGIES.COMMASEP_ONHEADROW_OPTENCLOSED
    TYPE = 'CSV' --csv for comma separated files
    FIELD_DELIMITER = ',' --tabs as column separators
    SKIP_HEADER = 1 --one header row
    FIELD_OPTIONALLY_ENCLOSED_BY = '"' -- means that some values will be wrapped in double-quotes bc they have commas in them
    ;

COPY INTO GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS_PLANT_HEIGHT
FROM @UTIL_DB.PUBLIC.MY_INTERNAL_STAGE
FILES = ( 'veg_plant_height.csv')
FILE_FORMAT = ( FORMAT_NAME=GARDEN_PLANTS.VEGGIES.COMMASEP_ONHEADROW_OPTENCLOSED);

SELECT *
FROM GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS_PLANT_HEIGHT;

