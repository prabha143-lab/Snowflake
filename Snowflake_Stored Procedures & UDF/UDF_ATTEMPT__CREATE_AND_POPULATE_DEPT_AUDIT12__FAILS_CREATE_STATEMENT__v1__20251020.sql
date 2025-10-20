CREATE OR REPLACE PROCEDURE create_and_populate_department()
RETURNS STRING
LANGUAGE JAVASCRIPT
AS
$$
try {
    // DDL: Create audit table
    var ddl = `CREATE OR REPLACE TABLE PUBLIC.DEPT_AUDIT (
                  DEPTNO NUMBER(38,0),
                  DNAME VARCHAR(50),
                  LOC VARCHAR(50)
              )`;
    snowflake.createStatement({sqlText: ddl}).execute();

    // DML: Insert data from DEPTDUP
    var dml = `INSERT INTO PUBLIC.DEPT_AUDIT (DEPTNO, DNAME,LOC)
               SELECT DEPTNO, DNAME,LOC FROM PUBLIC.DEPTDUP`;
    snowflake.createStatement({sqlText: dml}).execute();

    return 'Procedure executed successfully';
} catch(err) {
    return 'Error: ' + err.message;
}
$$;


call create_and_populate_department()

SELECT * FROM PUBLIC.DEPT_AUDIT

DEPTNO	DNAME	LOC
10	ACCOUNTING	NEW YORK
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON
20	RESEARCH	DALLAS
20	RESEARCH	DALLAS
20	RESEARCH	HYDERABAD
20	ACCOUNTS	SECBAD

SELECT DEPTNO, DNAME,LOC FROM PUBLIC.DEPTDUP;

DEPTNO	DNAME	LOC
10	ACCOUNTING	NEW YORK
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON
20	RESEARCH	DALLAS
20	RESEARCH	DALLAS
20	RESEARCH	HYDERABAD
20	ACCOUNTS	SECBAD


CREATE OR REPLACE FUNCTION create_and_populate_department12()
RETURNS STRING
LANGUAGE JAVASCRIPT
AS
$$
try {
    // DDL: Create audit table
    var ddl = `CREATE OR REPLACE TABLE PUBLIC.DEPT_AUDIT12 (
                  DEPTNO NUMBER(38,0),
                  DNAME VARCHAR(50),
                  LOC VARCHAR(50)
              )`;
    snowflake.createStatement({sqlText: ddl}).execute();

    // DML: Insert data from DEPTDUP
    var dml = `INSERT INTO PUBLIC.DEPT_AUDIT12 (DEPTNO, DNAME,LOC)
               SELECT DEPTNO, DNAME,LOC FROM PUBLIC.DEPTDUP`;
    snowflake.createStatement({sqlText: dml}).execute();

    return 'Procedure executed successfully';
} catch(err) {
    return 'Error: ' + err.message;
}
$$;

--Function CREATE_AND_POPULATE_DEPARTMENT12 successfully created.

SELECT create_and_populate_department12()

Error: snowflake.createStatement is not a function

❌ Problem: snowflake.createStatement is not allowed in JavaScript UDFs
You're using CREATE FUNCTION ... LANGUAGE JAVASCRIPT, which defines a JavaScript UDF.

UDFs cannot execute SQL statements using snowflake.createStatement(...). That API is only available in JavaScript Stored Procedures.

Hence, the error:

Error: snowflake.createStatement is not a function