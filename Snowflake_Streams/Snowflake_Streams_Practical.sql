CREATE OR REPLACE TABLE source_customers (
  customer_id INT,
  name STRING,
  email STRING,
  last_updated TIMESTAMP
);

INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES
  (101, 'Alice', 'alice@example.com', CURRENT_TIMESTAMP),
  (102, 'Bob', 'bob@example.com', CURRENT_TIMESTAMP),
  (103, 'Charlie', 'charlie@example.com', CURRENT_TIMESTAMP);

CREATE OR REPLACE STREAM source_customers_stream ON TABLE source_customers;

CREATE OR REPLACE TABLE target_customers (
  customer_id INT,
  name STRING,
  email STRING,
  last_updated TIMESTAMP
);

SELECT *FROM target_customers;

SELECT * FROM source_customers_stream;

UPDATE source_customers
SET email = 'alice.new@example.com', last_updated = CURRENT_TIMESTAMP
WHERE customer_id = 101;

number of rows updated	number of multi-joined rows updated
1	0

SELECT * FROM source_customers_stream;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
101	Alice	alice.new@example.com	2025-09-14 08:21:13.471	INSERT	TRUE	b72ff4afddaeda2fb3741c6fc6fab2d1f3d22181
101	Alice	alice@example.com	2025-09-14 08:20:06.107	DELETE	TRUE	b72ff4afddaeda2fb3741c6fc6fab2d1f3d22181


SELECT * FROM source_customers;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED
101	Alice	alice.new@example.com	2025-09-14 08:21:13.471
102	Bob	bob@example.com	2025-09-14 08:20:06.107
103	Charlie	charlie@example.com	2025-09-14 08:20:06.107

-- Insert a new record
INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES (104, 'David', 'david@example.com', CURRENT_TIMESTAMP);

number of rows inserted
1


SELECT * FROM source_customers_stream;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
101	Alice	alice.new@example.com	2025-09-14 08:21:13.471	INSERT	TRUE	b72ff4afddaeda2fb3741c6fc6fab2d1f3d22181
104	David	david@example.com	2025-09-14 08:23:44.213	INSERT	FALSE	5c9cab151462e8f5d318722541d0e9b590e1c282
101	Alice	alice@example.com	2025-09-14 08:20:06.107	DELETE	TRUE	b72ff4afddaeda2fb3741c6fc6fab2d1f3d22181


INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES (104, 'David', 'david@example.com', CURRENT_TIMESTAMP);

number of rows inserted
1


SELECT * FROM source_customers_stream;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
101	Alice	alice.new@example.com	2025-09-14 08:21:13.471	INSERT	TRUE	b72ff4afddaeda2fb3741c6fc6fab2d1f3d22181
104	David	david@example.com	2025-09-14 08:23:44.213	INSERT	FALSE	5c9cab151462e8f5d318722541d0e9b590e1c282
104	David	david@example.com	2025-09-14 08:27:23.417	INSERT	FALSE	dd1aab62108ab9bb05aa621df58635d116a0d05c
101	Alice	alice@example.com	2025-09-14 08:20:06.107	DELETE	TRUE	b72ff4afddaeda2fb3741c6fc6fab2d1f3d22181


Why You are Seeing Duplicate Records in the Stream
Snowflake Streams track changes (inserts, updates, deletes) to a table at the row level, not at the primary key level. 

This means:

If you insert the same customer_id twice (like David with ID 104), 
Snowflake treats each insert as a distinct change, even if the data is identical.

The stream doesn’t deduplicate based on business logic or primary key — 
it simply logs every change that modifies the table.


*************************************************


CREATE OR REPLACE TABLE source_customers (
  customer_id INT,
  name STRING,
  email STRING,
  last_updated TIMESTAMP
);

INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES
  (101, 'Alice', 'alice@example.com', CURRENT_TIMESTAMP),
  (102, 'Bob', 'bob@example.com', CURRENT_TIMESTAMP),
  (103, 'Charlie', 'charlie@example.com', CURRENT_TIMESTAMP);

CREATE OR REPLACE STREAM source_customers_stream ON TABLE source_customers APPEND_ONLY = FALSE;

SELECT *FROM source_customers_stream;--Zero records


UPDATE source_customers
SET email = 'alice.new@example.com', last_updated = CURRENT_TIMESTAMP
WHERE customer_id = 101;

number of rows updated	number of multi-joined rows updated
1	0


SELECT *FROM source_customers_stream;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
101	Alice	alice.new@example.com	2025-09-14 08:37:31.135	INSERT	TRUE	88a2b6a4d93580ec740eb7c3869d54867f750cd9
101	Alice	alice@example.com	2025-09-14 08:36:09.881	DELETE	TRUE	88a2b6a4d93580ec740eb7c3869d54867f750cd9

SELECT *FROM source_customers;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED
101	Alice	alice.new@example.com	2025-09-14 08:37:31.135
102	Bob	bob@example.com	2025-09-14 08:36:09.881
103	Charlie	charlie@example.com	2025-09-14 08:36:09.881

