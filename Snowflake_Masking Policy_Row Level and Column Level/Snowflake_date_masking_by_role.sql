Question:
*****************************
In Snowflake, how would you implement a masking policy on a DATE column so that non-admin users only see the year portion of the date, 
while admin users see the full date? Explain the logic and show how you would apply it to a table.

CREATE OR REPLACE TABLE employee_data (
    emp_id INT,
    birth_date DATE
);

INSERT INTO employee_data VALUES
(101, '1990-07-15'),
(102, '1985-12-03');

CREATE OR REPLACE MASKING POLICY mask_birth_year_only 
AS (val DATE)
RETURNS DATE ->
    CASE 
        WHEN CURRENT_ROLE() IN ('ADMIN', 'ACCOUNTADMIN') THEN val
        ELSE DATE_TRUNC('YEAR', val)
    END;

ALTER TABLE employee_data 
MODIFY COLUMN birth_date SET MASKING POLICY mask_birth_year_only;

USE ROLE ACCOUNTADMIN;

SELECT * FROM employee_data;

EMP_ID	BIRTH_DATE
101	1990-07-15
102	1985-12-03

CREATE OR REPLACE ROLE analyst_role;
GRANT ROLE analyst_role TO USER prabhakarreddy1433;

GRANT USAGE ON DATABASE MYSNOW TO ROLE analyst_role;
GRANT USAGE ON SCHEMA MYSNOW.public TO ROLE analyst_role;
GRANT SELECT ON TABLE employee_data TO ROLE analyst_role;

USE ROLE analyst_role;
SELECT * FROM employee_data;

EMP_ID	BIRTH_DATE
101	1990-01-01
102	1985-01-01

