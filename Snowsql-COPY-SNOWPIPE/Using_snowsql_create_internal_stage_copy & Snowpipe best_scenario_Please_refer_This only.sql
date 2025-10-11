
C:/Snowflakefilesprabha/employee_data_final.csv

emp_id,emp_name,department,salary
101,John Doe,Sales,75000
102,Jane Smith,Marketing,82000
103,Ali Khan,Engineering,95000
104,Mei Lin,Finance,88000
105,Mei Lin1,Finance,90000




prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>CREATE OR REPLACE TABLE employee_data_final (emp_id INT,emp_name STRING,department STRING,salary NUMBER);
+-------------------------------------------------+
| status                                          |
|-------------------------------------------------|
| Table EMPLOYEE_DATA_FINAL successfully created. |
+-------------------------------------------------+
1 Row(s) produced. Time Elapsed: 1.633s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>create or replace stage employee_stage_final;
+-------------------------------------------------------+
| status                                                |
|-------------------------------------------------------|
| Stage area EMPLOYEE_STAGE_FINAL successfully created. |
+-------------------------------------------------------+


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>PUT file://C:/Snowflakefilesprabha/employee_data_final.csv @employee_stage_final;
+-------------------------+----------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source                  | target                     | source_size | target_size | source_compression | target_compression | status   | message |
|-------------------------+----------------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| employee_data_final.csv | employee_data_final.csv.gz |         180 |         192 | NONE               | GZIP               | UPLOADED |         |
+-------------------------+----------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
1 Row(s) produced. Time Elapsed: 1.727s


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>COPY INTO employee_data_final FROM @employee_stage_final/employee_data_final.csv.gz FILE_FORMAT = (TYPE = 'CSV'
                                             FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);
+-------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                                            | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|-------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| employee_stage_final/employee_data_final.csv.gz | LOADED |           5 |           5 |           1 |           0 | NULL        |             NULL |                  NULL | NULL                    |
+-------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
1 Row(s) produced. Time Elapsed: 0.589s


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data_final;
+--------+------------+-------------+--------+
| EMP_ID | EMP_NAME   | DEPARTMENT  | SALARY |
|--------+------------+-------------+--------|
|    101 | John Doe   | Sales       |  75000 |
|    102 | Jane Smith | Marketing   |  82000 |
|    103 | Ali Khan   | Engineering |  95000 |
|    104 | Mei Lin    | Finance     |  88000 |
|    105 | Mei Lin1   | Finance     |  90000 |
+--------+------------+-------------+--------+
5 Row(s) produced. Time Elapsed: 0.316s


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>COPY INTO employee_data_final FROM @employee_stage_final/employee_data_final.csv.gz FILE_FORMAT = (TYPE = 'CSV'
                                             FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);
+---------------------------------------+
| status                                |
|---------------------------------------|
| Copy executed with 0 files processed. |
+---------------------------------------+
1 Row(s) produced. Time Elapsed: 0.371s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>COPY INTO employee_data_final FROM @employee_stage_final/employee_data_final.csv.gz FILE_FORMAT = (TYPE = 'CSV'
                                             FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1) FORCE=TRUE;
+-------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                                            | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|-------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| employee_stage_final/employee_data_final.csv.gz | LOADED |           5 |           5 |           1 |           0 | NULL        |             NULL |                  NULL | NULL                    |
+-------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
1 Row(s) produced. Time Elapsed: 0.690s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data_final;
+--------+------------+-------------+--------+
| EMP_ID | EMP_NAME   | DEPARTMENT  | SALARY |
|--------+------------+-------------+--------|
|    101 | John Doe   | Sales       |  75000 |
|    102 | Jane Smith | Marketing   |  82000 |
|    103 | Ali Khan   | Engineering |  95000 |
|    104 | Mei Lin    | Finance     |  88000 |
|    105 | Mei Lin1   | Finance     |  90000 |
|    101 | John Doe   | Sales       |  75000 |
|    102 | Jane Smith | Marketing   |  82000 |
|    103 | Ali Khan   | Engineering |  95000 |
|    104 | Mei Lin    | Finance     |  88000 |
|    105 | Mei Lin1   | Finance     |  90000 |
+--------+------------+-------------+--------+
10 Row(s) produced. Time Elapsed: 0.289s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>




emp_id,emp_name,department,salary
101,John Doe,Sales,75000
102,Jane Smith,Marketing,82000
103,Ali Khan,Engineering,95000
104,Mei Lin,Finance,88000
105,Mei Lin1,Finance,90000
106,Mei Lin1,Finance,90000---Inserted this record 



prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>PUT file://C:/Snowflakefilesprabha/employee_data_final.csv @employee_stage_final OVERWRITE=TRUE;
+-------------------------+----------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source                  | target                     | source_size | target_size | source_compression | target_compression | status   | message |
|-------------------------+----------------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| employee_data_final.csv | employee_data_final.csv.gz |         208 |         192 | NONE               | GZIP               | UPLOADED |         |
+-------------------------+----------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
1 Row(s) produced. Time Elapsed: 1.702s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>COPY INTO employee_data_final FROM @employee_stage_final/employee_data_final.csv.gz FILE_FORMAT = (TYPE = 'CSV'
                                             FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1) ;
+-------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                                            | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|-------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| employee_stage_final/employee_data_final.csv.gz | LOADED |           6 |           6 |           1 |           0 | NULL        |             NULL |                  NULL | NULL                    |
+-------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
1 Row(s) produced. Time Elapsed: 0.686s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data_final;
+--------+------------+-------------+--------+
| EMP_ID | EMP_NAME   | DEPARTMENT  | SALARY |
|--------+------------+-------------+--------|
|    101 | John Doe   | Sales       |  75000 |
|    102 | Jane Smith | Marketing   |  82000 |
|    103 | Ali Khan   | Engineering |  95000 |
|    104 | Mei Lin    | Finance     |  88000 |
|    105 | Mei Lin1   | Finance     |  90000 |
|    101 | John Doe   | Sales       |  75000 |
|    102 | Jane Smith | Marketing   |  82000 |
|    103 | Ali Khan   | Engineering |  95000 |
|    104 | Mei Lin    | Finance     |  88000 |
|    105 | Mei Lin1   | Finance     |  90000 |
|    101 | John Doe   | Sales       |  75000 |
|    102 | Jane Smith | Marketing   |  82000 |
|    103 | Ali Khan   | Engineering |  95000 |
|    104 | Mei Lin    | Finance     |  88000 |
|    105 | Mei Lin1   | Finance     |  90000 |
|    106 | Mei Lin1   | Finance     |  90000 |
+--------+------------+-------------+--------+
16 Row(s) produced. Time Elapsed: 0.659s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>



prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>COPY INTO employee_data_final FROM @employee_stage_final/employee_data_final.csv.gz FILE_FORMAT = (TYPE = 'CSV'
                                             FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1) ;
+---------------------------------------+
| status                                |
|---------------------------------------|
| Copy executed with 0 files processed. |
+---------------------------------------+
1 Row(s) produced. Time Elapsed: 0.479s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>



prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>COPY INTO employee_data_final FROM @employee_stage_final/employee_data_final.csv.gz FILE_FORMAT = (TYPE = 'CSV'
                                             FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1) FORCE=TRUE;
+-------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                                            | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|-------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| employee_stage_final/employee_data_final.csv.gz | LOADED |           6 |           6 |           1 |           0 | NULL        |             NULL |                  NULL | NULL                    |
+-------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
1 Row(s) produced. Time Elapsed: 0.673s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>



prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data_final;
+--------+------------+-------------+--------+
| EMP_ID | EMP_NAME   | DEPARTMENT  | SALARY |
|--------+------------+-------------+--------|
|    101 | John Doe   | Sales       |  75000 |
|    102 | Jane Smith | Marketing   |  82000 |
|    103 | Ali Khan   | Engineering |  95000 |
|    104 | Mei Lin    | Finance     |  88000 |
|    105 | Mei Lin1   | Finance     |  90000 |
|    101 | John Doe   | Sales       |  75000 |
|    102 | Jane Smith | Marketing   |  82000 |
|    103 | Ali Khan   | Engineering |  95000 |
|    104 | Mei Lin    | Finance     |  88000 |
|    105 | Mei Lin1   | Finance     |  90000 |
|    101 | John Doe   | Sales       |  75000 |
|    102 | Jane Smith | Marketing   |  82000 |
|    103 | Ali Khan   | Engineering |  95000 |
|    104 | Mei Lin    | Finance     |  88000 |
|    105 | Mei Lin1   | Finance     |  90000 |
|    106 | Mei Lin1   | Finance     |  90000 |
|    101 | John Doe   | Sales       |  75000 |
|    102 | Jane Smith | Marketing   |  82000 |
|    103 | Ali Khan   | Engineering |  95000 |
|    104 | Mei Lin    | Finance     |  88000 |
|    105 | Mei Lin1   | Finance     |  90000 |
|    106 | Mei Lin1   | Finance     |  90000 |
+--------+------------+-------------+--------+
22 Row(s) produced. Time Elapsed: 0.277s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>



C:/Snowflakefilesprabha/employee_data_final_snowpipe.csv

emp_id,emp_name,department,salary
101,John Doe,Sales,75000
102,Jane Smith,Marketing,82000
103,Ali Khan,Engineering,95000
104,Mei Lin,Finance,88000
105,Mei Lin1,Finance,90000
106,Mei Lin1,Finance,90000





prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>PUT file://C:/Snowflakefilesprabha/employee_data_final_snowpipe.csv @employee_stage_final OVERWRITE=TRUE;
+----------------------------------+-------------------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source                           | target                              | source_size | target_size | source_compression | target_compression | status   | message |
|----------------------------------+-------------------------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| employee_data_final_snowpipe.csv | employee_data_final_snowpipe.csv.gz |         208 |         192 | NONE               | GZIP               | UPLOADED |         |
+----------------------------------+-------------------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
1 Row(s) produced. Time Elapsed: 2.416s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>TRUNCATE TABLE employee_data_final;
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+
1 Row(s) produced. Time Elapsed: 0.322s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>CREATE OR REPLACE PIPE employee_pipe_final AUTO_INGEST = FALSE AS COPY INTO employee_data_final FROM @employee_
                                            stage_final/employee_data_final_snowpipe.csv.gz FILE_FORMAT = ( TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"'
                                             SKIP_HEADER = 1);
+------------------------------------------------+
| status                                         |
|------------------------------------------------|
| Pipe EMPLOYEE_PIPE_FINAL successfully created. |
+------------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.269s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data_final;
+--------+----------+------------+--------+
| EMP_ID | EMP_NAME | DEPARTMENT | SALARY |
|--------+----------+------------+--------|
+--------+----------+------------+--------+
0 Row(s) produced. Time Elapsed: 0.349s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>ALTER PIPE employee_pipe_final REFRESH;
+------+--------+
| File | Status |
|------+--------|
|      | SENT   |
+------+--------+
1 Row(s) produced. Time Elapsed: 0.557s



prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data_final;
+--------+----------+------------+--------+
| EMP_ID | EMP_NAME | DEPARTMENT | SALARY |
|--------+----------+------------+--------|
+--------+----------+------------+--------+
0 Row(s) produced. Time Elapsed: 0.349s


Since the last operation was to attempt a pipe refresh, you just need to wait a few moments and run the SELECT * command again.
Wait and Re-query: The ingestion process can take anywhere from a few seconds to 
a minute or two to start and complete, depending on the current serverless resource availability.



-- Wait about 30-60 seconds...

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data_final;
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
6 Row(s) produced. Time Elapsed: 0.570s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>



prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>CREATE OR REPLACE PIPE employee_pipe_final AUTO_INGEST = FALSE AS COPY INTO employee_data_final FROM @employee_
                                            stage_final/employee_data_final_snowpipe.csv.gz FILE_FORMAT = ( TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"'
                                             SKIP_HEADER = 1);
+------------------------------------------------+
| status                                         |
|------------------------------------------------|
| Pipe EMPLOYEE_PIPE_FINAL successfully created. |
+------------------------------------------------+
1 Row(s) produced. Time Elapsed: 4.227s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data_final;
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
6 Row(s) produced. Time Elapsed: 0.124s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>ALTER PIPE employee_pipe_final REFRESH;
+------+--------+
| File | Status |
|------+--------|
|      | SENT   |
+------+--------+
1 Row(s) produced. Time Elapsed: 0.548s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data_final;
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
6 Row(s) produced. Time Elapsed: 0.163s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>



You received the error: Invalid copy option 'FORCE' in pipe definition. 
because the FORCE=TRUE copy option is not supported when defining a Snowpipe.

Snowpipe is designed for continuous, incremental loading where FORCE=TRUE 
would cause massive duplication by default, defeating the purpose of its automatic load history tracking.

Explanation of the Error
Why FORCE=TRUE is Invalid for Pipes
Load History Conflict: Snowpipes primary function is deduplication and continuous ingestion of new files. 
It automatically tracks the files it has loaded into the target table (employee_data_final) using metadata stored in the pipe object.

FORCE=TRUE Overrides: The FORCE=TRUE option explicitly tells Snowflake to ignore the load history and re-load the file.

Design Conflict: Because the pipe is designed to be run continuously, 
including FORCE=TRUE would mean that every time the pipe runs (on refresh or via event), 
it would re-load every single file in the stage, leading to immediate and severe data duplication. 
Therefore, Snowflake prevents this option in the pipe definition to protect data integrity.

Correct Syntax for Your Pipe
To correctly define your pipe for future use without the error, simply remove the FORCE=TRUE option:

SQL

CREATE OR REPLACE PIPE employee_pipe_final AUTO_INGEST = FALSE AS 
COPY INTO employee_data_final 
FROM @employee_stage_final/employee_data_final_snowpipe.csv.gz 
FILE_FORMAT = ( 
    TYPE = 'CSV' 
    FIELD_OPTIONALLY_ENCLOSED_BY = '"' 
    SKIP_HEADER = 1
);






