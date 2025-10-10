CREATE OR REPLACE TABLE hotel_raw (
    hotel_name STRING,
    pune NUMBER,
    mumbai NUMBER,
    hyd NUMBER
);


INSERT INTO hotel_raw (hotel_name, pune, mumbai, hyd)
VALUES ('Taj', 1000, 2000, 3000);


SELECT hotel_name, city, collection
FROM hotel_raw
UNPIVOT (
    collection FOR city IN (pune, mumbai, hyd)
);

HOTEL_NAME	CITY	COLLECTION
Taj	PUNE	1000
Taj	MUMBAI	2000
Taj	HYD	3000


SELECT 
    hotel_name,
    f.key AS city,
    f.value::NUMBER AS collection
FROM hotel_raw,
LATERAL FLATTEN(
    INPUT => OBJECT_CONSTRUCT('pune', pune, 'mumbai', mumbai, 'hyd', hyd)
) f;

HOTEL_NAME	CITY	COLLECTION
Taj	hyd	3000
Taj	mumbai	2000
Taj	pune	1000


--------------------------------------

CREATE OR REPLACE TABLE sales_raw (
    sales_date DATE,
    product STRING,
    north NUMBER,
    south NUMBER,
    east NUMBER,
    west NUMBER
);


INSERT INTO sales_raw (sales_date, product, north, south, east, west)
VALUES 
    ('2025-09-13', 'Laptop', 1200, 800, 950, 1100),
    ('2025-09-13', 'Tablet', 600, 700, 500, 650);

SELECT *FROM sales_raw;

SALES_DATE	PRODUCT	NORTH	SOUTH	EAST	WEST
2025-09-13	Laptop	1200	800	950	1100
2025-09-13	Tablet	600	700	500	650

SELECT 
    sales_date,
    product,
    region,
    sales
FROM sales_raw
UNPIVOT (
    sales FOR region IN (north, south, east, west)
);


SALES_DATE	PRODUCT	REGION	SALES
2025-09-13	Laptop	NORTH	1200
2025-09-13	Laptop	SOUTH	800
2025-09-13	Laptop	EAST	950
2025-09-13	Laptop	WEST	1100
2025-09-13	Tablet	NORTH	600
2025-09-13	Tablet	SOUTH	700
2025-09-13	Tablet	EAST	500
2025-09-13	Tablet	WEST	650


CREATE OR REPLACE TABLE sales_normalized (
    sales_date DATE,
    product STRING,
    region STRING,
    sales NUMBER
);

INSERT INTO sales_normalized (sales_date, product, region, sales)
VALUES 
    ('2025-09-13', 'Laptop', 'NORTH', 1200),
    ('2025-09-13', 'Laptop', 'SOUTH', 800),
    ('2025-09-13', 'Laptop', 'EAST', 950),
    ('2025-09-13', 'Laptop', 'WEST', 1100),
    ('2025-09-13', 'Tablet', 'NORTH', 600),
    ('2025-09-13', 'Tablet', 'SOUTH', 700),
    ('2025-09-13', 'Tablet', 'EAST', 500),
    ('2025-09-13', 'Tablet', 'WEST', 650);


SELECT *
FROM sales_normalized
PIVOT (
    SUM(sales) FOR region IN ('NORTH', 'SOUTH', 'EAST', 'WEST')
);

SALES_DATE	PRODUCT	'NORTH'	'SOUTH'	'EAST'	'WEST'
2025-09-13	Laptop	1200	800	950	1100
2025-09-13	Tablet	600	700	500	650


*************************************************************************


CREATE OR REPLACE TABLE sales_transactions_snowflake (
    product_id INT,
    product_name STRING,
    quarter STRING,
    sales_amount INT
);

