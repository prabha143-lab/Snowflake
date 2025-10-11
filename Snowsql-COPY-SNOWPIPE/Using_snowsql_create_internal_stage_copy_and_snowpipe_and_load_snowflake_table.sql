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
prabhakarreddy1433#COMPUTE_WH@(no database).(no schema)>USE DATABASE MYSNOW;
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+
1 Row(s) produced. Time Elapsed: 0.584s



prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>CREATE OR REPLACE TABLE employee_data (emp_id INT,emp_name STRING,department STRING,salary NUMBER);
+-------------------------------------------+
| status                                    |
|-------------------------------------------|
| Table EMPLOYEE_DATA successfully created. |
+-------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.201s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>create or replace stage employee_stage;
+-------------------------------------------------+
| status                                          |
|-------------------------------------------------|
| Stage area EMPLOYEE_STAGE successfully created. |
+-------------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.160s


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SHOW STAGES;
+-------------------------------+----------------+---------------+-------------+-----+-----------------+--------------------+--------------+---------+--------+----------+-------+----------------------+---------------------+----------+-----------------+-------------------+
| created_on                    | name           | database_name | schema_name | url | has_credentials | has_encryption_key | owner        | comment | region | type     | cloud | notification_channel | storage_integration | endpoint | owner_role_type | directory_enabled |
|-------------------------------+----------------+---------------+-------------+-----+-----------------+--------------------+--------------+---------+--------+----------+-------+----------------------+---------------------+----------+-----------------+-------------------|
| 2025-10-11 07:18:05.778 -0700 | EMPLOYEE_STAGE | MYSNOW        | PUBLIC      |     | N               | N                  | ACCOUNTADMIN |         | NULL   | INTERNAL | NULL  | NULL                 | NULL                | NULL     | ROLE            | N                 |
+-------------------------------+----------------+---------------+-------------+-----+-----------------+--------------------+--------------+---------+--------+----------+-------+----------------------+---------------------+----------+-----------------+-------------------+
1 Row(s) produced. Time Elapsed: 0.132s


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>PUT file://C:/Snowflakefilesprabha/employee_data_test.csv @employee_stage;
+------------------------+---------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source                 | target                    | source_size | target_size | source_compression | target_compression | status   | message |
|------------------------+---------------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| employee_data_test.csv | employee_data_test.csv.gz |         152 |         176 | NONE               | GZIP               | UPLOADED |         |
+------------------------+---------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
1 Row(s) produced. Time Elapsed: 1.788s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>COPY INTO employee_data FROM @employee_stage/employee_data_test.csv.gz FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTION
                                            ALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);
+------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                                     | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| employee_stage/employee_data_test.csv.gz | LOADED |           4 |           4 |           1 |           0 | NULL        |             NULL |                  NULL | NULL                    |
+------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
1 Row(s) produced. Time Elapsed: 0.945s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>



prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data;
+--------+------------+-------------+--------+
| EMP_ID | EMP_NAME   | DEPARTMENT  | SALARY |
|--------+------------+-------------+--------|
|    101 | John Doe   | Sales       |  75000 |
|    102 | Jane Smith | Marketing   |  82000 |
|    103 | Ali Khan   | Engineering |  95000 |
|    104 | Mei Lin    | Finance     |  88000 |
+--------+------------+-------------+--------+
4 Row(s) produced. Time Elapsed: 0.410s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>



prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY( TABLE_NAME => 'EMPLOYEE_DATA', START_TIME => DATEADD(HOUR,
                                             -24, CURRENT_TIMESTAMP())));
+---------------------------+----------------------------------------------+-------------------------------+-----------+------------+-----------+---------------------+-------------------------+---------------------------+-------------------------+-------------+-------------+--------+--------------------+-------------------+---------------+-------------------+------------------+-----------+--------------------+--------------+
| FILE_NAME                 | STAGE_LOCATION                               | LAST_LOAD_TIME                | ROW_COUNT | ROW_PARSED | FILE_SIZE | FIRST_ERROR_MESSAGE | FIRST_ERROR_LINE_NUMBER | FIRST_ERROR_CHARACTER_POS | FIRST_ERROR_COLUMN_NAME | ERROR_COUNT | ERROR_LIMIT | STATUS | TABLE_CATALOG_NAME | TABLE_SCHEMA_NAME | TABLE_NAME    | PIPE_CATALOG_NAME | PIPE_SCHEMA_NAME | PIPE_NAME | PIPE_RECEIVED_TIME | BYTES_BILLED |
|---------------------------+----------------------------------------------+-------------------------------+-----------+------------+-----------+---------------------+-------------------------+---------------------------+-------------------------+-------------+-------------+--------+--------------------+-------------------+---------------+-------------------+------------------+-----------+--------------------+--------------|
| employee_data_test.csv.gz | stages/53ac9f01-96d9-4029-abd7-ae7b4926c025/ | 2025-10-11 07:22:18.960 -0700 |         4 |          4 |       176 | NULL                |                    NULL |                      NULL | NULL                    |           0 |           1 | Loaded | MYSNOW             | PUBLIC            | EMPLOYEE_DATA | NULL              | NULL             | NULL      | NULL               |         NULL |
+---------------------------+----------------------------------------------+-------------------------------+-----------+------------+-----------+---------------------+-------------------------+---------------------------+-------------------------+-------------+-------------+--------+--------------------+-------------------+---------------+-------------------+------------------+-----------+--------------------+--------------+
1 Row(s) produced. Time Elapsed: 0.664s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>TRUNCATE TABLE employee_data;
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+
1 Row(s) produced. Time Elapsed: 0.394s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data;
+--------+----------+------------+--------+
| EMP_ID | EMP_NAME | DEPARTMENT | SALARY |
|--------+----------+------------+--------|
+--------+----------+------------+--------+
0 Row(s) produced. Time Elapsed: 0.357s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>CREATE OR REPLACE PIPE employee_pipe AUTO_INGEST = FALSE AS COPY INTO employee_data FROM @employee_stage/employ
                                            ee_data_test.csv.gz FILE_FORMAT = ( TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);
