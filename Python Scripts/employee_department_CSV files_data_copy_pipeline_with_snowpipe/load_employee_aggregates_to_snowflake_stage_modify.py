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

# Step 3: Read CSVs from Snowflake stage
sp_employees_raw = session.read.csv("@my_stage/employees_test.csv")
sp_departments_raw = session.read.csv("@my_stage/departments_test.csv")

# Step 4: Rename columns and skip header row
sp_employees = sp_employees_raw.selectExpr(
    '"c1" AS EMP_ID',
    '"c2" AS NAME',
    '"c3" AS DEPT_ID',
    '"c4" AS SALARY'
).filter('"EMP_ID" != \'EMP_ID\'')

sp_departments = sp_departments_raw.selectExpr(
    '"c1" AS DEPT_ID',
    '"c2" AS DEPT_NAME'
).filter('"DEPT_ID" != \'DEPT_ID\'')

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
