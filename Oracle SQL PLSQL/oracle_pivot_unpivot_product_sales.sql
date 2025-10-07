CREATE TABLE product_sales (
    product_name VARCHAR2(50),
    quarter VARCHAR2(2),
    sales_amount NUMBER
);

INSERT INTO product_sales VALUES ('Laptop', 'Q1', 1000);
INSERT INTO product_sales VALUES ('Laptop', 'Q2', 1500);
INSERT INTO product_sales VALUES ('Laptop', 'Q3', 1200);
INSERT INTO product_sales VALUES ('Laptop', 'Q4', 1700);
INSERT INTO product_sales VALUES ('Tablet', 'Q1', 800);
INSERT INTO product_sales VALUES ('Tablet', 'Q2', 950);
INSERT INTO product_sales VALUES ('Tablet', 'Q3', 1100);
INSERT INTO product_sales VALUES ('Tablet', 'Q4', 1300);

COMMIT;

SELECT * FROM product_sales;
    
SELECT *
FROM (
    SELECT product_name, quarter, sales_amount
    FROM product_sales
)
PIVOT (
    SUM(sales_amount)
    FOR quarter IN ('Q1' AS Q1, 'Q2' AS Q2, 'Q3' AS Q3, 'Q4' AS Q4)
);

SELECT *
FROM product_sales
PIVOT (
    SUM(sales_amount) FOR quarter IN ('Q1', 'Q2', 'Q3', 'Q4')
);

SELECT
    product_name,
    SUM(CASE WHEN quarter = 'Q1' THEN sales_amount ELSE 0 END) AS Q1,
    SUM(CASE WHEN quarter = 'Q2' THEN sales_amount ELSE 0 END) AS Q2,
    SUM(CASE WHEN quarter = 'Q3' THEN sales_amount ELSE 0 END) AS Q3,
    SUM(CASE WHEN quarter = 'Q4' THEN sales_amount ELSE 0 END) AS Q4
FROM product_sales
GROUP BY product_name;


PRODUCT_NAME	'Q1'	'Q2'	'Q3'	'Q4'
Laptop	1000	1500	1200	1700
Tablet	800	    950	    1100	1300

********************************************************************    
CREATE TABLE quarterly_sales (
    product_name VARCHAR2(50),
    Q1 NUMBER,
    Q2 NUMBER,
    Q3 NUMBER,
    Q4 NUMBER
);


INSERT INTO quarterly_sales VALUES ('Laptop', 1000, 1500, 1200, 1700);
INSERT INTO quarterly_sales VALUES ('Tablet', 800, 950, 1100, 1300);
COMMIT;


SELECT product_name, quarter, sales_amount
FROM quarterly_sales
UNPIVOT (
    sales_amount FOR quarter IN (Q1 AS 'Q1', Q2 AS 'Q2', Q3 AS 'Q3', Q4 AS 'Q4')
);


SELECT *
FROM quarterly_sales
UNPIVOT (
    sales_amount FOR quarter IN (Q1, Q2, Q3, Q4)
);

PRODUCT_NAME	QUARTER	SALES_AMOUNT
Laptop	Q1	1000
Laptop	Q2	1500
Laptop	Q3	1200
Laptop	Q4	1700
Tablet	Q1	800
Tablet	Q2	950
Tablet	Q3	1100
Tablet	Q4	1300

8 rows selected.


SELECT product_name, 'Q1' AS quarter, Q1 AS sales_amount FROM quarterly_sales
UNION ALL
SELECT product_name, 'Q2' AS quarter, Q2 AS sales_amount FROM quarterly_sales
UNION ALL
SELECT product_name, 'Q3' AS quarter, Q3 AS sales_amount FROM quarterly_sales
UNION ALL
SELECT product_name, 'Q4' AS quarter, Q4 AS sales_amount FROM quarterly_sales
ORDER BY product_name,quarter ASC;


PRODUCT_NAME	QUARTER	SALES_AMOUNT
Laptop	Q1	1000
Laptop	Q2	1500
Laptop	Q3	1200
Laptop	Q4	1700
Tablet	Q1	800
Tablet	Q2	950
Tablet	Q3	1100
Tablet	Q4	1300

8 rows selected.