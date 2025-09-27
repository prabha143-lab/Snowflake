from snowflake.snowpark import Session
import requests
import pandas as pd

# Step 1: Define Snowflake session parameters
connection_parameters = {
    "account": "JABGDWO-GY97629",
    "user": "prabhakarreddy1433",
    "password": "Mysnowflake149$",
    "role": "ACCOUNTADMIN",
    "warehouse": "COMPUTE_WH",
    "database": "MYSNOW",
    "schema": "PUBLIC"
}

# Step 2: Create Snowpark session
session = Session.builder.configs(connection_parameters).create()

# Step 3: Define API endpoint
API_URL = "https://jsonplaceholder.typicode.com/posts"

# Step 4: Fetch data from API
def fetch_api_data():
    try:
        response = requests.get(API_URL)
        response.raise_for_status()
        data = response.json()
        print(f"✅ Fetched {len(data)} records from API.")
        return pd.DataFrame(data)
    except Exception as e:
        print(f"❌ API fetch failed: {e}")
        return pd.DataFrame()

# Step 5: Transform and load data into Snowflake
def load_to_snowflake(df, table_name="API_POSTS"):
    try:
        # Convert pandas DataFrame to list of dicts for Snowpark
        snowpark_df = session.create_dataframe(df.to_dict(orient="records"))

        # Create table if not exists
        session.sql(f"""
            CREATE TABLE IF NOT EXISTS {table_name} (
                userId INTEGER,
                id INTEGER,
                title STRING,
                body STRING
            )
        """).collect()

        # Write data to Snowflake
        snowpark_df.write.mode("append").save_as_table(table_name)
        print(f"✅ Inserted {len(df)} rows into {table_name}.")
    except Exception as e:
        print(f"❌ Snowflake load failed: {e}")

# Step 6: Run the pipeline
def main():
    df = fetch_api_data()
    if df.empty:
        print("⚠️ No valid data to load. Exiting.")
        return
    load_to_snowflake(df)

if __name__ == "__main__":
    main()
