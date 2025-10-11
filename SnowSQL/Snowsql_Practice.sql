snowsql -a AZGQQKX-CO77159 -u prabhakarreddy143 -r ACCOUNTADMIN -w COMPUTE_WH -d MYSNOW -s PUBLIC -o log_level=DEBUG


prabhakarreddy143#COMPUTE_WH@MYSNOW.PUBLIC>PUT file://C:/Snowflake_Files_ForPractice/data.csv @my_internal_stage;
254007 (n/a): The certificate is revoked or could not be validated: hostname=sfc-in-ds1-102-customer-stage.s3.amazonaws.com


PUT file://C:/Snowflake_Files_ForPractice/data.csv @~;


----------------Snowsql working fine right now-------------------------------------


Snowflake Interview Question

File Data:

A text file with the following lines:

EMPDUMP.txt

ID,NAME,CITY,SALARY
101,John Doe,New York,75000
102,Jane Smith,Los Angeles,82000
103,Ravi Kumar,Hyderabad,68000
104,Ana Silva,São Paulo,72000
105,Li Wei,Beijing,79000

To load the file data into a Snowflake Table ignoring empty lines.


create or replace stage my_stage;


snowsql -a AZGQQKX-CO77159 -u prabhakarreddy143



C:\Users\prabh>pip install "certifi<2025.4.26" -t C:/temp/certifi
Collecting certifi<2025.4.26
  Using cached certifi-2025.1.31-py3-none-any.whl.metadata (2.5 kB)
Using cached certifi-2025.1.31-py3-none-any.whl (166 kB)
Installing collected packages: certifi
Successfully installed certifi-2025.1.31
WARNING: Target directory C:\temp\certifi\certifi already exists. Specify --upgrade to force replacement.
WARNING: Target directory C:\temp\certifi\certifi-2025.1.31.dist-info already exists. Specify --upgrade to force replacement.

C:\Users\prabh>set REQUESTS_CA_BUNDLE=C:\temp\certifi\certifi\cacert.pem

C:\Users\prabh>snowsql -a AZGQQKX-CO77159 -u prabhakarreddy143
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
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+
1 Row(s) produced. Time Elapsed: 0.127s
prabhakarreddy143#COMPUTE_WH@MYSNOW.PUBLIC>PUT file://C:/Snowflake_Files_ForPractice/EMPDUMP.txt @my_stage;
+-------------+----------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source      | target         | source_size | target_size | source_compression | target_compression | status   | message |
|-------------+----------------+-------------+-------------+--------------------+--------------------+----------+---------|
| EMPDUMP.txt | EMPDUMP.txt.gz |         178 |         192 | NONE               | GZIP               | UPLOADED |         |
+-------------+----------------+-------------+-------------+--------------------+--------------------+----------+---------+
1 Row(s) produced. Time Elapsed: 7.794s
prabhakarreddy143#COMPUTE_WH@MYSNOW.PUBLIC>



prabhakarreddy143#COMPUTE_WH@MYSNOW.PUBLIC>LIST @my_stage;
+-------------------------+------+----------------------------------+------------------------------+
| name                    | size | md5                              | last_modified                |
|-------------------------+------+----------------------------------+------------------------------|
| my_stage/EMPDUMP.txt.gz |  192 | 22daeeecfa8b27d1e63a10ecd5b9c3c1 | Sun, 7 Sep 2025 06:23:24 GMT |
+-------------------------+------+----------------------------------+------------------------------+
1 Row(s) produced. Time Elapsed: 2.829s
prabhakarreddy143#COMPUTE_WH@MYSNOW.PUBLIC>


LIST @my_stage;

name	               size	md5	                                last_modified
my_stage/EMPDUMP.txt.gz	192	22daeeecfa8b27d1e63a10ecd5b9c3c1	Sun, 7 Sep 2025 06:23:24 GMT


CREATE OR REPLACE TABLE empdump_raw (
    id INT,
    name STRING,
    city STRING,
    salary NUMBER
);



CREATE OR REPLACE FILE FORMAT my_format
    TYPE = 'CSV'
    FIELD_DELIMITER = ',' 
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    ENCODING = 'UTF8';


CREATE OR REPLACE TABLE empdump_raw (
    id INT,
    name STRING,
    city STRING,
    salary NUMBER
);


CREATE OR REPLACE FILE FORMAT my_format
    TYPE = 'CSV'
    FIELD_DELIMITER = ',' 
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    ENCODING = 'UTF8';



COPY INTO empdump_raw
FROM @my_stage/EMPDUMP.txt.gz
FILE_FORMAT = (FORMAT_NAME = my_format);

End of record reached while expected to parse column '"EMPDUMP_RAW"["NAME":2]'
  File 'EMPDUMP.txt.gz', line 5, character 2
  Row 4, column "EMPDUMP_RAW"["NAME":2]
  If you would like to continue loading when an error is encountered, use other values such as 'SKIP_FILE' or 'CONTINUE' for the ON_ERROR option. For more information on loading options, please run 'info loading_data' in a SQL client.
  
