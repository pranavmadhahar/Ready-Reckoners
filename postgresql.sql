-- USERS / ROLES
-- ============================================

-- Option 1:

-- Create a new user (role) with a password with the ability to create databases
CREATE USER pm WITH PASSWORD 'your_password';
ALTER USER pm CREATEDB;

-- Option 2:

-- Create a new user (role) with a password and the ability to create databases
CREATE USER pm WITH PASSWORD 'your_password' CREATEDB;

-- Grant the new user access to the public schema
-- go to \c test first as postgres user, then run the following command:
GRANT USAGE, CREATE ON SCHEMA public TO pm;

-- Verify the creation of the new user
-- \du


-- DATABASE
-- ============================================

-- Create a new database for testing purposes
CREATE DATABASE test;



-- From the Linux terminal: Connect as pm to the test database
-- This will directly connect you to the test database as user pm:

-- psql -h localhost -p 5432 -U pm -d test

-- Alternatively, you can connect to the PostgreSQL server as the postgres user:

-- sudo -u postgres psql

-- And then to change to the test database as user pm, you can use:

-- \c test pm localhost


-- NOTE
--======================================================================================

-- PostgreSQL SQL Commands:

-- CREATE USER
-- CREATE DATABASE

-- PSQL COMMANDS
--======================================================================================

-- \dn                  → list schemas
-- \du                  → list users/roles
-- \l                   → list databases
-- \c test              → connect to database "test"
-- \q                   → quit psql
-- \dt                  → list Tables
-- \d person            → describe table person
-- \d+ person           → show detailed structure of table person
-- \i /home/pranav/Learning/databases/postgresql/data/car.sql → Insert bulk data from file
-- \x                   → extended display toggle on/off
-- \q                   → exit psql
-- \dx                  → list extensions

LINUX TERMINAL COMMAND
--======================================================================================

psql -h <host> -p <port> -U <username> -d <database>

Example:

psql -h localhost -p 5432 -U pm -d test


-- CREATE TABLE
--======================================================================================

CREATE TABLE person (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    birth_date DATE,
    gender CHAR(6) CHECK (gender IN ('MALE', 'FEMALE', 'OTHER'))
);

-- INSERT DATA
--======================================================================================

INSERT INTO person (first_name, last_name, email, birth_date, gender)
VALUES ('John', 'Doe', 'john.doe@example.com', '1990-01-01', 'Male');

INSERT INTO person (first_name, last_name, email, birth_date, gender)
VALUES ('jane', 'baker', 'jane@example.com', '1992-03-07', 'Female');

-- INSERT DATA FROM EXTERNAL SQL FILE
\i /home/pranav/Learning/databases/postgresql/data/person.sql


-- SELECT AND ORDER BY
--======================================================================================

SELECT * FROM person ORDER BY country_of_birth;

-- CLEAR SCREEN
Ctrl + L

-- SELECT COLUMNS
SELECT first_name FROM person;
SELECT first_name, last_name FROM person;

-- SELECT WITH LIMIT
SELECT * FROM person LIMIT 5;

-- ORDER BY - ASCENDING AND DESCENDING - DEFAULT IS ASCENDING
SELECT * FROM person ORDER BY last_name ASC LIMIT 5;

-- THIS WILL ORDER BY ID ASC AND THEN FIRST_NAME DESCENDING
SELECT * FROM person ORDER BY id, first_name DESC;

-- THIS WILL ORDER BY ID DESC AND THEN FIRST_NAME DESCENDING
SELECT * FROM person ORDER BY id DESC, first_name DESC;

-- THIS WILL ORDER BY BIRTH_DATE ASCENDING (DEFAULT)
SELECT * FROM person ORDER BY birth_date;


-- DISTINCT
--======================================================================================

SELECT country_of_birth FROM person ORDER BY country_of_birth;
SELECT DISTINCT country_of_birth FROM person ORDER BY country_of_birth;

-- WHERE
--======================================================================================

SELECT * FROM person WHERE gender = 'Female';

-- WHERE WITH AND OR
--======================================================================================

SELECT * FROM person WHERE gender = 'Female' AND country_of_birth = 'Poland';
SELECT * FROM person WHERE gender = 'Female' AND (country_of_birth = 'Poland' OR country_of_birth = 'China');

-- COMPARISON
--======================================================================================

SELECT 1 = 1;
SELECT 1 = 2;
SELECT 1 < 2;
SELECT 1 > 2;
-- <> is the not equal operator in PostgreSQL
SELECT 1 <> 2; 

-- OFFSET, LIMIT, FETCH, and PAGINATION
--======================================================================================

SELECT * FROM person ORDER BY id LIMIT 5;
SELECT * FROM person ORDER BY id LIMIT 5 OFFSET 5;
SELECT * FROM person ORDER BY id LIMIT 5 OFFSET 10;
SELECT * FROM person ORDER BY id OFFSET 15 FETCH FIRST 5 ROWS ONLY;

