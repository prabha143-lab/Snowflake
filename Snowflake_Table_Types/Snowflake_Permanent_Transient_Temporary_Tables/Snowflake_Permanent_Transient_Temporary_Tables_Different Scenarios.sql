Scenario 1:
*************************************************************************************

-- Question:
-- In Snowflake, can you create permanent, transient, and 
-- temporary tables with the same name in the same schema and database?

-- Answer:
-- You can create permanent and temporary tables with the same name in Snowflake, 
-- but not permanent and transient tables with the same name in the same schema.

-- ❌ Drop any existing table named 'sample_table' in MYSNOW.PUBLIC to start fresh
DROP TABLE MYSNOW.PUBLIC.sample_table;

-- ✅ Create permanent table
-- Permanent tables persist across sessions and retain data until explicitly dropped
CREATE OR REPLACE TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);

-- ✅ Insert 3 records into the permanent table
-- These rows will remain until deleted
INSERT INTO MYSNOW.PUBLIC.sample_table (id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

-- ❌ Attempt to create a transient table with the same name
-- This fails because a permanent table with the same name already exists in the same schema
CREATE TRANSIENT TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);--Object 'MYSNOW.PUBLIC.SAMPLE_TABLE' already exists.

-- ✅ Create temporary table
-- Temporary tables are session-scoped and can coexist with permanent tables of the same name
-- They "shadow" permanent tables during the session
CREATE TEMPORARY TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);--Table SAMPLE_TABLE successfully created.

-- 🔍 Query the table — resolves to the temporary version due to session precedence
-- Since it's newly created, it returns 0 records
SELECT COUNT(*) FROM MYSNOW.PUBLIC.SAMPLE_TABLE;--Zero records

-- ✅ Insert 3 records into the temporary table
-- These records are session-specific and will disappear after the session ends
INSERT INTO MYSNOW.PUBLIC.SAMPLE_TABLE (id, name) VALUES
(4, 'David'),
(5, 'Eva'),
(6, 'Frank');

-- 🔍 Query again — now returns 3 records from the temporary table
SELECT COUNT(*) FROM MYSNOW.PUBLIC.SAMPLE_TABLE;--3 records 

-- 📊 Display all rows from the temporary table
-- Note: The permanent table's data is hidden during this session
SELECT * FROM MYSNOW.PUBLIC.SAMPLE_TABLE;

-- Output:
-- ID   NAME
-- 4    David
-- 5    Eva
-- 6    Frank

-- Why This Happens:
-- **********************
-- Even though you used the "Fully Qualified Name" MYSNOW.PUBLIC.sample_table, 
-- Snowflake’s session resolution rules prioritize temporary tables 
-- over permanent ones if they share the same name.
-- ✅ Temporary tables "shadow" permanent tables in the same session — this is by design.

-- How to Access the Permanent Table Again:
-- To access the permanent table:

-- ❌ End your current session (log out or close the worksheet)
-- ✅ Start a new session (temporary table will be gone)

-- 🧾 Run:
SELECT * FROM MYSNOW.PUBLIC.SAMPLE_TABLE;

-- Output:
-- ID   NAME
-- 1    Alice
-- 2    Bob
-- 3    Charlie


***************************************************************************************

Scenario 2:


-- Case 1: TEMPORARY → PERMANENT → INSERT → SESSION CLOSE
-- *******************************************************

-- ❌ Drop any existing table named 'sample_table' in the schema
-- This removes any permanent/transient version of the table from MYSNOW.PUBLIC
DROP TABLE MYSNOW.PUBLIC.sample_table;

-- ✅ Create a TEMPORARY table
-- Temporary tables are session-scoped and shadow permanent/transient tables with the same name
-- They are not stored in the schema and are automatically dropped when the session ends
CREATE TEMPORARY TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);

-- ✅ Insert 3 records into the temporary table
-- These records are stored only for the duration of the session
INSERT INTO MYSNOW.PUBLIC.sample_table (id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

-- 🔍 Query the temporary table — returns 3 records
SELECT * FROM MYSNOW.PUBLIC.sample_table;

-- Output:
-- ID   NAME
-- 1    Alice
-- 2    Bob
-- 3    Charlie

-- ✅ Create a PERMANENT table with the same name
-- This is allowed because temporary tables are session-local
-- However, the temporary table still takes precedence in this session
CREATE TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);--Table SAMPLE_TABLE successfully created.

