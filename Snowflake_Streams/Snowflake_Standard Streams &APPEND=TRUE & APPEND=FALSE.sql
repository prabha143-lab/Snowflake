-- Create base table
CREATE OR REPLACE TABLE source_customers (
  customer_id INT,
  name STRING,
  email STRING,
  last_updated TIMESTAMP
);

-- Initial inserts BEFORE stream creation — ❌ not tracked by stream
INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES
  (101, 'Alice', 'alice@example.com', CURRENT_TIMESTAMP),
  (102, 'Bob', 'bob@example.com', CURRENT_TIMESTAMP),
  (103, 'Charlie', 'charlie@example.com', CURRENT_TIMESTAMP);

-- Create stream — ✅ starts tracking changes from this point forward
CREATE OR REPLACE STREAM source_customers_stream ON TABLE source_customers;
--Stream SOURCE_CUSTOMERS_STREAM successfully created.

-- Check stream — returns 0 because no changes occurred after stream creation
SELECT COUNT(*) FROM source_customers_stream;

-- Output:
-- COUNT(*)  
-- 0

-- ❌ Invalid: Cannot create a stream on another stream
CREATE OR REPLACE STREAM source_customers_stream1 ON STREAM source_customers_stream;
-- SQL compilation error: syntax error line 23 at position 53 unexpected 'STREAM'. 
-- syntax error line 1 at position 60 unexpected 'source_customers_stream'.

-- Create view and stream on view — ✅ allowed
CREATE OR REPLACE VIEW vw_active_customers AS
SELECT * FROM source_customers WHERE email IS NOT NULL;
--View VW_ACTIVE_CUSTOMERS successfully created.

CREATE OR REPLACE STREAM vw_active_customers_stream ON VIEW vw_active_customers;
--Stream VW_ACTIVE_CUSTOMERS_STREAM successfully created.

-- Create materialized view — ✅ allowed
CREATE OR REPLACE MATERIALIZED VIEW mv_customers AS
SELECT customer_id, name, email
FROM source_customers
WHERE email IS NOT NULL;
--Materialized view MV_CUSTOMERS successfully created.

-- ❌ Invalid: Cannot create stream on materialized view
CREATE OR REPLACE STREAM mv_customers_stream ON MATERIALIZED VIEW mv_customers;
-- Stream target type "Materialized View" unsupported. 
-- Expected one of the following: 
-- Table, View, External Table, Directory Table, Event Table, Dynamic Table.

-- ✅ Update Alice's email — triggers DELETE + INSERT with ISUPDATE = TRUE
UPDATE source_customers
SET email = 'alice.new@example.com', last_updated = CURRENT_TIMESTAMP
WHERE customer_id = 101;

-- Output:
-- number of rows updated   number of multi-joined rows updated  
-- 1    0

-- ✅ Check current table state
SELECT * FROM source_customers;

-- Output:
-- CUSTOMER_ID  NAME    EMAIL   LAST_UPDATED  
-- 101  Alice   alice.new@example.com   2025-10-15 08:02:28.962  
-- 102  Bob bob@example.com 2025-10-15 07:52:51.380  
-- 103  Charlie charlie@example.com 2025-10-15 07:52:51.380  

-- ✅ Check stream — shows DELETE + INSERT pair for Alice
SELECT * FROM source_customers_stream;

-- Output:
-- CUSTOMER_ID  NAME    EMAIL   LAST_UPDATED                      METADATA$ACTION  METADATA$ISUPDATE   METADATA$ROW_ID  
-- 101  Alice   alice.new@example.com   2025-10-15 08:02:28.962   INSERT           TRUE    93b423a460422eba6612fd96f05626fe8396f1c7  
-- 101  Alice   alice@example.com   2025-10-15 07:52:51.380       DELETE           TRUE    93b423a460422eba6612fd96f05626fe8396f1c7  


Why UPDATE = DELETE + INSERT with ISUPDATE = TRUE
✅ Reason:
Snowflake does not store row-level diffs. Instead, it tracks row-level changes by comparing before and after states.


-- ✅ Insert new customer David — tracked as INSERT with ISUPDATE = FALSE
INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES (104, 'David', 'david@example.com', CURRENT_TIMESTAMP);

-- Output:
-- number of rows inserted  
-- 1

-- ✅ Check stream — shows David's INSERT
SELECT * FROM source_customers_stream;

