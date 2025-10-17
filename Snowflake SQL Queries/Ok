1

CREATE OR REPLACE TABLE TableA (
    COLUMN_NAME STRING
);

-- Insert example records into TableA
INSERT INTO TableA (COLUMN_NAME) VALUES
('a.b'),
('c.d.e'),
('g'),
('h'),
('x.y.z');

Desired Output:

COLUMN_NAME
a
b
c
d
e
g
h
x
y
z

SELECT DISTINCT
    TRIM(value::string) AS COLUMN_NAME
FROM
    TableA,
    LATERAL FLATTEN(input => SPLIT(COLUMN_NAME, '.'));


COLUMN_NAME
a
b
c
d
e
g
h
x
y
z



SELECT DISTINCT
    TRIM(VALUE) AS COLUMN_NAME
FROM
    TableA,
    TABLE(SPLIT_TO_TABLE(TableA.COLUMN_NAME, '.'));


COLUMN_NAME
a
b
c
d
e
g
h
x
y
z

------------------------------Snowflake Streams---------------------------



CREATE OR REPLACE TABLE customers (
    customer_id INT,
    customer_name STRING,
    customer_email STRING,
    customer_phone STRING,
    customer_address STRING
);

INSERT INTO customers (customer_id, customer_name, customer_email, customer_phone, customer_address)
VALUES 
(1, 'Alice', 'alice@example.com', '123-456-7890', '123 Main St'),
(2, 'Bob', 'bob@example.com', '234-567-8901', '456 Elm St'),
(3, 'Charlie', 'charlie@example.com', '345-678-9012', '789 Oak St');


SELECT *FROM customers;

CUSTOMER_ID	CUSTOMER_NAME	CUSTOMER_EMAIL	CUSTOMER_PHONE	CUSTOMER_ADDRESS
1	Alice	alice@example.com	123-456-7890	123 Main St
2	Bob	bob@example.com	234-567-8901	456 Elm St
3	Charlie	charlie@example.com	345-678-9012	789 Oak St

CREATE OR REPLACE STREAM customer_stream ON TABLE customers;

SELECT *FROM customer_stream;--No Records

-- Insert a new customer
INSERT INTO customers (customer_id, customer_name, customer_email, customer_phone, customer_address)
VALUES (4, 'David', 'david@example.com', '456-789-0123', '101 Pine St');


SELECT *FROM customer_stream;

CUSTOMER_ID	CUSTOMER_NAME	CUSTOMER_EMAIL	CUSTOMER_PHONE	CUSTOMER_ADDRESS	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
4	David	david@example.com	456-789-0123	101 Pine St	INSERT	FALSE	ddc8c7c884148e40f639b4ae2fdc264414829af5


-- Update an existing customer
UPDATE customers
SET customer_email = 'newalice@example.com'
WHERE customer_id = 1;

number of rows updated	number of multi-joined rows updated
1	0

SELECT *FROM customer_stream order by customer_id

CUSTOMER_ID	CUSTOMER_NAME	CUSTOMER_EMAIL	CUSTOMER_PHONE	CUSTOMER_ADDRESS	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
1	Alice	newalice@example.com	123-456-7890	123 Main St	INSERT	TRUE	4cba42ddb4cbf34604e58b22ef408d9047d00447
1	Alice	alice@example.com	123-456-7890	123 Main St	DELETE	TRUE	4cba42ddb4cbf34604e58b22ef408d9047d00447
4	David	david@example.com	456-789-0123	101 Pine St	INSERT	FALSE	ddc8c7c884148e40f639b4ae2fdc264414829af5


-- Delete a customer
DELETE FROM customers
WHERE customer_id = 2;

number of rows deleted
1


SELECT *FROM customer_stream order by customer_id

CUSTOMER_ID	CUSTOMER_NAME	CUSTOMER_EMAIL	CUSTOMER_PHONE	CUSTOMER_ADDRESS	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
1	Alice	newalice@example.com	123-456-7890	123 Main St	INSERT	TRUE	4cba42ddb4cbf34604e58b22ef408d9047d00447
1	Alice	alice@example.com	123-456-7890	123 Main St	DELETE	TRUE	4cba42ddb4cbf34604e58b22ef408d9047d00447
2	Bob	bob@example.com	234-567-8901	456 Elm St	DELETE	FALSE	8ea5853dc5dbbd2bdcc21d96f108eee4ba3c722f
4	David	david@example.com	456-789-0123	101 Pine St	INSERT	FALSE	ddc8c7c884148e40f639b4ae2fdc264414829af5


Consume the Stream
Consume the stream to process the changes and update a target table or perform other actions:


-- Create a target table to store processed changes
CREATE OR REPLACE TABLE processed_customers AS
SELECT * FROM customer_stream;

-- Consume the stream
INSERT INTO processed_customers
SELECT * FROM customer_stream;


-----------------Errors in Streams---------------------------

SELECT * from INFORMATION_SCHEMA.STREAMS
WHERE  STREAM_NAME = 'CUSTOMER_STREAM';

--002003 (42S02): SQL compilation error:
Object 'MY_DB.INFORMATION_SCHEMA.STREAMS' does not exist or not authorized.

SELECT * from my_db.public.STREAMS
WHERE  STREAM_NAME = 'CUSTOMER_STREAM';

002003 (42S02): SQL compilation error:
Object 'MY_DB.PUBLIC.STREAMS' does not exist or not authorized.


--------------------------------------------------------------------


-- Customers table
CREATE OR REPLACE TABLE customers (
    customer_id INT,
    customer_name STRING,
    city STRING
);

-- Orders table
CREATE OR REPLACE TABLE orders (
    order_id INT,
    customer_id INT,
    order_date DATE,
    order_status STRING
);

-- Order Items table
CREATE OR REPLACE TABLE order_items (
    order_item_id INT,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2)
);

-- Products table
CREATE OR REPLACE TABLE products (
    product_id INT,
    product_name STRING,
    category STRING
);

-- Sample Data Insertion
INSERT INTO customers VALUES
    (101, 'Alice', 'New York'),
    (102, 'Bob', 'Los Angeles'),
    (103, 'Charlie', 'Chicago'),
    (104, 'David', 'Houston');

INSERT INTO orders VALUES
    (1, 101, '2023-10-26', 'Shipped'),
    (2, 102, '2023-10-27', 'Pending'),
    (3, 103, '2023-10-28', 'Completed'),
    (4, 104, '2023-10-29', 'Cancelled'),
    (5, 105, '2023-10-30', 'Processing'), -- Order with non-existing customer
    (6, 101, '2023-10-31', 'Shipped');