-- ✅ Recreate the TEMPORARY table again (overwriting the previous one)
-- This confirms that the session is still working with a temporary version
create or replace TEMPORARY TABLE SAMPLE_TABLE (
    ID NUMBER(38,0),
    NAME VARCHAR(16777216)
);

-- 🔍 Query resolves to the temporary table — still shows 3 records
-- Even though a permanent table exists, Snowflake uses the temporary one in this session
SELECT COUNT(*) FROM MYSNOW.PUBLIC.SAMPLE_TABLE;--3 records

-- ✅ Insert 3 more records — still going into the temporary table
-- These are not stored in the permanent table
INSERT INTO MYSNOW.PUBLIC.sample_table (id, name) VALUES
(4, 'Alice'),
(5, 'Bob'),
(6, 'Charlie');

-- 🔍 Query again — now returns 6 records (all in the temporary table)
SELECT COUNT(*) FROM MYSNOW.PUBLIC.SAMPLE_TABLE;--6 records

-- ✅ Commit is issued — but has no effect on temporary tables
-- Temporary tables auto-commit by default
commit;

-- 📊 View all rows — still from the temporary table
SELECT * FROM MYSNOW.PUBLIC.sample_table;

-- Output:
-- ID   NAME
-- 1    Alice
-- 2    Bob
-- 3    Charlie
-- 4    Alice
-- 5    Bob
-- 6    Charlie

-- ❌ Attempt to create a TRANSIENT table with the same name
-- Fails because a permanent table with the same name already exists in the schema
CREATE TRANSIENT TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);--SQL compilation error: Object 'MYSNOW.PUBLIC.SAMPLE_TABLE' already exists.

-- 🔄 After closing the session and reconnecting:
-- ❌ Temporary table is gone (session-scoped)
-- ✅ Permanent table exists, but it was never used in the session
-- All inserts went into the temporary table, not the permanent one
-- Therefore, the permanent table is empty
SELECT COUNT(*) FROM MYSNOW.PUBLIC.SAMPLE_TABLE;--Zero records

-- 🔍 Check which version of the table exists now
-- This confirms that only the permanent table remains after session close
SHOW TABLES LIKE 'sample_table' IN SCHEMA MYSNOW.PUBLIC;

-- ✅ Recreate the permanent table explicitly
-- This overwrites the existing permanent table and resets its structure
create or replace TABLE SAMPLE_TABLE (
    ID NUMBER(38,0),
    NAME VARCHAR(16777216)
);


*************************************************************************************************

Scenario 3:


-- Case 2: TEMPORARY → TRANSIENT → INSERT → SESSION CLOSE
-- *******************************************************

-- ❌ Drop any existing table named 'sample_table' in the schema
-- This removes any permanent or transient version of the table from MYSNOW.PUBLIC
DROP TABLE MYSNOW.PUBLIC.sample_table;

-- ✅ Create a TEMPORARY table
-- Temporary tables are session-scoped and automatically deleted when the session ends
-- They shadow permanent and transient tables with the same name during the session
CREATE TEMPORARY TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);

-- ✅ Insert 3 records into the temporary table
-- These records are stored only for the duration of the session
INSERT INTO MYSNOW.PUBLIC.sample_table (id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

-- 🔍 Query the temporary table — returns 3 records
SELECT * FROM MYSNOW.PUBLIC.sample_table;

-- Output:
-- ID   NAME
-- 1    Alice
-- 2    Bob
-- 3    Charlie

-- ✅ Create a TRANSIENT table with the same name
-- This is allowed because temporary tables are session-local and do not conflict at schema level
-- However, the temporary table still takes precedence in this session
CREATE TRANSIENT TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);--Table SAMPLE_TABLE successfully created.

-- ✅ Recreate the TEMPORARY table again (overwriting the previous one)
-- This confirms that the session is still working with a temporary version
-- Any future queries will continue to resolve to the temporary table
CREATE OR REPLACE TEMPORARY TABLE SAMPLE_TABLE (
    ID NUMBER(38,0),
    NAME VARCHAR(16777216)
);

-- 🔍 Query resolves to the temporary table — still shows 3 records
-- Even though a transient table exists, Snowflake uses the temporary one in this session
SELECT * FROM MYSNOW.PUBLIC.sample_table;--3 records

