CREATE OR REPLACE TABLE employee_data (
  emp_id INT,
  emp_name STRING,
  department STRING,
  salary NUMBER
);

employee_stage

SHOW STAGES;

SHOW STAGES LIKE 'employee_stage%';

name
EMPLOYEE_STAGE

LIST @employee_stage--No rows why?

Reason:
*******************
No files uploaded yet
You must upload files using the PUT command (from SnowSQL or Snowflake CLI):


C:\Snowflakefilesprabha\employee_stage

LIST @employee_stage

name	size	md5	last_modified
employee_stage/employee_data.csv.gz	176	8d6c07e8dff7054b5d065aff75665fe8	Sat, 11 Oct 2025 13:05:13 GMT



COPY INTO employee_data
FROM @employee_stage/employee_data.csv.gz
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"');

Numeric value 'emp_id' is not recognized File 'employee_data.csv.gz', line 1, character 1 Row 1, column "EMPLOYEE_DATA"["EMP_ID":1] 
If you would like to continue loading when an error is encountered, use other values such as 'SKIP_FILE' or 'CONTINUE' for the ON_ERROR option. 
For more information on loading options, please run 'info loading_data' in a SQL client.


COPY INTO employee_data
FROM @employee_stage/employee_data.csv.gz
FILE_FORMAT = (
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1
);


file	status	rows_parsed	rows_loaded	error_limit	errors_seen	first_error	first_error_line	first_error_character	first_error_column_name
employee_stage/employee_data.csv.gz	LOADED	4	4	1	0	


SELECT * FROM employee_data;

EMP_ID	EMP_NAME	DEPARTMENT	SALARY
101	John Doe	Sales	75000
102	Jane Smith	Marketing	82000
103	Ali Khan	Engineering	95000
104	Mei Lin	Finance	88000

SELECT *
FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
  TABLE_NAME => 'EMPLOYEE_DATA',
  START_TIME => DATEADD(HOUR, -24, CURRENT_TIMESTAMP())
));

FILE_NAME	STAGE_LOCATION	LAST_LOAD_TIME	ROW_COUNT	ROW_PARSED	FILE_SIZE	FIRST_ERROR_MESSAGE	FIRST_ERROR_LINE_NUMBER	FIRST_ERROR_CHARACTER_POS	FIRST_ERROR_COLUMN_NAME	ERROR_COUNT	ERROR_LIMIT	STATUS	TABLE_CATALOG_NAME	TABLE_SCHEMA_NAME	TABLE_NAME	PIPE_CATALOG_NAME	PIPE_SCHEMA_NAME	PIPE_NAME	PIPE_RECEIVED_TIME	BYTES_BILLED
employee_data.csv.gz	stages/eba0fcfb-c452-49f2-be92-dd62c6336c04/	2025-10-11 06:11:03.712 -0700	4	4	176					0	1	Loaded	MYSNOW	PUBLIC	EMPLOYEE_DATA					


SELECT *
FROM TABLE(INFORMATION_SCHEMA.LOAD_HISTORY(
  LOCATION => '@employee_stage',
  START_TIME => DATEADD(HOUR, -24, CURRENT_TIMESTAMP())
));

SQL compilation error: Unknown table function INFORMATION_SCHEMA.LOAD_HISTORY


TRUNCATE TABLE employee_data;

SELECT COUNT(*) FROM employee_data;--ZERO records

CREATE OR REPLACE PIPE employee_pipe
AUTO_INGEST = FALSE
AS
COPY INTO employee_data
FROM @employee_stage
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"');
--Pipe EMPLOYEE_PIPE successfully created.

SELECT * FROM employee_data;--Query produced no results


ALTER PIPE employee_pipe REFRESH;
File	Status
employee_data.csv.gz	SENT

SELECT * FROM employee_data;--No records

CREATE OR REPLACE PIPE employee_pipe
AUTO_INGEST = FALSE
AS
COPY INTO employee_data
FROM @employee_stage
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"');
--Pipe EMPLOYEE_PIPE successfully created.

SELECT * FROM employee_data;--No records