INSERT INTO sales_transactions_snowflake VALUES
-- Laptop (ID: 101)
(101, 'Laptop', 'Q1', 1200),
(101, 'Laptop', 'Q1', 1000),
(101, 'Laptop', 'Q2', 1500),
(101, 'Laptop', 'Q2', 1400),
(101, 'Laptop', 'Q3', 1300),
(101, 'Laptop', 'Q3', 1250),
(101, 'Laptop', 'Q4', 1600),
(101, 'Laptop', 'Q4', 1550),

-- Tablet (ID: 102)
(102, 'Tablet', 'Q1', 800),
(102, 'Tablet', 'Q1', 850),
(102, 'Tablet', 'Q2', 950),
(102, 'Tablet', 'Q2', 900),
(102, 'Tablet', 'Q3', 900),
(102, 'Tablet', 'Q3', 880),
(102, 'Tablet', 'Q4', 1100),
(102, 'Tablet', 'Q4', 1050),

-- Smartphone (ID: 103)
(103, 'Smartphone', 'Q1', 2000),
(103, 'Smartphone', 'Q1', 1950),
(103, 'Smartphone', 'Q2', 2200),
(103, 'Smartphone', 'Q2', 2150),
(103, 'Smartphone', 'Q3', 2100),
(103, 'Smartphone', 'Q3', 2050),
(103, 'Smartphone', 'Q4', 2300),
(103, 'Smartphone', 'Q4', 2250);


SELECT * FROM sales_transactions_snowflake;

SELECT *
FROM sales_transactions_snowflake
PIVOT(SUM(SALES_AMOUNT) FOR QUARTER IN('Q1','Q2','Q3','Q4') );

PRODUCT_ID	PRODUCT_NAME	'Q1'	'Q2'	'Q3'	'Q4'
101	Laptop	2200	2900	2550	3150
102	Tablet	1650	1850	1780	2150
103	Smartphone	3950	4350	4150	4550


SELECT *
FROM sales_transactions_snowflake
PIVOT(MAX(sales_amount) FOR quarter IN ('Q1', 'Q2', 'Q3', 'Q4'));

PRODUCT_ID	PRODUCT_NAME	'Q1'	'Q2'	'Q3'	'Q4'
101	Laptop	1200	1500	1300	1600
102	Tablet	850	950	900	1100
103	Smartphone	2000	2200	2100	2300


SELECT *
FROM sales_transactions_snowflake
PIVOT(SUM(SALES_AMOUNT) FOR QUARTER IN(ANY ORDER BY quarter) );

PRODUCT_ID	PRODUCT_NAME	'Q1'	'Q2'	'Q3'	'Q4'
103	Smartphone	3950	4350	4150	4550
101	Laptop	2200	2900	2550	3150
102	Tablet	1650	1850	1780	2150



CREATE OR REPLACE TABLE sales_by_quarter_snowflake (
    product_id INT,
    product_name STRING,
    Q1 INT,
    Q2 INT,
    Q3 INT,
    Q4 INT
);

INSERT INTO sales_by_quarter_snowflake VALUES
(101, 'Laptop', 2200, 2900, 2550, 3150),
(102, 'Tablet', 1650, 1850, 1780, 2150),
(103, 'Smartphone', 3950, 4350, 4150, 4550);


SELECT product_id, product_name, quarter, sales_amount
FROM sales_by_quarter_snowflake
UNPIVOT (
    sales_amount FOR quarter IN (Q1, Q2, Q3, Q4)
)
ORDER BY product_name, quarter;

PRODUCT_ID	PRODUCT_NAME	QUARTER	SALES_AMOUNT
101	Laptop	Q1	2200
101	Laptop	Q2	2900
101	Laptop	Q3	2550
101	Laptop	Q4	3150
103	Smartphone	Q1	3950
103	Smartphone	Q2	4350
103	Smartphone	Q3	4150
103	Smartphone	Q4	4550
102	Tablet	Q1	1650
102	Tablet	Q2	1850
102	Tablet	Q3	1780
102	Tablet	Q4	2150
