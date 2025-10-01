import requests
from snowflake.snowpark import Session

# Step 1: Fetch JSON from local server
weather_url = "http://localhost:8000/weather.json"
response = requests.get(weather_url)

if response.status_code == 200 and response.text.strip():
    weather_json = response.json()

    # Step 2: Snowflake connection parameters
    connection_parameters = {
        "account": "JABGDWO-GY97629",
        "user": "prabhakarreddy1433",
        "password": "Mysnowflake149$",
        "role": "ACCOUNTADMIN",
        "warehouse": "COMPUTE_WH",
        "database": "MYSNOW",
        "schema": "PUBLIC"
    }

    # Step 3: Connect to Snowflake
    session = Session.builder.configs(connection_parameters).create()

    # ✅ Step 4: Create DataFrame from dict
    df = session.create_dataframe([{"data": weather_json}])

    # Step 5: Load into Snowflake
    df.write.save_as_table("WEATHER_RAW_JSON", mode="append")
else:
    print(f"❌ Failed to fetch JSON. Status code: {response.status_code}")
