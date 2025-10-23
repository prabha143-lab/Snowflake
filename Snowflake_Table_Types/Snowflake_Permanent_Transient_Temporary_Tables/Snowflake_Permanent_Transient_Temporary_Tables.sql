Question:
In Snowflake, can you create permanent, transient, and 
temporary tables with the same name in the same schema and database?

Answer:
You can create permanent and temporary tables with the same name in Snowflake, 
but not permanent and transient tables with the same name in the same schema.

DROP TABLE MYSNOW.PUBLIC.sample_table;

-- Create permanent table
CREATE OR REPLACE TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);

-- Insert 3 records
INSERT INTO MYSNOW.PUBLIC.sample_table (id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

-- Create Transient table
CREATE TRANSIENT TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);--Object 'MYSNOW.PUBLIC.SAMPLE_TABLE' already exists.


-- Create temporary table
CREATE TEMPORARY TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);--Table SAMPLE_TABLE successfully created.


SELECT COUNT(*) FROM MYSNOW.PUBLIC.SAMPLE_TABLE;--Zero records


-- Insert 3 records
INSERT INTO MYSNOW.PUBLIC.SAMPLE_TABLE (id, name) VALUES
(4, 'David'),
(5, 'Eva'),
(6, 'Frank');

SELECT COUNT(*) FROM MYSNOW.PUBLIC.SAMPLE_TABLE;--3 records 

SELECT * FROM MYSNOW.PUBLIC.SAMPLE_TABLE;

ID	NAME
4	David
5	Eva
6	Frank


Why This Happens:
**********************
Even though you used the full name MYSNOW.PUBLIC.sample_table, 
Snowflake’s session resolution rules prioritize temporary tables 
over permanent ones if they share the same name.

✅ Temporary tables "shadow" permanent tables in the same session.

********

How to Access the Permanent Table Again
To access the permanent table:

End your current session (log out or close the worksheet)

Start a new session (temporary table will be gone)

Run:


SELECT * FROM MYSNOW.PUBLIC.SAMPLE_TABLE;

ID	NAME
1	Alice
2	Bob
3	Charlie


*******************************************************************************
Next scenario

Question:
In Snowflake, can you create transient, and 
temporary tables with the same name in the same schema and database?

Answer:
You can create transient and temporary tables with the same name in Snowflake



DROP TABLE MYSNOW.PUBLIC.sample_table;

-- Create Transient table
CREATE TRANSIENT TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);

INSERT INTO MYSNOW.PUBLIC.sample_table (id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

-- Create temporary table
CREATE TEMPORARY TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);

-- Insert 3 records
INSERT INTO MYSNOW.PUBLIC.SAMPLE_TABLE (id, name) VALUES
(4, 'David'),
(5, 'Eva'),
(6, 'Frank');

SELECT COUNT(*) FROM MYSNOW.PUBLIC.SAMPLE_TABLE;--3 records 

SELECT * FROM MYSNOW.PUBLIC.SAMPLE_TABLE;

ID	NAME
4	David
5	Eva
6	Frank


Why This Happens
Even though you used the full name MYSNOW.PUBLIC.sample_table, 
Snowflake’s session resolution rules prioritize temporary tables
over transient ones if they share the same name.

✅ Temporary tables "shadow" transient tables in the same session.


*******
How to Access the Transient Table Again
To access the Transient table:

End your current session (log out or close the worksheet)

Start a new session (temporary table will be gone)

Run:


SELECT * FROM MYSNOW.PUBLIC.SAMPLE_TABLE;

ID	NAME
4	David
5	Eva
6	Frank


-----------------------------------------------------
Next Scenario:

Question:
In Snowflake, I have created a temporary table with a certain name. 
Can I create a permanent table with the same name in the same schema and database?

Answer:
Yes

DROP TABLE MYSNOW.PUBLIC.sample_table;

SELECT *FROM MYSNOW.PUBLIC.sample_table;

-- Create Temporary table
CREATE OR REPLACE TEMPORARY TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);

-- Insert 3 records
INSERT INTO MYSNOW.PUBLIC.sample_table (id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

SELECT *FROM MYSNOW.PUBLIC.sample_table;

ID	NAME
1	Alice
2	Bob
3	Charlie

-- Create Permanent table
CREATE TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);--Table SAMPLE_TABLE successfully created.


