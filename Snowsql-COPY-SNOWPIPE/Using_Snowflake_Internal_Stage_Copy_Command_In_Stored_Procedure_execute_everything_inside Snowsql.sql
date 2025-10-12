
C:\Users\prabh>pip install "certifi<2025.4.26" -t C:/temp/certifi
Collecting certifi<2025.4.26
  Using cached certifi-2025.1.31-py3-none-any.whl.metadata (2.5 kB)
Using cached certifi-2025.1.31-py3-none-any.whl (166 kB)
Installing collected packages: certifi
Successfully installed certifi-2025.1.31
WARNING: Target directory C:\temp\certifi\certifi already exists. Specify --upgrade to force replacement.
WARNING: Target directory C:\temp\certifi\certifi-2025.1.31.dist-info already exists. Specify --upgrade to force replacement.

C:\Users\prabh>set REQUESTS_CA_BUNDLE=C:\temp\certifi\certifi\cacert.pem

C:\Users\prabh>snowsql -a JABGDWO-GY97629 -u prabhakarreddy1433
Password:
* SnowSQL * v1.3.3
Type SQL statements or !help
prabhakarreddy143#COMPUTE_WH@(no database).(no schema)>USE DATABASE MYSNOW;
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+
1 Row(s) produced. Time Elapsed: 0.193s
prabhakarreddy143#COMPUTE_WH@MYSNOW.PUBLIC>USE SCHEMA PUBLIC;


C:/Snowflakefilesprabha/employee_data2.csv

emp_id,emp_name,department,salary
101,John Doe,Sales,75000
102,Jane Smith,Marketing,82000
103,Ali Khan,Engineering,95000
104,Mei Lin,Finance,88000
105,Mei Lin1,Finance,90000
106,Mei Lin1,Finance,90000



prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>CREATE OR REPLACE TABLE employee_data2 (emp_id INT,emp_name STRING,department STRING,salary NUMBER);
+--------------------------------------------+
| status                                     |
|--------------------------------------------|
| Table EMPLOYEE_DATA2 successfully created. |
+--------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.279s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>create or replace stage employee_data2;
+-------------------------------------------------+
| status                                          |
|-------------------------------------------------|
| Stage area EMPLOYEE_DATA2 successfully created. |
+-------------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.186s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>PUT file://C:/Snowflakefilesprabha/employee_data2.csv @employee_data2;
+--------------------+-----------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source             | target                | source_size | target_size | source_compression | target_compression | status   | message |
|--------------------+-----------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| employee_data2.csv | employee_data2.csv.gz |         208 |         176 | NONE               | GZIP               | UPLOADED |         |
+--------------------+-----------------------+-------------+-------------+--------------------+--------------------+----------+---------+
1 Row(s) produced. Time Elapsed: 1.800s



-- Stored Procedure: Load employee data from stage to employee_data2
CREATE OR REPLACE PROCEDURE sp_load_employee_data2()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    copy_status STRING;
BEGIN
    -- Load data using COPY INTO from staged compressed CSV
    COPY INTO employee_data2
    FROM @employee_data2/employee_data2.csv.gz
    FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1)
    ON_ERROR = 'CONTINUE';  -- Optional: skip bad records

    -- Assign success message using := syntax
    copy_status := 'Data load completed into employee_data_final.';
    RETURN copy_status;
END;
$$;

Save your file: 
***************************
C:/Snowflakefilesprabha/sp_load_employee_data2.sql



prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>!source C:/Snowflakefilesprabha/sp_load_employee_data2.sql
+-------------------------------------------------------+
| status                                                |
|-------------------------------------------------------|
| Function SP_LOAD_EMPLOYEE_DATA2 successfully created. |
+-------------------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.268s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data2;
+--------+----------+------------+--------+
| EMP_ID | EMP_NAME | DEPARTMENT | SALARY |
|--------+----------+------------+--------|
+--------+----------+------------+--------+
0 Row(s) produced. Time Elapsed: 0.163s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>CALL sp_load_employee_data2();
+-----------------------------------------------+
| SP_LOAD_EMPLOYEE_DATA2                        |
|-----------------------------------------------|
| Data load completed into employee_data_final. |
+-----------------------------------------------+
1 Row(s) produced. Time Elapsed: 1.238s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data2;
+--------+------------+-------------+--------+
| EMP_ID | EMP_NAME   | DEPARTMENT  | SALARY |
|--------+------------+-------------+--------|
|    101 | John Doe   | Sales       |  75000 |
|    102 | Jane Smith | Marketing   |  82000 |
|    103 | Ali Khan   | Engineering |  95000 |
|    104 | Mei Lin    | Finance     |  88000 |
|    105 | Mei Lin1   | Finance     |  90000 |
|    106 | Mei Lin1   | Finance     |  90000 |
+--------+------------+-------------+--------+
6 Row(s) produced. Time Elapsed: 0.304s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>