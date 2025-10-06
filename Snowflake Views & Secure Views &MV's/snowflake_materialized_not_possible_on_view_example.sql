Question:
Is it possible to create a materialized view based on an existing view in Snowflake?

Answer:
In Snowflake, you cannot create a materialized view based on another view. 
Materialized views must be defined directly on base tables, not on views (regular or secure)


CREATE TABLE employees12 (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10, 2),
    hire_date DATE
);

INSERT INTO employees12 (employee_id, name, department, salary, hire_date)
VALUES
    (1, 'Aarav Mehta', 'Engineering', 120000.00, '2022-06-15'),
    (2, 'Neha Sharma', 'Marketing', 95000.00, '2023-01-10'),
    (3, 'Ravi Kumar', 'Finance', 105000.00, '2021-09-25');



CREATE VIEW high_earners AS
SELECT
    employee_id,
    name,
    department,
    salary
FROM
    employees12
WHERE
    salary > 100000;

CREATE MATERIALIZED VIEW mv_high_earners_summary AS
SELECT
    department,
    COUNT(*) AS num_high_earners,
    AVG(salary) AS avg_high_salary
FROM
    high_earners
GROUP BY
    department;

SQL compilation error: error line 35 at position 4 Invalid materialized view definition. 'HIGH_EARNERS' should be a table.


