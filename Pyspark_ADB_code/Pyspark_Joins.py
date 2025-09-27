from pyspark.sql import SparkSession
from pyspark.sql.functions import sum

# Create Spark session
spark = SparkSession.builder.appName("CustomerSpend").getOrCreate()

# Customer data
customers = spark.createDataFrame(
    [(101, "Alice"), (102, "Bob")],
    ["customer_id", "name"]
)

# Transaction data
transactions = spark.createDataFrame(
    [(101, 200), (101, 150), (102, 300)],
    ["customer_id", "amount"]
)

# Join and aggregate
result = (
    customers.join(transactions, "customer_id")
    .groupBy("customer_id", "name")
    .agg(sum("amount").alias("total_spend"))
)

# Show result
result.show()