INSERT INTO order_items VALUES
    (1, 1, 1, 2, 100.00),
    (2, 1, 2, 1, 150.00),
    (3, 2, 2, 1, 150.00),
    (4, 3, 3, 1, 200.00),
    (5, 4, 1, 1, 100.00),
    (6, 5, 4, 1, 50.00),
    (7, 6, 1, 3, 100.00);

INSERT INTO products VALUES
    (1, 'Laptop', 'Electronics'),
    (2, 'Mouse', 'Electronics'),
    (3, 'Keyboard', 'Electronics'),
    (4, 'T-Shirt', 'Clothing');


SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    c.customer_name,
    c.city,
    p.product_name,
    p.category,
    oi.quantity,
    oi.price,
    oi.quantity * oi.price AS line_total,
    CASE
        WHEN c.customer_id IS NULL THEN 'Missing Customer'
        ELSE 'Customer Found'
    END AS customer_status
FROM
    orders o
LEFT JOIN
    customers c ON o.customer_id = c.customer_id
LEFT JOIN
    (SELECT * FROM order_items WHERE quantity > 1) oi ON o.order_id = oi.order_id
LEFT JOIN
    products p ON oi.product_id = p.product_id
ORDER BY
    o.order_id, oi.order_item_id;


WITH FilteredOrderItems AS (
    SELECT * FROM order_items WHERE quantity > 1
)
SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    c.customer_name,
    c.city,
    p.product_name,
    p.category,
    oi.quantity,
    oi.price,
    oi.quantity * oi.price AS line_total,
    CASE
        WHEN c.customer_id IS NULL THEN 'Missing Customer'
        ELSE 'Customer Found'
    END AS customer_status
FROM
    orders o
LEFT JOIN
    customers c ON o.customer_id = c.customer_id
LEFT JOIN
    FilteredOrderItems oi ON o.order_id = oi.order_id
LEFT JOIN
    products p ON oi.product_id = p.product_id
ORDER BY
    o.order_id, oi.order_item_id;


SELECT O.ORDER_ID,CUSTOMER_NAME,
CASE WHEN CUSTOMER_NAME IS NULL THEN 'NO CUSTOMER'
ELSE 'CUSTOMER FOUND'  END  CUSTOMER_EXIST_OR_NOT, 
O.ORDER_ID,O.ORDER_DATE,O.ORDER_STATUS
FROM ORDERS O
LEFT JOIN CUSTOMERS C ON O.CUSTOMER_ID=C.CUSTOMER_ID
ORDER BY O.ORDER_ID;


-- Customers table
CREATE OR REPLACE TABLE customers (
    customer_id INT,
    customer_name STRING
);

-- Orders table
CREATE OR REPLACE TABLE orders (
    order_id INT,
    customer_id INT,
    order_date DATE
);

-- Products table
CREATE OR REPLACE TABLE products (
    product_id INT,
    product_name STRING
);

-- Order Items table
CREATE OR REPLACE TABLE order_items (
    order_item_id INT,
    order_id INT,
    product_id INT
);

-- Insert sample customer data
INSERT INTO customers VALUES
    (101, 'Alice'),
    (102, 'Bob'),
    (103, 'Charlie'),
    (104, 'David');

-- Insert sample order data
INSERT INTO orders VALUES
    (1, 101, '2023-11-01'),
    (2, 102, '2023-11-01'),
    (3, 101, '2023-11-01'),
    (4, 103, '2023-11-02'),
    (5, 101, '2023-11-01'),
    (6, 102, '2023-11-02'),
    (7, 104, '2023-11-01'),
    (8, 101, '2023-11-02'),
    (9, 103, '2023-11-01');

-- Insert sample product data
INSERT INTO products VALUES
    (1, 'Laptop'),
    (2, 'Mouse'),
    (3, 'Keyboard'),
    (4, 'Monitor');

-- Insert sample order items data
INSERT INTO order_items VALUES
    (1, 1, 1),
    (2, 1, 2),
    (3, 2, 2),
    (4, 3, 1),
    (5, 3, 3),
    (6, 5, 4),
    (7, 7, 1),
    (8, 7, 3),
    (9, 9, 2);

SELECT
    c.customer_name,
    COUNT(o.order_id) AS order_count,
    LISTAGG(p.product_name, ', ') WITHIN GROUP (ORDER BY p.product_name) AS products_ordered
FROM
    orders o
JOIN
    customers c ON o.customer_id = c.customer_id
LEFT JOIN
    order_items oi ON o.order_id = oi.order_id
LEFT JOIN
    products p ON oi.product_id = p.product_id
WHERE
    o.order_date = '2023-11-01' -- Change date here
GROUP BY
    c.customer_name
ORDER BY
    order_count DESC
LIMIT 1;


------------------------------------------------------------------------------------------


-- Create table TAB1
CREATE OR REPLACE TABLE TAB1 (C1 INT);

-- Create table TAB2
CREATE OR REPLACE TABLE TAB2 (A1 INT);

-- Insert data into TAB1
INSERT INTO TAB1 (C1) VALUES 
(0),
(0),
(0),
(1),
(1);

-- Insert data into TAB2
INSERT INTO TAB2 (A1) VALUES 
(1),
(1),
(1),
(1),
(0);

SELECT *FROM TAB1;

C1
0
0
0
1
1

SELECT *FROM TAB2;

A1
1
1
1
1
0


SELECT *
FROM TAB1
INNER JOIN TAB2
ON TAB1.C1 = TAB2.A1;

C1	A1
0	0
0	0
0	0
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1


SELECT *
FROM TAB1
LEFT OUTER JOIN TAB2
ON TAB1.C1 = TAB2.A1;

C1	A1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
0	0
0	0
0	0


SELECT *
FROM TAB1
RIGHT OUTER JOIN TAB2
ON TAB1.C1 = TAB2.A1;


C1	A1
0	0
0	0
0	0
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1

SELECT *
FROM TAB1
FULL OUTER JOIN TAB2
ON TAB1.C1 = TAB2.A1;

C1	A1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
0	0
0	0
0	0


SELECT *
FROM TAB1
JOIN TAB2
ON TAB1.C1 = TAB2.A1;

C1	A1
0	0
0	0
0	0
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1




SELECT C1
FROM TAB1
UNION
SELECT A1
FROM TAB2;

C1
0
1


SELECT C1
FROM TAB1
UNION ALL
SELECT A1
FROM TAB2;

C1
0
0
0
1
1
1
1
1
1
0


SELECT C1
FROM TAB1
INTERSECT
SELECT A1
FROM TAB2;

C1
0
1


SELECT C1
FROM TAB1
MINUS
SELECT A1
FROM TAB2;

--No rows

-------------------------------------------------

in snowflake SET operators -----UNION UNION ALL MINUS AND INTERSECT(EXCEPT)

