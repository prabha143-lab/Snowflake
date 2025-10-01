import json
from snowflake.snowpark import Session, Row

# Step 1: Snowflake connection parameters
connection_parameters = {
    "account": "JABGDWO-GY97629",
    "user": "prabhakarreddy1433",
    "password": "Mysnowflake149$",
    "role": "ACCOUNTADMIN",
    "warehouse": "COMPUTE_WH",
    "database": "MYSNOW",
    "schema": "PUBLIC"
}

# Step 2: Connect to Snowflake
session = Session.builder.configs(connection_parameters).create()

# Step 3: Create table if not exists
session.sql("""
    CREATE TABLE IF NOT EXISTS IOT_SENSOR_DATA (
        device_id STRING,
        timestamp TIMESTAMP,
        temperature FLOAT,
        humidity FLOAT,
        battery_level INT,
        status STRING
    )
""").collect()

# Step 4: Load JSON file
with open("C:/Pythontestfiles/iot_data.json", "r") as f:
    sensor_data = json.load(f)

# Step 5: Convert to Snowpark DataFrame
rows = [Row(**record) for record in sensor_data]
df = session.create_dataframe(rows)

# Step 6: Insert into Snowflake
df.write.save_as_table("IOT_SENSOR_DATA", mode="append")
print("✅ Successfully loaded IoT data into Snowflake.")
