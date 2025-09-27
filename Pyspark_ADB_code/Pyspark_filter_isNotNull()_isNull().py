from pyspark.sql import SparkSession
from pyspark.sql.functions import col

# Create Spark session
spark = SparkSession.builder.appName("ValidateOrders").getOrCreate()

# Create DataFrame (your preferred format)
df = spark.createDataFrame([
    (1001, 2001, 500),
    (1002, None, 300),
    (103, 2003, None)
], ["order_id", "customer_id", "amount"])

# Filter valid rows (both customer_id and amount must be present)
valid_rows = df.filter(
    col("customer_id").isNotNull() & col("amount").isNotNull()
)

# Identify invalid rows
invalid_rows = df.filter(
    col("customer_id").isNull() | col("amount").isNull()
)

# Log missing fields using a for loop
for row in invalid_rows.collect():
    missing_fields = []
    if row["customer_id"] is None:
        missing_fields.append("customer_id")
    if row["amount"] is None:
        missing_fields.append("amount")
    print(f"Row with order_id {row['order_id']} has missing {', '.join(missing_fields)}. Skipping load.")

# Show valid rows
valid_rows.show()




Row with order_id 1002 has missing customer_id. Skipping load.
Row with order_id 103 has missing amount. Skipping load.
+--------+-----------+------+
|order_id|customer_id|amount|
+--------+-----------+------+
|    1001|       2001|   500|