DROP TABLE TAB1;

DROP TABLE TAB2;

-- Create table TAB1
CREATE TABLE TAB1 (C1 INT);

-- Create table TAB2
CREATE TABLE TAB2 (A1 INT);

-- Insert data into TAB1 in descending order
INSERT INTO TAB1 (C1) VALUES (4);
INSERT INTO TAB1 (C1) VALUES (3);
INSERT INTO TAB1 (C1) VALUES (2);
INSERT INTO TAB1 (C1) VALUES (1);
INSERT INTO TAB1 (C1) VALUES (0);

-- Insert data into TAB2 in descending order
INSERT INTO TAB2 (A1) VALUES (4);
INSERT INTO TAB2 (A1) VALUES (3);
INSERT INTO TAB2 (A1) VALUES (2);
INSERT INTO TAB2 (A1) VALUES (1);
INSERT INTO TAB2 (A1) VALUES (0);

SELECT C1 FROM TAB1
UNION
SELECT A1 FROM TAB2;

C1
4
3
2
1
0


SELECT C1 FROM TAB1
UNION
SELECT A1 FROM TAB2
ORDER BY 1;

C1
0
1
2
3
4


SELECT C1 FROM TAB1
UNION ALL
SELECT A1 FROM TAB2;

C1
4
3
2
1
0
4
3
2
1
0

SELECT C1 FROM TAB1
UNION ALL
SELECT A1 FROM TAB2
ORDER BY 1;


SELECT C1 FROM TAB1
INTERSECT
SELECT A1 FROM TAB2;


C1
3
0
4
1
2

SELECT C1 FROM TAB1
INTERSECT
SELECT A1 FROM TAB2
ORDER BY 1;

C1
0
1
2
3
4


SELECT C1 FROM TAB1
MINUS
SELECT A1 FROM TAB2
ORDER BY 1;--No rows



---------Oracle

-- Create table TAB1
CREATE TABLE TAB1 (C1 INT);

-- Create table TAB2
CREATE TABLE TAB2 (A1 INT);

-- Insert data into TAB1 in descending order
INSERT INTO TAB1 (C1) VALUES (4);
INSERT INTO TAB1 (C1) VALUES (3);
INSERT INTO TAB1 (C1) VALUES (2);
INSERT INTO TAB1 (C1) VALUES (1);
INSERT INTO TAB1 (C1) VALUES (0);

-- Insert data into TAB2 in descending order
INSERT INTO TAB2 (A1) VALUES (4);
INSERT INTO TAB2 (A1) VALUES (3);
INSERT INTO TAB2 (A1) VALUES (2);
INSERT INTO TAB2 (A1) VALUES (1);
INSERT INTO TAB2 (A1) VALUES (0);


SELECT C1 FROM TAB1
UNION
SELECT A1 FROM TAB2;

C1
0
1
2
3
4
Download CSV
5 rows selected.


SELECT C1 FROM TAB1
UNION ALL
SELECT A1 FROM TAB2;


C1
4
3
2
1
0
4
3
2
1
0
Download CSV
10 rows selected


SELECT C1 FROM TAB1
INTERSECT
SELECT A1 FROM TAB2;

C1
0
1
2
3
4
Download CSV
5 rows selected.


SELECT C1 FROM TAB1
MINUS
SELECT A1 FROM TAB2;--no data found



----------------------------------------------------------------------------------------


CREATE TABLE emails (
    email VARCHAR2(50)
);

INSERT INTO emails (email) VALUES ('prabhakar.raju@gmail.com');
INSERT INTO emails (email) VALUES ('sanjay.konu@gmail.com');


SELECT SUBSTR(email, 1, INSTR(email, '@') - 1) AS name_portion
FROM emails;---Unknown function INSTR

SELECT SPLIT_PART(email, '@', 1) AS name_portion
FROM emails;

NAME_PORTION
prabhakar.raju
sanjay.konu


SELECT SPLIT_PART(email, '@', 2) AS domain
FROM emails;

DOMAIN
gmail.com
gmail.com


SELECT SPLIT_PART(email, '@', 1) AS name_portion1,SPLIT_PART(email, '@', 2) AS name_portion1
FROM emails;

NAME_PORTION1	 NAME_PORTION1
prabhakar.raju	 gmail.com
sanjay.konu   	 gmail.com

-------------------

CREATE OR REPLACE TABLE emails (
    email STRING
);

INSERT INTO emails (email) VALUES ('prabhakar.raju@gmail.com');
INSERT INTO emails (email) VALUES ('sanjay.konu@gmail.com');
INSERT INTO emails (email) VALUES ('john.doe@example.com');
INSERT INTO emails (email) VALUES ('jane.smith@domain.com');
-- Add more rows as needed


SELECT SPLIT(email, '@') AS result
FROM emails;

RESULT
[ "prabhakar.raju", "gmail.com" ]
[ "sanjay.konu", "gmail.com" ]
[ "john.doe", "example.com" ]
[ "jane.smith", "domain.com" ]



SELECT SPLIT_PART(email, '@', 1) AS name_portion,
       SPLIT_PART(email, '@', 2) AS domain
FROM emails;

NAME_PORTION	 DOMAIN
prabhakar.raju	 gmail.com
sanjay.konu	     gmail.com
john.doe	     example.com
jane.smith	     domain.com


SELECT email,
       t.VALUE AS part
FROM emails,
     TABLE(SPLIT_TO_TABLE(email, '@')) AS t;



-------------ORACLE------------------


CREATE TABLE emails (
    email VARCHAR2(50)
);

INSERT INTO emails (email) VALUES ('prabhakar.raju@gmail.com');
INSERT INTO emails (email) VALUES ('sanjay.konu@gmail.com');
-- Add more rows as needed


SELECT SUBSTR(email, 1, INSTR(email, '@') - 1) AS name_portion
FROM emails;


NAME_PORTION
prabhakar.raju
sanjay.konu
Download CSV
2 rows selected


-----------------------------------------------------------------------------------------

3rd Highest salary in snowflake


CREATE OR REPLACE TABLE employees (
    employee_id INT,
    salary NUMERIC
);

INSERT INTO employees (employee_id, salary) VALUES (1, 50000);
INSERT INTO employees (employee_id, salary) VALUES (2, 60000);
INSERT INTO employees (employee_id, salary) VALUES (3, 70000);
INSERT INTO employees (employee_id, salary) VALUES (4, 80000);
INSERT INTO employees (employee_id, salary) VALUES (5, 90000);
-- Add more rows as needed


SELECT MIN(salary) AS third_highest_salary
FROM (
    SELECT DISTINCT salary
    FROM employees
    ORDER BY salary DESC
    LIMIT 3
);

