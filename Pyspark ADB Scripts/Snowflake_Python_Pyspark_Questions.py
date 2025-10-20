Question 1:
************************************
Join customer and transaction datasets, then compute total spend per customer.

customers.csv:

 customer_id,name

• 101,Alice

• 102,Bob

transactions.csv:

customer_id,amount

101,200

101,150

102,300
 

import pandas as pd

# Load data
customers = pd.DataFrame({
    'customer_id': [101, 102],
    'name': ['Alice', 'Bob']
})

transactions = pd.DataFrame({
    'customer_id': [101, 101, 102],
    'amount': [200, 150, 300]
})

# Aggregate total spend
total_spend = transactions.groupby('customer_id')['amount'].sum().reset_index()

# Join with customer data
result = pd.merge(customers, total_spend, on='customer_id')

# Display result
print(result)


***************Using Pyspark***********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import sum

# Start Spark session
spark = SparkSession.builder.appName("CustomerSpend").getOrCreate()

# Create DataFrames
customers = spark.createDataFrame([
    (101, "Alice"),
    (102, "Bob")
], ["customer_id", "name"])

transactions = spark.createDataFrame([
    (101, 200),
    (101, 150),
    (102, 300)
], ["customer_id", "amount"])

# Aggregate total spend
total_spend = transactions.groupBy("customer_id").agg(sum("amount").alias("total_spend"))

# Join with customers
result = customers.join(total_spend, on="customer_id")

# Show result
result.show()


Question2:
************************************

Validate a CSV file for missing values in required columns before loading to Snowflake.
Sample Input:
orders.csv:
order_id,customer_id,amount
1001,2001,500
1002,,300
 
Expected Output:
Row 2 has missing customer_id. Skipping load.


import pandas as pd

# Load CSV
df = pd.read_csv("orders.csv")

# Define required columns
required_columns = ["order_id", "customer_id", "amount"]

# Find invalid rows
invalid = df[df[required_columns].isnull().any(axis=1)]

# Print skipped rows
for i in invalid.index:
    missing_cols = [col for col in required_columns if pd.isna(df.loc[i, col]) or str(df.loc[i, col]).strip() == ""]
    for col in missing_cols:
        print(f"Row {i + 2} has missing {col}. Skipping load.")

# Filter valid rows
valid_df = df.drop(index=invalid.index)

# Show valid records
print("\n✅ Valid records to be loaded:")
print(valid_df)


***************Using Pyspark***********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import col

# Start Spark session
spark = SparkSession.builder.appName("ValidateCSV").getOrCreate()

# Load CSV
df = spark.read.csv("orders.csv", header=True, inferSchema=True)

# Define required columns
required_columns = ["order_id", "customer_id", "amount"]

# Identify invalid rows (any required column is null or empty string)
invalid_rows = df.filter(
    " OR ".join([f"{col_name} IS NULL OR TRIM({col_name}) = ''" for col_name in required_columns])
)

# Print skipped rows
for row in invalid_rows.collect():
    for col_name in required_columns:
        value = row[col_name]
        if value is None or (isinstance(value, str) and value.strip() == ""):
            print(f"Row with order_id {row['order_id']} has missing {col_name}. Skipping load.")

# Filter valid rows
valid_rows = df.subtract(invalid_rows)

# Show valid records
print("\n✅ Valid records to be loaded:")
valid_rows.show()


COPY INTO 
ON_ERRORS=SKIP

Python code ---


------------------------------

Full COPY INTO Command with All Options                                                             

COPY INTO my_database.my_schema.my_table
FROM @my_stage/path/
FILES = ('data1.csv', 'data2.csv')
PATTERN = '.*[.]csv'
FILE_FORMAT = (
    TYPE = 'CSV',
    FIELD_OPTIONALLY_ENCLOSED_BY = '"',
    SKIP_HEADER = 1,
    NULL_IF = ('NULL', 'null'),
    COMPRESSION = 'AUTO',
    FIELD_DELIMITER = ',',
    RECORD_DELIMITER = '\n',
    ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE,
    TRIM_SPACE = TRUE,
    ESCAPE_UNENCLOSED_FIELD = NONE
)
ON_ERROR = 'CONTINUE'
FORCE = TRUE
VALIDATION_MODE = 'RETURN_ALL_ERRORS'
SIZE_LIMIT = 1000000000
PURGE = TRUE
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;


Full Snowpipe Definition with All Options                                                    

CREATE OR REPLACE PIPE my_pipe
AUTO_INGEST = TRUE
INTEGRATION = 'my_s3_integration'
ERROR_INTEGRATION = 'my_error_integration'
COMMENT = 'Pipe for loading CSV files from S3 with full config'
AS
COPY INTO my_database.my_schema.my_table
FROM @my_stage/path/
FILE_FORMAT = (
    TYPE = 'CSV',
    FIELD_OPTIONALLY_ENCLOSED_BY = '"',
    SKIP_HEADER = 1,
    NULL_IF = ('NULL', 'null'),
    COMPRESSION = 'AUTO',
    FIELD_DELIMITER = ',',
    RECORD_DELIMITER = '\n',
    ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE,
    TRIM_SPACE = TRUE,
    ESCAPE_UNENCLOSED_FIELD = NONE
)
ON_ERROR = 'CONTINUE'
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;



STORAGE INTEGRATION REQUIRED
AWS 
AWS= 

CREATE AN INTERNAL STAGE
S3:// FILE PATH


COPY

SNOWPIPE
COPY INTO 
STAGE AREA
=CSV
ON_ERRORS

--------

S3 BUCKET 

COPY TO SNOWFLAKE TABLE

CREATE STAGE 

COPT INTO 
S3 
FILE_FORMAT=CSV

------------
CSV /TSV/AVRO/JSON/TXT/PARQUET

S---------

S3  -->

PIPE_HISTORY==
COPY_HISTORY =

---

I hour ago

before (   )

at(  )

---------
snowpipe


create or replace pipe my_snowpipe
as
copy into emp
from s3://emp.cdv
file_format=csv 
on_errors=contine
auto_intest=true


-----

create or replace task task_name
time= 5minutes
stream_name 


------------------

Performanc tuning

--- t1_hist t2_hist
cluster key 

ware house sizing 


---snowsql

---time travel 

----pyspark---Handson exposure










