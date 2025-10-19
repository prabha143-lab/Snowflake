-- Extract DDL for a standard table
SELECT GET_DDL('TABLE', 'DEPTDUP');  
-- ✅ Works for permanent, transient, or temporary tables

-- Extract DDL for a view (can be standard or materialized)
SELECT GET_DDL('VIEW', 'MV_CUSTOMERS');  
-- ✅ Works for both standard and materialized views
-- ❗ Use 'VIEW' even for materialized views — Snowflake treats them as view objects for DDL

-- Extract DDL for a stored procedure
SELECT GET_DDL('PROCEDURE', 'COUNT_EMPLOYEES()');  
-- ✅ Must include parentheses, even if no arguments
-- ❗ Include schema if not in default context

-- Extract DDL for a scalar SQL function
SELECT GET_DDL('FUNCTION', 'ADD_NUMBERS_SQL(NUMBER, NUMBER)');  
-- ✅ Must include argument types
-- ❗ Use fully qualified name if needed (e.g., 'SCHEMA.FUNC_NAME(NUMBER, NUMBER)')

-- Attempt to extract DDL for a dynamic view (created via semantic layer or UI)
SELECT GET_DDL('TABLE', 'MY_DYNAMIC_TABLE');  
-- ❌ Likely to fail if it's a semantic view — use 'VIEW' instead
-- ❗ Semantic views may not support GET_DDL at all

-- List all materialized views in the PUBLIC schema
SHOW MATERIALIZED VIEWS IN SCHEMA PUBLIC;  
-- ✅ Confirms existence and metadata
-- ❗ Use this before calling GET_DDL to verify the object

-- Extract DDL for a materialized view
SELECT GET_DDL('VIEW', 'MV_CUSTOMERS');  
-- ✅ Use 'VIEW' even for materialized views
-- ❗ Snowflake does not use a separate keyword like 'MATERIALIZED VIEW' in GET_DDL
-- 🧠 Interview Tip: Materialized views store precomputed results and auto-refresh if enabled