-- IN
--======================================================================================

SELECT * FROM person WHERE country_of_birth IN ('Poland', 'France', 'Brazil');
SELECT * FROM person WHERE country_of_birth IN ('Poland', 'France', 'Brazil') AND gender = 'Female';

-- BETWEEN
--======================================================================================

SELECT * FROM person WHERE birth_date BETWEEN '2025-01-01' AND '2026-12-31';

-- LIKE 
--======================================================================================

SELECT * FROM person WHERE first_name LIKE 'John%';
SELECT * FROM person WHERE first_name LIKE 'J_h%';
SELECT * FROM person WHERE email LIKE '%wikia.com'; 
SELECT * FROM person WHERE email LIKE '%google%';

-- COUNT, GROUP BY, HAVING
--======================================================================================

SELECT COUNT(*) FROM person;
SELECT COUNT(*) FROM person WHERE country_of_birth = 'Brazil';
SELECT country_of_birth, COUNT(*) FROM person GROUP BY country_of_birth;
SELECT country_of_birth, COUNT(*) FROM person GROUP BY country_of_birth ORDER BY COUNT(*) DESC;
SELECT country_of_birth, COUNT(*) FROM person GROUP BY country_of_birth HAVING COUNT(*) > 3;

-- CREATE TABLE car FROM EXTERNAL SQL FILE
--======================================================================================

\i /home/pranav/Learning/databases/postgresql/data/car.sql


-- MAX, MIN, AVG, ROUND, SUM
--======================================================================================

SELECT * FROM car;
SELECT MAX(price) FROM car;
SELECT MIN(price) FROM car;
SELECT AVG(price) FROM car;
SELECT ROUND(AVG(price)) FROM car;
SELECT SUM(price) FROM car;

-- WITH GROUP BY
--======================================================================================

SELECT make, model, MIN(price) FROM car GROUP BY make, model;
SELECT make, model, MAX(price) FROM car GROUP BY make, model;
SELECT make, model, ROUND(AVG(price)) FROM car GROUP BY make, model;
SELECT make, SUM(price) FROM car GROUP BY make;
SELECT make, model, SUM(price) FROM car GROUP BY make, model;


-- ARITHMETIC OPERATORS
--======================================================================================

-- "For every row in car, return the constant value 10 / 2."
SELECT 10 / 2 FROM car; 
SELECT 10^2;
-- Take every price value from the car table and multiply it by 1.1.
SELECT price * 1.1 FROM car;
SELECT factorial(5);
SELECT 10 % 3; -- modulus operator

SELECT id, make, model, price, ROUND(price * 0.10, 2) AS discount FROM car;

SELECT 
id, make, model, price, ROUND(price * 0.10, 2) AS discount, ROUND(price * 0.90, 2) AS offer_price 
FROM car;


-- COALESCE, NULLIF
--======================================================================================

-- COALESCE: "Return the first non-NULL value from the arguments."
SELECT COALESCE(1);
SELECT COALESCE(NULL, 10);

-- With columns, it works row-by-row. 
SELECT COALESCE(email) FROM person;
-- provide non null value else return email not provided
SELECT COALESCE(email, 'email not provided') FROM person;

-- NULLIF: NULLIF(A, B): IF A = B = True RETURN NULL; IF A = B = FALSE RETURN A

SELECT NULLIF(10, 10);
SELECT NULLIF(10, 1);

-- NULLIF prevents invalid values (like division by zero) by converting them to NULL; 
SELECT NULLIF(price, 0) FROM car;

-- COALESCE can then replace that NULL with a default value.
-- TO avoid error for division by zero
SELECT COALESCE (10 / NULLIF(0, 0), 0);
-- Dummy Example
SELECT COALESCE(total_sales / NULLIF(number_of_customers, 0), 0)
FROM sales;


--TIMESTAMPS & DATES
--======================================================================================

SELECT NOW();
SELECT NOW()::DATE;
SELECT NOW()::TIME; -- PROVIDES TIME IN H:M:S:Microseconds
SELECT NOW()::TIME(0); -- PROVIDES APPROX TIME in H:M:S 
SELECT NOW()::TIME(3); --- PROVIDES APPROX TIME in H:M:S & milliseconds
SELECT NOW()::TIME(6);--- PROVIDES APPROX TIME in H:M:S & microseconds

-- INTERVAL

-- Subtraction

SELECT NOW() - INTERVAL '10 YEARS'; -- SUBTRACTS 10 YRS FROM PRESENT TIME
SELECT NOW() - INTERVAL '10 MONTHS';-- SUBTRACTS 10 MONTHS FROM PRESENT TIME
SELECT NOW() - INTERVAL '10 DAYS';-- SUBTRACTS 10 DAYS FROM PRESENT TIME

