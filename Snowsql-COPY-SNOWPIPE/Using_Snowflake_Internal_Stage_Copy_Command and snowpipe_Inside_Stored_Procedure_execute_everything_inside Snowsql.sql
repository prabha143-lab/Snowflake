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


C:/Snowflakefilesprabha/employee_data2_snowpipe_test.csv

emp_id,emp_name,department,salary
101,John Doe,Sales,75000
102,Jane Smith,Marketing,82000
103,Ali Khan,Engineering,95000
104,Mei Lin,Finance,88000
105,Mei Lin1,Finance,90000
106,Mei Lin1,Finance,90000




prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>CREATE OR REPLACE TABLE employee_data2_snowpipe_test (emp_id INT,emp_name STRING,department STRING,salary NUMBE
                                            R);
+----------------------------------------------------------+
| status                                                   |
|----------------------------------------------------------|
| Table EMPLOYEE_DATA2_SNOWPIPE_TEST successfully created. |
+----------------------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.296s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>create or replace stage employee_data2_snowpipe_test;
+---------------------------------------------------------------+
| status                                                        |
|---------------------------------------------------------------|
| Stage area EMPLOYEE_DATA2_SNOWPIPE_TEST successfully created. |
+---------------------------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.236s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>PUT file://C:/Snowflakefilesprabha/employee_data2_snowpipe_test.csv @employee_data2_snowpipe_test;
+----------------------------------+-------------------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source                           | target                              | source_size | target_size | source_compression | target_compression | status   | message |
|----------------------------------+-------------------------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| employee_data2_snowpipe_test.csv | employee_data2_snowpipe_test.csv.gz |         208 |         192 | NONE               | GZIP               | UPLOADED |         |
+----------------------------------+-------------------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
1 Row(s) produced. Time Elapsed: 1.803s




-- Stored Procedure: Load employee data from stage to employee_data2_pipe_test
CREATE OR REPLACE PROCEDURE sp_load_employee_data2_snowpipe_test()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    pipe_status STRING;
BEGIN
    CREATE OR REPLACE PIPE employee_data2_pipe_test
    AUTO_INGEST = FALSE
    AS
    COPY INTO employee_data2_snowpipe_test
    FROM @employee_data2_snowpipe_test/employee_data2_snowpipe_test.csv.gz
    FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1)
    ON_ERROR = 'CONTINUE';  -- Optional: skip bad records
    
	ALTER PIPE employee_data2_pipe_test REFRESH;
	
    -- Assign success message using := syntax
    pipe_status := 'Data load completed into employee_data2_pipe_test.';
    RETURN pipe_status;
END;
$$;

Save:
*************
C:/Snowflakefilesprabha/sp_load_employee_data2_snowpipe_test.sql


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>!source C:/Snowflakefilesprabha/sp_load_employee_data2_snowpipe_test.sql
+---------------------------------------------------------------------+
| status                                                              |
|---------------------------------------------------------------------|
| Function SP_LOAD_EMPLOYEE_DATA2_SNOWPIPE_TEST successfully created. |
+---------------------------------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.743s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data2_snowpipe_test;
+--------+----------+------------+--------+
| EMP_ID | EMP_NAME | DEPARTMENT | SALARY |
|--------+----------+------------+--------|
+--------+----------+------------+--------+
0 Row(s) produced. Time Elapsed: 0.156s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data2_snowpipe_test;
+--------+----------+------------+--------+
| EMP_ID | EMP_NAME | DEPARTMENT | SALARY |
|--------+----------+------------+--------|
+--------+----------+------------+--------+
0 Row(s) produced. Time Elapsed: 0.192s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>CALL sp_load_employee_data2_snowpipe_test();
+----------------------------------------------------+
| SP_LOAD_EMPLOYEE_DATA2_SNOWPIPE_TEST               |
|----------------------------------------------------|
| Data load completed into employee_data2_pipe_test. |
+----------------------------------------------------+
1 Row(s) produced. Time Elapsed: 1.656s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data2_snowpipe_test;
+--------+----------+------------+--------+
| EMP_ID | EMP_NAME | DEPARTMENT | SALARY |
|--------+----------+------------+--------|
+--------+----------+------------+--------+
0 Row(s) produced. Time Elapsed: 0.163s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data2_snowpipe_test;
+--------+----------+------------+--------+
| EMP_ID | EMP_NAME | DEPARTMENT | SALARY |
|--------+----------+------------+--------|
+--------+----------+------------+--------+
0 Row(s) produced. Time Elapsed: 0.221s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data2_snowpipe_test;
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
6 Row(s) produced. Time Elapsed: 0.884s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>