-- Output:
-- CUSTOMER_ID  NAME    EMAIL   LAST_UPDATED                        METADATA$ACTION METADATA$ISUPDATE   METADATA$ROW_ID  
-- 101  Alice   alice.new@example.com   2025-10-15 08:02:28.962     INSERT  TRUE    93b423a460422eba6612fd96f05626fe8396f1c7  
-- 104  David   david@example.com   2025-10-15 08:05:52.489         INSERT  FALSE   da3a4aa7cfc6637fd34fa534287fdec2693e161f  
-- 101  Alice   alice@example.com   2025-10-15 07:52:51.380         DELETE  TRUE    93b423a460422eba6612fd96f05626fe8396f1c7  

-- ✅ Check current table state
SELECT * FROM source_customers;

-- Output:
-- CUSTOMER_ID  NAME    EMAIL   LAST_UPDATED  
-- 101  Alice   alice.new@example.com   2025-10-15 08:02:28.962  
-- 102  Bob bob@example.com 2025-10-15 07:52:51.380  
-- 103  Charlie charlie@example.com 2025-10-15 07:52:51.380  
-- 104  David   david@example.com   2025-10-15 08:05:52.489  

-- ✅ Insert duplicate David — tracked as separate INSERT with new ROW_ID
INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES (104, 'David', 'david@example.com', CURRENT_TIMESTAMP);

-- Output:
-- number of rows inserted  
-- 1

-- ✅ Check current table state
SELECT * FROM source_customers;

-- Output:
-- CUSTOMER_ID  NAME    EMAIL   LAST_UPDATED  
-- 101  Alice   alice.new@example.com   2025-10-15 08:02:28.962  
-- 102  Bob bob@example.com 2025-10-15 07:52:51.380  
-- 103  Charlie charlie@example.com 2025-10-15 07:52:51.380  
-- 104  David   david@example.com   2025-10-15 08:05:52.489  
-- 104  David   david@example.com   2025-10-15 08:07:58.134  

-- ✅ Check stream — shows both INSERTs for David
SELECT * FROM source_customers_stream;

-- Output:
-- CUSTOMER_ID  NAME    EMAIL   LAST_UPDATED    METADATA$ACTION METADATA$ISUPDATE   METADATA$ROW_ID  
-- 101  Alice   alice.new@example.com   2025-10-15 08:02:28.962 INSERT  TRUE    93b423a460422eba6612fd96f05626fe8396f1c7  
-- 104  David   david@example.com   2025-10-15 08:05:52.489 INSERT  FALSE   da3a4aa7cfc6637fd34fa534287fdec2693e161f  
-- 104  David   david@example.com   2025-10-15 08:07:58.134 INSERT  FALSE   2d8081e3d8a7a6e64f72f092e04b3d51c7323d84  
-- 101  Alice   alice@example.com   2025-10-15 07:52:51.380 DELETE  TRUE    93b423a460422eba6612fd96f05626fe8396f1c7  

-- ✅ Delete Alice — tracked as standalone DELETE with ISUPDATE = FALSE
DELETE FROM source_customers WHERE CUSTOMER_ID=101;

-- Output:
-- number of rows deleted  
-- 1

-- ✅ Final stream state
SELECT * FROM source_customers_stream;

-- Output:
-- CUSTOMER_ID  NAME    EMAIL   LAST_UPDATED    METADATA$ACTION METADATA$ISUPDATE   METADATA$ROW_ID  
-- 104  David   david@example.com   2025-10-15 08:05:52.489 INSERT  FALSE   da3a4aa7cfc6637fd34fa534287fdec2693e161f  
-- 104  David   david@example.com   2025-10-15 08:07:58.134 INSERT  FALSE   2d8081e3d8a7a6e64f72f092e04b3d51c7323d84  
-- 101  Alice   alice@example.com   2025-10-15 07:52:51.380 DELETE  FALSE   93b423a460422eba6612fd96f05626fe8396f1c7  


Why You are Seeing Duplicate Records in the Stream
Snowflake Streams track changes (inserts, updates, deletes) 
to a table at the row level, not at the primary key level. 

This means:

If you insert the same customer_id twice (like David with ID 104), 
Snowflake treats each insert as a distinct change, even if the data is identical.

The stream doesn’t deduplicate based on business logic or primary key — 
it simply logs every change that modifies the table.



