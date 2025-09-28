Question:


Can I call a SPROC inside another SPROC? Yes, using the CALL command. 

What is IDENTIFIER? A function that lets you use a variable's string value as a dynamic SQL object name (like a table or schema). 

Without IDENTIFIER, what's the alternative? Use Dynamic SQL via the EXECUTE IMMEDIATE command.


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


CREATE OR REPLACE PROCEDURE MYSNOW.PUBLIC.AUDIT_LOG(table_name VARCHAR, rows_loaded NUMBER)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
    INSERT INTO MYSNOW.PUBLIC.AUDIT_HISTORY (AUDIT_TABLE, AUDIT_TIME, ROWS_AFFECTED)
    VALUES (:table_name, CURRENT_TIMESTAMP(), :rows_loaded);
    
    RETURN 'Audit complete for ' || :table_name;
END;
$$;


CREATE OR REPLACE PROCEDURE MYSNOW.PUBLIC.DATA_LOAD(source_table VARCHAR, target_table VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
DECLARE
    rows_inserted NUMBER;
    audit_status VARCHAR;
BEGIN
    -- 1. Execute the main DML operation (Insert)
    INSERT INTO IDENTIFIER(:target_table)
    SELECT * FROM IDENTIFIER(:source_table);
    
    -- 2. GET THE NUMBER OF ROWS AFFECTED using SQLROWCOUNT()
    -- This replaces the problematic 'rows_inserted := ROW_COUNT;'
    rows_inserted := SQLROWCOUNT; 

    -- 3. Call the INNER procedure to log the operation
    audit_status := (CALL MYSNOW.PUBLIC.AUDIT_LOG(:target_table, :rows_inserted));

    -- 4. Final return message
    RETURN 'Load complete. ' || :rows_inserted || ' rows inserted. ' || audit_status;
END;
$$;


-- EXECUTION: Call the outer procedure
CALL MYSNOW.PUBLIC.DATA_LOAD('MYSNOW.PUBLIC.STAGING_DATA', 'MYSNOW.PUBLIC.PRODUCTION_TABLE');

Load complete. 2 rows inserted. Audit complete for MYSNOW.PUBLIC.PRODUCTION_TABLE

-- VERIFICATION 1: Check the final load table
SELECT * FROM MYSNOW.PUBLIC.PRODUCTION_TABLE;

-- VERIFICATION 2: Check the audit log table
SELECT * FROM MYSNOW.PUBLIC.AUDIT_HISTORY
ORDER BY AUDIT_TIME DESC;