----LESSON 12: NESTED SEMI-STRUCTURED DATA----

---Load and Query Nested Author & Book JSON Data---

--1) create table and file format for nested JSON data

USE DATABASE LIBRARY_CARD_CATALOG;
USE SCHEMA PUBLIC;
USE ROLE SYSADMIN;

CREATE OR REPLACE table NESTED_INGEST_JSON(
    RAW_NESTED_BOOK VARIANT
);

--2) Load nested JSON file into table - can use same file format as in Lesson 11
COPY INTO LIBRARY_CARD_CATALOG.PUBLIC.NESTED_INGEST_JSON
FROM @UTIL_DB.PUBLIC.MY_INTERNAL_STAGE
FILES = ( 'json_book_author_nested.txt')
FILE_FORMAT = ( FORMAT_NAME=LIBRARY_CARD_CATALOG.PUBLIC.JSON_FILE_FORMAT);

--query Nest JSON data
SELECT RAW_NESTED_BOOK
FROM NESTED_INGEST_JSON;

SELECT RAW_NESTED_BOOK:year_published
FROM NESTED_INGEST_JSON;

SELECT RAW_NESTED_BOOK:authors
FROM NESTED_INGEST_JSON;

--3) USE FLATTEN command on nested data

-- use these example flatten commands to explore flattening the nested book and author data
SELECT value:first_name
FROM nested_ingest_json
,LATERAL FLATTEN(INPUT => raw_nested_book:authors);

SELECT value:first_name
FROM nested_ingest_json
,TABLE(FLATTEN(raw_nested_book:authors));

-- add a CAST command to the fields returned
SELECT value:first_name::VARCHAR, value:last_name::VARCHAR
FROM nested_ingest_json
,LATERAL FLATTEN(INPUT => raw_nested_book:authors);

-- assign new column  names to the columns using "AS"
SELECT value:first_name::VARCHAR AS first_nm
, value:last_name::VARCHAR AS last_nm
FROM nested_ingest_json
,LATERAL FLATTEN(INPUT => raw_nested_book:authors);

---Load, Query and FLATTEN Nested TWEET data---

CREATE DATABASE SOCIAL_MEDIA_FLOODGATES;
USE SCHEMA PUBLIC;

CREATE OR REPLACE TABLE TWEET_INGEST(
    RAW_STATUS VARIANT
);

CREATE FILE FORMAT NESTED_JSON_FILE_FORMAT
TYPE = 'JSON'
COMPRESSION = 'AUTO'
ENABLE_OCTAL = FALSE
ALLOW_DUPLICATE = FALSE
STRIP_OUTER_ARRAY = TRUE
STRIP_NULL_VALUES = FALSE
IGNORE_UTF8_ERRORS = FALSE;

SELECT $1
FROM @util_db.public.my_internal_stage/nutrition_tweets.json
(file_format => NESTED_JSON_FILE_FORMAT);

COPY INTO SOCIAL_MEDIA_FLOODGATES.PUBLIC.TWEET_INGEST
FROM @UTIL_DB.PUBLIC.MY_INTERNAL_STAGE
FILES = ( 'nutrition_tweets.json')
FILE_FORMAT = ( FORMAT_NAME=SOCIAL_MEDIA_FLOODGATES.PUBLIC.NESTED_JSON_FILE_FORMAT);

SELECT RAW_STATUS
FROM TWEET_INGEST;

SELECT RAW_STATUS:entities
FROM TWEET_INGEST;

SELECT RAW_STATUS:entities:hashtags
FROM TWEET_INGEST;

--ecplore looking at specific hashtages by adding bracketed numbers
--return just first hashtag in each tweet
SELECT RAW_STATUS:entities:hashtags[0].text
FROM TWEET_INGEST;

--add a WHERE CLAUSE to remove tweets which do not have hashtags
SELECT RAW_STATUS:entities:hashtags[0].text
FROM TWEET_INGEST
WHERE RAW_STATUS:entities:hashtags[0].text IS NOT NULL;

--perform a CAST on created key and add ORDER BY to sort by tweet's creation date

SELECT RAW_STATUS:created_at::DATE
FROM TWEET_INGEST
ORDER BY RAW_STATUS:created_at::DATE;

--FLATTEN Entities

SELECT value
FROM TWEET_INGEST,
LATERAL FLATTEN(INPUT=> RAW_STATUS:entities:urls);

--Isolate entities
SELECT value 
FROM TWEET_INGEST,
TABLE(FLATTEN(RAW_STATUS:entities:urls));

--FLATTEN and return just hashtag text, CAST text as VARCHAR
SELECT value:text::VARCHAR as hashtag_used 
FROM TWEET_INGEST,
LATERAL FLATTEN 
(INPUT => RAW_STATUS:entities:hashtags);

--add Tweet_id ad USER_ID to returned table so can join hashtag back to source tweet

SELECT 
    RAW_STATUS:user:name::text as USER_NAME,
    RAW_STATUS:id as TWEET_ID,
    value:text::VARCHAR as hastage_used
FROM TWEET_INGEST,
LATERAL FLATTEN
(INPUT => RAW_STATUS:entities:hashtags);

-- create normalised view of URL data
CREATE OR REPLACE VIEW SOCIAL_MEDIA_FLOODGATES.PUBLIC.URLS_NORMALIZED AS (
    SELECT 
        RAW_STATUS:user:name::text as USER_NAME,
        RAW_STATUS:id AS TWEET_ID,
        value:display_url::text as URL_USED
    FROM TWEET_INGEST,
    LATERAL FLATTEN
    (INPUT => RAW_STATUS:entities:urls)
);

SELECT * FROM URLS_NORMALIZED;

--create normalised view of Hastag data
CREATE OR REPLACE VIEW SOCIAL_MEDIA_FLOODGATES.PUBLIC.HASHTAGS_NORMALIZED AS(
    SELECT
        RAW_STATUS:user:name::text as USER_NAME,
        RAW_STATUS:id AS TWEET_ID,
        value:text::VARCHAR as hashtags_used
    FROM TWEET_INGEST,
    LATERAL FLATTEN
    (INPUT => RAW_STATUS:entities:hashtags)
);

SELECT * FROM HASHTAGS_NORMALIZED;