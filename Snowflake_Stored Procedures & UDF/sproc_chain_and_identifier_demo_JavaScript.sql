-- 1. Target Table for the Outer Procedure to INSERT into
CREATE OR REPLACE TABLE MYSNOW.PUBLIC.PRODUCTION_TABLE (
    ID NUMBER,
    DATA_COL VARCHAR
);

-- 2. Source Table for the Outer Procedure to read from
CREATE OR REPLACE TABLE MYSNOW.PUBLIC.STAGING_DATA (
    ID NUMBER,
    DATA_COL VARCHAR
);

INSERT INTO MYSNOW.PUBLIC.STAGING_DATA (ID, DATA_COL) 
VALUES (1, 'Initial Data'), (2, 'More Data');

-- 3. Audit Table for the Inner Procedure to INSERT into
CREATE OR REPLACE TABLE MYSNOW.PUBLIC.AUDIT_HISTORY (
    AUDIT_ID NUMBER AUTOINCREMENT,
    AUDIT_TABLE VARCHAR,
    AUDIT_TIME TIMESTAMP_LTZ,
    ROWS_AFFECTED NUMBER
);


--JavaScript Stored Procedures
-- Inner Procedure

CREATE OR REPLACE PROCEDURE MYSNOW.PUBLIC.AUDIT_LOG_JS(table_name VARCHAR, rows_loaded FLOAT) -- Changed NUMBER to FLOAT
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
AS
$$
  // Construct the INSERT statement using bind variables (the '?' placeholders)
  var insert_sql = "INSERT INTO MYSNOW.PUBLIC.AUDIT_HISTORY (AUDIT_TABLE, AUDIT_TIME, ROWS_AFFECTED) " +
                   "VALUES (?, CURRENT_TIMESTAMP(), ?)";
  
  // Execute the INSERT statement, binding the variables
  snowflake.createStatement({
    sqlText: insert_sql,
    // The argument variables are now accessed using their JavaScript type:
    binds: [TABLE_NAME, ROWS_LOADED] 
  }).execute();
  
  return 'Audit complete for ' + TABLE_NAME;
$$;

CREATE OR REPLACE PROCEDURE MYSNOW.PUBLIC.DATA_LOAD_JS(source_table VARCHAR, target_table VARCHAR)
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
AS
$$
  var rows_inserted;
  var audit_status;
  
  // 1. Construct and execute the main DML operation (Insert)
  // In JavaScript, build the SQL string using concatenation (dynamic SQL)
  var dml_sql = "INSERT INTO " + TARGET_TABLE + " SELECT * FROM " + SOURCE_TABLE;
  
  var statement = snowflake.createStatement({ sqlText: dml_sql });
  var result = statement.execute();
  
  // 2. GET THE NUMBER OF ROWS AFFECTED using getRowCount()
  rows_inserted = statement.getRowCount();

  // 3. Call the INNER procedure (AUDIT_LOG_JS)
  var call_sql = "CALL MYSNOW.PUBLIC.AUDIT_LOG_JS(?, ?)";

  var call_statement = snowflake.createStatement({
    sqlText: call_sql,
    binds: [TARGET_TABLE, rows_inserted]
  });
  
  var call_result_set = call_statement.execute();
  
  // Get the return value from the inner SPROC
  call_result_set.next();
  audit_status = call_result_set.getColumnValue(1);

  // 4. Final return message
  return 'Load complete. ' + rows_inserted + ' rows inserted. ' + audit_status;
$$;

-- EXECUTION: Call the new JavaScript outer procedure
CALL MYSNOW.PUBLIC.DATA_LOAD_JS('MYSNOW.PUBLIC.STAGING_DATA', 'MYSNOW.PUBLIC.PRODUCTION_TABLE');

Load complete. 1 rows inserted. Audit complete for MYSNOW.PUBLIC.PRODUCTION_TABLE

-- VERIFICATION 1: Check the final load table
SELECT * FROM MYSNOW.PUBLIC.PRODUCTION_TABLE;

ID	DATA_COL
1	Initial Data
2	More Data

-- VERIFICATION 2: Check the audit log table
SELECT * FROM MYSNOW.PUBLIC.AUDIT_HISTORY
ORDER BY AUDIT_TIME DESC;

AUDIT_ID	AUDIT_TABLE	AUDIT_TIME	ROWS_AFFECTED
1	MYSNOW.PUBLIC.PRODUCTION_TABLE	2025-09-27 06:06:46.226 -0700	1