+------------------------------------------+
| status                                   |
|------------------------------------------|
| Pipe EMPLOYEE_PIPE successfully created. |
+------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.265s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data;
+--------+----------+------------+--------+
| EMP_ID | EMP_NAME | DEPARTMENT | SALARY |
|--------+----------+------------+--------|
+--------+----------+------------+--------+
0 Row(s) produced. Time Elapsed: 0.144s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>ALTER PIPE employee_pipe REFRESH;
+------+--------+
| File | Status |
|------+--------|
|      | SENT   |
+------+--------+
1 Row(s) produced. Time Elapsed: 0.535s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data;
+--------+----------+------------+--------+
| EMP_ID | EMP_NAME | DEPARTMENT | SALARY |
|--------+----------+------------+--------|
+--------+----------+------------+--------+
0 Row(s) produced. Time Elapsed: 0.180s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>



The records were not recopied into the employee_data table after the 
ALTER PIPE employee_pipe REFRESH command because the Snowpipe refresh 
operation only loads new or modified files in the stage that haven't been loaded before.

Here's a breakdown of why:

Initial Load and Tracking: You successfully loaded the file
 employee_data_test.csv.gz into the employee_data table using a COPY INTO command.

Tracking Mechanism: Snowflake tracks the files that have been 
successfully loaded from a stage into a table. 
The COPY_HISTORY output confirms this file was loaded at 2025-10-11 07:22:18.960 -0700.

Table Truncation: You used TRUNCATE TABLE employee_data, which empties the table 
but does not clear the load history associated with the staged files.

Pipe Creation and Refresh:

You created a Snowpipe (employee_pipe) referencing the same file: @employee_stage/employee_data_test.csv.gz.

You then executed ALTER PIPE employee_pipe REFRESH. This command attempts 
to load new files that appeared in the stage after the pipe was created.

No New Files: Since the file employee_data_test.csv.gz was already loaded into
the employee_data table prior to the pipe refresh (as recorded in the load history), 
Snowpipe considers it an already processed file and skips loading it again, even though the target table was truncated. 
The ALTER PIPE... REFRESH command successfully sent a request (Status: SENT), 
but the background copy process found no new files to load.




prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>PUT file://C:/Snowflakefilesprabha/employee_data_test_snowpipe.csv @employee_stage;
+---------------------------------+------------------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source                          | target                             | source_size | target_size | source_compression | target_compression | status   | message |
|---------------------------------+------------------------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| employee_data_test_snowpipe.csv | employee_data_test_snowpipe.csv.gz |         152 |         192 | NONE               | GZIP               | UPLOADED |         |
+---------------------------------+------------------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
1 Row(s) produced. Time Elapsed: 1.986s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>



prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>CREATE OR REPLACE PIPE employee_pipe AUTO_INGEST = FALSE AS COPY INTO employee_data FROM @employee_stage/employ
                                            ee_data_test_snowpipe.csv.gz FILE_FORMAT = ( TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);
+------------------------------------------+
| status                                   |
|------------------------------------------|
| Pipe EMPLOYEE_PIPE successfully created. |
+------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.364s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data;
+--------+------------+-------------+--------+
| EMP_ID | EMP_NAME   | DEPARTMENT  | SALARY |
|--------+------------+-------------+--------|
|    101 | John Doe   | Sales       |  75000 |
|    102 | Jane Smith | Marketing   |  82000 |
|    103 | Ali Khan   | Engineering |  95000 |
|    104 | Mei Lin    | Finance     |  88000 |
+--------+------------+-------------+--------+
4 Row(s) produced. Time Elapsed: 0.906s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>