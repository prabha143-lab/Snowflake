Column level security by using Dynamic Data Masking concept in Snowflake.
SNOWFLAKE_SAMPLE_DATA database is now changed as SFSALESSHARED_SFC_SAMPLES_VA3_SAMPLE_DATA in new Snowflake accounts, you can get this sample data from Data -- Private Sharing -- Get database.

I can be reachable on jana.snowflake2@gmail.com.

=================
Masking Policies 
=================
USE DATABASE MYSNOW;

// Create a schema for policies
CREATE SCHEMA MYPOLICIES ;

// Try to clone from sample data -- we can't clone tables from shared databases
CREATE TABLE PUBLIC.CUSTOMER
CLONE SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

// Create a sample table
CREATE TABLE PUBLIC.CUSTOMER
AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

SELECT * FROM PUBLIC.CUSTOMER;

// Grant access to other roles
GRANT USAGE ON DATABASE MYSNOW TO ROLE sales_users;--Role 'SALES_USERS' does not exist or not authorized.

CREATE ROLE SALES_USERS;

GRANT USAGE ON DATABASE MYSNOW TO ROLE sales_users;
GRANT USAGE ON SCHEMA MYSNOW.public TO ROLE sales_users;
GRANT SELECT ON TABLE MYSNOW.public.CUSTOMER TO ROLE sales_users;

CREATE ROLE sales_admin;

GRANT USAGE ON DATABASE MYSNOW TO ROLE sales_admin;
GRANT USAGE ON SCHEMA MYSNOW.public TO ROLE sales_admin;
GRANT SELECT ON TABLE MYSNOW.public.CUSTOMER TO ROLE sales_admin;

CREATE ROLE market_users;

GRANT USAGE ON DATABASE MYSNOW TO ROLE market_users;
GRANT USAGE ON SCHEMA MYSNOW.public TO ROLE market_users;
GRANT SELECT ON TABLE MYSNOW.public.CUSTOMER TO ROLE market_users;

CREATE ROLE market_admin;

GRANT USAGE ON DATABASE MYSNOW TO ROLE market_admin;
GRANT USAGE ON SCHEMA MYSNOW.public TO ROLE market_admin;
GRANT SELECT ON TABLE MYSNOW.public.CUSTOMER TO ROLE market_admin;

======================

// Want to Hide Phone and Account Balance
CREATE OR REPLACE MASKING POLICY customer_phone 
    as (val string) returns string-v
CASE WHEN CURRENT_ROLE() in ('SALES_ADMIN', 'MARKET_ADMIN') THEN val
    ELSE '##-###-###-'||SUBSTRING(val,12,4) 
    END;
--Syntax error: unexpected '-'. (line 55)

CREATE OR REPLACE MASKING POLICY customer_phone 
AS (val STRING) 
RETURNS STRING ->
CASE 
    WHEN CURRENT_ROLE() IN ('SALES_ADMIN', 'MARKET_ADMIN') THEN val
    ELSE '##-###-###-' || SUBSTRING(val, 12, 4)
END;--Masking policy CUSTOMER_PHONE successfully created.


    
CREATE OR REPLACE MASKING POLICY customer_accbal 
    as (val number) returns number-v
CASE WHEN CURRENT_ROLE() in ('SALES_ADMIN', 'MARKET_ADMIN') THEN val
    ELSE '####' 
    END;
    
