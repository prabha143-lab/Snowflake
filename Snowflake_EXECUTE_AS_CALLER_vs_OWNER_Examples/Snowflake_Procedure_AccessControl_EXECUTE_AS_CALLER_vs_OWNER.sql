-- ✅ Using a powerful role to set up objects and privileges
USE ROLE ACCOUNTADMIN;

-- ✅ Step 1: Create a database if it doesn't exist
CREATE DATABASE IF NOT EXISTS sample_db;
USE sample_db;

-- ✅ Step 2: Create a schema inside the database
CREATE SCHEMA IF NOT EXISTS admin_schema;
USE SCHEMA admin_schema;

-- ✅ Step 3: Create a secure table inside the schema
CREATE OR REPLACE TABLE secure_table (
  id INT,
  name STRING
);

-- ✅ Insert sample data into the secure table
INSERT INTO admin_schema.secure_table VALUES (1, 'Alice'), (2, 'Bob');

-- ✅ Create a limited role with no access to the table
CREATE OR REPLACE ROLE limited_role;
GRANT ROLE limited_role TO USER prabhakarreddy1433;

-- 🚫 No SELECT privilege granted to limited_role on secure_table
-- 🚫 No EXECUTE privilege granted yet on procedures

-- ✅ Create a procedure that runs with caller's privileges
-- ❗ Will fail if caller lacks SELECT privilege on secure_table
CREATE OR REPLACE PROCEDURE admin_schema.proc_execute_as_caller()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
    RETURN (SELECT COUNT(*) FROM admin_schema.secure_table)::STRING;
END;
$$;

-- ✅ Create a procedure that runs with owner's privileges
-- ✅ Will succeed even if caller lacks access to secure_table
CREATE OR REPLACE PROCEDURE admin_schema.proc_execute_as_owner()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS OWNER
AS
$$
BEGIN
    RETURN (SELECT COUNT(*) FROM admin_schema.secure_table)::STRING;
END;
$$;

-- ✅ Switch to limited_role to test access
USE ROLE limited_role;

-- ❌ This will fail:
-- Reason 1: limited_role lacks USAGE on schema and EXECUTE on procedure
-- Reason 2: limited_role lacks SELECT on secure_table
CALL admin_schema.proc_execute_as_caller();  
-- Expected error: SQL compilation error: Unknown user-defined function ADMIN_SCHEMA.PROC_EXECUTE_AS_CALLER

-- ✅ This will succeed:
-- Reason: Procedure runs with owner's privileges (ACCOUNTADMIN)
CALL admin_schema.proc_execute_as_owner();  
-- Expected output: 2
