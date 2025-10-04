TASK 1 :
I HAVE EMP TABLE
COLUMNS=> ID,NAME,SALARY

FILE=> EMP.TXT
ID,NAME,CITY,SALARY

LOAD THIS FILE INTO EMP TABLE

==================================

TASK 2 :
FILE=> EMP.TXT
ID,NAME,CITY,SALARY

LOAD ONLY NAME AND CITY COLUMN DATA INTO TABLE


----------------------------------------------------------------
TASK 1 :
I HAVE EMP TABLE
COLUMNS=> ID,NAME,SALARY

FILE=> EMP.TXT
ID,NAME,CITY,SALARY

LOAD THIS FILE INTO EMP TABLE

==================================



EMP.txt file data

ID,NAME,CITY,SALARY
101,John Doe,New York,75000
102,Jane Smith,Los Angeles,82000
103,Ravi Kumar,Hyderabad,68000
104,Ana Silva,São Paulo,72000
105,Li Wei,Beijing,79000


CREATE OR REPLACE TABLE EMP (
    ID INT,
    NAME STRING,
    CITY STRING,
    SALARY NUMBER
);

CREATE OR REPLACE FILE FORMAT emp_file_format
TYPE = 'CSV'
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
SKIP_HEADER = 1;

create or replace storage integration mystorageintegrationname
    type = external_stage
    storage_provider = s3
    storage_aws_role_arn = 'arn:aws:iam::551647579256:role/myrole'
    enabled = true
    storage_allowed_locations = ( 's3://mytextfilesdump/EMP.txt'  )
    -- storage_blocked_locations = ( 's3://<location1>', 's3://<location2>' )
    -- comment = '<comment>'
    ;

Error
-----
User: arn:aws:iam::186297945588:user/gs161000-s is not authorized to perform: sts:AssumeRole on resource: arn:aws:iam::551647579256:role/myrole


create or replace storage integration mystorageintegrationname
    type = external_stage
    storage_provider = s3
    storage_aws_role_arn = 'arn:aws:iam::551647579256:role/myrole'
    enabled = true
    storage_allowed_locations = ( 's3://mytextfilesdump/EMP.txt' )
    -- storage_blocked_locations = ( 's3://<location1>', 's3://<location2>' )
    -- comment = '<comment>'
    ;

--Integration MYSTORAGEINTEGRATIONNAME successfully created.

CREATE OR REPLACE STAGE emp_stage
URL = 's3://mytextfilesdump/EMP.txt'
STORAGE_INTEGRATION = mystorageintegrationname
FILE_FORMAT = emp_file_format;

--Stage area EMP_STAGE successfully created

COPY INTO EMP (ID, NAME, CITY, SALARY)
FROM (
    SELECT $1, $2, $3, $4
    FROM @emp_stage/EMP.TXT
)
FILE_FORMAT = emp_file_format;

--Copy executed with 0 files processed.

COPY INTO EMP (ID, NAME, CITY, SALARY)
FROM (
    SELECT $1, $2, $3, $4
    FROM @emp_stage/
)
FILE_FORMAT = emp_file_format;

file	status	rows_parsed	rows_loaded	error_limit	errors_seen	first_error	first_error_line	first_error_character	first_error_column_name
s3://mytextfilesdump/EMP.txt	LOADED	5	5	1	0				

SELECT *FROM EMP;

ID	NAME	CITY	SALARY
101	John Doe	New York	75000
102	Jane Smith	Los Angeles	82000
103	Ravi Kumar	Hyderabad	68000
104	Ana Silva	São Paulo	72000
105	Li Wei	Beijing	79000


----------------------------------------------
TASK 2 :
FILE=> EMP.TXT
ID,NAME,CITY,SALARY

LOAD ONLY NAME AND CITY COLUMN DATA INTO TABLE


CREATE OR REPLACE TABLE EMP (
    ID INT,
    NAME STRING,
    CITY STRING,
    SALARY NUMBER
);

CREATE OR REPLACE FILE FORMAT emp_file_format
TYPE = 'CSV'
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
SKIP_HEADER = 1;

create or replace storage integration mystorageintegrationname
    type = external_stage
    storage_provider = s3
    storage_aws_role_arn = 'arn:aws:iam::551647579256:role/myrole'
    enabled = true
    storage_allowed_locations = ( 's3://mytextfilesdump/'  )
    -- storage_blocked_locations = ( 's3://<location1>', 's3://<location2>' )
    -- comment = '<comment>'
    ;

CREATE OR REPLACE STAGE emp_stage
URL = 's3://mytextfilesdump/'
STORAGE_INTEGRATION = mystorageintegrationname
FILE_FORMAT = emp_file_format;


