
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






