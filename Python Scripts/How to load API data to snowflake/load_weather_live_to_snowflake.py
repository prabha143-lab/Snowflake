import requests
from snowflake.snowpark import Session, Row

# Step 1: Real-time weather API endpoint
weather_url = "https://api.weatherapi.com/v1/current.json?key=ed194f11d57e4c2587a115514250110&q=Hyderabad"

try:
    response = requests.get(weather_url)
    response.raise_for_status()  # Raise error for HTTP issues
    weather_json = response.json()
except requests.exceptions.HTTPError as e:
    print("❌ HTTP error:", e)
    print("Response:", response.text)
    exit()
except requests.exceptions.JSONDecodeError as e:
    print("❌ JSON decode error:", e)
    print("Raw response:", response.text)
    exit()

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

# Step 4: Create table if not exists
session.sql("""
    CREATE TABLE IF NOT EXISTS WEATHER_LIVE (
        city STRING,
        region STRING,
        country STRING,
        temperature FLOAT,
        humidity INT,
        condition STRING
    )
""").collect()

# Step 5: Prepare row and insert
row = Row(
    city=weather_json["location"]["name"],
    region=weather_json["location"]["region"],
    country=weather_json["location"]["country"],
    temperature=weather_json["current"]["temp_c"],
    humidity=weather_json["current"]["humidity"],
    condition=weather_json["current"]["condition"]["text"]
)

df = session.create_dataframe([row])
df.write.save_as_table("WEATHER_LIVE", mode="append")
print("✅ Real-time weather data loaded into Snowflake.")
