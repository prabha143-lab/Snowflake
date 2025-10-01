from snowflake.snowpark import Session
from snowflake.snowpark.functions import count

# Step 1: Define Snowflake connection parameters
connection_parameters = {
    "account": "JABGDWO-GY97629",
    "user": "prabhakarreddy1433",
    "password": "Mysnowflake149$",  # ⚠️ Use environment variables in production
    "role": "ACCOUNTADMIN",
    "warehouse": "COMPUTE_WH",
    "database": "MYSNOW",
    "schema": "PUBLIC"
}

# Step 2: Create Snowpark session
session = Session.builder.configs(connection_parameters).create()

# Step 3: Create structured tables
session.sql("""
    CREATE OR REPLACE TABLE EMPLOYEES_STAGE (
        EMP_ID STRING,
        NAME STRING,
        DEPT_ID STRING,
        SALARY STRING
    )
""").collect()

session.sql("""
    CREATE OR REPLACE TABLE DEPARTMENTS_STAGE (
        DEPT_ID STRING,
        DEPT_NAME STRING
    )
""").collect()

# Step 4: Create file format for CSVs
session.sql("""
    CREATE OR REPLACE FILE FORMAT my_csv_format
    TYPE = 'CSV'
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    SKIP_HEADER = 1
""").collect()

# Step 5: Create Snowpipes for auto-ingestion
session.sql("""
    CREATE OR REPLACE PIPE EMPLOYEES_PIPE AS
    COPY INTO EMPLOYEES_STAGE
    FROM @my_stage/employees_test12.csv
    FILE_FORMAT = my_csv_format
""").collect()

session.sql("""
    CREATE OR REPLACE PIPE DEPARTMENTS_PIPE AS
    COPY INTO DEPARTMENTS_STAGE
    FROM @my_stage/departments_test12.csv
    FILE_FORMAT = my_csv_format
""").collect()

# Step 6: Manually trigger Snowpipe to load staged files
session.sql("ALTER PIPE EMPLOYEES_PIPE REFRESH").collect()
session.sql("ALTER PIPE DEPARTMENTS_PIPE REFRESH").collect()

# Step 7: Read structured tables into Snowpark
sp_employees = session.table("EMPLOYEES_STAGE")
sp_departments = session.table("DEPARTMENTS_STAGE")

# Step 8: Join and aggregate employee counts by department
joined_df = sp_employees.join(
    sp_departments,
    sp_employees["DEPT_ID"] == sp_departments["DEPT_ID"]
)

agg_df = joined_df.group_by("DEPT_NAME").agg(
    count("EMP_ID").alias("EMPLOYEE_COUNT")
)

# Step 9: Write result to Snowflake table
agg_df.write.save_as_table("EMPLOYEE_COUNTS_BY_DEPT", mode="overwrite")

print("✅ Data loaded into Snowflake table: EMPLOYEE_COUNTS_BY_DEPT")