-- Addition

SELECT NOW() + INTERVAL '10 YEARS'; -- ADDS 10 YRS FROM PRESENT TIME
SELECT NOW() + INTERVAL '10 MONTHS';-- ADDS 10 MONTHS FROM PRESENT TIME
SELECT NOW() + INTERVAL '10 DAYS';-- ADDS 10 DAYS FROM PRESENT TIME

-- TO GET FUTURE DATE

SELECT (NOW() + INTERVAL '10 YEARS')::DATE; 

-- Extracting Fields

SELECT EXTRACT(YEAR FROM NOW());
SELECT EXTRACT(MONTH FROM NOW());
SELECT EXTRACT(DAY FROM NOW());
SELECT EXTRACT(DOW FROM NOW()); -- day of week
SELECT EXTRACT(CENTURY FROM NOW());
SELECT EXTRACT(HOURS FROM NOW());
SELECT EXTRACT(MINUTES FROM NOW());
SELECT EXTRACT(MILLISECONDS FROM NOW());
SELECT EXTRACT(MICROSECONDS FROM NOW());

-- Age
--======================================================================================

SELECT
first_name, last_name, gender, country_of_birth, birth_date, AGE(NOW(), birth_date) AS "AGE"
FROM PERSON; 


-- PRIMARY KEY
--======================================================================================

-- deleting primary key

ALTER TABLE person DROP CONSTRAINT person_pkey;

-- adding primary key

ALTER TABLE person ADD PRIMARY KEY (id);


-- UNIQUE CONSTRAINT
--======================================================================================

SELECT email, count(*) FROM person GROUP BY email;
SELECT email, count(*) FROM person GROUP BY email HAVING COUNT(*) > 1;

-- We define the constraint name
ALTER TABLE person ADD CONSTRAINT unique_email UNIQUE (email);
ALTER TABLE person DROP CONSTRAINT unique_email;

-- postgres will define the constraint name
ALTER TABLE person ADD UNIQUE (email);
ALTER TABLE person DROP CONSTRAINT person_email_key;


-- CHECK CONSTRAINT: BOOLEAN BASED CONSTRAINT
--======================================================================================

ALTER TABLE person 
ADD CONSTRAINT gender_constraint 
CHECK 
(gender IN ('Female', 'Male', 'Genderqueer', 'Bigender', 'Genderfluid', 'Non-binary', 'Polygender', 'Agender'));


-- DELETE
--======================================================================================

DELETE FROM person WHERE id = 11; 
DELETE FROM person WHERE gender = 'Female' AND country_of_birth = 'China';
DELETE FROM person WHERE gender = 'Male';


-- UPDATE, SET
--======================================================================================

-- If we do not use where with update command then all records will be updated
UPDATE person SET email = 'calinadolan@gmail.com' WHERE id = 9;
UPDATE person SET first_name = 'Carolina', last_name = 'Montana', email = 'carolinamontana@gmail.com' WHERE id = 9; 


-- DUPLICATE KEY ERRORS:
--======================================================================================

-- Duplicate-key conflicts can occur with UNIQUE constraints and PRIMARY KEY constraints.

INSERT INTO
person (first_name, last_name, gender, email, birth_date, country_of_birth)
VALUES
('Carolina', 'Montana', 'Female', 'carolinamontana@gmail.com', '2026-07-04', 'China')
ON CONFLICT (email)
DO NOTHING;

-- Get notified of the update
-- If email already exists

INSERT INTO
person (first_name, last_name, gender, email, birth_date, country_of_birth)
VALUES
('Carolina', 'Montana', 'Female', 'carolinamontana@gmail.com', '2026-07-04', 'China')
ON CONFLICT (email)
DO NOTHING
RETURNING id;


-- UPSERT: (Update + Insert)
--======================================================================================

-- Create new record if it does not exists, otherwise allow for updates

INSERT INTO
person (first_name, last_name, gender, email, birth_date, country_of_birth)
VALUES
('Carolina', 'Swan', 'Female', 'carolinamontana@gmail.uk', '2026-07-04', 'China')
ON CONFLICT (email)
DO UPDATE
SET last_name = EXCLUDED.last_name
RETURNING id;

INSERT INTO
person (first_name, last_name, gender, email, birth_date, country_of_birth)
VALUES
('Carolina', 'White', 'Female', 'carolinamontana@gmail.uk', '2026-07-04', 'China')
ON CONFLICT (email)
DO UPDATE
SET last_name = EXCLUDED.last_name, first_name = EXCLUDED.first_name, country_of_birth = EXCLUDED.country_of_birth
RETURNING id;


-- FOREIGN KEYS & RELATIONSHIPS
--======================================================================================

-- A foreign key references a primary key or UNIQUE key in another table.