COPY INTO empdump_raw
FROM @my_stage/EMPDUMP.txt.gz
FILE_FORMAT = (FORMAT_NAME = my_format)
ON_ERROR = CONTINUE;

file	status	rows_parsed	rows_loaded	error_limit	errors_seen	first_error	first_error_line	first_error_character	first_error_column_name
my_stage/EMPDUMP.txt.gz	PARTIALLY_LOADED	7	5	7	2	End of record reached while expected to parse column '"EMPDUMP_RAW"["NAME":2]'	5	2	"EMPDUMP_RAW"["NAME":2]

SELECT *FROM empdump_raw;

ID	NAME	CITY	SALARY
101	John Doe	New York	75000
102	Jane Smith	Los Angeles	82000
103	Ravi Kumar	Hyderabad	68000
104	Ana Silva	São Paulo	72000
105	Li Wei	Beijing	79000



SELECT * from 
    INFORMATION_SCHEMA.STAGES
WHERE
    stage_type = 'Internal Named'
ORDER BY
    stage_name;

SELECT * from 
    INFORMATION_SCHEMA.STAGES
WHERE
    stage_type = 'External Named'
ORDER BY
    stage_name;
	
	
---------Please follow below steps-----------------

Run the Certifi Install Command
Open Command Prompt:

Press Windows + R, type cmd, and hit Enter.

Run the command:

bash
pip install "certifi<2025.4.26" -t C:/temp/certifi
This installs a compatible version of the certifi package (which contains trusted SSL certificates) into the folder C:/temp/certifi.


Set Environment Variable
After installing, in the same Command Prompt window, run:

bash
set REQUESTS_CA_BUNDLE=C:\temp\certifi\certifi\cacert.pem
This tells SnowSQL to use the updated certificate bundle.


----------------------------------------------------------------------------------
Question 2:


Snowpipe Interview Questions:

==============================

How to refresh Pipe Manually

How to debug Snowpipe

Can we create pipe on Internal stages

How to stop the Pipe

Snowpipe metadata how long it copies



EMPDUMP14.txt

ID,NAME,CITY,SALARY
101,John Doe,New York,75000
102,Jane Smith,Los Angeles,82000
103,Ravi Kumar,Hyderabad,68000


104,Ana Silva,São Paulo,72000
105,Li Wei,Beijing,79000



create or replace stage my_stage14;

prabhakarreddy143#COMPUTE_WH@MYSNOW.PUBLIC>PUT file://C:/Snowflake_Files_ForPractice/EMPDUMP14.txt @my_stage14;
+---------------+------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source        | target           | source_size | target_size | source_compression | target_compression | status   | message |
|---------------+------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| EMPDUMP14.txt | EMPDUMP14.txt.gz |         178 |         192 | NONE               | GZIP               | UPLOADED |         |
+---------------+------------------+-------------+-------------+--------------------+--------------------+----------+---------+
1 Row(s) produced. Time Elapsed: 5.358s
prabhakarreddy143#COMPUTE_WH@MYSNOW.PUBLIC>


CREATE OR REPLACE TABLE empdump_raw14 (
    id INT,
    name STRING,
    city STRING,
    salary NUMBER
);


CREATE OR REPLACE FILE FORMAT my_format14
    TYPE = 'CSV'
    FIELD_DELIMITER = ',' 
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    ENCODING = 'UTF8'
    EMPTY_FIELD_AS_NULL = TRUE
    SKIP_BLANK_LINES = TRUE;

CREATE OR REPLACE PIPE empdump_pipe14
AS
COPY INTO empdump_raw14
FROM @my_stage14
FILE_FORMAT = (FORMAT_NAME = my_format14)
ON_ERROR = CONTINUE;


ALTER PIPE empdump_pipe14 REFRESH;

SELECT *FROM empdump_raw14;--After refresh also no records

*************************************************************************************


PUT file://C:/Snowflake_Files_ForPractice/EMPDUMP14.txt @~;



PUT file://C:/Snowflake_Files_ForPractice/EMPDUMP14.txt @%empdump_raw14;


CREATE OR REPLACE TABLE empdump_raw14 (
    id INT,
    name STRING,
    city STRING,
    salary NUMBER
);



COPY INTO empdump_raw14
FROM @%empdump_raw14/EMPDUMP14.txt.gz
FILE_FORMAT = (
    TYPE = 'CSV',
    FIELD_DELIMITER = ',',
    SKIP_HEADER = 1,
    FIELD_OPTIONALLY_ENCLOSED_BY = '"',
    ENCODING = 'UTF8',
    EMPTY_FIELD_AS_NULL = TRUE,
    SKIP_BLANK_LINES = TRUE
)
ON_ERROR = CONTINUE;


SELECT *FROM empdump_raw14;

ID	NAME	CITY	SALARY
101	John Doe	New York	75000
102	Jane Smith	Los Angeles	82000
103	Ravi Kumar	Hyderabad	68000
104	Ana Silva	São Paulo	72000
105	Li Wei	Beijing	79000