Breakdown of METADATA$ISUPDATE

Operation	METADATA$ACTION	METADATA$ISUPDATE	Explanation
INSERT	INSERT	            FALSE	New row added after stream creation
UPDATE	DELETE	            TRUE	Old version of the row removed
UPDATE	INSERT           	TRUE	New version of the row added
DELETE	DELETE	            FALSE	Row removed without replacement

🧠 Mnemonic: U-DI / U-II / D-D
Update → DELETE + INSERT → ISUPDATE = TRUE

Insert → INSERT only → ISUPDATE = FALSE

Delete → DELETE only → ISUPDATE = FALSE


************************************************************************************************


-- Create the base table
CREATE OR REPLACE TABLE source_customers (
  customer_id INT,
  name STRING,
  email STRING,
  last_updated TIMESTAMP
);

-- Insert initial data BEFORE stream creation
-- ❗ These rows are not tracked by the stream because they occurred before the stream was created
INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES
  (101, 'Alice', 'alice@example.com', CURRENT_TIMESTAMP),
  (102, 'Bob', 'bob@example.com', CURRENT_TIMESTAMP),
  (103, 'Charlie', 'charlie@example.com', CURRENT_TIMESTAMP);

-- Create stream with APPEND_ONLY = FALSE to track INSERT, UPDATE, DELETE
-- ✅ Stream begins tracking changes from this point forward
CREATE OR REPLACE STREAM source_customers_stream 
ON TABLE source_customers APPEND_ONLY = FALSE;

-- Check stream immediately after creation
SELECT * FROM source_customers_stream;
-- ❌ Zero records because no changes occurred after stream creation

-- Perform an UPDATE on Alice's email
-- ✅ This triggers a DELETE of the old row and INSERT of the new row
UPDATE source_customers
SET email = 'alice.new@example.com', last_updated = CURRENT_TIMESTAMP
WHERE customer_id = 101;

-- Output:
-- number of rows updated   number of multi-joined rows updated
-- 1    0

-- Check stream after UPDATE
SELECT * FROM source_customers_stream;

-- Output:
-- INSERT: new version of Alice's row
-- DELETE: old version of Alice's row
-- Both share the same METADATA$ROW_ID
-- METADATA$ISUPDATE = TRUE → because this is an UPDATE operation

CUSTOMER_ID NAME    EMAIL   LAST_UPDATED    METADATA$ACTION METADATA$ISUPDATE   METADATA$ROW_ID  
101 Alice   alice.new@example.com   2025-10-15 08:32:24.062 INSERT  TRUE    938cce1369aec8fd276d1c90b1490fde13cb0bab  
101 Alice   alice@example.com   2025-10-15 08:32:03.478 DELETE  TRUE    938cce1369aec8fd276d1c90b1490fde13cb0bab  

-- Check current table state
SELECT * FROM source_customers;

-- Output:
CUSTOMER_ID NAME    EMAIL   LAST_UPDATED  
101 Alice   alice.new@example.com   2025-10-15 08:32:24.062  
102 Bob bob@example.com 2025-10-15 08:32:03.478  
103 Charlie charlie@example.com 2025-10-15 08:32:03.478  

-- Insert a new customer David
-- ✅ This is a fresh INSERT → METADATA$ISUPDATE = FALSE
INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES (104, 'David', 'david@example.com', CURRENT_TIMESTAMP);

-- Output:
-- number of rows inserted
-- 1

-- Check stream after INSERT
SELECT * FROM source_customers_stream;

-- Output:
-- INSERT: David's new row
-- METADATA$ISUPDATE = FALSE → because it's a standalone insert

CUSTOMER_ID NAME    EMAIL   LAST_UPDATED    METADATA$ACTION METADATA$ISUPDATE   METADATA$ROW_ID  
101 Alice   alice.new@example.com   2025-10-15 08:32:24.062 INSERT  TRUE    938cce1369aec8fd276d1c90b1490fde13cb0bab  
104 David   david@example.com   2025-10-15 08:33:00.758 INSERT  FALSE   e0ed5aa5579d20c0ead70df0f05871216e567ad0  
101 Alice   alice@example.com   2025-10-15 08:32:03.478 DELETE  TRUE    938cce1369aec8fd276d1c90b1490fde13cb0bab  

-- Check current table state
SELECT * FROM source_customers;