create table car (
	id int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	make VARCHAR(100) NOT NULL,
	model VARCHAR(100) NOT NULL,
	price DECIMAL(8,2) NOT NULL
);

create table person (
	id int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(50),
	gender VARCHAR(50),
	birth_date DATE,
	country_of_birth VARCHAR(50),
    car_id int REFERENCES car(id) UNIQUE ON DELETE SET NULL
);

-- ASSIGNING FOREIGN KEYS TO person table

UPDATE person SET car_id = 2 WHERE id = 1;
UPDATE person SET car_id = 1 WHERE id = 3;


-- JOINS
--======================================================================================

-- inner join

SELECT * FROM person
JOIN car 
ON person.car_id = car.id;

-- Join with selected columns

SELECT person.first_name, car.make, car.model, car.price
FROM person
JOIN car ON person.car_id = car.id;

-- left join

SELECT * FROM person
LEFT JOIN car
ON person.car_id = car.id;

-- USING KEYWORD: when primary key and foreign key has same name

SELECT *
FROM person
LEFT JOIN car USING (car_uid);

-- select non matching values
SELECT *
FROM person
LEFT JOIN car USING (car_uid)
WHERE car.* IS NULL;


-- EXPORTING QUERY RESULTS TO CSV
--======================================================================================

SELECT * FROM person
INNER JOIN car
ON person.car_id = car.id;

-- \copy (query) TO 'path' DELIMITER '' CSV HEADER 

\copy 
(SELECT * FROM person
INNER JOIN car
ON person.car_id = car.id)
TO
'/home/pranav/Learning/databases/postgresql/data/results.csv'
DELIMITER ',' CSV HEADER; 


-- IDENTITY COLUMNS & SEQUENCES
--======================================================================================


-- first find the identity sequence
SELECT pg_get_serial_sequence('person', 'id');

-- restart it
ALTER SEQUENCE person_id_seq RESTART WITH 10;

-- or simply
ALTER TABLE person
ALTER COLUMN id RESTART WITH 10;

-- insert data to check
insert into 
person (first_name, last_name, email, gender, birth_date, country_of_birth) 
values ('John', 'Black', null, 'Male', '2025-09-25', 'England');


-- EXTENSIONS: Functions which add extra functionalities
--======================================================================================

-- list available extensions
SELECT * FROM pg_available_extensions;

-- create uuid-ossp extension, ex name should be in double quotes
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- \df : list of available functions with the extension

-- run the function
SELECT uuid_generate_v4();

-- using uuids as primary keys: change the below code from to

-- instead of:
id int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,

-- use: uuid-ossp extension
person_uid UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

-- or built-in 
person_uid UUID PRIMARY KEY DEFAULT gen_random_uuid(),


-- EXPLAIN ANALYZE
--======================================================================================

-- Example:
EXPLAIN ANALYZE
SELECT * FROM person
WHERE gender = 'Male';

-- Output:
-- Seq Scan on person
-- (cost=0.00..11.50 rows=1 width=626)
-- (actual time=0.011..0.013 rows=2 loops=1)
--   Filter: ((gender)::text = 'Male'::text)
--   Rows Removed by Filter: 1
-- Planning Time: 0.061 ms
-- Execution Time: 0.026 ms

-- READING EXPLAIN ANALYZE OUTPUT:
--
-- Seq Scan on person
--   PostgreSQL scans the table sequentially, row by row.
--
-- cost=0.00..11.50
--   Estimated planner cost, NOT milliseconds.
--
-- rows=1
--   Planner estimated 1 matching row.
--
-- width=626
--   Estimated average size of each output row in bytes.
--
-- actual time=0.011..0.013
--   0.011 ms → first row produced.
--   0.013 ms → node finished.
--
-- rows=2
--   Actually 2 rows matched.
--
-- loops=1
--   Scan executed once.
--
-- Filter: gender = 'Male'
--   Condition PostgreSQL applied to each row.
--
-- Rows Removed by Filter: 1
--   1 row didn't match and was discarded.
--
-- Planning Time: 0.061 ms
--   Time spent choosing the execution plan.
--
-- Execution Time: 0.026 ms
--   Actual execution time.


-- The key distinction: 
-- Estimated:
-- rows=1
-- cost=11.50

-- Actual:
-- rows=2
-- Execution Time=0.026 ms

-- EXPLAIN → estimated plan
-- EXPLAIN ANALYZE → actually executes + shows what happened


-- Why Too Many Indexes Are Bad Practice:
--======================================================================================

-- Indexes improve read/query performance, but they add costs.

-- More indexes
     ↓
-- More storage
     ↓
-- More maintenance
     ↓
-- Slower INSERT / UPDATE / DELETE

-- Main disadvantages:

