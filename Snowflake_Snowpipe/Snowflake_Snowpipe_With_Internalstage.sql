Did you use an internal stage while creating a Snowpipe? 


C:\Users\prabh>snowsql -a AZGQQKX-CO77159 -u prabhakarreddy143
Password:
* SnowSQL * v1.3.3
Type SQL statements or !help
prabhakarreddy143#COMPUTE_WH@(no database).(no schema)>
prabhakarreddy143#COMPUTE_WH@(no database).(no schema)>

prabhakarreddy143#COMPUTE_WH@(no database).(no schema)>USE DATABASE MYSNOW;
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+
1 Row(s) produced. Time Elapsed: 0.136s
prabhakarreddy143#COMPUTE_WH@MYSNOW.PUBLIC>USE SCHEMA PUBLIC;
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+
1 Row(s) produced. Time Elapsed: 0.107s
prabhakarreddy143#COMPUTE_WH@MYSNOW.PUBLIC>CREATE OR REPLACE STAGE my_internal_stage;
+----------------------------------------------------+
| status                                             |
|----------------------------------------------------|
| Stage area MY_INTERNAL_STAGE successfully created. |
+----------------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.176s
prabhakarreddy143#COMPUTE_WH@MYSNOW.PUBLIC>CREATE OR REPLACE STAGE my_internal_stage
                                           FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

+----------------------------------------------------+
| status                                             |
|----------------------------------------------------|
| Stage area MY_INTERNAL_STAGE successfully created. |
+----------------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.306s
prabhakarreddy143#COMPUTE_WH@MYSNOW.PUBLIC


CREATE OR REPLACE TABLE target_customers (
  id INT,
  name STRING,
  city STRING,
  salary INT
);

CREATE OR REPLACE PIPE load_customers_pipe
AS
COPY INTO target_customers
FROM @my_internal_stage
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

--Pipe LOAD_CUSTOMERS_PIPE successfully created.


prabhakarreddy143#COMPUTE_WH@MYSNOW.PUBLIC>PUT file://C:/Snowflakefilesprabha/customers.txt @my_stage;
254007 (n/a): The certificate is revoked or could not be validated: hostname=sfc-in-ds1-102-customer-stage.s3.amazonaws.com