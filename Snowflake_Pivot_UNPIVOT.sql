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