DESC INTEGRATION mystorageintegrationname

STORAGE_AWS_IAM_USER_ARN	String	arn:aws:iam::186297945588:user/gs161000-s
STORAGE_AWS_ROLE_ARN	String	arn:aws:iam::551647579256:role/myrole
STORAGE_AWS_EXTERNAL_ID	String	RW88632_SFCRole=4_azNNHnCgpbr8drDxBLH69Hd+ftQ=

LIST @emp_stage;

name	size	md5	last_modified
s3://mytextfilesdump/EMP.txt	174	0dd0764fa7c415fedce0029703eba171	Wed, 3 Sep 2025 04:19:59 GMT

SELECT *
FROM @emp_stage/EMP.txt
FILE_FORMAT = emp_file_format;
--Syntax error: unexpected '='. (line 42)

SELECT *
FROM TABLE(
    EXTERNAL_TABLE(
        LOCATION => '@emp_stage/EMP.txt',
        FILE_FORMAT => emp_file_format
    )
);

Error: invalid identifier 'EMP_FILE_FORMAT' (line 49)

SELECT $1,$2,$3,$4
FROM @emp_stage/EMP.txt (FILE_FORMAT => 'emp_file_format');



COPY INTO EMP (NAME, CITY)
FROM (
    SELECT $2, $3
    FROM @emp_stage/EMP.txt
)
FILE_FORMAT = emp_file_format;

SELECT *FROM EMP;

ID	NAME	CITY	SALARY
	John Doe	New York	
	Jane Smith	Los Angeles	
	Ravi Kumar	Hyderabad	
	Ana Silva	São Paulo	
	Li Wei	Beijing	


---------------------------------------------------------------------------------------------------
Question 2:

Snowflake RealTime Use Case

Scenario 1:
Loaded the Employee.Txt file into Employee Table Using Copy Statement (External Location AWS S3)
Now Same File can be loaded into Different Tables using Copy. Is it Possible??

Scenario 2:
Added 1 more record in the Existing File and Upload in the External Location.
Now Executed the copy Statement again Does records loads into Table ??



CREATE OR REPLACE TABLE EMPLOYEE (
    ID INT,
    NAME STRING,
    CITY STRING,
    SALARY NUMBER
);

CREATE OR REPLACE FILE FORMAT employee_file_format
TYPE = 'CSV'
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
SKIP_HEADER = 1;

create or replace storage integration myemployeestorageintegrationname
    type = external_stage
    storage_provider = s3
    storage_aws_role_arn = 'arn:aws:iam::551647579256:role/myrole'
    enabled = true
    storage_allowed_locations = ( 's3://mytextfilesdump/'  )
    -- storage_blocked_locations = ( 's3://<location1>', 's3://<location2>' )
    -- comment = '<comment>'
    ;



CREATE OR REPLACE STAGE employee_stage
URL = 's3://mytextfilesdump/'
STORAGE_INTEGRATION = myemployeestorageintegrationname
FILE_FORMAT = emp_file_format;


DESC INTEGRATION myemployeestorageintegrationname

STORAGE_AWS_IAM_USER_ARN	String	arn:aws:iam::186297945588:user/gs161000-s
STORAGE_AWS_ROLE_ARN	String	arn:aws:iam::551647579256:role/myrole
STORAGE_AWS_EXTERNAL_ID	String	RW88632_SFCRole=4_9CaCR8hZFk3S1rVcf+G4dY4yw0Y=

COPY INTO EMPLOYEE (ID, NAME, CITY, SALARY)
FROM (
    SELECT $1, $2, $3, $4
    FROM @employee_stage/Employee.txt
)
FILE_FORMAT = emp_file_format;

file	status	rows_parsed	rows_loaded	error_limit	errors_seen	first_error	first_error_line	first_error_character	first_error_column_name
s3://mytextfilesdump/Employee.txt	LOADED	3	3	1	0				

Now i have modified the file and inserted a new record


ID,NAME,CITY,SALARY
101,John Doe,New York,75000
102,Jane Smith,Los Angeles,82000
103,Ravi Kumar,Hyderabad,68000
104,James,Hyderabad,71000

COPY INTO EMPLOYEE (ID, NAME, CITY, SALARY)
FROM (
    SELECT $1, $2, $3, $4
    FROM @employee_stage/Employee.txt
)
FILE_FORMAT = emp_file_format;

file	status	rows_parsed	rows_loaded	error_limit	errors_seen	first_error	first_error_line	first_error_character	first_error_column_name
s3://mytextfilesdump/Employee.txt	LOADED	4	4	1	0	