---------------------------------------------------------------------------------------------


DROP TABLE EMPLOYEES;

-- Create Table
CREATE TABLE EMPLOYEES (
    EMP_ID INT,
    NAME VARCHAR(50),
    SALARY INT
);

-- Insert Sample Data
INSERT INTO EMPLOYEES VALUES (101, 'Alice', 70000);
INSERT INTO EMPLOYEES VALUES (102, 'Bob', 85000);
INSERT INTO EMPLOYEES VALUES (103, 'Charlie', 80000);
INSERT INTO EMPLOYEES VALUES (104, 'David', 95000);
INSERT INTO EMPLOYEES VALUES (105, 'Eve', 92000);
INSERT INTO EMPLOYEES VALUES (106, 'Even', 92000);

SELECT *FROM EMPLOYEES;

101	Alice	70000
102	Bob	85000
103	Charlie	80000
104	David	95000
105	Eve	92000
106	Even	92000

SELECT NAME,SALARY
FROM EMPLOYEES
QUALIFY ROW_NUMBER() OVER(ORDER BY SALARY DESC) =2

SELECT NAME,SALARY
FROM EMPLOYEES
QUALIFY RANK() OVER(ORDER BY SALARY DESC) =2


CREATE TABLE employee_emails (
    id NUMBER,
    email_address VARCHAR2(100)
);

-- Insert some sample data
INSERT INTO employee_emails (id, email_address) VALUES (1, 'john.doe@example.com');
INSERT INTO employee_emails (id, email_address) VALUES (2, 'jane_smith@example.net');
INSERT INTO employee_emails (id, email_address) VALUES (3, 'first.last.middle@company.org');
INSERT INTO employee_emails (id, email_address) VALUES (4, 'manager@organization.com');

COMMIT;

SELECT *FROM employee_emails;

SELECT
    ID,
    EMAIL_ADDRESS,
    SPLIT_PART(EMAIL_ADDRESS,'@',1),
    SPLIT_PART(EMAIL_ADDRESS,'@',-2),
    SPLIT_PART(EMAIL_ADDRESS,'@',-1)
    FROM  employee_emails;
	
	



------------------------------------------------------------------------------------------------------
ORACLE 


SELECT 3 FROM DUAL
UNION
SELECT 1 FROM DUAL
UNION
SELECT 2 FROM DUAL;

OUTPUT 
----------------    
1
2
3

SELECT 3 FROM DUAL
UNION
SELECT 1 FROM DUAL
UNION
SELECT 2 FROM DUAL
ORDER BY 1;


OUTPUT 
-------------
1
2
3

3 rows selected.


SELECT 3 FROM DUAL
UNION ALL
SELECT 1 FROM DUAL
UNION ALL
SELECT 2 FROM DUAL;

OUTPUT 
-----------
3
1
2

3 rows selected.





DROP TABLE TAB1;

DROP TABLE TAB2;

-- Create table TAB1
CREATE TABLE TAB1 (C1 INT);

-- Create table TAB2
CREATE TABLE TAB2 (A1 INT);

-- Insert data into TAB1 in descending order
INSERT INTO TAB1 (C1) VALUES (-4);
INSERT INTO TAB1 (C1) VALUES (1);
INSERT INTO TAB1 (C1) VALUES (4);
INSERT INTO TAB1 (C1) VALUES (3);
INSERT INTO TAB1 (C1) VALUES (0);

-- Insert data into TAB2 in descending order
INSERT INTO TAB2 (A1) VALUES (-4);
INSERT INTO TAB2 (A1) VALUES (1);
INSERT INTO TAB2 (A1) VALUES (12);
INSERT INTO TAB2 (A1) VALUES (1);
INSERT INTO TAB2 (A1) VALUES (0);


SELECT C1 FROM TAB1
INTERSECT
SELECT A1 FROM TAB2;

C1
-----    
-4
0
1

3 rows selected
    
SELECT C1 FROM TAB1
MINUS
SELECT A1 FROM TAB2;

C1
----
3
4

2 rows selected.


SELECT C1 FROM TAB1
EXCEPT
SELECT A1 FROM TAB2;

ORA-00933: SQL command not properly ended


DROP TABLE TAB1;

DROP TABLE TAB2;

-- Create table TAB1
CREATE TABLE TAB1 (C1 INT);

-- Create table TAB2
CREATE TABLE TAB2 (A1 INT);

-- Insert data into TAB1 in descending order
INSERT INTO TAB1 (C1) VALUES (-4);
INSERT INTO TAB1 (C1) VALUES (1);
INSERT INTO TAB1 (C1) VALUES (4);
INSERT INTO TAB1 (C1) VALUES (3);
INSERT INTO TAB1 (C1) VALUES (0);

-- Insert data into TAB2 in descending order
INSERT INTO TAB2 (A1) VALUES (-4);
INSERT INTO TAB2 (A1) VALUES (1);
INSERT INTO TAB2 (A1) VALUES (12);
INSERT INTO TAB2 (A1) VALUES (1);
INSERT INTO TAB2 (A1) VALUES (0);


SELECT C1 FROM TAB1
UNION
SELECT A1 FROM TAB2;

C1
    
-4
0
1
3
4
12

6 rows selected.


SELECT C1 FROM TAB1
UNION ALL
SELECT A1 FROM TAB2;


C1
    
-4
1
4
3
0
-4
1
12
1
0

10 rows selected.




Snowflake
-------------------------

SELECT 3
UNION
SELECT 1
UNION
SELECT 2;

OUTPUT 
---------------
3
1
2


SELECT 3
UNION
SELECT 1
UNION
SELECT 2
ORDER BY 1 ASC;

OUTPUT 
------------
1
2
3

SELECT 3
UNION ALL
SELECT 1
UNION ALL
SELECT 2;

OUTPUT 
---------------
3
1
2



DROP TABLE TAB1;

DROP TABLE TAB2;

-- Create table TAB1
CREATE TABLE TAB1 (C1 INT);

-- Create table TAB2
CREATE TABLE TAB2 (A1 INT);

-- Insert data into TAB1 in descending order
INSERT INTO TAB1 (C1) VALUES (-4);
INSERT INTO TAB1 (C1) VALUES (1);
INSERT INTO TAB1 (C1) VALUES (4);
INSERT INTO TAB1 (C1) VALUES (3);
INSERT INTO TAB1 (C1) VALUES (0);

-- Insert data into TAB2 in descending order
INSERT INTO TAB2 (A1) VALUES (-4);
INSERT INTO TAB2 (A1) VALUES (1);
INSERT INTO TAB2 (A1) VALUES (12);
INSERT INTO TAB2 (A1) VALUES (1);
INSERT INTO TAB2 (A1) VALUES (0);


