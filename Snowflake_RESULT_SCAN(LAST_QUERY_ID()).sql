Understanding RESULT_SCAN Behavior with Duplicate Column Aliases in Snowflake
In Snowflake, when you execute a query like:
sql
SELECT 1 AS a, 2 AS a_1, 3 AS a;
The result set displays duplicate column aliases:
| A | A_1 | A |
|---+-----+---|
| 1 |   2 | 3 |

This is allowed in direct query output, even though the alias a is used twice.
However, when you use RESULT_SCAN(LAST_QUERY_ID()) to retrieve the result of that query:
sql
SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));
Snowflake automatically renames duplicate column aliases to ensure uniqueness in the result set:
Code
| A | A_1 | A_2 |
|---+-----+-----|
| 1 |   2 |   3 |
This renaming is necessary because RESULT_SCAN() treats the result as a virtual table, and table columns must have unique names to avoid ambiguity in downstream operations.

-- Step 1: Run the target query
SELECT * FROM MYSNOW.MY_TRANSIENT_SCHEMA.sample_table;

-- Step 2: Capture the query ID right after
SET my_query_id = LAST_QUERY_ID();

-- Step 3: Use RESULT_SCAN with the captured ID
SELECT * FROM TABLE(RESULT_SCAN($my_query_id));


CREATE OR REPLACE PROCEDURE audit_high_value_sales()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    query_id STRING;
BEGIN
    -- Step 1: Filter high-value sales
    SELECT * FROM sales.transactions
    WHERE amount > 100000;

    -- Step 2: Capture the query ID
    LET query_id = LAST_QUERY_ID();

    -- Step 3: Insert the result into audit table using RESULT_SCAN
    INSERT INTO audit.high_value_sales_log
    SELECT * FROM TABLE(RESULT_SCAN(query_id));

    -- Step 4: Return confirmation
    RETURN 'High-value sales successfully audited.';
END;
$$;

In our audit pipeline, we use RESULT_SCAN() to capture and reuse filtered data sets without re-execution. This ensures performance efficiency and guarantees consistency between analysis and logging steps.”