-- Storage: Every index consumes disk space.
-- INSERT: New rows require index entries to be created.
-- UPDATE: Changes to indexed columns may require index updates.
-- DELETE: Corresponding index entries must be maintained.
-- Memory/cache: Indexes can consume valuable memory/cache.
-- Unused indexes: An index may never be chosen by PostgreSQL's planner.
-- Redundant indexes: Multiple indexes can sometimes overlap unnecessarily.

-- Practical rule:

-- Create indexes based on actual query patterns, especially frequently used:

-- WHERE
-- JOIN
-- ORDER BY
-- GROUP BY

-- And validate their usefulness with: EXPLAIN ANALYZE


-- INDEX
--======================================================================================

-- create
CREATE INDEX person_gender ON person(gender);

-- delete
DROP INDEX person_gender;

-- delete without error if index doesn't exist
DROP INDEX IF EXISTS person_gender; 


-- TRANSACTIONS
--======================================================================================

BEGIN TRANSACTION;

-- or simply begin, transaction is optional in code
BEGIN;

DELETE FROM person
WHERE gender = 'Male';

SELECT * FROM person;

ROLLBACK;
COMMIT;


-- SAVEPOINT:

BEGIN;

insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Dale', 'Kemmer', 'dkemmer7@fda.gov', 'Female', '2025-12-13', 'China');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Carlina', 'Dolan', null, 'Female', '2026-07-04', 'China');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Mahmud', 'McMenamy', 'mmcmenamy9@apple.com', 'Male', '2026-03-24', 'Ecuador');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Darlleen', 'Terry', null, 'Female', '2025-09-08', 'Finland');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Lizabeth', 'Pierri', 'lpierrib@indiatimes.com', 'Female', '2025-10-01', 'Russia');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Zane', 'Lorant', 'zlorantc@elegantthemes.com', 'Male', '2026-03-01', 'China');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Wilma', 'Speariett', 'wspeariettd@jugem.jp', 'Female', '2025-08-22', 'Finland');
SAVEPOINT one;

insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Stearn', 'Rann', null, 'Male', '2026-03-12', 'China');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Rodge', 'Pedro', 'rpedrof@stumbleupon.com', 'Male', '2026-01-22', 'Norway');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Peta', 'Wheelhouse', 'pwheelhouseg@wp.com', 'Genderqueer', '2025-08-25', 'United States');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Consuela', 'Bortoluzzi', 'cbortoluzzih@shinystat.com', 'Female', '2026-03-20', 'Thailand');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Emmalee', 'McTeggart', 'emcteggarti@youtu.be', 'Female', '2026-03-02', 'Indonesia');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Toddy', 'Tingcomb', null, 'Male', '2026-03-02', 'Greece');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Goldie', 'Escott', 'gescottk@squidoo.com', 'Female', '2026-05-17', 'Sweden');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Odette', 'Nore', 'onorel@senate.gov', 'Female', '2026-04-25', 'Czech Republic');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Carie', 'Simmell', 'csimmellm@alexa.com', 'Female', '2026-02-12', 'Democratic Republic of the Congo');
SAVEPOINT two;

insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Helli', 'Kloster', 'hklostern@aol.com', 'Female', '2025-10-29', 'Honduras');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Emalee', 'Wyer', null, 'Female', '2026-05-20', 'South Korea');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Otha', 'Cahn', 'ocahnp@networksolutions.com', 'Genderqueer', '2025-10-23', 'China');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Nelson', 'Dilawey', 'ndilaweyq@amazon.co.jp', 'Male', '2026-04-08', 'Serbia');
SAVEPOINT three;

insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Dulcy', 'Paynes', 'dpaynesr@hc360.com', 'Female', '2026-02-04', 'Philippines');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Lenci', 'Wellstood', null, 'Male', '2025-10-31', 'China');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Luise', 'Kinnoch', 'lkinnocht@ihg.com', 'Female', '2025-09-28', 'Portugal');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Abie', 'Livens', 'alivensu@theatlantic.com', 'Male', '2026-01-17', 'France');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Brewster', 'Nasey', 'bnaseyv@kickstarter.com', 'Male', '2025-09-28', 'Ukraine');
insert into person (first_name, last_name, email, gender, birth_date, country_of_birth) values ('Charity', 'Gapper', 'cgapperw@nps.gov', 'Female', '2025-12-20', 'Poland');
SAVEPOINT four;

ROLLBACK TO SAVEPOINT two;
RELEASE SAVEPOINT two;

SELECT * FROM person;

ROLLBACK;
-- COMMIT;



-- SUBQUERIES:
--======================================================================================

-- A subquery is a query nested inside another query. It can be used in SELECT,
-- WHERE, FROM, and other clauses. Subqueries can return a single value, a list
-- of values, or a table.

SELECT AGE(NOW(), birth_date) AS age FROM person;