SELECT C1 FROM TAB1
INTERSECT
SELECT A1 FROM TAB2;

C1
-----    
0
-4
1

3 rows selected
    
SELECT C1 FROM TAB1
MINUS
SELECT A1 FROM TAB2;

C1
----
3
4

2 rows selected.


SELECT C1 FROM TAB1
EXCEPT
SELECT A1 FROM TAB2;

C1
----
3
4

2 rows selected.


What is the difference between MINUS and EXCEPT in Snowflake? Both are displaying the same output.


---------------------------------------------------------------------

CREATE TABLE country_teams (
    column_name VARCHAR(50)
);


INSERT INTO country_teams (column_name) VALUES ('INDIA');
INSERT INTO country_teams (column_name) VALUES ('AUSTRALIA');
INSERT INTO country_teams (column_name) VALUES ('FRANCE');
INSERT INTO country_teams (column_name) VALUES ('GERMANY');


SELECT 
    a.column_name AS team_1,
    b.column_name AS team_2
FROM country_teams a
JOIN country_teams b 
  ON a.column_name < b.column_name;

SELECT 
    a.column_name AS home_team,
    b.column_name AS away_team
FROM country_teams a
JOIN country_teams b 
  ON a.column_name <> b.column_name;


SELECT 
    a.column_name AS team_1,
    b.column_name AS team_2,
    ROW_NUMBER() OVER (ORDER BY a.column_name, b.column_name) AS match_id
FROM country_teams a
JOIN country_teams b 
  ON a.column_name < b.column_name;


SELECT 
  a.column_name AS team_1,
  b.column_name AS team_2
FROM country_teams a
JOIN country_teams b 
  ON a.column_name != b.column_name;

  SELECT 
  a.column_name AS team_1,
  b.column_name AS team_2
FROM country_teams a
JOIN country_teams b 
  ON TRUE; -- includes all combinations, including self matches


SELECT 
  a.column_name AS team_1,
  b.column_name AS team_2
FROM country_teams a
CROSS JOIN country_teams b;

--------------------------------------------------------------------


CREATE OR REPLACE TABLE product_sales (
    category VARCHAR,
    product_id INT,
    product_name VARCHAR,
    revenue NUMBER,
    quantity_sold INT
);


INSERT INTO product_sales (category, product_id, product_name, revenue, quantity_sold) VALUES
('Electronics', 1, 'Smartphone A', 25000, 150),
('Electronics', 2, 'Smartphone B', 22000, 120),
('Electronics', 3, 'Tablet A', 18000, 110),
('Electronics', 4, 'Smartwatch A', 12000, 90),
('Electronics', 5, 'TV A', 30000, 130),

('Books', 6, 'Book A', 5000, 80),
('Books', 7, 'Book B', 6000, 90),
('Books', 8, 'Book C', 5500, 70),

('Appliances', 9, 'Fridge A', 40000, 120),
('Appliances', 10, 'Oven A', 28000, 100),
('Appliances', 11, 'Microwave A', 22000, 95),
('Appliances', 12, 'Washer A', 31000, 110);


CATEGORY	PRODUCT_ID	PRODUCT_NAME	REVENUE	QUANTITY_SOLD
Electronics	1	Smartphone A	25000	150
Electronics	2	Smartphone B	22000	120
Electronics	3	Tablet A	18000	110
Electronics	4	Smartwatch A	12000	90
Electronics	5	TV A	30000	130
Books	6	Book A	5000	80
Books	7	Book B	6000	90
Books	8	Book C	5500	70
Appliances	9	Fridge A	40000	120
Appliances	10	Oven A	28000	100
Appliances	11	Microwave A	22000	95
Appliances	12	Washer A	31000	110


WITH category_sales AS (
  SELECT 
    category,
    SUM(quantity_sold) AS total_quantity
  FROM product_sales
  GROUP BY category
  HAVING SUM(quantity_sold) > 100
),
ranked_products AS (
  SELECT 
    ps.category,
    ps.product_name,
    ps.revenue,
    RANK() OVER (PARTITION BY ps.category ORDER BY ps.revenue DESC) AS revenue_rank
  FROM product_sales ps
  JOIN category_sales cs ON ps.category = cs.category
)
SELECT 
  category,
  product_name,
  revenue
FROM ranked_products
WHERE revenue_rank <= 3
ORDER BY category, revenue DESC;


WITH category_sales AS (
  SELECT 
    category,
    SUM(quantity_sold) AS total_quantity
  FROM product_sales
  GROUP BY category
  HAVING SUM(quantity_sold) > 100
),
ranked_products AS (
  SELECT 
    ps.category,
    ps.product_name,
    ps.revenue,
    RANK() OVER (PARTITION BY ps.category ORDER BY ps.revenue DESC) AS revenue_rank
  FROM product_sales ps
  JOIN category_sales cs ON ps.category = cs.category
)
SELECT 
  category,
  product_name,
  revenue,
  revenue_rank
FROM ranked_products
WHERE revenue_rank <= 3
ORDER BY category, revenue_rank;

CATEGORY	PRODUCT_NAME	REVENUE	REVENUE_RANK
Appliances	Fridge A	40000	1
Appliances	Washer A	31000	2
Appliances	Oven A	28000	3
Books	Book B	6000	1
Books	Book C	5500	2
Books	Book A	5000	3
Electronics	TV A	30000	1
Electronics	Smartphone A	25000	2
Electronics	Smartphone B	22000	3


SELECT 
  ps.category,
  ps.product_name,
  ps.revenue,
  RANK() OVER (PARTITION BY ps.category ORDER BY ps.revenue DESC NULLS FIRST) AS revenue_rank
FROM product_sales ps
JOIN (
    SELECT 
      category
    FROM product_sales
    GROUP BY category
    HAVING SUM(quantity_sold) > 100
) AS filtered_categories
  ON ps.category = filtered_categories.category
QUALIFY RANK() OVER (PARTITION BY ps.category ORDER BY ps.revenue DESC NULLS FIRST) <= 3
ORDER BY ps.category, revenue_rank;

------------------------------------------


CREATE OR REPLACE TABLE orders (
  order_id INT,
  customer_id INT,
  order_timestamp TIMESTAMP,
  delivery_date DATE,
  shipping_time TIME,
  order_amount NUMBER(10,2),
  order_status STRING
);