SELECT COUNT(*) FROM MYSNOW.PUBLIC.SAMPLE_TABLE;--Zero records

SELECT *FROM MYSNOW.PUBLIC.sample_table;

ID	NAME
1	Alice
2	Bob
3	Charlie

-- Insert 3 records
INSERT INTO MYSNOW.PUBLIC.SAMPLE_TABLE (id, name) VALUES
(4, 'David'),
(5, 'Eva'),
(6, 'Frank');


SELECT *FROM MYSNOW.PUBLIC.sample_table;

ID	NAME
1	Alice
2	Bob
3	Charlie
4	David
5	Eva
6	Frank


How to See the Permanent Tables Records
To access the permanent table:

End your current session (log out or close the worksheet)

Start a new session (temporary table will no longer exist)

SELECT COUNT(*) FROM MYSNOW.PUBLIC.SAMPLE_TABLE;--Zero records

SELECT *FROM MYSNOW.PUBLIC.sample_table;

***********************************************************


Next Scenario:

Question:
In Snowflake, I have created a temporary table with a certain name. 
Can I create a TRANSIENT table with the same name in the same schema and database?

Answer:
Yes

DROP TABLE MYSNOW.PUBLIC.sample_table;

SELECT *FROM MYSNOW.PUBLIC.sample_table;

-- Create Temporary table
CREATE TEMPORARY TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);

-- Insert 3 records
INSERT INTO MYSNOW.PUBLIC.sample_table (id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

SELECT *FROM MYSNOW.PUBLIC.sample_table;

ID	NAME
1	Alice
2	Bob
3	Charlie

-- Create TRANSIENT table
CREATE TRANSIENT TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);--Table SAMPLE_TABLE successfully created.

-- Insert 3 records
INSERT INTO MYSNOW.PUBLIC.SAMPLE_TABLE (id, name) VALUES
(4, 'David'),
(5, 'Eva'),
(6, 'Frank');

SELECT *FROM MYSNOW.PUBLIC.sample_table;

ID	NAME
1	Alice
2	Bob
3	Charlie
4	David
5	Eva
6	Frank


*************************************************************************
Next scenario


-- Drop any existing table
DROP TABLE MYSNOW.PUBLIC.sample_table;

-- Create permanent table
CREATE OR REPLACE TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);


CREATE TRANSIENT TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);--Object 'MYSNOW.PUBLIC.SAMPLE_TABLE' already exists.


CREATE TEMPORARY TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
);--Table SAMPLE_TABLE successfully created.

CREATE ICEBERG TABLE MYSNOW.PUBLIC.sample_table (
    id INT,
    name STRING
)
CATALOG = 'my_catalog'
EXTERNAL_VOLUME = 'my_volume';--Object 'SAMPLE_TABLE' already exists as TABLE

CREATE OR REPLACE DYNAMIC TABLE MYSNOW.PUBLIC.sample_table
TARGET_LAG = '1 minute'
AS
SELECT id, name FROM source_table;--Object 'SAMPLE_TABLE' already exists as TABLE


In Snowflake:

Permanent, transient, dynamic, and Iceberg tables are all schema-level objects.

That means they cannot share the same name (sample_table) 
within the same schema (MYSNOW.PUBLIC) at the same time.

Temporary tables, however, are session-scoped and do not live 
in the schema—so they can share the same name.


*********************************************************

Another scenario


Question: 

In Snowflake, you first create a transient schema 
and then create a permanent table within it. 
However, because the schema is transient, the table 
inherits that property and becomes transient by default.
 
After inserting data into this table, you later 
create a temporary table with the same name and insert different data. 
When you query the table using its fully qualified name, 
Snowflake returns only the data from the temporary table. 

Answer: 
This happens because temporary tables take precedence 
over transient or permanent tables with the same name within the same session.

Answer:
Snowflake shows only the temporary tables data because 
temporary tables take priority over transient or permanent tables
with the same name in your session—even when using the full schema path. 
To access the transient table, you must drop the temporary one first.

CREATE OR REPLACE TRANSIENT SCHEMA MYSNOW.MY_TRANSIENT_SCHEMA;

DROP TABLE MYSNOW.MY_TRANSIENT_SCHEMA.sample_table;

CREATE TABLE MYSNOW.MY_TRANSIENT_SCHEMA.sample_table (
    id INT,
    name STRING
);