Syntax error: unexpected '-'. (line 72)
syntax error line 3 at position 5 unexpected 'WHEN'. (line 72

CREATE OR REPLACE MASKING POLICY customer_accbal 
AS (val NUMBER) 
RETURNS NUMBER ->
CASE 
    WHEN CURRENT_ROLE() IN ('SALES_ADMIN', 'MARKET_ADMIN') THEN val
    ELSE NULL
END;--Masking policy CUSTOMER_ACCBAL successfully created.


CREATE OR REPLACE MASKING POLICY customer_accbal2
    as (val number) returns number-v
CASE WHEN CURRENT_ROLE() in ('SALES_ADMIN', 'MARKET_ADMIN') THEN val
    ELSE 0 
    END;

Syntax error: unexpected '-'. (line 90)
syntax error line 3 at position 5 unexpected 'WHEN'. (line 90)

CREATE OR REPLACE MASKING POLICY customer_accbal2
AS (val NUMBER)
RETURNS NUMBER ->
CASE 
    WHEN CURRENT_ROLE() IN ('SALES_ADMIN', 'MARKET_ADMIN') THEN val
    ELSE 0
END;--Masking policy CUSTOMER_ACCBAL2 successfully created.


// Apply masking policies on columns of CUSTOMER table
ALTER TABLE PUBLIC.CUSTOMER MODIFY COLUMN C_PHONE
    SET MASKING POLICY customer_phone;--Statement executed successfully.
    
ALTER TABLE PUBLIC.CUSTOMER MODIFY COLUMN C_ACCTBAL
    SET MASKING POLICY customer_accbal;--Statement executed successfully.
    
// switch to sales_users and see the data
USE ROLE sales_users;

SQL access control error:
Requested role 'SALES_USERS' is not assigned to the executing user.  Specify another role to activate.

USE ROLE SECURITYADMIN;

GRANT ROLE SALES_USERS TO USER prabhakarreddy143;--Statement executed successfully.

USE ROLE SALES_USERS;--Statement executed successfully.


SELECT * FROM PUBLIC.CUSTOMER;

SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

// Unset policy customer_accbal and set to customer_accbal2
ALTER TABLE PUBLIC.CUSTOMER MODIFY COLUMN C_ACCTBAL
    UNSET MASKING POLICY;--Statement executed successfully.

ALTER TABLE PUBLIC.CUSTOMER MODIFY COLUMN C_ACCTBAL
    SET MASKING POLICY customer_accbal2;--Statement executed successfully.
    
    
// switch to sales_admin and see the data
USE ROLE sales_admin;
--Requested role 'SALES_ADMIN' is not assigned to the executing user.  Specify another role to activate.

USE ROLE SECURITYADMIN;

GRANT ROLE sales_admin TO USER prabhakarreddy143;--Statement executed successfully.

USE ROLE sales_admin;--Statement executed successfully.

SELECT * FROM PUBLIC.CUSTOMER;


// Altering policies
ALTER MASKING POLICY customer_phone SET body -v
CASE WHEN CURRENT_ROLE() in ('SALES_ADMIN', 'MARKET_ADMIN') THEN val
    ELSE '##########' 
    END;

// switch to sales_users and see the data
USE ROLE sales_users;

SELECT * FROM PUBLIC.CUSTOMER;

// To see masking policies
USE ROLE SYSADMIN;

SHOW MASKING POLICIES;

created_on	name	database_name	schema_name	kind	owner	comment	owner_role_type	options
2025-09-16 23:01:50.242 -0700	CUSTOMER_ACCBAL	MYSNOW	MYPOLICIES	MASKING_POLICY	ACCOUNTADMIN		ROLE	
2025-09-16 23:02:27.589 -0700	CUSTOMER_ACCBAL2	MYSNOW	MYPOLICIES	MASKING_POLICY	ACCOUNTADMIN		ROLE	
2025-09-16 23:00:59.079 -0700	CUSTOMER_PHONE	MYSNOW	MYPOLICIES	MASKING_POLICY	ACCOUNTADMIN		ROLE	

DESC MASKING POLICY CUSTOMER_PHONE;

name	signature	return_type	body
CUSTOMER_PHONE	(VAL VARCHAR)	VARCHAR	CASE 
    WHEN CURRENT_ROLE() IN ('SALES_ADMIN', 'MARKET_ADMIN') THEN val
    ELSE '##-###-###-' || SUBSTRING(val, 12, 4)
END

// To see wherever you applied the policy
SELECT * FROM table(information_schema.policy_references(policy_name='CUSTOMER_PHONE'));
Error: invalid identifier 'POLICY_NAME' (line 182)

SELECT * 
FROM TABLE(information_schema.policy_references(POLICY_NAME => 'CUSTOMER_PHONE'));

POLICY_DB	POLICY_SCHEMA	POLICY_NAME	POLICY_KIND	REF_DATABASE_NAME	REF_SCHEMA_NAME	REF_ENTITY_NAME	REF_ENTITY_DOMAIN	REF_COLUMN_NAME	REF_ARG_COLUMN_NAMES	TAG_DATABASE	TAG_SCHEMA	TAG_NAME	POLICY_STATUS
MYSNOW	MYPOLICIES	CUSTOMER_PHONE	MASKING_POLICY	MYSNOW	PUBLIC	CUSTOMER	TABLE	C_PHONE					ACTIVE


// Applying on views
ALTER VIEW MYVIEWS.VW_CUSTOMER MODIFY COLUMN C_PHONE
    SET MASKING POLICY customer_phone;--Schema 'MYSNOW.MYVIEWS' does not exist or not authorized

USE ROLE SECURITYADMIN;

GRANT CREATE SCHEMA ON DATABASE MYSNOW TO ROLE SYSADMIN;--Statement executed successfully.

CREATE SCHEMA IF NOT EXISTS MYSNOW.MYVIEWS;

SQL access control error:
Insufficient privileges to operate on database 'MYSNOW'.

GRANT CREATE SCHEMA ON DATABASE MYSNOW TO ROLE sales_users;--Statement executed successfully.


// switch to sales_users and see the data
USE ROLE sales_users;

SELECT * FROM MYVIEWS.VW_CUSTOMER;--Schema 'MYSNOW.MYVIEWS' does not exist or not authorized

USE ROLE SECURITYADMIN;

CREATE SCHEMA IF NOT EXISTS MYSNOW.MYVIEWS;

SQL access control error:
Insufficient privileges to operate on database MYSNOW

USE ROLE ACCOUNTADMIN;
CREATE SCHEMA IF NOT EXISTS MYSNOW.MYVIEWS;--Schema MYVIEWS successfully created.

CREATE OR REPLACE VIEW MYSNOW.MYVIEWS.VW_CUSTOMER AS
SELECT * FROM MYSNOW.PUBLIC.CUSTOMER;--View VW_CUSTOMER successfully created.


// Dropping masking policies
DROP MASKING POLICY customer_phone;--Masking policy 'MYSNOW.MYVIEWS.CUSTOMER_PHONE' does not exist or not authorized.

DROP MASKING POLICY MYSNOW.MYPOLICIES.CUSTOMER_PHONE;
--Policy CUSTOMER_PHONE cannot be dropped/replaced as it is associated with one or more entities.

SELECT * 
FROM TABLE(information_schema.policy_references(
  POLICY_NAME => 'CUSTOMER_PHONE'
));--Policy 'MYSNOW.MYVIEWS.CUSTOMER_PHONE' does not exist or not authorized.

ALTER TABLE MYSNOW.PUBLIC.CUSTOMER 
MODIFY COLUMN C_PHONE UNSET MASKING POLICY;--Statement executed successfully.

ALTER TABLE PUBLIC.CUSTOMER MODIFY COLUMN C_ACCTBAL
    UNSET MASKING POLICY;---Statement executed successfully.
    
DROP MASKING POLICY customer_accbal2;--Masking policy 'MYSNOW.MYVIEWS.CUSTOMER_ACCBAL2' does not exist or not authorized.

DROP MASKING POLICY MYSNOW.MYPOLICIES.CUSTOMER_ACCBAL2;---CUSTOMER_ACCBAL2 successfully dropped.



****************************************************************

create or replace TABLE MYSNOW.PUBLIC.CUSTOMER (
	C_CUSTKEY NUMBER(38,0),
	C_NAME VARCHAR(25),
	C_ADDRESS VARCHAR(40),
	C_NATIONKEY NUMBER(38,0),
	C_PHONE VARCHAR(15) WITH MASKING POLICY MYSNOW.MYPOLICIES.CUSTOMER_PHONE,
	C_ACCTBAL NUMBER(12,2) WITH MASKING POLICY MYSNOW.MYPOLICIES.CUSTOMER_ACCBAL,
	C_MKTSEGMENT VARCHAR(10),
	C_COMMENT VARCHAR(117)
);
