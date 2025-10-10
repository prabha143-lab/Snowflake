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
