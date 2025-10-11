C:/Snowflakefilesprabha/employee_data_test2.csv

emp_id,emp_name,department,salary
101,John Doe,Sales,75000
102,Jane Smith,Marketing,82000
103,Ali Khan,Engineering,95000
104,Mei Lin,Finance,88000



prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>CREATE OR REPLACE TABLE employee_data (emp_id INT,emp_name STRING,department STRING,salary NUMBER);
+-------------------------------------------+
| status                                    |
|-------------------------------------------|
| Table EMPLOYEE_DATA successfully created. |
+-------------------------------------------+
1 Row(s) produced. Time Elapsed: 3.598s


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data;
+--------+----------+------------+--------+
| EMP_ID | EMP_NAME | DEPARTMENT | SALARY |
|--------+----------+------------+--------|
+--------+----------+------------+--------+
0 Row(s) produced. Time Elapsed: 0.163s


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>create or replace stage employee_stage;
+-------------------------------------------------+
| status                                          |
|-------------------------------------------------|
| Stage area EMPLOYEE_STAGE successfully created. |
+-------------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.443s


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>PUT file://C:/Snowflakefilesprabha/employee_data_test2.csv @employee_stage;
+-------------------------+----------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source                  | target                     | source_size | target_size | source_compression | target_compression | status   | message |
|-------------------------+----------------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| employee_data_test2.csv | employee_data_test2.csv.gz |         152 |         176 | NONE               | GZIP               | UPLOADED |         |
+-------------------------+----------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
1 Row(s) produced. Time Elapsed: 1.709s


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>COPY INTO employee_data FROM @employee_stage/employee_data_test2.csv.gz FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIO
                                            NALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);
+-------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                                      | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|-------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| employee_stage/employee_data_test2.csv.gz | LOADED |           4 |           4 |           1 |           0 | NULL        |             NULL |                  NULL | NULL                    |
+-------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
1 Row(s) produced. Time Elapsed: 1.094s


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data;
+--------+------------+-------------+--------+
| EMP_ID | EMP_NAME   | DEPARTMENT  | SALARY |
|--------+------------+-------------+--------|
|    101 | John Doe   | Sales       |  75000 |
|    102 | Jane Smith | Marketing   |  82000 |
|    103 | Ali Khan   | Engineering |  95000 |
|    104 | Mei Lin    | Finance     |  88000 |
+--------+------------+-------------+--------+
4 Row(s) produced. Time Elapsed: 0.421s


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>CREATE OR REPLACE PIPE employee_pipe AUTO_INGEST = FALSE AS COPY INTO employee_data FROM @employee_stage/employ
                                            ee_data_test2.csv.gz FILE_FORMAT = ( TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);
+------------------------------------------+
| status                                   |
|------------------------------------------|
| Pipe EMPLOYEE_PIPE successfully created. |
+------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.470s


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data;
+--------+------------+-------------+--------+
| EMP_ID | EMP_NAME   | DEPARTMENT  | SALARY |
|--------+------------+-------------+--------|
|    101 | John Doe   | Sales       |  75000 |
|    102 | Jane Smith | Marketing   |  82000 |
|    103 | Ali Khan   | Engineering |  95000 |
|    104 | Mei Lin    | Finance     |  88000 |
+--------+------------+-------------+--------+
4 Row(s) produced. Time Elapsed: 0.128s


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>TRUNCATE TABLE employee_data;
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+
1 Row(s) produced. Time Elapsed: 0.396s


emp_id,emp_name,department,salary
101,John Doe,Sales,75000
102,Jane Smith,Marketing,82000
103,Ali Khan,Engineering,95000
104,Mei Lin,Finance,88000
105,Mei Lin1,Finance,90000---Now i have inserted this record 


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>CREATE OR REPLACE PIPE employee_pipe AUTO_INGEST = FALSE AS COPY INTO employee_data FROM @employee_stage/employ
                                            ee_data_test2.csv.gz FILE_FORMAT = ( TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);
+------------------------------------------+
| status                                   |
|------------------------------------------|
| Pipe EMPLOYEE_PIPE successfully created. |
+------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.266s


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data;
+--------+----------+------------+--------+
| EMP_ID | EMP_NAME | DEPARTMENT | SALARY |
|--------+----------+------------+--------|
+--------+----------+------------+--------+
0 Row(s) produced. Time Elapsed: 0.350s


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>ALTER PIPE employee_pipe REFRESH;
+------+--------+
| File | Status |
|------+--------|
|      | SENT   |
+------+--------+
1 Row(s) produced. Time Elapsed: 0.558s


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data;
+--------+----------+------------+--------+
| EMP_ID | EMP_NAME | DEPARTMENT | SALARY |
|--------+----------+------------+--------|
+--------+----------+------------+--------+
0 Row(s) produced. Time Elapsed: 0.278s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>COPY INTO employee_data FROM @employee_stage/employee_data_test2.csv.gz FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIO
                                            NALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);
+-------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                                      | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|-------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| employee_stage/employee_data_test2.csv.gz | LOADED |           4 |           4 |           1 |           0 | NULL        |             NULL |                  NULL | NULL                    |
+-------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
1 Row(s) produced. Time Elapsed: 1.090s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data;
+--------+------------+-------------+--------+
| EMP_ID | EMP_NAME   | DEPARTMENT  | SALARY |
|--------+------------+-------------+--------|
|    101 | John Doe   | Sales       |  75000 |
|    102 | Jane Smith | Marketing   |  82000 |
|    103 | Ali Khan   | Engineering |  95000 |
|    104 | Mei Lin    | Finance     |  88000 |
|    101 | John Doe   | Sales       |  75000 |
|    102 | Jane Smith | Marketing   |  82000 |
|    103 | Ali Khan   | Engineering |  95000 |
|    104 | Mei Lin    | Finance     |  88000 |
+--------+------------+-------------+--------+
8 Row(s) produced. Time Elapsed: 0.348s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>