ALTER PIPE employee_pipe REFRESH;

File	Status
employee_data.csv.gz	SENT
employee_data_snowpipe.csv.gz	SENT

SELECT * FROM employee_data;--No records



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






LIST @employee_stage

employee_stage/employee_data_snowpipe.csv.gz

CREATE OR REPLACE PIPE employee_pipe
AUTO_INGEST = FALSE
AS
COPY INTO employee_data
FROM @employee_stage/employee_data_snowpipe.csv.gz
FILE_FORMAT = (
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1
);
--Pipe EMPLOYEE_PIPE successfully created.

SELECT * FROM employee_data;--No data

ALTER PIPE employee_pipe REFRESH;

SELECT * FROM employee_data;--No data

SELECT *
FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
  TABLE_NAME => 'EMPLOYEE_DATA',
  START_TIME => DATEADD(HOUR, -1, CURRENT_TIMESTAMP())
));

FILE_NAME	STAGE_LOCATION	LAST_LOAD_TIME	ROW_COUNT	ROW_PARSED	FILE_SIZE	FIRST_ERROR_MESSAGE	FIRST_ERROR_LINE_NUMBER	FIRST_ERROR_CHARACTER_POS	FIRST_ERROR_COLUMN_NAME	ERROR_COUNT	ERROR_LIMIT	STATUS	TABLE_CATALOG_NAME	TABLE_SCHEMA_NAME	TABLE_NAME	PIPE_CATALOG_NAME	PIPE_SCHEMA_NAME	PIPE_NAME	PIPE_RECEIVED_TIME	BYTES_BILLED
employee_data.csv.gz	stages/eba0fcfb-c452-49f2-be92-dd62c6336c04/	2025-10-11 06:18:45.740 -0700	0	5	176	Numeric value 'emp_id' is not recognized	1	1	"EMPLOYEE_DATA"["EMP_ID":1]	1	1	Load failed	MYSNOW	PUBLIC	EMPLOYEE_DATA	MYSNOW	PUBLIC	EMPLOYEE_PIPE	2025-10-11 06:18:29.302 -0700	152
employee_data.csv.gz	stages/eba0fcfb-c452-49f2-be92-dd62c6336c04/	2025-10-11 06:22:21.594 -0700	0	5	176	Numeric value 'emp_id' is not recognized	1	1	"EMPLOYEE_DATA"["EMP_ID":1]	1	1	Load failed	MYSNOW	PUBLIC	EMPLOYEE_DATA	MYSNOW	PUBLIC	EMPLOYEE_PIPE	2025-10-11 06:22:05.735 -0700	152
employee_data_snowpipe.csv.gz	stages/eba0fcfb-c452-49f2-be92-dd62c6336c04/	2025-10-11 06:22:21.594 -0700	0	5	176	Numeric value 'emp_id' is not recognized	1	1	"EMPLOYEE_DATA"["EMP_ID":1]	1	1	Load failed	MYSNOW	PUBLIC	EMPLOYEE_DATA	MYSNOW	PUBLIC	EMPLOYEE_PIPE	2025-10-11 06:22:05.735 -0700	152
	stages/eba0fcfb-c452-49f2-be92-dd62c6336c04/employee_data_snowpipe.csv.gz	2025-10-11 06:25:37.599 -0700	4	4	176					0	1	Loaded	MYSNOW	PUBLIC	EMPLOYEE_DATA	MYSNOW	PUBLIC	EMPLOYEE_PIPE	2025-10-11 06:25:19.539 -0700	152

    
CREATE OR REPLACE PIPE employee_pipe
AUTO_INGEST = FALSE
AS
COPY INTO employee_data
FROM @employee_stage/employee_data_snowpipe.csv.gz
FILE_FORMAT = (
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1
);

--Pipe EMPLOYEE_PIPE successfully created.


SELECT * FROM employee_data;--

EMP_ID	EMP_NAME	DEPARTMENT	SALARY
101	John Doe	Sales	75000
102	Jane Smith	Marketing	82000
103	Ali Khan	Engineering	95000
104	Mei Lin	Finance	88000