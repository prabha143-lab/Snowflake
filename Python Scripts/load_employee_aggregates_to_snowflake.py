import pandas as pd
from snowflake.snowpark import Session
from snowflake.snowpark.functions import count

# Step 1: Define Snowflake connection parameters
connection_parameters = {
    "account": "JABGDWO-GY97629",
    "user": "prabhakarreddy1433",
    "password": "Mysnowflake149$",  # ⚠️ Consider using environment variables for security
    "role": "ACCOUNTADMIN",
    "warehouse": "COMPUTE_WH",
    "database": "MYSNOW",
    "schema": "PUBLIC"
}

# Step 2: Create Snowpark session
session = Session.builder.configs(connection_parameters).create()

# Step 3: Load CSVs using pandas
employees_df = pd.read_csv("C:/Pythontestfiles/employees_test.csv")
departments_df = pd.read_csv("C:/Pythontestfiles/departments_test.csv")

# Step 4: Convert pandas DataFrames to Snowpark DataFrames
sp_employees = session.create_dataframe(employees_df)
sp_departments = session.create_dataframe(departments_df)

# Step 5: Join and aggregate
joined_df = sp_employees.join(
    sp_departments,
    sp_employees["DEPT_ID"] == sp_departments["DEPT_ID"]
)

agg_df = joined_df.group_by("DEPT_NAME").agg(
    count("EMP_ID").alias("EMPLOYEE_COUNT")
)

# Step 6: Write result to Snowflake table
agg_df.write.save_as_table("EMPLOYEE_COUNTS_BY_DEPT", mode="overwrite")

print("✅ Data loaded into Snowflake table: EMPLOYEE_COUNTS_BY_DEPT")
