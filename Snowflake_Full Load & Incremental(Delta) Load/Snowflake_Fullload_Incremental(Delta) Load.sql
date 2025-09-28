-- Source table (simulates incoming data)
CREATE OR REPLACE TABLE source_customer_data (
    cust_id INT,
    name STRING,
    last_update_ts TIMESTAMP
);

-- Target table (destination in warehouse)
CREATE OR REPLACE TABLE target_customer_data (
    cust_id INT,
    name STRING,
    last_update_ts TIMESTAMP
);


-- Insert initial data into source
INSERT INTO source_customer_data VALUES
(1, 'Alice', '2025-09-25 10:00:00'),
(2, 'Bob', '2025-09-25 10:00:00'),
(3, 'Charlie', '2025-09-25 10:00:00');

-- Full load into target
TRUNCATE TABLE target_customer_data;

INSERT INTO target_customer_data
SELECT * FROM source_customer_data;

-- Check count after full load
SELECT COUNT(*) AS full_load_count FROM target_customer_data;
-- ✅ Output: 3


-- Add new and updated records to source
INSERT INTO source_customer_data VALUES
(2, 'Bob Marley', '2025-09-26 09:00:00'),  -- updated
(4, 'Diana', '2025-09-26 09:00:00');       -- new


TRUNCATE TABLE target_customer_data;

INSERT INTO target_customer_data
SELECT * FROM source_customer_data;

-- Check count after full load
SELECT COUNT(*) AS full_load_count FROM target_customer_data;
-- ✅ Output: 5 (all records from source)



-- Get latest timestamp from target
SELECT MAX(last_update_ts) AS last_loaded_ts FROM target_customer_data;
-- : 2025-09-26 09:00:00.000


MERGE INTO target_customer_data AS tgt
USING (
    SELECT * FROM source_customer_data
    WHERE last_update_ts >= '2025-09-26 09:00:00.000'
) AS src
ON tgt.cust_id = src.cust_id
WHEN MATCHED THEN UPDATE SET
    tgt.name = src.name,
    tgt.last_update_ts = src.last_update_ts
WHEN NOT MATCHED THEN INSERT (
    cust_id, name, last_update_ts
) VALUES (
    src.cust_id, src.name, src.last_update_ts
);
--number of rows inserted	number of rows updated
0	3

SELECT COUNT(*) AS incremental_load_count FROM target_customer_data;
-- ✅ Output: 4 (1 updated + 1 new = 2 changes applied to existing 3)

INCREMENTAL_LOAD_COUNT
5