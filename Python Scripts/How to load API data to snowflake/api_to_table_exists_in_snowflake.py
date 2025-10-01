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
def create_snowflake_session():
    try:
        session = Session.builder.configs(connection_parameters).create()
        print("✅ Snowflake session established.")
        return session
    except Exception as e:
        print(f"❌ Failed to create Snowflake session: {e}")
        return None

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

# Step 5: Load data into Snowflake (assuming table already exists)
def load_to_snowflake(session, df, table_name="API_POSTS"):
    try:
        if df.empty:
            print("⚠️ DataFrame is empty. Skipping load.")
            return

        # Convert pandas DataFrame to Snowpark DataFrame
        snowpark_df = session.create_dataframe(df.to_dict(orient="records"))

        # Append data to existing table
        snowpark_df.write.mode("append").save_as_table(table_name)
        print(f"✅ Inserted {len(df)} rows into {table_name}.")
    except Exception as e:
        print(f"❌ Snowflake load failed: {e}")

# Step 6: Run the pipeline
def main():
    session = create_snowflake_session()
    if not session:
        print("⚠️ Session creation failed. Exiting.")
        return

    df = fetch_api_data()
    load_to_snowflake(session, df)

if __name__ == "__main__":
    main()