-- Output:
CUSTOMER_ID NAME    EMAIL   LAST_UPDATED  
101 Alice   alice.new@example.com   2025-10-15 08:32:24.062  
102 Bob bob@example.com 2025-10-15 08:32:03.478  
103 Charlie charlie@example.com 2025-10-15 08:32:03.478  
104 David   david@example.com   2025-10-15 08:33:00.758  

-- Insert duplicate David (same customer_id)
-- ✅ Snowflake allows duplicates unless constrained
-- This is treated as a separate INSERT with a new ROW_ID
INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES (104, 'David', 'david@example.com', CURRENT_TIMESTAMP);

-- Check current table state
SELECT * FROM source_customers;

-- Output:
CUSTOMER_ID NAME    EMAIL   LAST_UPDATED  
101 Alice   alice.new@example.com   2025-10-15 08:32:24.062  
102 Bob bob@example.com 2025-10-15 08:32:03.478  
103 Charlie charlie@example.com 2025-10-15 08:32:03.478  
104 David   david@example.com   2025-10-15 08:33:00.758  
104 David   david@example.com   2025-10-15 08:35:08.495  

-- Check stream after second INSERT
SELECT * FROM source_customers_stream;

-- Output:
-- Two INSERTs for David with different ROW_IDs
-- METADATA$ISUPDATE = FALSE → both are standalone inserts

CUSTOMER_ID NAME    EMAIL   LAST_UPDATED    METADATA$ACTION METADATA$ISUPDATE   METADATA$ROW_ID  
101 Alice   alice.new@example.com   2025-10-15 08:32:24.062 INSERT  TRUE    938cce1369aec8fd276d1c90b1490fde13cb0bab  
104 David   david@example.com   2025-10-15 08:33:00.758 INSERT  FALSE   e0ed5aa5579d20c0ead70df0f05871216e567ad0  
104 David   david@example.com   2025-10-15 08:35:08.495 INSERT  FALSE   a8feb7b0ff956da07a21fec62cccbd11cba69013  
101 Alice   alice@example.com   2025-10-15 08:32:03.478 DELETE  TRUE    938cce1369aec8fd276d1c90b1490fde13cb0bab  

-- Delete Alice
-- ✅ This is a standalone DELETE → METADATA$ISUPDATE = FALSE
DELETE FROM source_customers WHERE CUSTOMER_ID=101;

-- Output:
-- number of rows deleted
-- 1

-- Check stream after DELETE
SELECT * FROM source_customers_stream;

-- Output:
-- DELETE: Alice's original row
-- METADATA$ISUPDATE = FALSE → because it's a final removal

CUSTOMER_ID NAME    EMAIL   LAST_UPDATED    METADATA$ACTION METADATA$ISUPDATE   METADATA$ROW_ID  
104 David   david@example.com   2025-10-15 08:33:00.758 INSERT  FALSE   e0ed5aa5579d20c0ead70df0f05871216e567ad0  
104 David   david@example.com   2025-10-15 08:35:08.495 INSERT  FALSE   a8feb7b0ff956da07a21fec62cccbd11cba69013  
101 Alice   alice@example.com   2025-10-15 08:32:03.478 DELETE  FALSE   938cce1369aec8fd276d1c90b1490fde13cb0bab  

-- Delete David (both rows with customer_id = 104)
-- ✅ Each row is deleted individually → each DELETE tracked separately
DELETE FROM source_customers WHERE CUSTOMER_ID=104;

-- Output:
-- number of rows deleted
-- 1

-- Check stream after DELETE
SELECT * FROM source_customers_stream;

-- Output:
-- Only Alice's DELETE remains visible (David's DELETEs may be consumed or filtered depending on stream consumption logic)

CUSTOMER_ID NAME    EMAIL   LAST_UPDATED    METADATA$ACTION METADATA$ISUPDATE   METADATA$ROW_ID  
101 Alice   alice@example.com   2025-10-15 08:32:03.478 DELETE  FALSE   938cce1369aec8fd276d1c90b1490fde13cb0bab  


**************************************************************************************************************


-- Step 1: Create the base table
CREATE OR REPLACE TABLE source_customers (
  customer_id INT,
  name STRING,
  email STRING,
  last_updated TIMESTAMP
);

