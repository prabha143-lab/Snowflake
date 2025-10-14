-- ❓ Purpose: Create sample ORDERS table in Snowflake for dbt source testing
-- 📦 Database: MYSNOW
-- 🗂️ Schema: PUBLIC
-- 👤 Role: ACCOUNTADMIN
-- 🧪 Use case: dbt source('raw', 'orders') model validation

-- Step 1: Create the table
CREATE OR REPLACE TABLE MYSNOW.PUBLIC.ORDERS (
    ORDER_ID        INT,
    CUSTOMER_ID     VARCHAR,
    ORDER_DATE      DATE,
    TOTAL_AMOUNT    NUMBER(10,2),
    ORDER_STATUS    VARCHAR
);

-- Step 2: Insert sample data
INSERT INTO MYSNOW.PUBLIC.ORDERS (ORDER_ID, CUSTOMER_ID, ORDER_DATE, TOTAL_AMOUNT, ORDER_STATUS)
VALUES
    (1001, 'C001', '2023-10-01', 250.00, 'completed'),
    (1002, 'C002', '2023-10-02', 180.00, 'pending'),
    (1003, 'C003', '2023-10-03', 320.00, 'completed');

-- Step 3: Grant access to dbt role (ACCOUNTADMIN used here)
GRANT USAGE ON DATABASE MYSNOW TO ROLE ACCOUNTADMIN;
GRANT USAGE ON SCHEMA MYSNOW.PUBLIC TO ROLE ACCOUNTADMIN;
GRANT SELECT ON TABLE MYSNOW.PUBLIC.ORDERS TO ROLE ACCOUNTADMIN;