SELECT AVG(AGE(NOW(), birth_date)) AS avg_age FROM person;

-- The subquery calculates the average age and returns a single value.
-- The outer query compares each person's age against that value.

SELECT *
FROM person
WHERE AGE(NOW(), birth_date) > (
    SELECT AVG(AGE(NOW(), birth_date))
    FROM person
);


-- CTE:
--======================================================================================

-- A CTE (Common Table Expression) creates a temporary named result
-- that can be referenced by the main query.
-- It is useful for breaking complex queries into readable steps.

WITH age AS (
    SELECT
        first_name,
        gender,
        country_of_birth,
        AGE(NOW(), birth_date) AS person_age
    FROM person
)

-- The CTE calculates each person's age once, then the main query
-- filters people whose age is greater than the average age from the CTE.

SELECT *
FROM age
WHERE person_age > (
    SELECT AVG(person_age)
    FROM age
);


-- WINDOW FUNCTIONS:
--======================================================================================

-- Window functions perform calculations across related rows WITHOUT
-- collapsing them into a single row like GROUP BY does.
--
-- Syntax:
-- function() OVER (window_definition)
--
-- OVER (...) defines the window — the rows/order the function operates on.
--
-- ORDER BY inside OVER() controls the order used by the window function.
--
-- PARTITION BY divides rows into groups; the window function operates
-- separately within each group.
--
-- Common ranking functions:
-- ROW_NUMBER()  → unique sequential number; ties get different numbers.
-- RANK()        → same rank for ties; leaves gaps after ties.
-- DENSE_RANK()  → same rank for ties; no gaps after ties.
--
-- Window functions are calculated after WHERE, so their results cannot
-- normally be filtered directly with WHERE at the same query level.
-- Use a subquery or CTE to filter window-function results.
--
-- Common pattern:
-- 1. Prepare data
-- 2. Apply window function
-- 3. Filter the result using a subquery/CTE
--
-- ------------------------------------------------------------
-- sort the results

WITH age AS (

    SELECT

        first_name,

        gender,

        country_of_birth,

        AGE(NOW(), birth_date) AS person_age

    FROM person

)

SELECT *

FROM age

ORDER BY person_age DESC;


-- add a senior_rank column (window function)

-- OVER (ORDER BY person_age DESC) defines the window/order.
-- ROW_NUMBER() assigns a unique sequential number to each row.

WITH age AS (

    SELECT

        first_name,

        gender,

        country_of_birth,

        AGE(NOW(), birth_date) AS person_age

    FROM person

)

SELECT first_name, gender, person_age,

ROW_NUMBER() OVER (ORDER BY person_age DESC) AS senior_rank

FROM age;


-- try different functions

WITH age AS (

    SELECT

        first_name,

        gender,

        country_of_birth,

        AGE(NOW(), birth_date) AS person_age

    FROM person

)

SELECT first_name, gender, person_age,

ROW_NUMBER() OVER (ORDER BY person_age DESC) AS senior_rank,

RANK() OVER (ORDER BY person_age DESC) AS senior_rank_R,

DENSE_RANK() OVER (ORDER BY person_age DESC) AS senior_rank_DR

FROM age;


-- try different windows

-- PARTITION BY gender creates a separate window for each gender.
-- Ranking restarts within each gender.

WITH age AS (

    SELECT

        first_name,

        gender,

        country_of_birth,

        AGE(NOW(), birth_date) AS person_age

    FROM person

)

SELECT first_name, gender, person_age,

ROW_NUMBER() OVER (PARTITION BY gender ORDER BY person_age DESC) AS senior_rank

FROM age;


-- what are the top 3 oldest persons for each gender ?

-- Apply ROW_NUMBER() within each gender, then filter the ranked result.
-- A subquery is needed because window-function results cannot be
-- filtered with WHERE at the same query level.

WITH age AS (

    SELECT

        first_name,

        gender,

        country_of_birth,

        AGE(NOW(), birth_date) AS person_age

    FROM person

)

SELECT * FROM

(SELECT first_name, gender, person_age,

ROW_NUMBER() OVER (PARTITION BY gender ORDER BY person_age DESC) AS senior_rank

FROM age)

WHERE senior_rank <= 3;


-- JSONB
--======================================================================================

-- ->                 Access JSON/JSONB
-- ->>                Access as text
-- jsonb_array_elements_text()
                --    Expand JSON array
-- DISTINCT           Remove duplicates
-- @>                 Contains
-- ?                  Contains key/element


CREATE TABLE emp (
    emp_id int NOT NULL,
    data jsonb
);

INSERT INTO emp VALUES
(1, '{"name": "John", "hobbies": ["Movies", "Football", "Hiking"] }');

INSERT INTO emp VALUES
(2, '{"name": "Marc", "hobbies": ["Gaming", "Movies", "Music"] }');