INSERT INTO orders (order_id, customer_id, order_timestamp, delivery_date, shipping_time, order_amount, order_status)
VALUES
(1001, 501, '2023-06-15 10:45:00', '2023-06-20', '10:00:00', 2500.75, 'Delivered'),
(1002, 502, '2023-07-01 15:30:00', '2023-07-05', '14:30:00', 1499.99, 'Shipped'),
(1003, 503, '2023-07-20 09:00:00', '2023-07-25', '08:45:00', 789.65, 'Delivered'),
(1004, 504, '2023-08-02 13:20:00', '2023-08-07', '13:00:00', 3100.00, 'Pending'),
(1005, 505, '2023-08-15 19:15:00', '2023-08-20', '19:00:00', 2200.50, 'Delivered'),
(1006, 506, '2023-09-01 11:00:00', '2023-09-06', '11:30:00', 560.00, 'Cancelled'),
(1007, 507, '2023-09-10 16:45:00', '2023-09-15', '16:00:00', 999.95, 'Delivered'),
(1008, 508, '2023-10-01 08:30:00', '2023-10-06', '08:00:00', 870.25, 'Delivered');



SELECT 
  order_id,
  customer_id,
  order_timestamp,
  -- 🏗️ Construction
  DATE_FROM_PARTS(YEAR(order_timestamp), MONTH(order_timestamp), DAY(order_timestamp)) AS constructed_date,
  TIME_FROM_PARTS(HOUR(order_timestamp), MINUTE(order_timestamp), SECOND(order_timestamp), 0) AS constructed_time,
  TIMESTAMP_FROM_PARTS(YEAR(order_timestamp), MONTH(order_timestamp), DAY(order_timestamp), HOUR(order_timestamp), MINUTE(order_timestamp), SECOND(order_timestamp), 0) AS constructed_timestamp,

  -- 🔍 Extraction
  DATE_PART('year', order_timestamp) AS year_part,
  DAYNAME(order_timestamp) AS day_name,
  MONTHNAME(order_timestamp) AS month_name,
  DAY(order_timestamp) AS day_of_month,
  WEEK(order_timestamp) AS week_of_year,
  QUARTER(order_timestamp) AS quarter,
  HOUR(order_timestamp) AS hour,
  MINUTE(order_timestamp) AS minute,
  SECOND(order_timestamp) AS second,

  -- ➕ Arithmetic
  DATEADD(DAY, 7, order_timestamp) AS plus_7_days,
  DATEDIFF(DAY, order_timestamp, CURRENT_DATE) AS days_since_order,
  ADD_MONTHS(order_timestamp, 1) AS next_month,
  MONTHS_BETWEEN(CURRENT_DATE, order_timestamp) AS months_between,

  -- ✂️ Truncation
  DATE_TRUNC('month', order_timestamp) AS month_start,
  DATE_TRUNC('week', order_timestamp) AS week_start,
  LAST_DAY(order_timestamp) AS month_end,

  -- 🔁 Conversion
  TO_DATE(order_timestamp) AS converted_date,
  TO_TIME(order_timestamp) AS converted_time,
  TO_TIMESTAMP(TO_DATE(order_timestamp)) AS reconverted_timestamp,

  -- 🌍 Timezone
  CONVERT_TIMEZONE('UTC', 'Asia/Kolkata', order_timestamp) AS india_time

FROM orders
WHERE order_timestamp IS NOT NULL
ORDER BY order_timestamp DESC;


----------------------------------------------------------------------------


CREATE OR REPLACE TABLE orders (
  order_id INT,
  customer_id INT,
  order_timestamp TIMESTAMP
);

INSERT INTO orders (order_id, customer_id, order_timestamp) VALUES
(1, 101, '2023-01-01 10:15:00'),  -- first order
(2, 101, '2023-01-20 09:30:00'),  -- within 30 days → match
(3, 101, '2023-02-25 11:45:00'),  -- outside 30 days

(4, 102, '2023-03-05 14:00:00'),  -- only one order

(5, 103, '2023-04-01 08:20:00'),  -- first order
(6, 103, '2023-04-10 10:15:00'),  -- within 30 days → match
(7, 103, '2023-04-25 16:40:00'),  -- within 30 days → match
(8, 103, '2023-05-30 12:00:00'),  -- outside 30 days

(9, 104, '2023-06-01 09:00:00'),  -- first order
(10, 104, '2023-06-15 11:30:00'), -- within 30 days → match

(11, 105, '2023-07-10 10:30:00'); -- only one order


SELECT *FROM orders;

ORDER_ID	CUSTOMER_ID	ORDER_TIMESTAMP
1	101	2023-01-01 10:15:00.000
2	101	2023-01-20 09:30:00.000
3	101	2023-02-25 11:45:00.000
4	102	2023-03-05 14:00:00.000
5	103	2023-04-01 08:20:00.000
6	103	2023-04-10 10:15:00.000
7	103	2023-04-25 16:40:00.000
8	103	2023-05-30 12:00:00.000
9	104	2023-06-01 09:00:00.000
10	104	2023-06-15 11:30:00.000
11	105	2023-07-10 10:30:00.000


SELECT 
  o1.customer_id,
  o1.order_id AS order_1_id,
  o1.order_timestamp AS order_1_timestamp,
  o2.order_id AS order_2_id,
  o2.order_timestamp AS order_2_timestamp
FROM orders o1
JOIN orders o2
  ON o1.customer_id = o2.customer_id
  AND o1.order_id != o2.order_id
  AND o2.order_timestamp BETWEEN o1.order_timestamp - INTERVAL '30 days' AND o1.order_timestamp
ORDER BY o1.customer_id, o1.order_timestamp;


CUSTOMER_ID	ORDER_1_ID	ORDER_1_TIMESTAMP	ORDER_2_ID	ORDER_2_TIMESTAMP
101	2	2023-01-20 09:30:00.000	1	2023-01-01 10:15:00.000
103	6	2023-04-10 10:15:00.000	5	2023-04-01 08:20:00.000
103	7	2023-04-25 16:40:00.000	5	2023-04-01 08:20:00.000
103	7	2023-04-25 16:40:00.000	6	2023-04-10 10:15:00.000
104	10	2023-06-15 11:30:00.000	9	2023-06-01 09:00:00.000


------------------------------------------------------


DROP TABLE profit_summary;

-- Create the table
CREATE TABLE profit_summary (
    day_name VARCHAR2(10),
    profit NUMBER
);

-- Insert sample data
INSERT INTO profit_summary (day_name, profit) VALUES ('Day 1', 10);
INSERT INTO profit_summary (day_name, profit) VALUES ('Day 2', 20);
INSERT INTO profit_summary (day_name, profit) VALUES ('Day 3', 30);
INSERT INTO profit_summary (day_name, profit) VALUES ('Day 4', 5);
INSERT INTO profit_summary (day_name, profit) VALUES ('Day 5', 6);
INSERT INTO profit_summary (day_name, profit) VALUES ('Day 7', 0);
INSERT INTO profit_summary (day_name, profit) VALUES ('Day 8', 50);
INSERT INTO profit_summary (day_name, profit) VALUES ('Day 9', 150);
INSERT INTO profit_summary (day_name, profit) VALUES ('Day 10', 2500);

