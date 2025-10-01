import requests
from snowflake.snowpark import Session, Row

# Step 1: Define your WeatherAPI key and cities
API_KEY = "ed194f11d57e4c2587a115514250110"
cities = ["Hyderabad", "Delhi", "Mumbai", "Chennai", "Bangalore"]

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

# Step 4: Create table with correct schema (7 columns)
session.sql("""
    CREATE OR REPLACE TABLE WEATHER_LIVE (
        city STRING,
        region STRING,
        country STRING,
        temperature FLOAT,
        humidity INT,
        condition STRING,
        last_updated TIMESTAMP
    )
""").collect()

# Step 5: Loop through cities and fetch + insert data
for city in cities:
    url = f"https://api.weatherapi.com/v1/current.json?key={API_KEY}&q={city}"

    try:
        response = requests.get(url)
        response.raise_for_status()
        data = response.json()

        row = Row(
            city=data["location"]["name"],
            region=data["location"]["region"],
            country=data["location"]["country"],
            temperature=data["current"]["temp_c"],
            humidity=data["current"]["humidity"],
            condition=data["current"]["condition"]["text"],
            last_updated=data["current"]["last_updated"]
        )

        df = session.create_dataframe([row])
        df.write.save_as_table("WEATHER_LIVE", mode="append")
        print(f"✅ Inserted weather for {city}")

    except requests.exceptions.RequestException as e:
        print(f"❌ Failed to fetch weather for {city}: {e}")
    except Exception as e:
        print(f"❌ Failed to insert weather for {city}: {e}")