SELECT * FROM emp;

SELECT data FROM emp;

-- access any attribute inside json
SELECT data -> 'name' FROM emp;

-- -> returns the JSON/JSONB value
SELECT data -> 'name' FROM emp;

-- ->> returns the JSON value as text
SELECT data ->> 'name' FROM emp;

-- with column name
SELECT data -> 'name' AS name FROM emp;

SELECT data -> 'hobbies' AS hobbies FROM emp;

-- access all columns using json attribute as filter
SELECT * FROM emp WHERE data -> 'name' = '"Marc"';

SELECT * FROM emp WHERE data ->> 'name' = 'Marc';

-- access attributes inside json using json attribute as filter
SELECT data -> 'hobbies' FROM emp WHERE data -> 'name' = '"Marc"';


-- expand array elements into separate rows in a column
SELECT jsonb_array_elements_text(data -> 'hobbies') AS hobbies FROM emp; 

-- get distinct hobbies
SELECT DISTINCT jsonb_array_elements_text(data -> 'hobbies') AS hobbies FROM emp; 

-- add emp id
SELECT emp_id, jsonb_array_elements_text(data -> 'hobbies') AS hobbies FROM emp;

-- select all records of employees having hobby as gaming
-- @> checks for containment, e.g where hobbies contain gaming
SELECT * FROM emp WHERE data -> 'hobbies' @> '["Gaming"]' :: jsonb;
SELECT * FROM emp WHERE data -> 'hobbies' @> '["Movies"]' :: jsonb;

-- ? checks whether a JSONB object contains a key
-- data ? 'hobbies' : Does the JSONB object have a "hobbies" key?
SELECT *
FROM emp
WHERE data ? 'hobbies';

-- You could also use it with an array:
SELECT *
FROM emp
WHERE data -> 'hobbies' ? 'Gaming';

DROP TABLE emp;



-- PGVECTOR
--======================================================================================

-- PostgreSQL extension for storing and searching
-- vector/embedding data.

-- DISTANCE / SIMILARITY MEASURES

-- Cosine: 
-- Measures the angle/direction between vectors.
-- Smaller cosine distance = more similar.
-- vector_cosine_ops

-- L1 (Manhattan)/Taxicab distance:
-- Sum of absolute differences between vector values.
-- Smaller distance = more similar.
-- vector_l1_ops

-- L2 (Euclidean):
-- Straight-line distance between vectors in vector space.
-- Smaller distance = more similar.
-- vector_l2_ops

-- Inner Product:
-- Measures the dot product/alignment between vectors.
-- Larger inner product = more similar.
-- pgvector operator: <#> (negative inner product)
-- pgvector returns negative inner product because it by default order by ASC
-- ORDER BY something ASC, which means smaller = better.
-- vector_ip_ops

-- Index / Operator

-- Cosine          - <=>
-- L1              - <+>
-- L2              - <->
-- Inner Product   - <#>

-- VECTOR SEARCH INDEXES

-- HNSW:
-- Graph-based index that provides fast approximate
-- nearest-neighbor search with high recall.
-- Generally preferred for high-quality vector search.

-- HNSW parameters

-- m:
-- Controls the maximum number of connections a node can have
-- to neighboring nodes in each graph layer.
-- Default is 16.
-- Higher m → richer graph, potentially better recall, but more memory/build cost.

-- ef_construction:
-- Size of the candidate list considered while building the graph.
-- Default is 64.
-- Higher value → higher-quality graph, but slower index construction.

-- ef_search:
-- Size of the candidate list considered during a search.
-- Set at query/session time.
-- Higher value → better recall, but slower search.

-- HNSW:
-- Does not need to train/cluster the data before index creation.
-- Therefore, an HNSW index can be created on an empty table.

-- IVFFlat:
-- Partitions vectors into clusters/lists and searches
-- selected clusters instead of the entire dataset.
-- Faster search with less indexing cost, but generally
-- lower recall than HNSW.
-- Lists
-- WITH(lists=N) at build time sets the number of clusters/lists
-- Probes
-- SET ivfflat.probes raises how many lists/clusters each query searches

-- StreamingDiskANN:
-- An approximate nearest-neighbor (ANN) vector search index.
-- Designed for large and continuously changing vector datasets.
-- Uses a graph-based approach and is optimized for efficient disk/SSD-based search.
-- Trades some recall for faster search at scale.

-- Default / exact vector search:
-- No vector index is used.
-- PostgreSQL compares the query vector against the vectors
-- in the table and finds the true nearest neighbors.
-- This provides exact nearest-neighbor search, but can become
-- expensive as the number of vectors grows.
-- This is exact nearest-neighbor search.

