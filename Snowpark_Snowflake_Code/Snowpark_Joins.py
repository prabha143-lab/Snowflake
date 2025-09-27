Question 1: Customer Spend Aggregation
You are given two datasets:

customers.csv

customer_id,name
101,Alice
102,Bob


transactions.csv

customer_id,amount
101,200
101,150
102,300

✅ Task:
Write a program to:

Join the customers and transactions datasets on customer_id

Compute the total spend for each customer

Display the result with columns: customer_id, name, and total_spend

Answer: 

from snowflake.snowpark import Session
from snowflake.snowpark.functions import sum as sum_

def main(session: Session):
    # Create DataFrames manually
    customers = session.create_dataframe([
        (101, "Alice"),
        (102, "Bob")
    ], schema=["customer_id", "name"])

    transactions = session.create_dataframe([
        (101, 200),
        (101, 150),
        (102, 300)
    ], schema=["customer_id", "amount"])

    # Join and aggregate
    result = (
        customers.join(transactions, "customer_id")
        .group_by("customer_id", "name")
        .agg(sum_("amount").alias("total_spend"))
    )

    return result


CUSTOMER_ID	NAME	TOTAL_SPEND
101	Alice	350
102	Bob	300


************************************************************************

from snowflake.snowpark import Session
from snowflake.snowpark.functions import sum as sum_

def main(session: Session):
    c = session.create_dataframe([(101, "Alice"), (102, "Bob")], ["customer_id", "name"])
    t = session.create_dataframe([(101, 200), (101, 150), (102, 300)], ["customer_id", "amount"])
    return c.join(t, "customer_id").group_by("customer_id", "name").agg(sum_("amount").alias("total"))



CUSTOMER_ID	NAME	TOTAL_SPEND
101	Alice	350
102	Bob	300


**********************************************************************

from snowflake.snowpark import Session
from snowflake.snowpark.functions import sum as sum_

def main(session: Session):
    c = session.create_dataframe(["customer_id", "name"],[(101, "Alice"), (102, "Bob")])
    t = session.create_dataframe( ["customer_id", "amount"],[(101, 200), (101, 150), (102, 300)])
    return c.join(t, "customer_id").group_by("customer_id", "name").agg(sum_("amount").alias("total"))

    Syntax error: unexpected 'from'. (line 1)

Key Fix:
create_dataframe(data, schema) → data first, then column names


**************************************************************

from snowflake.snowpark import Session
from snowflake.snowpark.functions import sum as sum_

def main(session: Session):
    # Create customer DataFrame
    customers = session.create_dataframe(
        [(101, "Alice"), (102, "Bob")],
        ["customer_id", "name"]
    )

    # Create transaction DataFrame
    transactions = session.create_dataframe(
        [(101, 200), (101, 150), (102, 300)],
        ["customer_id", "amount"]
    )

    # Join and aggregate
    result = (
        customers.join(transactions, "customer_id")
        .group_by("customer_id", "name")
        .agg(sum_("amount").alias("total_spend"))
    )

    return result


CUSTOMER_ID	NAME	TOTAL_SPEND
101	Alice	350
102	Bob	300



****************************************************************************


Question: 
    
Validate CSV Data Before Loading to Snowflake
You are given a CSV file named orders.csv containing order information. 
Before loading this data into Snowflake, you must validate each row to ensure that all required fields are present.

📂 Sample Input: orders.csv

order_id,customer_id,amount
1001,2001,500
1002,,300
103,2003,


Expected Output:

Row 2 has missing customer_id and amount. Skipping load.


Answer:
    
 from snowflake.snowpark import Session
from snowflake.snowpark.functions import col

def main(session: Session):
    # Sample data simulating a CSV file
    data = [
        (1001, 2001, 500),
        (1002, None, 300),
        (103, 2003, None)
    ]

    # Create DataFrame
    df = session.create_dataframe(data, ["order_id", "customer_id", "amount"])

    # Filter valid rows (both customer_id and amount must be present)
    valid_rows = df.filter(
        col("customer_id").is_not_null() & col("amount").is_not_null()
    )

    # Identify invalid rows
    invalid_rows = df.filter(
        col("customer_id").is_null() | col("amount").is_null()
    )

    # Log messages using a for loop
    for row in invalid_rows.collect():
        missing_fields = []
        if row[1] is None:
            missing_fields.append("customer_id")
        if row[2] is None:
            missing_fields.append("amount")
        print(f"Row with order_id {row[0]} has missing {', '.join(missing_fields)}. Skipping load.")

    return valid_rows


Output :
    
Row with order_id 1002 has missing customer_id. Skipping load.
Row with order_id 103 has missing amount. Skipping load.
Closing a session in a stored procedure is a no-op.


Result:
    
ORDER_ID	CUSTOMER_ID	AMOUNT
1001	2001	500


******************************************************************
from snowflake.snowpark import Session
from snowflake.snowpark.functions import col

def main(session: Session):
    # Sample data simulating a CSV file
    data = [
        (1001, 2001, 500),
        (1002, None, 300),
        (103, 2003, None)
    ]

    # Create DataFrame
    df = session.create_dataframe(data, ["order_id", "customer_id", "amount"])

    # Filter valid rows (both customer_id and amount must be present)
    valid_rows = df.filter(
        col("customer_id").is_not_null() & col("amount").is_not_null()
    )

    # Identify invalid rows
    invalid_rows = df.filter(
        col("customer_id").is_null() & col("amount").is_null()
    )

    # Log messages using a for loop
    for row in invalid_rows.collect():
        missing_fields = []
        if row[1] is None:
            missing_fields.append("customer_id")
        if row[2] is None:
            missing_fields.append("amount")
        print(f"Row with order_id {row[0]} has missing {', '.join(missing_fields)}. Skipping load.")

    return valid_rows


Output:
    
Closing a session in a stored procedure is a no-op.


Result: ORDER_ID	CUSTOMER_ID	AMOUNT
1001	2001	500


****************************************************************

from snowflake.snowpark import Session
from snowflake.snowpark.functions import col

def main(session: Session):
    # Create DataFrame: data first, then column names
    df = session.create_dataframe([
        (1001, 2001, 500),
        (1002, None, 300),
        (103, 2003, None)
    ], ["order_id", "customer_id", "amount"])

    # Filter valid rows (both customer_id and amount must be present)
    valid_rows = df.filter(
        col("customer_id").is_not_null() & col("amount").is_not_null()
    )

    # Identify invalid rows (either field missing)
    invalid_rows = df.filter(
        col("customer_id").is_null() | col("amount").is_null()
    )

    # Log messages using a for loop
    for row in invalid_rows.collect():
        missing_fields = []
        if row[1] is None:
            missing_fields.append("customer_id")
        if row[2] is None:
            missing_fields.append("amount")
        print(f"Row with order_id {row[0]} has missing {', '.join(missing_fields)}. Skipping load.")

    return valid_rows


Output :
    
Row with order_id 1002 has missing customer_id. Skipping load.
Row with order_id 103 has missing amount. Skipping load.
Closing a session in a stored procedure is a no-op.


Result:
    
ORDER_ID	CUSTOMER_ID	AMOUNT
1001	2001	500