-- Commit the changes
COMMIT;



Query to Find Maximum Profit and Corresponding Day
    
SELECT day_name, profit
FROM (
    SELECT day_name, profit
    FROM profit_summary
    ORDER BY profit DESC
)
WHERE ROWNUM = 1;

DAY_NAME	PROFIT
Day 10	2500




Query to Find Maximum Profit Difference Between Consecutive Days
Finding the Maximum Profit Difference Between Consecutive Days (Corrected Oracle SQL)
    
-- Using a Common Table Expression (CTE) for clarity and correctness
WITH daily_profit_diff AS (
  SELECT
    day_name,
    ABS(profit - LAG(profit, 1) OVER (ORDER BY TO_NUMBER(SUBSTR(day_name, 5)))) AS profit_difference
  FROM
    profit_summary
)
SELECT
  day_name,
  profit_difference
FROM
  daily_profit_diff
WHERE
  profit_difference = (
    SELECT MAX(profit_difference) FROM daily_profit_diff
  );


DAY_NAME	PROFIT_DIFFERENCE
Day 10	2350

    
SELECT
    daily_diffs.prev_day_name,
    daily_diffs.day_name,
    daily_diffs.prev_profit,
    daily_diffs.profit,
    daily_diffs.profit_difference
FROM (
  SELECT
    day_name,
    profit,
    LAG(day_name, 1) OVER (ORDER BY TO_NUMBER(SUBSTR(day_name, 5))) AS prev_day_name,
    LAG(profit, 1) OVER (ORDER BY TO_NUMBER(SUBSTR(day_name, 5))) AS prev_profit,
    ABS(profit - LAG(profit, 1) OVER (ORDER BY TO_NUMBER(SUBSTR(day_name, 5)))) AS profit_difference
  FROM
    profit_summary
) daily_diffs
WHERE
  daily_diffs.profit_difference = (
    SELECT MAX(profit_difference)
    FROM (
      SELECT
        ABS(profit - LAG(profit, 1) OVER (ORDER BY TO_NUMBER(SUBSTR(day_name, 5)))) AS profit_difference
      FROM
        profit_summary
    )
  );

PREV_DAY_NAME	DAY_NAME	PREV_PROFIT	PROFIT	PROFIT_DIFFERENCE
Day 9	Day 10	150	2500	2350

------------------------------------------------------------------------------------------------------------



DROP TABLE EMP;

DROP TABLE DEPT;

CREATE TABLE DEPT
(DEPTNO NUMERIC(2),
DNAME VARCHAR(14),
LOC VARCHAR(13),
CONSTRAINT DEPTNO_PK PRIMARY KEY (DEPTNO));

INSERT INTO DEPT VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO DEPT VALUES (20, 'RESEARCH', 'DALLAS');
INSERT INTO DEPT VALUES (30, 'SALES', 'CHICAGO');
INSERT INTO DEPT VALUES (40, 'OPERATIONS', 'BOSTON');

COMMIT;

CREATE TABLE EMP
(EMPNO NUMERIC(4) not null,
ENAME VARCHAR(10),
JOB VARCHAR(9),
MGR NUMERIC(4),
HIREDATE DATE,
SAL NUMERIC(7, 2),
COMM NUMERIC(7, 2),
DEPTNO NUMERIC(2),
  CONSTRAINT empno_PK PRIMARY KEY (EMPNO),
  constraint fk_deptno foreign key (deptno) references dept (deptno)  );


INSERT INTO EMP VALUES
(7369, 'SMITH', 'CLERK', 7902, '17-DEC-1980', 800, NULL, 20);
INSERT INTO EMP VALUES
(7499, 'ALLEN', 'SALESMAN', 7698, '20-FEB-1981', 1600, 300, 30);
INSERT INTO EMP VALUES
(7521, 'WARD', 'SALESMAN', 7698, '22-FEB-1981', 1250, 500, 30);
INSERT INTO EMP VALUES
(7566, 'JONES', 'MANAGER', 7839, '2-APR-1981', 2975, NULL, 20);
INSERT INTO EMP VALUES
(7654, 'MARTIN', 'SALESMAN', 7698, '28-SEP-1981', 1250, 1400, 30);
INSERT INTO EMP VALUES
(7698, 'BLAKE', 'MANAGER', 7839, '1-MAY-1981', 2850, NULL, 30);
INSERT INTO EMP VALUES
(7782, 'CLARK', 'MANAGER', 7839, '9-JUN-1981', 2450, NULL, 10);
INSERT INTO EMP VALUES
(7788, 'SCOTT', 'ANALYST', 7566, '09-DEC-1982', 3000, NULL, 20);
INSERT INTO EMP VALUES
(7839, 'KING', 'PRESIDENT', NULL, '17-NOV-1981', 5000, NULL, 10);
INSERT INTO EMP VALUES
(7844, 'TURNER', 'SALESMAN', 7698, '8-SEP-1981', 1500, 0, 30);
INSERT INTO EMP VALUES
(7876, 'ADAMS', 'CLERK', 7788, '12-JAN-1983', 1100, NULL, 20);
INSERT INTO EMP VALUES
(7900, 'JAMES', 'CLERK', 7698, '3-DEC-1981', 950, NULL, 30);
INSERT INTO EMP VALUES
(7902, 'FORD', 'ANALYST', 7566, '3-DEC-1981', 3000, NULL, 20);
INSERT INTO EMP VALUES
(7934, 'MILLER', 'CLERK', 7782, '23-JAN-1982', 1300, NULL, 10);
commit;


SELECT empno,ename,
    deptno,
    sal,
    SUM(sal) OVER (PARTITION BY deptno ORDER BY sal) AS cumulative_salary
FROM 
    emp
ORDER BY deptno, sal;

EMPNO	ENAME	DEPTNO	SAL	CUMULATIVE_SALARY
7934	MILLER	10	1300.00	1300.00
7782	CLARK	10	2450.00	3750.00
7839	KING	10	5000.00	8750.00
7369	SMITH	20	800.00	800.00
7876	ADAMS	20	1100.00	1900.00
7566	JONES	20	2975.00	4875.00
7788	SCOTT	20	3000.00	10875.00
7902	FORD	20	3000.00	10875.00
7900	JAMES	30	950.00	950.00
7521	WARD	30	1250.00	3450.00
7654	MARTIN	30	1250.00	3450.00
7844	TURNER	30	1500.00	4950.00
7499	ALLEN	30	1600.00	6550.00
7698	BLAKE	30	2850.00	9400.00

