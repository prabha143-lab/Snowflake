
create or replace storage integration mystorageintegrationname
    type = external_stage
    storage_provider = s3
    storage_aws_role_arn = 'arn:aws:iam::551647579256:role/myrole'
    enabled = true
    storage_allowed_locations = ( 's3://mytextfilesdump/EMP.txt' )
    -- storage_blocked_locations = ( 's3://<location1>', 's3://<location2>' )
    -- comment = '<comment>'
    ;

    

CREATE OR REPLACE STAGE my_ext_stage
URL = 's3://mytextfilesdump/EMP.txt'
STORAGE_INTEGRATION = mystorageintegrationname;

show stages

SELECT $1,$2,$3,$4 FROM @my_ext_stage;

$1	$2	$3	$4
ID	NAME	CITY	SALARY
101	John Doe	New York	75000
102	Jane Smith	Los Angeles	82000
103	Ravi Kumar	Hyderabad	68000
104	Ana Silva	São Paulo	72000
105	Li Wei	Beijing	79000


CREATE OR REPLACE FILE FORMAT my_csv_format
TYPE = 'CSV'
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"';


CREATE OR REPLACE EXTERNAL TABLE ext_customers (
  id INT AS (VALUE:c1::INT),
  name STRING AS (VALUE:c2::STRING),
  city STRING AS (VALUE:c3::STRING),
  salary INT AS (VALUE:c4::INT)
)
WITH LOCATION = @my_ext_stage
FILE_FORMAT = my_csv_format;


SELECT *FROM 
CREATE OR REPLACE EXTERNAL TABLE ext_customers (
  customer_id INT AS (VALUE:cust_id::INT),
  name STRING AS (VALUE:name::STRING),
  email STRING AS (VALUE:email::STRING),
  last_updated TIMESTAMP AS (VALUE:last_updated::TIMESTAMP)
)
WITH LOCATION = @my_ext_stage
FILE_FORMAT = (TYPE = CSV);

Error assuming AWS_ROLE:
User: arn:aws:iam::186297945588:user/gs161000-s is not authorized to perform: sts:AssumeRole on resource: arn:aws:iam::551647579256:role/myrole

DESC INTEGRATION mystorageintegrationname;

CREATE OR REPLACE EXTERNAL TABLE ext_customers (
  customer_id INT AS (VALUE:cust_id::INT),
  name STRING AS (VALUE:name::STRING),
  email STRING AS (VALUE:email::STRING),
  last_updated TIMESTAMP AS (VALUE:last_updated::TIMESTAMP)
)
WITH LOCATION = @my_ext_stage
FILE_FORMAT = (TYPE = JSON);

Table EXT_CUSTOMERS successfully created.


CREATE OR REPLACE STREAM ext_customers_stream
ON TABLE ext_customers
INSERT_ONLY = TRUE;

Object found is of type 'EXTERNAL_TABLE', not specified type 'TABLE'.


CREATE OR REPLACE STREAM ext_customers_stream
ON EXTERNAL TABLE ext_customers
INSERT_ONLY = TRUE;

Stream EXT_CUSTOMERS_STREAM successfully created.

SELECT *FROM ext_customers;--No records


CREATE OR REPLACE EXTERNAL TABLE ext_customers (
  id INT AS (VALUE:id::INT),
  name STRING AS (VALUE:name::STRING),
  city STRING AS (VALUE:city::STRING),
  salary INT AS (VALUE:salary::INT)
)
WITH LOCATION = @my_ext_stage
FILE_FORMAT = (TYPE = CSV);

SELECT *FROM ext_customers;

SELECT METADATA$FILENAME, METADATA$FILE_ROW_NUMBER, VALUE FROM ext_customers;


CREATE OR REPLACE EXTERNAL TABLE ext_customers (
  id INT AS (VALUE:c1::INT),
  name STRING AS (VALUE:c2::STRING),
  city STRING AS (VALUE:c3::STRING),
  salary INT AS (VALUE:c4::INT)
)
WITH LOCATION = @my_ext_stage
FILE_FORMAT = my_csv_format;

select *from ext_customers;--still no data

SELECT VALUE FROM ext_customers;


CREATE OR REPLACE STAGE my_ext_stage
URL = 's3://mytextfilesdump/EMP.txt'
STORAGE_INTEGRATION = mystorageintegrationname;