---Below TRANSIENT table created  
create or replace TRANSIENT TABLE MYSNOW.MY_TRANSIENT_SCHEMA.SAMPLE_TABLE (
	ID NUMBER(38,0),
	NAME VARCHAR(16777216)
    );

INSERT INTO MYSNOW.MY_TRANSIENT_SCHEMA.SAMPLE_TABLE (id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');--number of rows inserted 3

SELECT *FROM MYSNOW.MY_TRANSIENT_SCHEMA.SAMPLE_TABLE;

ID	NAME
1	Alice
2	Bob
3	Charlie

CREATE TEMPORARY TABLE MYSNOW.MY_TRANSIENT_SCHEMA.sample_table (
    id INT,
    name STRING
);--Table SAMPLE_TABLE successfully created.



INSERT INTO MYSNOW.MY_TRANSIENT_SCHEMA.sample_table (id, name) VALUES
(4, 'David'),
(5, 'Eva'),
(6, 'Frank');--number of rows inserted 3

SELECT *FROM MYSNOW.MY_TRANSIENT_SCHEMA.SAMPLE_TABLE;--

ID	NAME
4	David
5	Eva
6	Frank

************************************************************************
Another Scenario

In Snowflake, you first create a transient schema and 
then create a permanent table within it. 

However, because the schema is transient, the table
inherits that property and becomes transient by default. 
After inserting data into this table, you attempt to 
create another table using CREATE TABLE with the same name. 
Snowflake returns an error stating that the object already exists. 

Explain why this error occurs, even though 
the new statement is intended to create a permanent table.

DROP  SCHEMA MYSNOW.MY_TRANSIENT_SCHEMA;

CREATE OR REPLACE TRANSIENT SCHEMA MYSNOW.MY_TRANSIENT_SCHEMA;

DROP TABLE MYSNOW.MY_TRANSIENT_SCHEMA.sample_table;

CREATE TABLE MYSNOW.MY_TRANSIENT_SCHEMA.sample_table (
    id INT,
    name STRING
);--Table SAMPLE_TABLE successfully created.

SELECT TABLE_CATALOG,TABLE_SCHEMA,TABLE_NAME,TABLE_TYPE,
IS_TRANSIENT,IS_TEMPORARY FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME='SAMPLE_TABLE'
AND TABLE_SCHEMA='MY_TRANSIENT_SCHEMA';

TABLE_CATALOG	TABLE_SCHEMA	TABLE_NAME	TABLE_TYPE	IS_TRANSIENT IS_TEMPORARY

MYSNOW	MY_TRANSIENT_SCHEMA	SAMPLE_TABLE	BASE TABLE	YES   NO

---Below TRANSIENT table created  
create or replace TRANSIENT TABLE MYSNOW.MY_TRANSIENT_SCHEMA.SAMPLE_TABLE (
	ID NUMBER(38,0),
	NAME VARCHAR(16777216)
    );

INSERT INTO MYSNOW.MY_TRANSIENT_SCHEMA.SAMPLE_TABLE (id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');--number of rows inserted 3

SELECT *FROM MYSNOW.MY_TRANSIENT_SCHEMA.SAMPLE_TABLE;

ID	NAME
1	Alice
2	Bob
3	Charlie

CREATE TABLE MYSNOW.MY_TRANSIENT_SCHEMA.sample_table (
    id INT,
    name STRING
);--Object 'MYSNOW.MY_TRANSIENT_SCHEMA.SAMPLE_TABLE' already exists.



**************************************************************************************


CREATE OR REPLACE TRANSIENT TABLE staging_transactions (
    transaction_id STRING,
    account_number STRING,
    amount NUMBER(10,2),
    currency STRING,
    transaction_date DATE
);


CREATE OR REPLACE STREAM staging_transactions_stream
ON TABLE staging_transactions
APPEND_ONLY = TRUE;  -- Set to TRUE if you only want INSERTs

--Stream STAGING_TRANSACTIONS_STREAM successfully created.



CREATE OR REPLACE TEMPORARY TABLE staging_transactions (
    transaction_id STRING,
    account_number STRING,
    amount NUMBER(10,2),
    currency STRING,
    transaction_date DATE
);


CREATE OR REPLACE STREAM staging_transactions_stream
ON TABLE staging_transactions
APPEND_ONLY = TRUE;  -- Set to TRUE if you only want INSERTs

--Stream STAGING_TRANSACTIONS_STREAM successfully created.