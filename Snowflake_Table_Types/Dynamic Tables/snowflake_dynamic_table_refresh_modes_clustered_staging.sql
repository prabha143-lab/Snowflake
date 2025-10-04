***********************************Dynamic Table ****************************


-- ❸ Create a staging table with clustering (✅ Valid)
-- Clustering is supported in permanent tables to optimize pruning and performance
CREATE OR REPLACE TABLE staging_table (
    product_id INT,
    product_name STRING,
    order_time TIMESTAMP_NTZ
)
CLUSTER BY (product_id);  -- ✅ Valid here



-- ❹ Create a dynamic table correctly (✅ Valid)
-- Pulls data from the clustered staging table, but does not use CLUSTER BY itself
CREATE OR REPLACE DYNAMIC TABLE my_dynamic_table
TARGET_LAG = '20 minutes'
WAREHOUSE = compute_wh
REFRESH_MODE = auto
INITIALIZE = on_create
AS
SELECT product_id, product_name
FROM staging_table;  -- ✅ Valid and successfully created

--Dynamic table MY_DYNAMIC_TABLE successfully created.


SELECT * FROM my_dynamic_table;


-- Insert sample product records
INSERT INTO staging_table (product_id, product_name, order_time) VALUES
(101, 'Wireless Mouse', '2025-10-01 10:15:00'),
(102, 'Mechanical Keyboard', '2025-10-01 11:30:00'),
(103, 'USB-C Hub', '2025-10-02 09:45:00'),
(104, 'Laptop Stand', '2025-10-02 14:20:00'),
(105, 'Noise Cancelling Headphones', '2025-10-03 16:00:00');

SELECT * FROM staging_table;

SELECT * FROM my_dynamic_table;

PRODUCT_ID	PRODUCT_NAME
101	Wireless Mouse
102	Mechanical Keyboard
103	USB-C Hub
104	Laptop Stand
105	Noise Cancelling Headphones

UPDATE my_dynamic_table SET RODUCT_NAME='MY WAREHOUSE' WHERE PRODUCT_ID=101;

--SQL Compilation error: Invalid Operation UPDATE on Dynamic Table

Note: Dynamic tables in Snowflake are read-only views over declarative pipelines. You cannot perform DML operations like:

UPDATE
DELETE
INSERT
MERGE

on a dynamic table.



******************************************

-- ✅ AUTO mode: Snowflake decides between full or incremental based on query complexity
CREATE OR REPLACE DYNAMIC TABLE my_dynamic_table_auto
TARGET_LAG = '2 minutes'
WAREHOUSE = compute_wh
REFRESH_MODE = auto
INITIALIZE = on_create
AS
SELECT product_id, product_name
FROM staging_table;
--Dynamic table MY_DYNAMIC_TABLE_AUTO successfully created.

-- ✅ FULL mode: Entire result set is recomputed on each refresh
CREATE OR REPLACE DYNAMIC TABLE my_dynamic_table_full
TARGET_LAG = '2 minutes'
WAREHOUSE = compute_wh
REFRESH_MODE = full
INITIALIZE = on_create
AS
SELECT product_id, product_name
FROM staging_table;

--Dynamic table MY_DYNAMIC_TABLE_FULL successfully created.

-- ✅ INCREMENTAL mode: Only changed data is refreshed
CREATE OR REPLACE DYNAMIC TABLE my_dynamic_table_incremental
TARGET_LAG = '2 minutes'
WAREHOUSE = compute_wh
REFRESH_MODE = incremental
INITIALIZE = on_create
AS
SELECT product_id, product_name
FROM staging_table;

--Dynamic table MY_DYNAMIC_TABLE_INCREMENTAL successfully created.


***************************************


CREATE OR REPLACE TABLE raw_sales (
    product_id INT,
    day DATE,
    revenue FLOAT
);


INSERT INTO raw_sales VALUES
(101, '2024-12-15', 500.00),
(102, '2024-12-20', 750.00),
(101, '2025-01-05', 600.00),
(102, '2025-01-10', 800.00),
(103, '2025-01-15', 900.00);


CREATE OR REPLACE TABLE sales_backfill AS
SELECT product_id, day, SUM(revenue) AS total_revenue
FROM raw_sales
WHERE day < '2025-01-01'
GROUP BY product_id, day;



CREATE OR REPLACE DYNAMIC TABLE sales_summary
TARGET_LAG = '5 minutes'
WAREHOUSE = compute_wh
REFRESH_MODE = incremental
INITIALIZE = on_create
IMMUTABLE WHERE (day < '2025-01-01')
BACKFILL FROM sales_backfill
AS
SELECT product_id, day, SUM(revenue) AS total_revenue
FROM raw_sales
GROUP BY product_id, day;

--Dynamic table SALES_SUMMARY successfully created.