---The newly inserted record is missing, and Snowpipe hasn't loaded data into the employee_data table.
It looks like the COPY command is re-inserting records.


There are two distinct issues occurring in your session log:

Snowpipe Failure to Load (Missing New Record): Snowpipe failed to load any records 
from employee_data_test2.csv.gz after the TRUNCATE and the file modification because you did not re-upload the modified file.

Duplicate Records in Table (Re-inserting Old Records): The four records were loaded 
twice in the final step because the last COPY INTO command you ran re-executed the manual load of the entire staged file.

1. Snowpipe Failure (Missing New Record)
The new record (105,Mei Lin1,Finance,90000) is missing because the employee_data_test2.csv.gz 
file currently in your Snowflake stage does not contain that record.

Reason for Snowpipe Failure
File Modification is Local: You modified the source file locally on
 your Windows machine (at C:/Snowflakefilesprabha/employee_data_test2.csv) to add the new row (105, Mei Lin1...).

The Stage is Outdated: The file in your Snowflake stage (@employee_stage/employee_data_test2.csv.gz) 
is the original version uploaded earlier, which only contained 4 rows.

Missing PUT Command: You needed to run the PUT command again 
after modifying the local CSV file to upload the new, 5-row version to the stage. 
Since you skipped this step, the ALTER PIPE employee_pipe REFRESH command 
found no new file to process and the old file was already tracked as loaded.




prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>PUT file://C:/Snowflakefilesprabha/employee_data_test2.csv @employee_stage OVERWRITE=TRUE;
+-------------------------+----------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source                  | target                     | source_size | target_size | source_compression | target_compression | status   | message |
|-------------------------+----------------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| employee_data_test2.csv | employee_data_test2.csv.gz |         180 |         192 | NONE               | GZIP               | UPLOADED |         |
+-------------------------+----------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
1 Row(s) produced. Time Elapsed: 4.757s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>TRUNCATE TABLE employee_data;
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+
1 Row(s) produced. Time Elapsed: 0.425s

prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>CREATE OR REPLACE PIPE employee_pipe AUTO_INGEST = FALSE AS COPY INTO employee_data FROM @employee_stage/employ
                                            ee_data_test2.csv.gz FILE_FORMAT = ( TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);
+------------------------------------------+
| status                                   |
|------------------------------------------|
| Pipe EMPLOYEE_PIPE successfully created. |
+------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.254s


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data;
+--------+----------+------------+--------+
| EMP_ID | EMP_NAME | DEPARTMENT | SALARY |
|--------+----------+------------+--------|
+--------+----------+------------+--------+
0 Row(s) produced. Time Elapsed: 0.176s



prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>TRUNCATE TABLE employee_data;
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+
1 Row(s) produced. Time Elapsed: 2.802s


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data;
+--------+----------+------------+--------+
| EMP_ID | EMP_NAME | DEPARTMENT | SALARY |
|--------+----------+------------+--------|
+--------+----------+------------+--------+
0 Row(s) produced. Time Elapsed: 0.174s


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>COPY INTO employee_data FROM @employee_stage/employee_data_test2.csv.gz FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIO
                                            NALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);
+-------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                                      | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|-------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| employee_stage/employee_data_test2.csv.gz | LOADED |           5 |           5 |           1 |           0 | NULL        |             NULL |                  NULL | NULL                    |
+-------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
1 Row(s) produced. Time Elapsed: 0.920s


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data;
+--------+------------+-------------+--------+
| EMP_ID | EMP_NAME   | DEPARTMENT  | SALARY |
|--------+------------+-------------+--------|
|    101 | John Doe   | Sales       |  75000 |
|    102 | Jane Smith | Marketing   |  82000 |
|    103 | Ali Khan   | Engineering |  95000 |
|    104 | Mei Lin    | Finance     |  88000 |
|    105 | Mei Lin1   | Finance     |  90000 |
+--------+------------+-------------+--------+
5 Row(s) produced. Time Elapsed: 0.320s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>COPY INTO employee_data FROM @employee_stage/employee_data_test2.csv.gz FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIO
                                            NALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);
+---------------------------------------+
| status                                |
|---------------------------------------|
| Copy executed with 0 files processed. |
+---------------------------------------+
1 Row(s) produced. Time Elapsed: 0.463s


prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data;
+--------+------------+-------------+--------+
| EMP_ID | EMP_NAME   | DEPARTMENT  | SALARY |
|--------+------------+-------------+--------|
|    101 | John Doe   | Sales       |  75000 |
|    102 | Jane Smith | Marketing   |  82000 |
|    103 | Ali Khan   | Engineering |  95000 |
|    104 | Mei Lin    | Finance     |  88000 |
|    105 | Mei Lin1   | Finance     |  90000 |
+--------+------------+-------------+--------+
5 Row(s) produced. Time Elapsed: 0.284s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>



prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>COPY INTO employee_data FROM @employee_stage/employee_data_test2.csv.gz FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIO
                                            NALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1) FORCE=TRUE;
+-------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                                      | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|-------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| employee_stage/employee_data_test2.csv.gz | LOADED |           5 |           5 |           1 |           0 | NULL        |             NULL |                  NULL | NULL                    |
+-------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
1 Row(s) produced. Time Elapsed: 0.553s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>SELECT * FROM employee_data;
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
10 Row(s) produced. Time Elapsed: 0.240s
prabhakarreddy1433#COMPUTE_WH@MYSNOW.PUBLIC>

