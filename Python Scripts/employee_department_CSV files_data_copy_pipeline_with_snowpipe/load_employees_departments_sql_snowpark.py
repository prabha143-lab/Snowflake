# Filename: load_employees_departments_sql_snowpark.py

"""
Step-by-step Snowpark demo:
1. Load employees and departments CSV files
2. Upload them to Snowflake as tables
3. Run SQL inside Snowpark to join and count employees per department
4. Save result as EMPLOYEE_COUNTS_BY_DEPT
"""

import pandas as pd
from snowflake.snowpark import Session

# Step 1: Connect to Snowflake
conn = {
    "account": "JABGDWO-GY97629",
    "user": "prabhakarreddy1433",
    "password": "Mysnowflake149$",  # ⚠️ Use env vars in production
    "role": "ACCOUNTADMIN",
    "warehouse": "COMPUTE_WH",
    "database": "MYSNOW",
    "schema": "PUBLIC"
}
session = Session.builder.configs(conn).create()

# Step 2: Load CSVs
emp_df = pd.read_csv("C:/Pythontestfiles/employees_test.csv")
dept_df = pd.read_csv("C:/Pythontestfiles/departments_test.csv")

# Step 3: Upload to Snowflake
session.create_dataframe(emp_df).write.save_as_table("employees_test", mode="overwrite")
session.create_dataframe(dept_df).write.save_as_table("departments_test", mode="overwrite")

# Step 4: Run SQL inside Snowpark
sql_query = """
    CREATE OR REPLACE TABLE EMPLOYEE_COUNTS_BY_DEPT AS
    SELECT d.DEPT_NAME, COUNT(e.EMP_ID) AS EMPLOYEE_COUNT
    FROM employees_test e
    JOIN departments_test d ON e.DEPT_ID = d.DEPT_ID
    GROUP BY d.DEPT_NAME
"""
session.sql(sql_query).collect()

# Step 5: Confirm success
print("✅ EMPLOYEE_COUNTS_BY_DEPT created using SQL in Snowpark")