-- Step 2: Insert initial data BEFORE stream creation
-- ❗ These rows are NOT tracked by the stream because they occurred before the stream was created
INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES
  (101, 'Alice', 'alice@example.com', CURRENT_TIMESTAMP),
  (102, 'Bob', 'bob@example.com', CURRENT_TIMESTAMP),
  (103, 'Charlie', 'charlie@example.com', CURRENT_TIMESTAMP);

-- Step 3: Create a stream to track changes
-- ✅ APPEND_ONLY = FALSE enables tracking of INSERT, UPDATE, DELETE
CREATE OR REPLACE STREAM source_customers_stream 
ON TABLE source_customers APPEND_ONLY = FALSE;

-- Step 4: Check stream immediately after creation
-- ✅ No changes yet, so stream returns zero records
SELECT *FROM source_customers_stream;--Zero records


-- Step 5: Update Alice's email
-- ✅ Triggers a DELETE of the old row and INSERT of the new row
-- ✅ METADATA$ISUPDATE = TRUE for both rows
UPDATE source_customers
SET email = 'alice.new@example.com', last_updated = CURRENT_TIMESTAMP
WHERE customer_id = 101;

number of rows updated	number of multi-joined rows updated
1	0


-- Step 6: Check stream after UPDATE
-- ✅ Shows both DELETE and INSERT for Alice with same ROW_ID
-- ✅ METADATA$ISUPDATE = TRUE indicates this is an UPDATE pair
SELECT *FROM source_customers_stream;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
101	Alice	alice.new@example.com	2025-10-15 08:32:24.062	INSERT	TRUE 938cce1369aec8fd276d1c90b1490fde13cb0bab
101	Alice	alice@example.com	2025-10-15 08:32:03.478	DELETE	TRUE	938cce1369aec8fd276d1c90b1490fde13cb0bab


-- Step 7: Check current table state
-- ✅ Alice's email is updated
SELECT *FROM source_customers;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED
101	Alice	alice.new@example.com	2025-10-15 08:32:24.062
102	Bob	bob@example.com	2025-10-15 08:32:03.478
103	Charlie	charlie@example.com	2025-10-15 08:32:03.478

-- Step 8: Insert new customer David
-- ✅ Tracked as standalone INSERT with ISUPDATE = FALSE
-- Insert a new record
INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES (104, 'David', 'david@example.com', CURRENT_TIMESTAMP);

number of rows inserted
1


-- Step 9: Check stream after INSERT
-- ✅ David's row appears with ISUPDATE = FALSE
SELECT *FROM source_customers_stream;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
101	Alice	alice.new@example.com	2025-10-15 08:32:24.062	INSERT	TRUE 938cce1369aec8fd276d1c90b1490fde13cb0bab
104	David	david@example.com	2025-10-15 08:33:00.758	INSERT	FALSE	e0ed5aa5579d20c0ead70df0f05871216e567ad0
101	Alice	alice@example.com	2025-10-15 08:32:03.478	DELETE	TRUE	938cce1369aec8fd276d1c90b1490fde13cb0bab

-- Step 10: Check current table state
-- ✅ David is added
SELECT *FROM source_customers;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED
101	Alice	alice.new@example.com	2025-10-15 08:32:24.062
102	Bob	bob@example.com	2025-10-15 08:32:03.478
103	Charlie	charlie@example.com	2025-10-15 08:32:03.478
104	David	david@example.com	2025-10-15 08:33:00.758


-- Step 11: Insert duplicate David (same customer_id)
-- ✅ Snowflake allows duplicates unless constrained
-- ✅ Tracked as separate INSERT with new ROW_ID

-- Insert a new record
INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES (104, 'David', 'david@example.com', CURRENT_TIMESTAMP);

-- Step 12: Check current table state
-- ✅ Two rows with customer_id = 104
SELECT *FROM source_customers;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED
101	Alice	alice.new@example.com	2025-10-15 08:32:24.062
102	Bob	bob@example.com	2025-10-15 08:32:03.478
103	Charlie	charlie@example.com	2025-10-15 08:32:03.478
104	David	david@example.com	2025-10-15 08:33:00.758
104	David	david@example.com	2025-10-15 08:35:08.495