-- ✅ Insert 3 more records — still going into the temporary table
-- These are not stored in the transient table
INSERT INTO MYSNOW.PUBLIC.sample_table (id, name) VALUES
(4, 'Alice'),
(5, 'Bob'),
(6, 'Charlie');

-- ✅ Commit is issued — but has no effect on temporary tables
-- Temporary tables auto-commit by default
commit;

-- 📊 View all rows — still from the temporary table
SELECT * FROM MYSNOW.PUBLIC.sample_table;

-- Output:
-- ID   NAME
-- 1    Alice
-- 2    Bob
-- 3    Charlie
-- 4    Alice
-- 5    Bob
-- 6    Charlie

-- ❌ Attempt to create a PERMANENT table with the same name
-- Fails because a transient table with the same name already exists in the schema
CREATE TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);--SQL compilation error: Object 'MYSNOW.PUBLIC.SAMPLE_TABLE' already exists.

-- 🔄 After closing the session and reconnecting:
-- ❌ Temporary table is gone (session-scoped)
-- ✅ Transient table remains, but it was never used in the session
-- All inserts went into the temporary table, not the transient one
-- Therefore, the transient table is empty
SELECT COUNT(*) FROM MYSNOW.PUBLIC.SAMPLE_TABLE;--0 records

-- ✅ Recreate the TRANSIENT table explicitly
-- This overwrites the existing transient table and resets its structure
-- Useful if you want to start fresh after session close
CREATE OR REPLACE TRANSIENT TABLE SAMPLE_TABLE (
    ID NUMBER(38,0),
    NAME VARCHAR(16777216)
);


*************************************************************************************
Scenario 4:


-- ❌ Drop any existing table named 'sample_table' in the schema
-- This removes any permanent or transient version of the table from MYSNOW.PUBLIC
DROP TABLE MYSNOW.PUBLIC.sample_table;

-- ✅ Create a TRANSIENT table
-- Transient tables persist across sessions and are stored in the schema
-- They do not support Fail-safe but do support Time Travel and manual commits
CREATE TRANSIENT TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);

-- ✅ Insert 3 records into the transient table
-- These records are stored in the schema and persist across sessions
INSERT INTO MYSNOW.PUBLIC.sample_table (id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

-- 🔍 Query the transient table — returns 3 records
SELECT * FROM MYSNOW.PUBLIC.sample_table;

-- Output:
-- ID   NAME
-- 1    Alice
-- 2    Bob
-- 3    Charlie

-- ❌ Attempt to create a PERMANENT table with the same name
-- Fails because a transient table with the same name already exists in the schema
CREATE TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);--SQL compilation error: Object 'MYSNOW.PUBLIC.SAMPLE_TABLE' already exists.

-- 🔍 Query still resolves to the transient table — shows 3 records
SELECT * FROM MYSNOW.PUBLIC.sample_table;--3 records

-- ✅ Create a TEMPORARY table with the same name
-- Temporary tables are session-scoped and shadow transient tables during the session
-- From this point onward, all queries will resolve to the temporary table
CREATE TEMPORARY TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);--Table SAMPLE_TABLE successfully created.

-- ✅ Recreate the TEMPORARY table again (overwriting the previous one)
-- This confirms that the session is now working with a fresh temporary table
-- The transient table still exists in the schema, but is shadowed
CREATE OR REPLACE TEMPORARY TABLE SAMPLE_TABLE (
    ID NUMBER(38,0),
    NAME VARCHAR(16777216)
);

-- 🔍 Query resolves to the temporary table — returns 0 records
-- Even though the transient table has 3 records, Snowflake uses the temporary one in this session
SELECT COUNT(*) FROM MYSNOW.PUBLIC.SAMPLE_TABLE;--0 records

-- 🔄 After closing the session and reconnecting:
-- ✅ Temporary table is automatically dropped (session-scoped)
-- ✅ Transient table remains and is now visible again
-- ✅ Query now resolves to the transient table, showing the 3 records inserted earlier
SELECT * FROM MYSNOW.PUBLIC.SAMPLE_TABLE;

-- Output:
-- ID   NAME
-- 1    Alice
-- 2    Bob
-- 3    Charlie