-- Keyword search:
-- Searches the actual text for matching terms/words.
-- PostgreSQL full-text search is commonly combined with a GIN index.
-- GIN is an index type.
-- It is commonly used for:
--   • PostgreSQL full-text search
--   • JSONB
--   • Arrays
--
-- For vector search, pgvector uses specialized vector indexes
-- such as HNSW and IVFFlat instead.

-- ASIDE:
-- Recall here means:
-- How many of the truly relevant/nearest vectors did the search successfully find?
-- Suppose the exact search says there are 10 nearest vectors
-- And approx index returns 7 then recall = 7 / 10 
-- Lower recall means the search is missing more of the vectors that should have been in the top results


--  VECTOR & AI EXTENSIONS:

-- pgvector
CREATE EXTENSION IF NOT EXISTS vector;

-- -- pgvector/pgai ecosystem extension for additional vector capabilities
-- CREATE EXTENSION IF NOT EXISTS vectorscale;


-- Create a table of quotes
create table quotes(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    quote TEXT,
    person TEXT,
    embedding VECTOR(1536) -- the vector data type is from the pgvector extension
);

-- ivff 

-- Build the vector index on embedding column using cosine distance.
CREATE INDEX ON quotes
USING ivfflat (embedding vector_cosine_ops)
WITH (lists = 3); 

-- how many cluster to be searched at query time
SET ivfflat.probes = 2; 

-- HNSW

-- Build the HNSW vector index on the embedding column using cosine distance.

CREATE INDEX ON quotes
USING hnsw (embedding vector_cosine_ops)
WITH (
    m = 16,
    ef_construction = 64
);

-- Number of candidates explored during search.
-- Higher value → better recall but slower search.

SET hnsw.ef_search = 64;

create table summaries(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    summary TEXT,
    question TEXT
);


-- Sample data quotes about US cities from histrical figures
insert into quotes (quote, person) values
  ('I love New York, even though it isn''t mine, the way something has to be, a tree or a street or a house, something, anyway, that belongs to me because I belong to it.', 'Truman Capote'),
  ('I would give the greatest sunset in the world for one sight of New York''s skyline.', 'Ayn Rand'),
  ('In Boston they ask, how much does he know? In New York, how much is he worth? In Philadelphia, who were his parents?', 'Mark Twain'),
  ('Los Angeles is 72 suburbs in search of a city.', 'Dorothy Parker'),
  ('What you see in Chicago is the triumph of the American middle class.', 'Norman Mailer'),
  ('Eventually, I think Chicago will be the most beautiful great city left in the world.', 'Frank Lloyd Wright'),
  ('San Francisco is a city where people are never more abroad than when they are at home.', 'Benjamin F. Taylor'),
  ('Washington is a city of Southern efficiency and Northern charm.', 'John F. Kennedy');


-- ARCHITECTURE

-- Embedding model:
-- Converts text/data into numerical vectors.

-- pgvector:
-- Stores vectors and provides vector similarity search,
-- distance operators, and vector indexes.

-- PostgreSQL:
-- Stores the application data and metadata alongside vectors.

-- Application:
-- Calls the embedding model and sends the resulting vector
-- to PostgreSQL for similarity search.

-- Typical application flow:
-- Application → Embedding model → PostgreSQL + pgvector
--                              → similarity search
--                              → top-K results


-- GIN INDEX
--======================================================================================

-- GIN (Generalized Inverted Index) is commonly used for
-- efficiently searching within multiple values contained
-- in a row, such as arrays, JSONB, and full-text search.

-- Things to remember:

-- ||                → concatenate strings

-- to_tsvector()     → convert text into searchable terms

-- plainto_tsquery() → convert user's search text into a search query

-- @@                → test whether tsvector matches tsquery

-- GIN               → efficiently index/search that representation

--'english'          → which text-search language configuration/rules to use

-- Expression Index:
-- PostgreSQL can create an index on the result of an expression,
-- rather than directly on a column.
-- by combining columns first_name and last_name

-- Example: full-text search
CREATE INDEX person_search_idx
ON person
USING GIN (to_tsvector('english', first_name || ' ' || last_name));

-- Search for matching words
SELECT *
FROM person
WHERE to_tsvector('english', first_name || ' ' || last_name)
      @@ plainto_tsquery('english', 'John Doe');



-- INVERTED INDEX
--======================================================================================

-- An inverted index maps each searchable term/token
-- to the rows/documents where it appears.

-- Instead of:
-- document → words

-- It stores:
-- word/token → documents/rows

-- Example:
-- PostgreSQL → row 1, row 3
-- database   → row 1, row 2
-- Python     → row 2, row 3

-- This allows PostgreSQL to quickly find matching rows
-- without scanning every document.

-- GIN (Generalized Inverted Index) is PostgreSQL's
-- implementation of an inverted-index structure.

-- Commonly used for:
-- • Full-text search
-- • JSONB
-- • Arrays