-- Step 13: Check stream after second INSERT
-- ✅ Both David rows appear with ISUPDATE = FALSE
SELECT *FROM source_customers_stream;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
101	Alice	alice.new@example.com	2025-10-15 08:32:24.062	INSERT	TRUE938cce1369aec8fd276d1c90b1490fde13cb0bab
104	David	david@example.com	2025-10-15 08:33:00.758	INSERT	FALSE	e0ed5aa5579d20c0ead70df0f05871216e567ad0
104	David	david@example.com	2025-10-15 08:35:08.495	INSERT	FALSE	a8feb7b0ff956da07a21fec62cccbd11cba69013
101	Alice	alice@example.com	2025-10-15 08:32:03.478	DELETE	TRUE	938cce1369aec8fd276d1c90b1490fde13cb0bab

-- Step 14: Delete Alice
-- ✅ Tracked as standalone DELETE with ISUPDATE = FALSE
DELETE FROM source_customers WHERE CUSTOMER_ID=101;

number of rows deleted
1

SELECT *FROM source_customers_stream;

--Previous records 
CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
101	Alice	alice.new@example.com	2025-10-15 08:32:24.062	INSERT	TRUE938cce1369aec8fd276d1c90b1490fde13cb0bab
104	David	david@example.com	2025-10-15 08:33:00.758	INSERT	FALSE	e0ed5aa5579d20c0ead70df0f05871216e567ad0
104	David	david@example.com	2025-10-15 08:35:08.495	INSERT	FALSE	a8feb7b0ff956da07a21fec62cccbd11cba69013
101	Alice	alice@example.com	2025-10-15 08:32:03.478	DELETE	TRUE	938cce1369aec8fd276d1c90b1490fde13cb0bab

--After DELETE 
CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
104	David	david@example.com	2025-10-15 08:33:00.758	INSERT	FALSE	e0ed5aa5579d20c0ead70df0f05871216e567ad0
104	David	david@example.com	2025-10-15 08:35:08.495	INSERT	FALSE	a8feb7b0ff956da07a21fec62cccbd11cba69013
101	Alice	alice@example.com	2025-10-15 08:32:03.478	DELETE	FALSE	938cce1369aec8fd276d1c90b1490fde13cb0bab

-- Step 15: Check stream after DELETE
-- ✅ Alice's DELETE now shows ISUPDATE = FALSE (final removal)

DELETE FROM source_customers WHERE CUSTOMER_ID=104;

number of rows deleted
2

SELECT *FROM source_customers_stream;

--Before DELETE
CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
104	David	david@example.com	2025-10-15 08:33:00.758	INSERT	FALSE	e0ed5aa5579d20c0ead70df0f05871216e567ad0
104	David	david@example.com	2025-10-15 08:35:08.495	INSERT	FALSE	a8feb7b0ff956da07a21fec62cccbd11cba69013
101	Alice	alice@example.com	2025-10-15 08:32:03.478	DELETE	FALSE	938cce1369aec8fd276d1c90b1490fde13cb0bab

SELECT *FROM source_customers_stream;

--AFTER DELETE
CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
101	Alice	alice@example.com	2025-10-15 08:32:03.478	DELETE	FALSE	938cce1369aec8fd276d1c90b1490fde13cb0bab


Note:

Standard stream = Full change tracking

Mode	INSERT	UPDATE	DELETE

APPEND_ONLY = FALSE	✅	✅	✅


Standard Stream ≡ APPEND_ONLY = FALSE

It tracks all row-level changes:

✅ INSERT

✅ UPDATE (as DELETE + INSERT pair with ISUPDATE = TRUE)

✅ DELETE



***********************************************************************************************


-- Step 1: Create the base table
CREATE OR REPLACE TABLE source_customers (
  customer_id INT,
  name STRING,
  email STRING,
  last_updated TIMESTAMP
);

-- Step 2: Insert initial data BEFORE stream creation
-- ❗ These rows are NOT tracked by the stream
INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES
  (101, 'Alice', 'alice@example.com', CURRENT_TIMESTAMP),
  (102, 'Bob', 'bob@example.com', CURRENT_TIMESTAMP),
  (103, 'Charlie', 'charlie@example.com', CURRENT_TIMESTAMP);

-- Step 3: Create append-only stream (tracks only INSERTs)
CREATE OR REPLACE STREAM source_customers_stream 
ON TABLE source_customers APPEND_ONLY = TRUE;

-- Step 4: Check stream immediately after creation
-- ✅ No changes yet, so stream returns zero records
SELECT * FROM source_customers_stream;
-- Output: Zero records

