import requests
import pandas as pd
from snowflake.snowpark import Session
import io

# Step 1: Fetch CSV from local server
csv_url = "http://localhost:8000/sales.csv"
response = requests.get(csv_url)
df = pd.read_csv(io.StringIO(response.text))

# 🌟 CORRECTION: Convert column names to uppercase to match Snowflake's default behavior.
# This fixes the "invalid identifier" error for columns like 'order_id'.
df.columns = df.columns.str.upper()

# Step 2: Define Snowflake connection parameters (Using placeholder values for security)
connection_parameters = {
    # WARNING: Do not hardcode credentials in production code. Use environment variables or secrets management.
    "account": "JABGDWO-GY97629",
    "user": "prabhakarreddy1433",
    "password": "Mysnowflake149$",
    "role": "ACCOUNTADMIN",
    "warehouse": "COMPUTE_WH",
    "database": "MYSNOW",
    "schema": "PUBLIC"
}

# Step 3: Connect to Snowflake
try:
    session = Session.builder.configs(connection_parameters).create()
    print("Successfully connected to Snowflake. 🎉")

    # Step 4: Load data into Snowflake table
    # write_pandas is now successful because the DataFrame column names are uppercase (e.g., 'ORDER_ID')
    session.write_pandas(df, "SALES_DATA", auto_create_table=True, overwrite=True)
    print(f"Data successfully loaded into table MYSNOW.PUBLIC.SALES_DATA.")

except Exception as e:
    print(f"An error occurred: {e}")

finally:
    # Step 5: Close the session
    if 'session' in locals() and session:
        session.close()
        print("Snowflake session closed.")