-- Insert a new record
INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES (104, 'David', 'david@example.com', CURRENT_TIMESTAMP);

number of rows inserted
1


SELECT *FROM source_customers_stream;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
101	Alice	alice.new@example.com	2025-09-14 08:37:31.135	INSERT	TRUE	88a2b6a4d93580ec740eb7c3869d54867f750cd9
104	David	david@example.com	2025-09-14 08:39:32.590	INSERT	FALSE	fbb90b09f44699280e704fa648a119ab596c3187
101	Alice	alice@example.com	2025-09-14 08:36:09.881	DELETE	TRUE	88a2b6a4d93580ec740eb7c3869d54867f750cd9


SELECT *FROM source_customers;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED
101	Alice	alice.new@example.com	2025-09-14 08:37:31.135
102	Bob	bob@example.com	2025-09-14 08:36:09.881
103	Charlie	charlie@example.com	2025-09-14 08:36:09.881
104	David	david@example.com	2025-09-14 08:39:32.590


DELETE FROM source_customers WHERE CUSTOMER_ID=101;

number of rows deleted
1

SELECT *FROM source_customers_stream;

--Previous records 
CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
101	Alice	alice.new@example.com	2025-09-14 08:37:31.135	INSERT	TRUE	88a2b6a4d93580ec740eb7c3869d54867f750cd9
104	David	david@example.com	2025-09-14 08:39:32.590	INSERT	FALSE	fbb90b09f44699280e704fa648a119ab596c3187
101	Alice	alice@example.com	2025-09-14 08:36:09.881	DELETE	TRUE	88a2b6a4d93580ec740eb7c3869d54867f750cd9

--After DELETE 
CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
104	David	david@example.com	2025-09-14 08:39:32.590	INSERT	FALSE	fbb90b09f44699280e704fa648a119ab596c3187
101	Alice	alice@example.com	2025-09-14 08:36:09.881	DELETE	FALSE	88a2b6a4d93580ec740eb7c3869d54867f750cd9


DELETE FROM source_customers WHERE CUSTOMER_ID=104;

number of rows deleted
1


SELECT *FROM source_customers_stream;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
101	Alice	alice@example.com	2025-09-14 08:36:09.881	DELETE	FALSE	88a2b6a4d93580ec740eb7c3869d54867f750cd9

*****************************************************************

CREATE OR REPLACE TABLE source_customers (
  customer_id INT,
  name STRING,
  email STRING,
  last_updated TIMESTAMP
);

INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES
  (101, 'Alice', 'alice@example.com', CURRENT_TIMESTAMP),
  (102, 'Bob', 'bob@example.com', CURRENT_TIMESTAMP),
  (103, 'Charlie', 'charlie@example.com', CURRENT_TIMESTAMP);

CREATE OR REPLACE STREAM source_customers_stream ON TABLE source_customers APPEND_ONLY = TRUE;

SELECT *FROM source_customers_stream;--No records

UPDATE source_customers
SET email = 'alice.new@example.com', last_updated = CURRENT_TIMESTAMP
WHERE customer_id = 101;

number of rows updated	number of multi-joined rows updated
1	0


SELECT *FROM source_customers_stream;--Zero records


SELECT *FROM source_customers;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED
101	Alice	alice.new@example.com	2025-09-14 08:47:40.906
102	Bob	bob@example.com	2025-09-14 08:46:53.560
103	Charlie	charlie@example.com	2025-09-14 08:46:53.560



-- Insert a new record
INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES (104, 'David', 'david@example.com', CURRENT_TIMESTAMP);

number of rows inserted
1

SELECT *FROM source_customers_stream;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
104	David	david@example.com	2025-09-14 08:49:08.653	INSERT	FALSE	ee5645298e421da6e4cf6a6bae3ddb555aa95cc2


SELECT *FROM source_customers;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED
101	Alice	alice.new@example.com	2025-09-14 08:47:40.906
102	Bob	bob@example.com	2025-09-14 08:46:53.560
103	Charlie	charlie@example.com	2025-09-14 08:46:53.560
104	David	david@example.com	2025-09-14 08:49:08.653

DELETE FROM source_customers WHERE CUSTOMER_ID=104;

SELECT *FROM source_customers_stream;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
104	David	david@example.com	2025-09-14 08:49:08.653	INSERT	FALSE	ee5645298e421da6e4cf6a6bae3ddb555aa95cc2

--APPEND_ONLY = FALSE equals to Standard stream

--APPEND_ONLY = TRUE means it will capture only INSERT records


Why You're Seeing This Error
You're trying to create an INSERT_ONLY stream on a standard internal table (source_customers). But Snowflake now restricts INSERT_ONLY = TRUE to:

External tables (e.g., S3-backed)

Iceberg tables with external catalog integration

This change was introduced to ensure consistency with how external data sources are tracked — internal tables already support APPEND_ONLY = TRUE, which is the correct alternative.



***************************************************************************************************

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