-- Step 5: Update Alice's email
-- ❌ UPDATE is ignored by append-only stream
UPDATE source_customers
SET email = 'alice.new@example.com', last_updated = CURRENT_TIMESTAMP
WHERE customer_id = 101;
-- Output: number of rows updated = 1

-- Step 6: Check stream after UPDATE
-- ❌ No output because UPDATEs are not tracked
SELECT * FROM source_customers_stream;

-- Step 7: Check current table state
-- ✅ Alice's email is updated in base table
SELECT * FROM source_customers;
-- Output:
-- 101  Alice   alice.new@example.com   2025-10-15 09:23:35.199
-- 102  Bob bob@example.com 2025-10-15 09:22:32.454
-- 103  Charlie charlie@example.com 2025-10-15 09:22:32.454

-- Step 8: Insert new customer David
-- ✅ INSERT is tracked by stream
INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES (104, 'David', 'david@example.com', CURRENT_TIMESTAMP);
-- Output: number of rows inserted = 1

-- Step 9: Check stream after INSERT
SELECT * FROM source_customers_stream;
-- Output:
-- 104  David   david@example.com   2025-10-15 09:24:07.004 INSERT  FALSE   8b15ff46e049c32eaa27117b1f88a147e67b10e7

-- Step 10: Check current table state
SELECT * FROM source_customers;
-- Output:
-- 101  Alice   alice.new@example.com   2025-10-15 09:23:35.199
-- 102  Bob bob@example.com 2025-10-15 09:22:32.454
-- 103  Charlie charlie@example.com 2025-10-15 09:22:32.454
-- 104  David   david@example.com   2025-10-15 09:24:07.004

-- Step 11: Insert duplicate David (same customer_id)
-- ✅ Allowed unless constrained
INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES (104, 'David', 'david@example.com', CURRENT_TIMESTAMP);
-- Output: number of rows inserted = 1

-- Step 12: Check current table state
SELECT * FROM source_customers;
-- Output:
-- 101  Alice   alice.new@example.com   2025-10-15 09:23:35.199
-- 102  Bob bob@example.com 2025-10-15 09:22:32.454
-- 103  Charlie charlie@example.com 2025-10-15 09:22:32.454
-- 104  David   david@example.com   2025-10-15 09:24:07.004
-- 104  David   david@example.com   2025-10-15 09:24:39.767

-- Step 13: Check stream after second INSERT
SELECT * FROM source_customers_stream;
-- Output:
-- 104  David   david@example.com   2025-10-15 09:24:39.767 INSERT  FALSE   b403b1c599f18bf834bbf80436ed43860585608a
-- 104  David   david@example.com   2025-10-15 09:24:07.004 INSERT  FALSE   8b15ff46e049c32eaa27117b1f88a147e67b10e7

-- Step 14: Delete Alice
-- ❌ DELETE is ignored by append-only stream
DELETE FROM source_customers WHERE CUSTOMER_ID=101;
-- Output: number of rows deleted = 1

-- Step 15: Check stream after DELETE
SELECT * FROM source_customers_stream;
-- Output (unchanged):
-- 104  David   david@example.com   2025-10-15 09:24:07.004 INSERT  FALSE   8b15ff46e049c32eaa27117b1f88a147e67b10e7
-- 104  David   david@example.com   2025-10-15 09:24:39.767 INSERT  FALSE   b403b1c599f18bf834bbf80436ed43860585608a

-- Step 16: Delete both David rows
-- ❌ DELETEs are ignored by append-only stream
DELETE FROM source_customers WHERE CUSTOMER_ID=104;
-- Output: number of rows deleted = 2

-- Step 17: Final stream check
SELECT * FROM source_customers_stream;
-- Output (still unchanged):
-- 104  David   david@example.com   2025-10-15 09:24:39.767 INSERT  FALSE   b403b1c599f18bf834bbf80436ed43860585608a
-- 104  David   david@example.com   2025-10-15 09:24:07.004 INSERT  FALSE   8b15ff46e049c32eaa27117b1f88a147e67b10e7


Mnemonic for Teaching
Standard stream = Full CDC (Change Data Capture)

Stream Mode	INSERT	UPDATE	DELETE
APPEND_ONLY = TRUE	✅	❌	❌
APPEND_ONLY = FALSE	✅	✅	✅
(default if omitted)	✅	✅	✅