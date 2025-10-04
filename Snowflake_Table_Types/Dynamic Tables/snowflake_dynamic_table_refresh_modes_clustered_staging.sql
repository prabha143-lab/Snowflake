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


--Step 1: Create Raw Sales Table
CREATE OR REPLACE TABLE raw_sales (
    product_id INT,
    day DATE,
    revenue FLOAT
);


--Step 2: Insert Historical and Recent Records

-- Historical (before 2025-01-01)
INSERT INTO raw_sales VALUES
(201, '2024-12-01', 1000.00),
(201, '2024-12-01', 500.00),
(202, '2024-12-10', 1500.00),
(203, '2024-12-20', 1200.00),
(204, '2024-12-25', 1300.00);

-- Recent (on or after 2025-01-01)
INSERT INTO raw_sales VALUES
(201, '2025-01-05', 1100.00),
(201, '2025-01-05', 900.00),
(202, '2025-01-10', 1600.00),
(203, '2025-01-15', 1700.00),
(204, '2025-01-20', 1800.00);

SELECT * FROM RAW_SALES ORDER BY PRODUCT_ID;

--Step 3: Create Backfill Table for Frozen Region
CREATE OR REPLACE TABLE sales_backfill AS
SELECT product_id, day, SUM(revenue) AS total_revenue
FROM raw_sales
WHERE day < '2025-01-01'
GROUP BY product_id, day;

SELECT * FROM sales_backfill;

PRODUCT_ID	DAY	TOTAL_REVENUE
201	2024-12-01	1500
202	2024-12-10	1500
203	2024-12-20	1200
204	2024-12-25	1300


--Step 4: Create Dynamic Table
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

SELECT * FROM sales_summary;


PRODUCT_ID	DAY	TOTAL_REVENUE
201	2024-12-01	1500
202	2024-12-10	1500
203	2024-12-20	1200
204	2024-12-25	1300
201	2025-01-05	2000
202	2025-01-10	1600
203	2025-01-15	1700
204	2025-01-20	1800


--Step 6: Teaching Query to Simulate Region Label
SELECT 
  product_id, 
  day, 
  total_revenue,
  CASE 
    WHEN day < '2025-01-01' THEN 'Immutable ❄️'
    ELSE 'Refreshable 🔄'
  END AS region
FROM sales_summary
ORDER BY product_id, day;


PRODUCT_ID	DAY	TOTAL_REVENUE	REGION
201	2024-12-01	1500	Immutable ❄️
201	2025-01-05	2000	Refreshable 🔄
202	2024-12-10	1500	Immutable ❄️
202	2025-01-10	1600	Refreshable 🔄
203	2024-12-20	1200	Immutable ❄️
203	2025-01-15	1700	Refreshable 🔄
204	2024-12-25	1300	Immutable ❄️
204	2025-01-20	1800	Refreshable 🔄


***************************************************************************************


-- STEP 1: Create base tables
CREATE OR REPLACE TABLE raw_sales (
    product_id INT,
    day DATE,
    revenue NUMBER(12,2)  -- ✅ Fixed-point type
);


CREATE OR REPLACE TABLE product_info (
    product_id INT,
    category STRING,
    brand STRING
);

-- STEP 2: Insert sample data
INSERT INTO raw_sales VALUES
-- Historical
(101, '2024-12-01', 1000.00),
(101, '2024-12-01', 500.00),
(102, '2024-12-10', 1500.00),
-- Recent
(101, '2025-01-05', 1100.00),
(101, '2025-01-05', 900.00),
(102, '2025-01-10', 1600.00);


INSERT INTO product_info VALUES
(101, 'Electronics', 'Sony'),
(102, 'Appliances', 'LG');

-- STEP 3: Create backfill table for frozen region
CREATE OR REPLACE TABLE sales_backfill AS
SELECT 
  s.product_id, 
  s.day, 
  SUM(s.revenue) AS total_revenue,
  p.category,
  p.brand
FROM raw_sales s
JOIN product_info p
  ON s.product_id = p.product_id
WHERE s.day < '2025-01-01'
GROUP BY s.product_id, s.day, p.category, p.brand;

-- STEP 4: Create dynamic table with join + immutability
CREATE OR REPLACE DYNAMIC TABLE sales_enriched
TARGET_LAG = '5 minutes'
WAREHOUSE = compute_wh
REFRESH_MODE = incremental
INITIALIZE = on_create
IMMUTABLE WHERE (day < '2025-01-01')
BACKFILL FROM sales_backfill
AS
SELECT 
  s.product_id, 
  s.day, 
  SUM(s.revenue) AS total_revenue,
  p.category,
  p.brand
FROM raw_sales s
JOIN product_info p
  ON s.product_id = p.product_id
GROUP BY s.product_id, s.day, p.category, p.brand;

--Dynamic table SALES_ENRICHED successfully created.

-- STEP 5: Teaching query to simulate region label
SELECT 
  product_id, 
  day, 
  total_revenue,
  category,
  brand,
  CASE 
    WHEN day < '2025-01-01' THEN 'Immutable ❄️'
    ELSE 'Refreshable 🔄'
  END AS region
FROM sales_enriched
ORDER BY product_id, day;


PRODUCT_ID	DAY	TOTAL_REVENUE	CATEGORY	BRAND	REGION
101	2024-12-01	1500.00	Electronics	Sony	Immutable ❄️
101	2025-01-05	2000.00	Electronics	Sony	Refreshable 🔄
102	2024-12-10	1500.00	Appliances	LG	Immutable ❄️
102	2025-01-10	1600.00	Appliances	LG	Refreshable 🔄