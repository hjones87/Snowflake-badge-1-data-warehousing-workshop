----LESSON 10: DATA STORAGE STRUCTURES----

---WALKTHROUGH EXERCISES---


 --1) Create new database

USE ROLE SYSADMIN;

CREATE DATABASE LIBRARY_CARD_CATALOG;
COMMENT IF EXISTS ON DATABASE LIBRARY_CARD_CATALOG IS 'DWW Lesson 10';
USE DATABASE LIBRARY_CARD_CATALOG;

--2) Create and fill Books Table
    -- create the book table and use AUTOINCREMENT to generate UID for each new row

CREATE or REPLACE TABLE BOOK (
    BOOK_UID NUMBER AUTOINCREMENT,
    TITLE VARCHAR(50),
    YEAR_PUBLISHED NUMBER(4,0)
);

    --insert records into BOOK table - You don;t have to list anything for BOOK_UID - AUTOINCREMENT property will dot his for you

INSERT INTO BOOK (TITLE, YEAR_PUBLISHED)
VALUES
    ('FOOD', 2001),
    ('FOOD', 2006),
    ('FOOD', 2008),
    ('FOOD', 2016),
    ('FOOD', 2015);

    --check table has unique ID
SELECT *
FROM BOOK;

--3) Create AUTHOR table

    --Create table
CREATE OR REPLACE TABLE AUTHOR (
    AUTHOR_UID NUMBER,
    FIRST_NAME VARCHAR(50),
    MIDDLE_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50)
);

    --input data into table
INSERT INTO AUTHOR(AUTHOR_UID, FIRST_NAME, MIDDLE_NAME, LAST_NAME)
VALUES
    (1, 'Fiona', '', 'Macdonald'),
    (2, 'Gian', 'Paulo','Faleschini');

    --check rows in table
SELECT *
FROM AUTHOR;

--4) Create sequence for generating unique identifiers

--HOME > CATALOG > EXPLORER > PUBLIC > CREATE > SEQUENCE

--create SEQUENCE
    --need to include ORDER or values will skip by 100 each time
create sequence LIBRARY_CARD_CATALOG.PUBLIC.SEQ_AUTHOR_UID
    start = 1,
    increment = 1,
    ORDER,
    comment = 'Use this to fill in AUTHOR_UID';

--show SEQUENCES
SHOW SEQUENCES;

--query sequence for next value
USE ROLE SYSADMIN;
SELECT LIBRARY_CARD_CATALOG.PUBLIC.SEQ_AUTHOR_UID.NEXTVAL;

--check what happens when using nextval more than once per query - not a common use case though
SELECT LIBRARY_CARD_CATALOG.PUBLIC.SEQ_AUTHOR_UID.NEXTVAL, LIBRARY_CARD_CATALOG.PUBLIC.SEQ_AUTHOR_UID.NEXTVAL;

--reset the sequence and recreate counter
CREATE OR REPLACE SEQUENCE LIBRARY_CARD_CATALOG.PUBLIC.SEQ_AUTHOR_UID
START = 3
INCREMENT = 1
ORDER
COMMENT = 'Use this to fill in AUTHOR_UID every time you add a row';

--add remaining author records and use nextval function instead of adding numbers manually
INSERT INTO AUTHOR (AUTHOR_UID, FIRST_NAME, MIDDLE_NAME, LAST_NAME)
VALUES
    (LIBRARY_CARD_CATALOG.PUBLIC.SEQ_AUTHOR_UID.NEXTVAL, 'Laura', 'K', 'Edendorf'),
    (LIBRARY_CARD_CATALOG.PUBLIC.SEQ_AUTHOR_UID.NEXTVAL, 'Jan', '', 'Grover'),
    (LIBRARY_CARD_CATALOG.PUBLIC.SEQ_AUTHOR_UID.NEXTVAL, 'Jennifer', '', 'Clapp'),
    (LIBRARY_CARD_CATALOG.PUBLIC.SEQ_AUTHOR_UID.NEXTVAL, 'Kathleen', '', 'Petelinsek');

--5) Create BOOK_TO_AUTHOR bridge table

USE DATABASE LIBRARY_CARD_CATALOG;
USE ROLE SYSADMIN;

    --create many-to-many relationship table
CREATE TABLE BOOK_TO_AUTHOR (
    BOOK_UID NUMBER,
    AUTHOR_UID NUMBER
);

    --insert known relationship rows to BOOK_TO_AUTHOR table
INSERT INTO BOOK_TO_AUTHOR (BOOK_UID, AUTHOR_UID)
VALUES
    (1,1),
    (1,2),
    (2,3),
    (3,4),
    (4,5),
    (5,6);

    --join the three tables
SELECT *
FROM BOOK_TO_AUTHOR ba
JOIN AUTHOR a
    ON ba.AUTHOR_UID = a.AUTHOR_UID
JOIN BOOK b
    ON ba.BOOK_UID = b.BOOK_UID;