SELECT 
    empno,
    ename,
    deptno,
    sal,
    SUM(sal) OVER (
        PARTITION BY deptno 
        ORDER BY sal, empno
    ) AS cumulative_salary
FROM 
    emp
ORDER BY deptno, sal, empno;

EMPNO	ENAME	DEPTNO	SAL	CUMULATIVE_SALARY
7934	MILLER	10	1300.00	1300.00
7782	CLARK	10	2450.00	3750.00
7839	KING	10	5000.00	8750.00
7369	SMITH	20	800.00	800.00
7876	ADAMS	20	1100.00	1900.00
7566	JONES	20	2975.00	4875.00
7788	SCOTT	20	3000.00	7875.00
7902	FORD	20	3000.00	10875.00
7900	JAMES	30	950.00	950.00
7521	WARD	30	1250.00	2200.00
7654	MARTIN	30	1250.00	3450.00
7844	TURNER	30	1500.00	4950.00
7499	ALLEN	30	1600.00	6550.00
7698	BLAKE	30	2850.00	9400.00

SELECT 
    empno,
    ename,
    deptno,
    sal,
    SUM(sal) OVER (
        PARTITION BY deptno 
        ORDER BY sal, empno
    ) AS cumulative_salary
FROM 
    emp
ORDER BY deptno, sal;

EMPNO	ENAME	DEPTNO	SAL	CUMULATIVE_SALARY
7934	MILLER	10	1300.00	1300.00
7782	CLARK	10	2450.00	3750.00
7839	KING	10	5000.00	8750.00
7369	SMITH	20	800.00	800.00
7876	ADAMS	20	1100.00	1900.00
7566	JONES	20	2975.00	4875.00
7788	SCOTT	20	3000.00	7875.00
7902	FORD	20	3000.00	10875.00
7900	JAMES	30	950.00	950.00
7521	WARD	30	1250.00	2200.00
7654	MARTIN	30	1250.00	3450.00
7844	TURNER	30	1500.00	4950.00
7499	ALLEN	30	1600.00	6550.00
7698	BLAKE	30	2850.00	9400.00


SELECT 
    empno,
    ename,
    deptno,
    sal,
    SUM(sal) OVER (
        PARTITION BY deptno 
        ORDER BY sal ASC NULLS LAST, empno ASC NULLS LAST
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_salary
FROM 
    emp
ORDER BY deptno, sal, empno;


EMPNO	ENAME	DEPTNO	SAL	CUMULATIVE_SALARY
7934	MILLER	10	1300.00	1300.00
7782	CLARK	10	2450.00	3750.00
7839	KING	10	5000.00	8750.00
7369	SMITH	20	800.00	800.00
7876	ADAMS	20	1100.00	1900.00
7566	JONES	20	2975.00	4875.00
7788	SCOTT	20	3000.00	7875.00
7902	FORD	20	3000.00	10875.00
7900	JAMES	30	950.00	950.00
7521	WARD	30	1250.00	2200.00
7654	MARTIN	30	1250.00	3450.00
7844	TURNER	30	1500.00	4950.00
7499	ALLEN	30	1600.00	6550.00
7698	BLAKE	30	2850.00	9400.00


-----------------------------------------------------------------


-- Table A: List of countries (Team A)
CREATE OR REPLACE TABLE TableA (
    country STRING
);

-- Table B: List of countries (Team B)
CREATE OR REPLACE TABLE TableB (
    country STRING
);

-- Insert countries into TableA
INSERT INTO TableA (country) VALUES
('India'),
('Australia'),
('England'),
('South Africa');

-- Insert countries into TableB
INSERT INTO TableB (country) VALUES
('Pakistan'),
('New Zealand'),
('Sri Lanka'),
('West Indies'),
('India');

TableA contains: India, Australia, England, South Africa

TableB contains: Pakistan, West Indies, New Zealand, Sri Lanka

There is no overlap—no country appears in both tables. So when you run:

SELECT 
    A.country AS team_1,
    B.country AS team_2
FROM 
    TableA A
CROSS JOIN 
    TableB B;

TEAM_1	TEAM_2
India	Pakistan
India	West Indies
India	India
India	New Zealand
India	Sri Lanka
Australia	Pakistan
Australia	West Indies
Australia	India
Australia	New Zealand
Australia	Sri Lanka
England	Pakistan
England	West Indies
England	India
England	New Zealand
England	Sri Lanka
South Africa	Pakistan
South Africa	West Indies
South Africa	India
South Africa	New Zealand
South Africa	Sri Lanka

SELECT 
    A.country AS team_1,
    B.country AS team_2
FROM 
    TableA A
CROSS JOIN 
    TableB B
WHERE 
    A.country != B.country;

TEAM_1	TEAM_2
India	Pakistan
India	West Indies
India	New Zealand
India	Sri Lanka
Australia	Pakistan
Australia	West Indies
Australia	India
Australia	New Zealand
Australia	Sri Lanka
England	Pakistan
England	West Indies
England	India
England	New Zealand
England	Sri Lanka
South Africa	Pakistan
South Africa	West Indies
South Africa	India
South Africa	New Zealand
South Africa	Sri Lanka

   SELECT 
    A.country AS team_1,
    B.country AS team_2
FROM 
    TableA A
JOIN 
    TableA B
ON 
    A.country < B.country;

TEAM_1	TEAM_2
India	South Africa
Australia	India
Australia	South Africa
Australia	England
England	India
England	South Africa

You want to generate unique country matchups where each pair appears only once, and India vs Australia is included but Australia vs India is excluded. This means you are looking for non-repeating, non-reversed combinations across both tables.

SELECT 
    A.country AS team_1,
    B.country AS team_2
FROM 
    (
        SELECT country FROM TableA
        UNION
        SELECT country FROM TableB
    ) A
JOIN 
    (
        SELECT country FROM TableA
        UNION
        SELECT country FROM TableB
    ) B
ON 
    A.country < B.country;


TEAM_1	TEAM_2
New Zealand	Sri Lanka
New Zealand	South Africa
New Zealand	West Indies
New Zealand	Pakistan
Australia	Sri Lanka
Australia	England
Australia	South Africa
Australia	West Indies
Australia	India
Australia	Pakistan
Australia	New Zealand
South Africa	Sri Lanka
South Africa	West Indies
Sri Lanka	West Indies
England	Sri Lanka
England	South Africa
England	West Indies
England	India
England	Pakistan
England	New Zealand
Pakistan	Sri Lanka
Pakistan	South Africa
Pakistan	West Indies
India	Sri Lanka
India	South Africa
India	West Indies
India	Pakistan
India	New Zealand

